#!/usr/bin/env bash
# Build a clean, up-to-date distribution of the siefken-syllabus package in
# dist/siefken-syllabus/<version>/ — the folder that gets copied into the
# typst/packages repository (under packages/preview/) to publish
# @preview/siefken-syllabus.
#
# Usage:
#   ./make_dist.sh --tag=<TAG>   e.g. ./make_dist.sh --tag=v1.0.0
#   ./make_dist.sh --no-tag
#
# Steps:
#   1. run the test suite
#   2. compile every example as validation
#   3. rebuild the thumbnails the README references
#   4. rewrite the README's `@preview/siefken-syllabus:<version>` import so it
#      advertises the version in typst.toml
#   5. assemble the package (typst.toml, LICENSE, README.md, src/ — no test/ or
#      examples/, matching `exclude` in typst.toml); the README's links and
#      images are pinned to a permalink (see below) so the published README is
#      portable to Typst Universe / typst/packages
#   6. compile the examples (import rewritten to
#      `@preview/siefken-syllabus:<version>` in a scratch copy) against the
#      vendored package, to validate it works as advertised
set -euo pipefail
cd "$(dirname "$0")"

usage() {
    cat >&2 <<'EOF'
usage: ./make_dist.sh (--tag=<TAG> | --no-tag)

This script pins README.md's links and images to a permalink, since the
published package does not ship the docs/ or examples/ directories itself. A
permalink must point at something immutable — a release tag or a commit — so
you must say which:

  --tag=<TAG>   Pin the links to the given git tag, e.g. --tag=v1.0.0. Use
                this for an actual release: create and push the tag first
                    git tag v1.0.0 && git push origin v1.0.0
                then pass that same tag here, so the published README reads
                nicely and links stay valid for that release forever.

  --no-tag      Pin the links to the current commit (git rev-parse HEAD)
                instead of a tag. Use this for a local/test build of dist/
                when you don't want to create a release tag yet.

Exactly one of these is required — there is no default, because silently
falling back to one could point a real release at an untagged commit, or
force a test build to fail for lacking a tag.
EOF
}

TAG_MODE=""
RELEASE_TAG=""
for arg in "$@"; do
    case "$arg" in
        --tag=*)
            TAG_MODE="tag"
            RELEASE_TAG="${arg#--tag=}"
            ;;
        --no-tag)
            TAG_MODE="no-tag"
            ;;
        *)
            echo "error: unknown argument '$arg'" >&2
            echo >&2
            usage
            exit 1
            ;;
    esac
done
if [ -z "$TAG_MODE" ]; then
    echo "error: --tag=<TAG> or --no-tag is required" >&2
    echo >&2
    usage
    exit 1
fi
if [ "$TAG_MODE" = "tag" ] && [ -z "$RELEASE_TAG" ]; then
    echo "error: --tag= was given an empty tag name" >&2
    echo >&2
    usage
    exit 1
fi

toml_value() { grep -m1 "^$1" typst.toml | sed 's/.*"\(.*\)"/\1/'; }

NAME=$(toml_value name)
VERSION=$(toml_value version)
REPO_URL=$(toml_value repository)
PKG="dist/$NAME/$VERSION"
echo "==> $NAME $VERSION"

# Base URLs for pinning the README's links (see step 5). Always a permalink (a
# tag or a commit, never a branch name), so the links keep pointing at the exact
# files this version shipped with — the typst/packages checker flags
# branch-relative links ("GitHub URL links to default branch").
if [ "$TAG_MODE" = "tag" ]; then
    if ! git rev-parse --verify --quiet "refs/tags/$RELEASE_TAG" >/dev/null; then
        echo "error: git tag '$RELEASE_TAG' does not exist in this repository." >&2
        echo >&2
        echo "  --tag=$RELEASE_TAG was given, but that tag hasn't been created." >&2
        echo "  Create and push it first:" >&2
        echo >&2
        echo "    git tag $RELEASE_TAG" >&2
        echo "    git push origin $RELEASE_TAG" >&2
        echo >&2
        echo "  ...then re-run this script." >&2
        exit 1
    fi
    GITHUB_REF="$RELEASE_TAG"
    if [ "$(git rev-parse "$RELEASE_TAG")" != "$(git rev-parse HEAD)" ]; then
        echo "warning: tag '$RELEASE_TAG' does not point at the current commit (HEAD)." >&2
        echo "         The README will link to tag '$RELEASE_TAG', but the examples and" >&2
        echo "         thumbnails used to build this dist/ come from the current" >&2
        echo "         working tree, which may not match what that tag contains." >&2
    fi
else
    GITHUB_REF=$(git rev-parse HEAD)
fi
if [ -n "$(git status --porcelain)" ]; then
    echo "warning: working tree has uncommitted changes; README links will point at" >&2
    echo "         $GITHUB_REF, which may not match what's on GitHub yet." >&2
    echo "         Commit and push before running this for a release." >&2
fi
BLOB_BASE="$REPO_URL/blob/$GITHUB_REF"
TREE_BASE="$REPO_URL/tree/$GITHUB_REF"
RAW_BASE="https://raw.githubusercontent.com/${REPO_URL#https://github.com/}/$GITHUB_REF"

echo "==> Running tests"
./test/run.sh

echo "==> Compiling examples"
for f in examples/*.typ; do
    typst compile --root . -f pdf "$f" /dev/null
done

echo "==> Rebuilding README thumbnails"
# docs/thumbnail.typ pulls the example from docs/index.typ, so the thumbnail
# tracks the README's "Usage" section automatically.
typst compile --root . -f svg docs/thumbnail.typ docs/images/example.svg

echo "==> Pointing the README import at $NAME:$VERSION"
# Keeps the README's usage snippet advertising the version in typst.toml, so a
# version bump only has to happen in one place. docs/index.typ derives its own
# import line from typst.toml already.
perl -i -pe "s{\@preview/\Q$NAME\E:[0-9][^\"]*}{\@preview/$NAME:$VERSION}g" README.md

echo "==> Assembling $PKG/"
rm -rf dist
mkdir -p "$PKG"
cp typst.toml LICENSE "$PKG/"
# The published README keeps user documentation only: strip the Development
# section (everything from "## Development" up to the next "## " heading).
# Then pin links so the README is portable outside GitHub: repo-relative
# markdown links `](path)` and `<a href="path">` become blob links (or tree
# links for directory paths ending in `/`), `<img src="path">` becomes a
# raw.githubusercontent.com link, and links already written as absolute URLs
# against the default branch are re-pinned to $GITHUB_REF. Anchor (`#...`) and
# `mailto:` targets are left untouched.
awk '/^## Development$/ { skip = 1; next } skip && /^## / { skip = 0 } !skip' \
    README.md \
    | REPO_URL="$REPO_URL" BLOB_BASE="$BLOB_BASE" TREE_BASE="$TREE_BASE" \
      RAW_BASE="$RAW_BASE" GITHUB_REF="$GITHUB_REF" perl -pe '
        # Re-pin absolute links that point at the default branch.
        s{\Q$ENV{REPO_URL}\E/(raw|blob|tree)/main/}{$ENV{REPO_URL} . "/$1/" . $ENV{GITHUB_REF} . "/"}ge;
        s{https://raw\.githubusercontent\.com/(\S+?)/main/}{"https://raw.githubusercontent.com/$1/" . $ENV{GITHUB_REF} . "/"}ge;
        # Rewrite repo-relative targets.
        s{\]\(([^)]+)\)}{
            my $p = $1;
            $p =~ m{^(?:https?:|#|mailto:)} ? "](" . $p . ")"
            : $p =~ m{/$} ? "](" . $ENV{TREE_BASE} . "/" . $p . ")"
            : "](" . $ENV{BLOB_BASE} . "/" . $p . ")"
        }ge;
        # The captures are copied into lexicals first: the inner `=~ m{...}`
        # resets $1/$2/$3 when it matches, which would otherwise blank out the
        # tag for URLs that are already absolute.
        s{(<img\b[^>]*\bsrc=")([^"]+)(")}{
            my ($pre, $p, $post) = ($1, $2, $3);
            $p =~ m{^https?:} ? "$pre$p$post" : "$pre" . $ENV{RAW_BASE} . "/$p" . "$post"
        }ge;
        s{(<a\b[^>]*\bhref=")([^"]+)(")}{
            my ($pre, $p, $post) = ($1, $2, $3);
            $p =~ m{^https?:} ? "$pre$p$post" : "$pre" . $ENV{BLOB_BASE} . "/$p" . "$post"
        }ge;
    ' >"$PKG/README.md"
cp -r src "$PKG/src"

echo "==> Validating the vendored package as @preview/$NAME:$VERSION"
# Typst resolves `@preview/...` from `$TYPST_PACKAGE_PATH/preview/...`, so
# expose dist/ under a `preview` symlink and compile the examples against it —
# exactly how users will consume the package. The examples aren't part of the
# published package (see step 5); a scratch copy with the import rewritten to
# `@preview/<name>:<version>` is used here only for validation.
pkgroot=$(mktemp -d)
validation_examples=$(mktemp -d)
trap 'rm -rf "$pkgroot" "$validation_examples"' EXIT
ln -s "$PWD/dist" "$pkgroot/preview"
for f in examples/*.typ; do
    sed "s|#import \"../src/lib.typ\"|#import \"@preview/$NAME:$VERSION\"|" \
        "$f" >"$validation_examples/$(basename "$f")"
done
for f in "$validation_examples"/*.typ; do
    TYPST_PACKAGE_PATH="$pkgroot" typst compile -f pdf "$f" /dev/null
done

echo "==> Done: $PKG/ ($(du -sh dist | cut -f1))"
find dist -type f | sort

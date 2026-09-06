FROM mcr.microsoft.com/devcontainers/base:bookworm

ARG TYPST_VERSION=0.15.0
ARG LIBERTINUS_VERSION=7.051

RUN apt-get update && apt-get install -y --no-install-recommends \
        fonts-dejavu-core \
        fonts-dejavu-extra \
        fontconfig \
        unzip \
        vim \
        poppler-utils \
        imagemagick \
    && rm -rf /var/lib/apt/lists/*

# Make vim the default editor for git commits (e.g. `git commit` with no -m).
RUN git config --system core.editor vim

# Install the typst CLI, pinned to the compiler version in typst.toml.
# Detected via `uname -m` rather than Docker's $TARGETARCH build-arg, since
# that's only populated by BuildKit/buildx, not the legacy builder.
RUN case "$(uname -m)" in \
        x86_64) ARCH=x86_64 ;; \
        aarch64) ARCH=aarch64 ;; \
        *) echo "Unsupported architecture: $(uname -m)" >&2 && exit 1 ;; \
    esac \
    && curl -fsSL "https://github.com/typst/typst/releases/download/v${TYPST_VERSION}/typst-${ARCH}-unknown-linux-musl.tar.xz" -o /tmp/typst.tar.xz \
    && tar -xf /tmp/typst.tar.xz -C /tmp \
    && install -m 755 "/tmp/typst-${ARCH}-unknown-linux-musl/typst" /usr/local/bin/typst \
    && rm -rf /tmp/typst*

# Install Arial, the default `font_sans` in src/settings.typ. It ships in
# Microsoft's core web fonts, which live in Debian's `contrib` component (the
# package downloads the fonts from upstream at install time rather than
# redistributing them), so enable that component and preseed the EULA prompt.
# Typst matches fonts by family name and ignores fontconfig aliases, so a
# metric-compatible substitute like Liberation Sans would not answer to "Arial".
RUN sed -i 's/^Components: main$/Components: main contrib/' /etc/apt/sources.list.d/debian.sources \
    && echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" \
        | debconf-set-selections \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ttf-mscorefonts-installer \
    && rm -rf /var/lib/apt/lists/* \
    && fc-cache -f

# Install Libertinus Serif, used by src/elements/exam.typ.
# Not packaged for Debian stable/testing, so fetch it from upstream.
RUN curl -fsSL "https://github.com/alerque/libertinus/releases/download/v${LIBERTINUS_VERSION}/Libertinus-${LIBERTINUS_VERSION}.zip" -o /tmp/libertinus.zip \
    && mkdir -p /usr/local/share/fonts/libertinus \
    && unzip -j /tmp/libertinus.zip "Libertinus-${LIBERTINUS_VERSION}/static/OTF/*.otf" -d /usr/local/share/fonts/libertinus \
    && rm -rf /tmp/libertinus.zip \
    && fc-cache -f

# Install Geo Sans Light, the `font_sans` override in examples/syllabus-example.typ.
# A freeware font with no upstream release archive; dafont is the canonical
# distribution point, and the download URL is unversioned.
RUN curl -fsSL -A "Mozilla/5.0" "https://dl.dafont.com/dl/?f=geo_sans_light" -o /tmp/geosans.zip \
    && mkdir -p /usr/local/share/fonts/geosans \
    && unzip -j /tmp/geosans.zip "*.ttf" -d /usr/local/share/fonts/geosans \
    && rm -rf /tmp/geosans.zip \
    && fc-cache -f

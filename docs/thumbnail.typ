// Source for the README thumbnail (docs/images/example.svg), rendered by
// ./make_dist.sh. The example content is imported from docs/index.typ rather
// than duplicated here, so the thumbnail always shows the same syllabus as the
// README's "Usage" section. The block styling mirrors the one docs/index.typ
// uses to display this example inline.
#import "/docs/index.typ": usage_string, full_package_name

#set page(width: auto, height: auto, margin: 0pt, fill: none)
#block(stroke: 1pt + black, width: 20em, inset: .5cm, {
  set text(size: .5em)
  set align(left)
  // Point the import at the working tree and let the template lay itself out
  // in a block rather than on its own page.
  eval(
    ("[\n" + usage_string + "\n]")
      .replace(full_package_name, "/src/lib.typ")
      .replace("show: s.template", "show: s.template.with(minipage: true)"),
  )
})

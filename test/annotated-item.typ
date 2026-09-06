#import "/src/types.typ": *
#import "/src/utils.typ": *
#import "/src/lib.typ" as s

// The first baseline of a line of text sits one ascender below its top, so the offset grows
// with the font size. `annotated_item` uses this to line the title's baseline up with the
// body's even though the two are set at different sizes.
#context {
  let at_size = size => first_baseline_offset(body => text(size: size, body))
  let small = at_size(10pt)
  let large = at_size(20pt)
  assert(
    large > small,
    message: "Larger text should have a larger first-baseline offset, got "
      + repr(large)
      + " vs "
      + repr(small),
  )
  assert(
    calc.abs((large - 2 * small).pt()) < 0.01,
    message: "The first-baseline offset should scale with the font size, got "
      + repr(large)
      + " for twice the size of "
      + repr(small),
  )

  // A font declaration may draw its glyphs off the baseline with `text.baseline`. `measure`
  // cannot see that offset, but the reported first baseline has to move with the glyphs, or
  // anything aligned against it lands too high.
  let raised = first_baseline_offset(body => text(size: 12pt, baseline: -3pt, body))
  let unraised = first_baseline_offset(body => text(size: 12pt, body))
  assert(
    calc.abs((unraised - raised - 3pt).pt()) < 0.01,
    message: "Raising the baseline by 3pt should raise the first baseline by 3pt, got "
      + repr(raised)
      + " vs "
      + repr(unraised),
  )
}

#show: e.set_(
  s.settings,
  code: "MAT244",
  name: "Differential Equations",
  term: "Fall 2025",
  // A font declaration that draws its glyphs above the baseline, as the example syllabus does.
  font_sans: it => text(font: "Arial", baseline: -0.3em, it),
  events: (),
  holidays: (),
)

// An annotation with a title, with a title and subtitle, and with neither should all render.
#s.annotated_item(title: "A Title", subtitle: "Subtitle")[
  The body's first line shares a baseline with the title next to it.
]
#s.annotated_item(title: "Title Only")[A second item.]
#s.annotated_item[An item with no annotation at all.]

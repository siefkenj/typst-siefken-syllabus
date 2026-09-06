#import "/src/types.typ": *
#import "/src/utils.typ": *


// Test the `date_in_range` function finds dates in the range (without hours)
#for days in range(7) {
  let start_date = datetime(year: 2025, month: 9, day: 1)
  let date = start_date + duration(days: days)
  let start = start_date
  let end = start_date + duration(days: 6)
  let val = date_in_range(date, start, end)
  assert(
    val == "during",
    message: "Date in range computed incorrectly "
      + date.display(
        "[year]-[month repr:short]-[day]"
          + " as "
          + val
          + " for range "
          + start.display("[year]-[month repr:short]-[day]")
          + " to "
          + end.display("[year]-[month repr:short]-[day]"),
      ),
  )
}

// Test the `date_in_range` function finds dates in the range (without hours)
#for days in range(7) {
  let start_date = datetime(
    year: 2025,
    month: 9,
    day: 1,
    hour: 17,
    minute: 10,
    second: 0,
  )
  let date = start_date + duration(days: days)
  let start = start_date
  let end = start_date + duration(days: 6)
  let val = date_in_range(date, start, end)
  assert(
    val == "during",
    message: "Date in range computed incorrectly "
      + date.display(
        "[year]-[month repr:short]-[day]"
          + " as "
          + val
          + " for range "
          + start.display("[year]-[month repr:short]-[day]")
          + " to "
          + end.display("[year]-[month repr:short]-[day]"),
      ),
  )
}

// Specific test that failed in the past
#let val = date_in_range(
  datetime(
    year: 2025,
    month: 1,
    day: 7,
    hour: 17,
    minute: 10,
    second: 0,
  ),
  datetime(year: 2025, month: 1, day: 1),
  datetime(
    year: 2025,
    month: 1,
    day: 7,
  ),
)
#assert(
  val == "during",
  message: "Date in range computed incorrectly "
    + datetime(
      year: 2025,
      month: 1,
      day: 7,
      hour: 17,
      minute: 10,
      second: 0,
    ).display("[year]-[month repr:short]-[day]")
    + " as "
    + val
    + " for range "
    + datetime(year: 2025, month: 1, day: 1).display("[year]-[month repr:short]-[day]")
    + " to "
    + datetime(year: 2025, month: 1, day: 7).display("[year]-[month repr:short]-[day]"),
)

// An event with a `duration` overlaps *every* week it spans, not just the one it starts in.
#let reading_break = (
  name: [Reading break],
  date: datetime(year: 2025, month: 10, day: 26),
  duration: duration(days: 5),
)
#let week = (start, end) => (
  datetime(year: 2025, month: 10, day: start),
  datetime(year: 2025, month: 10, day: end),
)
#for (label, weekdays, expected) in (
  ("the week before the break", week(13, 19), false),
  ("the week the break starts in", week(20, 26), true),
  ("the week the break ends in", week(27, 31) , true),
) {
  let (start, end) = weekdays
  assert(
    event_overlaps_range(reading_break, start, end) == expected,
    message: "Expected the reading break to "
      + (if expected { "overlap " } else { "not overlap " })
      + label,
  )
}

// Events without a duration overlap exactly the range that contains them.
#let homework = (name: [Homework], date: datetime(year: 2025, month: 10, day: 20))
#assert(
  event_overlaps_range(homework, ..week(20, 26)),
  message: "An event on the first day of a week should overlap that week",
)
#assert(
  event_overlaps_range(homework, ..week(14, 20)),
  message: "An event on the last day of a week should overlap that week",
)
#assert(
  not event_overlaps_range(homework, ..week(21, 27)),
  message: "An event before a week should not overlap that week",
)

// An event that ends on the day a range starts still overlaps that range, even when
// neither has hours attached.
#assert(
  event_overlaps_range(
    (name: [Break], date: datetime(year: 2025, month: 10, day: 25), duration: duration(days: 2)),
    ..week(26, 31),
  ),
  message: "An event ending on the first day of a range should overlap that range",
)

// A whole-day event counts the day it starts on, so it must not spill into the next day.
#assert(
  not event_overlaps_range(
    (name: [Holiday], date: datetime(year: 2025, month: 10, day: 25), duration: duration(days: 1)),
    ..week(26, 31),
  ),
  message: "A one-day event should not spill into the following day",
)
#let (_, break_end) = event_start_and_end(
  (name: [Break], date: datetime(year: 2025, month: 10, day: 26), duration: duration(days: 5)),
)
#assert(
  break_end.display("[year]-[month]-[day]") == "2025-10-30",
  message: "A five-day event starting Oct. 26 should end on Oct. 30, got "
    + break_end.display("[year]-[month]-[day]"),
)

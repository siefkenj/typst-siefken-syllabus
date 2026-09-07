#import "/src/types.typ": *
#import "/src/utils.typ": *

=== Duration and hours
#let ev = (
  name: "",
  date: datetime(year: 2025, month: 9, day: 15, hour: 17, minute: 10, second: 0),
  duration: duration(hours: 2),
)
#let formatted = format_event_date(ev)
#let expected = "Monday, Sep. 15 from 5:10pm to 7:10pm"
#assert(
  formatted == expected,
  message: "Expected '" + expected + "', got '" + formatted + "'",
)
#ev $->$ #raw(formatted)

=== No duration with hours
#let ev = (
  name: "",
  date: datetime(year: 2025, month: 9, day: 15, hour: 17, minute: 10, second: 0),
)
#let formatted = format_event_date(ev)
#let expected = "Monday, Sep. 15 at 5:10pm"
#assert(
  formatted == expected,
  message: "Expected '" + expected + "', got '" + formatted + "'",
)
#ev $->$ #raw(formatted)

=== No hours
#let ev = (
  name: "",
  date: datetime(year: 2025, month: 9, day: 15),
)
#let formatted = format_event_date(ev)
#let expected = "Monday, Sep. 15"
#assert(
  formatted == expected,
  message: "Expected '" + expected + "', got '" + formatted + "'",
)
#ev $->$ #raw(formatted)

=== No hours with duration
#let ev = (
  name: "",
  date: datetime(year: 2025, month: 9, day: 15),
  duration: duration(hours: 2),
)
#let formatted = format_event_date(ev)
#let expected = "Monday, Sep. 15"
#assert(
  formatted == expected,
  message: "Expected '" + expected + "', got '" + formatted + "'",
)
#ev $->$ #raw(formatted)

=== Multi-day event without hours
// Whole-day events count the day they start on, so a two-day event ends the day after it starts.
#let ev = (
  name: "",
  date: datetime(year: 2025, month: 9, day: 15),
  duration: duration(days: 2),
)
#let formatted = format_event_date(ev)
#let expected = "Monday, Sep. 15 to Tuesday, Sep. 16"
#assert(
  formatted == expected,
  message: "Expected '" + expected + "', got '" + formatted + "'",
)
#ev $->$ #raw(formatted)

=== Multi-day event with hours
#let ev = (
  name: "",
  date: datetime(year: 2025, month: 9, day: 15, hour: 17, minute: 10, second: 0),
  duration: duration(days: 2),
)
#let formatted = format_event_date(ev)
#let expected = "Monday, Sep. 15 at 5:10pm to Wednesday, Sep. 17 at 5:10pm"
#assert(
  formatted == expected,
  message: "Expected '" + expected + "', got '" + formatted + "'",
)
#ev $->$ #raw(formatted)

=== Multi-day event ending on the same day of a different month
#let ev = (
  name: "",
  date: datetime(year: 2025, month: 9, day: 15),
  duration: duration(days: 31),
)
#let formatted = format_event_date(ev)
#let expected = "Monday, Sep. 15 to Wednesday, Oct. 15"
#assert(
  formatted == expected,
  message: "Expected '" + expected + "', got '" + formatted + "'",
)
#ev $->$ #raw(formatted)

=== Single-digit days are not zero padded
#let ev = (
  name: "",
  date: datetime(year: 2025, month: 9, day: 5),
)
#let formatted = format_event_date(ev)
#let expected = "Friday, Sep. 5"
#assert(
  formatted == expected,
  message: "Expected '" + expected + "', got '" + formatted + "'",
)
#ev $->$ #raw(formatted)

=== A one-day event stays on its own day
#let ev = (
  name: "",
  date: datetime(year: 2025, month: 9, day: 3),
  duration: duration(days: 1),
)
#let formatted = format_event_date(ev)
#let expected = "Wednesday, Sep. 3"
#assert(
  formatted == expected,
  message: "Expected '" + expected + "', got '" + formatted + "'",
)
#ev $->$ #raw(formatted)

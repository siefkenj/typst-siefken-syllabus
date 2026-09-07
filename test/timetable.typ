#import "/src/types.typ": *
#import "/src/lib.typ" as s

#set page(margin: (left: 2in))

// A term that is shorter than a week may never contain the `week_start_day`. The whole
// term should then be rendered as a single partial week instead of crashing.
#[
  #show: e.set_(
    s.settings,
    // Thursday to Saturday; no Monday in sight.
    term_start_date: datetime(year: 2025, month: 9, day: 4),
    term_end_date: datetime(year: 2025, month: 9, day: 6),
    events: (
      (name: [Quiz], date: datetime(year: 2025, month: 9, day: 5), type: "test"),
    ),
    holidays: (),
  )

  === Mini-course shorter than a week
  #s.timetable(week_start_day: "monday", weekly_data: ([The whole course],))
]

// A holiday spanning a week boundary must be shown in every week it touches.
#[
  #show: e.set_(
    s.settings,
    term_start_date: datetime(year: 2025, month: 9, day: 1),
    term_end_date: datetime(year: 2025, month: 9, day: 21),
    events: (),
    holidays: (
      (
        name: [Long break],
        date: datetime(year: 2025, month: 9, day: 12),
        duration: duration(days: 4),
        type: "holiday",
      ),
    ),
  )

  #v(2in)
  === Holiday spanning a week boundary
  #s.timetable(
    week_start_day: "monday",
    weekly_data: ([Week one], [Week two], [Week three]),
  )
]

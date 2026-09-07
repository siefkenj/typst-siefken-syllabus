# Changelog

## 1.0.0

- Require Typst 0.15.0 or later.
- Fix date-range computation: whole-day events are now inclusive of their end
  day, and events with a `duration` count the day they start on.
- Events spanning a week boundary now appear in every week they overlap.
- Fix `annotated_item` title/body baseline alignment across font sizes.
- `timetable`: extra `weekly_data` entries append to "After Classes" instead of
  being dropped.
- Drop the leading zero from day numbers in formatted dates.
- Add a dev container, a test runner (`test/run.sh`), and CI.

## 0.1.0

- Initial release.

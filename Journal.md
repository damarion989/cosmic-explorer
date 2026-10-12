# Testing and reflection

Prepared October 11, 2026.

## Actual validation status

The installed Flutter tool could not run in this environment. The launcher
stalled; attempts through the installed Dart executable failed with
`Empty value for option resolved_executable_name` and
`Unrecognized flags: resolved_executable_name`. The alternate Dart runtime
reported a missing `dartdev_aot.dart.snapshot` when formatting was attempted.
Therefore dependency resolution, formatting, analysis, widget tests, and
browser/device execution are **not verified**. No manual testing results
are claimed. Run the commands in README.md on a working Flutter installation.

## Tests supplied

The widget suite checks all five detail selections and returned visit
messages, ordinary AppBar Back without a confirmation, drawer navigation
and return, malformed/negative/out-of-range planet IDs, an unknown route,
and a direct detail URL without a waiting caller.

## Code review insights

The AI review identified that int.parse and unchecked indexing can crash
on invalid URLs. The app uses int.tryParse and explicit bounds checks with
a recovery screen. It checks context.mounted after awaiting navigation,
uses typed String results, and handles direct detail links without blindly
popping an empty stack. Drawer callbacks use a Builder context below the
Scaffold so closeDrawer can find the correct Scaffold. The app owns and
disposes its router instead of recreating it during builds.

No external AI tutor was contacted. This review used the assignment and
official GoRouter navigation documentation. Complex state-management
patterns were unnecessary for this small catalog.

## Manual checks still to perform

- Browse all five planets and confirm each description and URL index.
- Confirm visits and check each SnackBar; use AppBar and device Back and
  verify those actions do not report a visit.
- Open and close the drawer repeatedly; test both destinations and return.
- Open `/planet/1` directly and refresh it. Confirm safely returns home.
- Open `/planet/nope`, `/planet/-1`, `/planet/5`, and an unknown destination.
  Verify the recovery button works.
- Try rapid taps, small screens, large text, and browser Back/Forward.
  Record any duplicate navigation, overflow, or browser-history behavior.
- Run the separate phase-one example and test its button and default
  AppBar back arrow in both directions.

Replace this pending checklist with observed results after running the app.

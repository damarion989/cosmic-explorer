# Cosmic Explorer

The final assignment app is in `lib/main.dart`. It uses MaterialApp.router,
GoRouter, exactly five immutable planets, a catalog, planet details, visit
results, a navigation drawer, and recoverable invalid-route screens.
`examples/phase1.dart` separately preserves the initial two-screen Navigator
exercise; it is not mixed with the final router.

## Run

From this directory, with a working Flutter SDK:

```sh
flutter pub get
dart format lib test examples
flutter analyze
flutter test
flutter run -d chrome
```

The web host is included. To generate mobile hosts if needed, run
`flutter create --platforms=android,ios .` on an appropriate development machine.
For the initial exercise, use `flutter run -d chrome -t examples/phase1.dart`.

## Assignment explanations

**Navigation stack:** A push puts a new route above the existing route.
Mission Control remains below it, usually retaining its state. Pop removes
the top route; after its transition, its widget subtree is disposed and can
be reclaimed when no references remain. The previous route becomes visible.
This is a stack of routes, not a literal copy of the phone's entire memory.

**Builder and data transfer:** ListView.builder creates rows as they are
needed around the viewport. A basic children list constructs its widgets
up front, and a Column does not provide scrolling or lazy construction.
With five rows the efficiency difference is small, but the builder scales.
In the imperative version, `PlanetDetail(planet: selectedPlanet)` receives
a reference to the immutable Planet object; the object is not serialized
or copied. In the final app the URL carries the index, and the route builder
retrieves that object from the shared catalog before passing it to the widget.

**Round trip:** `context.push<String>` returns a Future. Mission Control
awaits it while the detail page is open. `context.pop(message)` completes
that Future with the string, which becomes `result`. The mounted check
protects the use of context after the asynchronous gap. Ordinary Back
returns null, so no confirmation is shown. A directly opened detail URL has
no awaiting caller; Confirm Visit safely goes home without a return message.

**Imperative and declarative routing:** Navigator.push explicitly adds a
route object. GoRouter maps URL locations to pages. `go` changes the
location and replaces the configured page stack for that destination;
`push` places a page above the current stack and supports an awaited result.
The drawer uses go, and planet rows use push. Thus Docking Bay entered from
the drawer has a Return button but no preceding in-app page to pop. Browser
history is a separate concern from the in-app stack.

URLs allow direct links, browser refreshes, and shared destinations without
requiring a previously passed in-memory object. Index URLs are simple for
this assignment; reordering the catalog changes their meaning. Stable IDs
would be preferable in a larger app.

Official routing reference:
https://github.com/flutter/packages/blob/main/packages/go_router/doc/navigation.md

See Journal.md for validation status and the remaining manual checklist.

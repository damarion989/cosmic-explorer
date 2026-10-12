# Cosmic Explorer

## Phase 1

Navigator.push adds DockingBay to the navigation stack while MissionControl stays underneath it. Navigator.pop removes DockingBay and shows MissionControl again. The Return button and the default AppBar back button both return to the previous screen.

## Phase 2

Planet stores each planet's name, type, and description. PlanetCatalog holds five planets in one shared list. ListView.builder creates rows as they are needed. In the original navigation flow, the selected Planet object is passed to PlanetDetail through its constructor.

## Phase 3

MissionControl awaits the result of opening PlanetDetail. Confirm Visit returns a message when the detail screen closes, and MissionControl displays it in a SnackBar. Checking context.mounted after the await makes sure the context is still valid. Using the back button returns no visit message.

## Phase 4

GoRouter maps URL paths to screens. The planet route reads the ID from the URL and uses it to look up the planet in the catalog. context.push allows the detail screen to return a result, while context.go changes the destination for drawer navigation. URL routes also support direct links to specific screens.

## Phase 5

Invalid planet IDs show a fallback screen instead of crashing. A directly opened detail page returns safely to MissionControl. Navigation tests are included, but the app and tests could not be run because the local Flutter tools failed. The remaining testing steps are recorded in Journal.md.

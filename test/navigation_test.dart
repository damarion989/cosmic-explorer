import 'package:cosmic_explorer/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('all five planets return their visit message', (tester) async {
    await tester.pumpWidget(const CosmicExplorerApp());
    await tester.pumpAndSettle();
    for (final planet in PlanetCatalog.planets) {
      await tester.tap(find.text(planet.name));
      await tester.pumpAndSettle();
      expect(find.text(planet.description), findsOneWidget);
      await tester.tap(find.text('Confirm Visit'));
      await tester.pumpAndSettle();
      expect(find.text('You visited ${planet.name}!'), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('AppBar back returns without a confirmation', (tester) async {
    await tester.pumpWidget(const CosmicExplorerApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mars'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Cosmic Explorer - Mission Control'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('drawer opens Docking Bay and returns', (tester) async {
    await tester.pumpWidget(const CosmicExplorerApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Docking Bay'));
    await tester.pumpAndSettle();
    expect(find.text('Docking Bay Telemetry'), findsOneWidget);
    await tester.tap(find.text('Return to Control'));
    await tester.pumpAndSettle();
    expect(find.text('Cosmic Explorer - Mission Control'), findsOneWidget);
  });

  for (final path in ['/planet/nope', '/planet/-1', '/planet/5', '/unknown']) {
    testWidgets('$path has a recoverable fallback', (tester) async {
      final router = createRouter(initialLocation: path);
      addTearDown(router.dispose);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();
      expect(find.text('Destination unavailable'), findsOneWidget);
      await tester.tap(find.text('Return to Control'));
      await tester.pumpAndSettle();
      expect(find.text('Cosmic Explorer - Mission Control'), findsOneWidget);
    });
  }

  testWidgets('direct detail URL confirms safely without a caller', (tester) async {
    final router = createRouter(initialLocation: '/planet/1');
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    expect(find.text(PlanetCatalog.planets[1].description), findsOneWidget);
    await tester.tap(find.text('Confirm Visit'));
    await tester.pumpAndSettle();
    expect(find.text('Cosmic Explorer - Mission Control'), findsOneWidget);
  });
}

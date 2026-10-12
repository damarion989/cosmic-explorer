import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const CosmicExplorerApp());

class Planet {
  final String name;
  final String type;
  final String description;

  const Planet({required this.name, required this.type, required this.description});
}

class PlanetCatalog {
  static const List<Planet> planets = [
    Planet(name: 'Mercury', type: 'Terrestrial', description: 'Mercury is the smallest planet in our solar system and the closest to the Sun. Its rocky surface is heavily cratered, and its thin exosphere provides little insulation against extreme temperature changes.'),
    Planet(name: 'Mars', type: 'Terrestrial', description: 'Mars is a rocky planet with a thin atmosphere and a surface colored red by iron-rich minerals. It has polar ice caps, immense volcanoes, and evidence that liquid water once flowed across its surface.'),
    Planet(name: 'Jupiter', type: 'Gas Giant', description: 'Jupiter is the largest planet in our solar system. Its atmosphere contains bands of clouds and powerful storms, including the Great Red Spot. It has a large family of moons and a faint ring system.'),
    Planet(name: 'Kepler-186f', type: 'Terrestrial exoplanet candidate', description: 'Kepler-186f is an approximately Earth-sized exoplanet orbiting a red dwarf. It lies in its star’s habitable zone, where suitable conditions could allow liquid water. Its atmosphere, surface conditions, and habitability are not known.'),
    Planet(name: 'Proxima Centauri b', type: 'Terrestrial exoplanet candidate', description: 'Proxima Centauri b orbits the closest star to the Sun, Proxima Centauri. It is a roughly Earth-mass planet in the star’s habitable zone. Stellar activity and uncertainty about its atmosphere mean that its suitability for life remains unknown.'),
  ];
}

GoRouter createRouter({String initialLocation = '/'}) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MissionControl()),
    GoRoute(path: '/docking-bay', builder: (context, state) => const DockingBay()),
    GoRoute(path: '/planet/:id', builder: (context, state) {
      final id = int.tryParse(state.pathParameters['id'] ?? '');
      if (id == null || id < 0 || id >= PlanetCatalog.planets.length) {
        return const RouteFallback(message: 'Planet not found. Choose a planet from Mission Control.');
      }
      return PlanetDetail(planet: PlanetCatalog.planets[id]);
    }),
  ],
  errorBuilder: (context, state) => const RouteFallback(message: 'This destination does not exist.'),
);

class CosmicExplorerApp extends StatefulWidget {
  const CosmicExplorerApp({super.key});

  @override
  State<CosmicExplorerApp> createState() => _CosmicExplorerAppState();
}

class _CosmicExplorerAppState extends State<CosmicExplorerApp> {
  final GoRouter _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Cosmic Explorer',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo), useMaterial3: true),
    routerConfig: _router,
  );
}

class MissionControl extends StatelessWidget {
  const MissionControl({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Cosmic Explorer - Mission Control')),
    drawer: Builder(builder: (context) => Drawer(child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(child: Text('IEA Command Systems')),
        ListTile(leading: const Icon(Icons.home), title: const Text('Mission Control'), onTap: () {
          Scaffold.of(context).closeDrawer();
          context.go('/');
        }),
        ListTile(leading: const Icon(Icons.rocket_launch), title: const Text('Docking Bay'), onTap: () {
          Scaffold.of(context).closeDrawer();
          context.go('/docking-bay');
        }),
      ],
    ))),
    body: ListView.builder(
      itemCount: PlanetCatalog.planets.length,
      itemBuilder: (context, index) {
        final planet = PlanetCatalog.planets[index];
        return ListTile(
          leading: const Icon(Icons.public),
          title: Text(planet.name),
          subtitle: Text(planet.type),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            final result = await context.push<String>('/planet/$index');
            if (!context.mounted) return;
            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
            }
          },
        );
      },
    ),
  );
}

class PlanetDetail extends StatelessWidget {
  final Planet planet;
  const PlanetDetail({super.key, required this.planet});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(planet.name)),
    body: SingleChildScrollView(child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(planet.type, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Text(planet.description),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () {
          if (context.canPop()) {
            context.pop('You visited ${planet.name}!');
          } else {
            // A direct URL has no waiting caller to receive a pop result.
            context.go('/');
          }
        }, child: const Text('Confirm Visit')),
      ]),
    )),
  );
}

class DockingBay extends StatelessWidget {
  const DockingBay({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Docking Bay Telemetry')),
    body: Center(child: ElevatedButton(
      onPressed: () => context.go('/'),
      child: const Text('Return to Control'),
    )),
  );
}

class RouteFallback extends StatelessWidget {
  final String message;
  const RouteFallback({super.key, required this.message});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Destination unavailable')),
    body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
      Text(message),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: () => context.go('/'), child: const Text('Return to Control')),
    ])),
  );
}

// Optional starting exercise. Run with flutter run -t examples/phase1.dart.
import 'package:flutter/material.dart';

void main() => runApp(const CosmicExplorerApp());

class CosmicExplorerApp extends StatelessWidget {
  const CosmicExplorerApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(home: MissionControl());
}

class MissionControl extends StatelessWidget {
  const MissionControl({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Cosmic Explorer - Mission Control')),
    body: Center(child: ElevatedButton(
      onPressed: () => Navigator.push<void>(context,
        MaterialPageRoute(builder: (context) => const DockingBay())),
      child: const Text('Enter Docking Bay'),
    )),
  );
}

class DockingBay extends StatelessWidget {
  const DockingBay({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Docking Bay Telemetry')),
    body: Center(child: ElevatedButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Return to Control'),
    )),
  );
}

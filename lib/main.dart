import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rive Stutter Test',
      theme: ThemeData.dark(),
      home: const RiveTestPage(),
    );
  }
}

class RiveTestPage extends StatefulWidget {
  const RiveTestPage({super.key});

  @override
  State<RiveTestPage> createState() => _RiveTestPageState();
}

class _RiveTestPageState extends State<RiveTestPage> {
  static const _assets = [
    'assets/logo_flat.riv',
    'assets/logo_feather.riv',
    'assets/logo_component_feather.riv',
  ];

  static const _labels = ['Flat', 'Feather', 'Component Feather'];

  int _selected = 0;

  late List<FileLoader> _fileLoaders;

  @override
  void initState() {
    super.initState();
    _fileLoaders = _assets
        .map(
          (asset) => FileLoader.fromAsset(asset, riveFactory: Factory.flutter),
        )
        .toList();
  }

  @override
  void dispose() {
    for (final loader in _fileLoaders) {
      loader.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rive Stutter Test')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SegmentedButton<int>(
              segments: [
                for (int i = 0; i < _labels.length; i++)
                  ButtonSegment(value: i, label: Text(_labels[i])),
              ],
              selected: {_selected},
              onSelectionChanged: (v) => setState(() => _selected = v.first),
            ),
          ),
          Expanded(
            child: Center(
              child: RiveWidgetBuilder(
                key: ValueKey(_selected),
                fileLoader: _fileLoaders[_selected],
                builder: (context, state) => switch (state) {
                  RiveLoaded(:final controller) => RiveWidget(
                    controller: controller,
                    fit: Fit.contain,
                  ),
                  RiveFailed(:final error) => Text('Error: $error'),
                  RiveLoading() => const CircularProgressIndicator(),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

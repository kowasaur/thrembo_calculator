import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thrembo Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Thrembo Calculator Ϫ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _buttonLabels = [
    '.',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    'Ϫ',
    '7',
    '8',
    '9'
  ];

  String _thremboText = "";

  void _inputChar(String char) => setState(() => _thremboText += char);

  @override
  Widget build(BuildContext context) {
    var buttons = GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        children: _buttonLabels
            .map((c) =>
                ElevatedButton(onPressed: () => _inputChar(c), child: Text(c)))
            .toList());

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(_thremboText), buttons],
      ),
    );
  }
}

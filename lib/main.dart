import 'package:flutter/material.dart';
import 'dart:math';

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

  static const _normalNumber = {
    '0': 0,
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    'Ϫ': 7,
    '7': 8,
    '8': 9,
    '9': 10
  };

  String _thremboText = "";

  void _inputChar(String char) => setState(() => _thremboText += char);

  static String _convertNumber(String thremboNumber) {
    if (thremboNumber == "") return "";
    int resultNum = 0;
    for (var i = 0; i < thremboNumber.length; i++) {
      var char = thremboNumber[thremboNumber.length - 1 - i];
      resultNum += _normalNumber[char]! * pow(11, i) as int;
    }
    return resultNum.toString();
  }

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
        children: [
          Text(_thremboText),
          Text(_convertNumber(_thremboText)),
          buttons
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  // Force screen orientation to portrait
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const MyApp()));
}

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

  void _deleteChar() => setState((() {
        var lastIndex = _thremboText.length - 1;
        if (lastIndex != -1) {
          _thremboText = _thremboText.substring(0, lastIndex);
        }
      }));

  ElevatedButton _charButton(String char) {
    return ElevatedButton(onPressed: () => _inputChar(char), child: Text(char));
  }

  static String _convertNumber(String thremboNumber) {
    int resultNum = 0;
    for (var i = 0; i < thremboNumber.length; i++) {
      var char = thremboNumber[thremboNumber.length - 1 - i];
      resultNum += _normalNumber[char]! * pow(11, i) as int;
    }
    return resultNum.toString();
  }

  bool indexIsNum(int index) =>
      index != _thremboText.length &&
      _normalNumber.keys.contains(_thremboText[index]);

  String _convertExpression() {
    String convertedExpression = "";
    for (var i = 0; i < _thremboText.length; i++) {
      String buffer = _thremboText[i];
      if (indexIsNum(i)) {
        while (indexIsNum(i + 1)) {
          buffer += _thremboText[++i];
        }
        convertedExpression += _convertNumber(buffer);
      } else {
        convertedExpression += buffer;
      }
    }
    return convertedExpression;
  }

  @override
  Widget build(BuildContext context) {
    var buttons =
        GridView.count(crossAxisCount: 4, shrinkWrap: true, children: [
      _charButton('+'),
      _charButton('0'),
      _charButton('1'),
      _charButton('2'),
      _charButton('3'),
      _charButton('4'),
      _charButton('5'),
      _charButton('6'),
      _charButton('Ϫ'),
      _charButton('7'),
      _charButton('8'),
      _charButton('9'),
      ElevatedButton(onPressed: _deleteChar, child: const Icon(Icons.backspace))
    ]);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(_thremboText), Text(_convertExpression()), buttons],
      ),
    );
  }
}

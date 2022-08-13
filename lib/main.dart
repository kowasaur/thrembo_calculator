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
  static const _thremboToNormal = {
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

  static final Map<String, int Function(int, int)> _operators = {
    '+': (a, b) => a + b,
    '-': (a, b) => a - b,
    '×': (a, b) => a * b,
    '÷': (a, b) => a ~/ b
  };

  // Reverse of _thremboToNormal
  static final _normalToThrembo =
      _thremboToNormal.map((key, value) => MapEntry(value, key));

  String _thremboText = "";

  void _setThremboText(String str) => setState(() => _thremboText = str);

  void _inputChar(String char) => _setThremboText(_thremboText + char);

  void _deleteChar() {
    final lastIndex = _thremboText.length - 1;
    if (lastIndex != -1) {
      _setThremboText(_thremboText.substring(0, lastIndex));
    }
  }

  CalcButton _charButton(String char) {
    return CalcButton(onPressed: () => _inputChar(char), child: Text(char));
  }

  static int _convertNumber(String thremboNumber) {
    int resultNum = 0;
    for (var i = 0; i < thremboNumber.length; i++) {
      var char = thremboNumber[thremboNumber.length - 1 - i];
      resultNum += _thremboToNormal[char]! * pow(11, i) as int;
    }
    return resultNum;
  }

  /// Check whether the _thremboText character at this index is a thrembo number
  bool _indexIsNum(int index) =>
      index != _thremboText.length &&
      _thremboToNormal.keys.contains(_thremboText[index]);

  List<dynamic> _parseExpression() {
    final tokens = [];
    for (var i = 0; i < _thremboText.length; i++) {
      String buffer = _thremboText[i];
      if (_indexIsNum(i)) {
        while (_indexIsNum(i + 1)) {
          buffer += _thremboText[++i];
        }
        tokens.add(_convertNumber(buffer));
      } else {
        tokens.add(buffer);
      }
    }
    return tokens;
  }

  String _convertExpression() =>
      _parseExpression().fold("", (str, token) => str + token.toString());

  void _evaluateExpression() {
    final tokens = _parseExpression();
    while (tokens.length != 1) {
      for (var i = 0; i < tokens.length; i++) {
        // If it's an operator
        if (tokens[i].runtimeType == String) {
          final int left = tokens[i - 1];
          final int right = tokens[i + 1];
          final int result = _operators[tokens[i]]!(left, right);
          tokens.removeRange(i, i + 2); // [i, i+2)
          tokens[i - 1] = result;
          break;
        }
      }
    }
    final int answer = tokens[0];

    // Convert to thrembo number
    int remaining = answer;
    String buffer = "";
    while (true) {
      final remainder = remaining % 11;
      buffer = _normalToThrembo[remainder]! + buffer;
      if ((remaining - remainder) < 11) break;
      remaining = (remaining - remainder) ~/ 11;
    }
    _setThremboText(buffer);
  }

  @override
  Widget build(BuildContext context) {
    var buttons =
        GridView.count(crossAxisCount: 4, shrinkWrap: true, children: [
      _charButton('+'),
      _charButton('-'),
      _charButton('×'),
      _charButton('÷'),
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
      CalcButton(onPressed: _deleteChar, child: const Icon(Icons.backspace)),
      CalcButton(onPressed: _evaluateExpression, child: const Text('='))
    ]);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_thremboText, textScaleFactor: 2.5),
          Text(
            _convertExpression(),
            textScaleFactor: 2,
          ),
          buttons
        ],
      ),
    );
  }
}

class CalcButton extends StatelessWidget {
  const CalcButton({Key? key, required this.onPressed, required this.child})
      : super(key: key);

  final void Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 25)),
          child: child));
}

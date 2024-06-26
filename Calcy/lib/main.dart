import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartCalc',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _display = '0';
  String _input = '';
  double? _firstOperand;
  double? _secondOperand;
  String? _operator;

  void _inputDigit(String digit) {
    setState(() {
      if (_input == '0') {
        _input = digit;
      } else {
        _input += digit;
      }
      _display = _input;
    });
  }

  void _inputOperator(String operator) {
    setState(() {
      _firstOperand = double.tryParse(_input) ?? 0;
      _operator = operator;
      _input += ' $operator ';
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _input = '';
      _firstOperand = null;
      _secondOperand = null;
      _operator = null;
    });
  }

  void _calculate() {
    setState(() {
      List<String> parts = _input.split(' ');
      if (parts.length < 3) return;
      _firstOperand = double.tryParse(parts[0]) ?? 0;
      _operator = parts[1];
      _secondOperand = double.tryParse(parts[2]) ?? 0;

      switch (_operator) {
        case '+':
          _display = (_firstOperand! + _secondOperand!).toString();
          break;
        case '-':
          _display = (_firstOperand! - _secondOperand!).toString();
          break;
        case '*':
          _display = (_firstOperand! * _secondOperand!).toString();
          break;
        case '/':
          _display = (_firstOperand! / _secondOperand!).toString();
          break;
      }
      _input = _display;
      _firstOperand = null;
      _secondOperand = null;
      _operator = null;
    });
  }

  void _inputDecimal() {
    setState(() {
      if (!_input.contains('.')) {
        _input += '.';
      }
      _display = _input;
    });
  }

  Widget _buildButton(String label, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          onPressed: () {
            if (label == 'C') {
              _clear();
            } else if (label == '.') {
              _inputDecimal();
            } else if ('0123456789'.contains(label)) {
              _inputDigit(label);
            } else if ('+-*/'.contains(label)) {
              _inputOperator(label);
            } else if (label == '=') {
              _calculate();
            }
          },
          child: Text(
            label,
            style: const TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartCalc'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _input,
                    style: const TextStyle(fontSize: 24.0, color: Colors.grey),
                  ),
                  Text(
                    _display,
                    style: const TextStyle(fontSize: 48.0),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('/'),
            ],
          ),
          Row(
            children: [
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('*'),
            ],
          ),
          Row(
            children: [
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('-'),
            ],
          ),
          Row(
            children: [
              _buildButton('0'),
              _buildButton('.'),
              _buildButton('='),
              _buildButton('+'),
            ],
          ),
          Row(
            children: [
              _buildButton('C', color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }
}

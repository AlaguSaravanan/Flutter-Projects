import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _display = '0';
  String _input = '';

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
      if (_input.isNotEmpty && !'+-*/'.contains(_input[_input.length - 1])) {
        _input += operator;
      }
    });
  }

  void _backspace() {
    setState(() {
      if (_input.isNotEmpty) {
        _input = _input.substring(0, _input.length - 1);
        _display = _input.isEmpty ? '0' : _input;
      }
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _input = '';
    });
  }

  void _calculate() {
    setState(
      () {
        String expression = _input.replaceAll(' ', '');
        List<String> parts = [];
        String currentOperand = '';

        for (int i = 0; i < expression.length; i++) {
          String char = expression[i];
          if ('+-*/'.contains(char)) {
            parts.add(currentOperand);
            parts.add(char);
            currentOperand = '';
          } else {
            currentOperand += char;
          }
        }
        parts.add(currentOperand);

        double result = double.tryParse(parts[0]) ?? 0;
        for (int i = 1; i < parts.length; i += 2) {
          String operator = parts[i];
          double operand = double.tryParse(parts[i + 1]) ?? 0;

          switch (operator) {
            case '+':
              result += operand;
              break;
            case '-':
              result -= operand;
              break;
            case '*':
              result *= operand;
              break;
            case '/':
              result /= operand;
              break;
          }
        }
        _display = result.toString();
        _input = _display;
      },
    );
  }

  void _calculatePercentage() {
    setState(() {
      double value = double.tryParse(_input) ?? 0;
      value = value / 100;
      _input = value.toString();
      _display = _input;
    });
  }

  void _inputDecimal() {
    setState(() {
      if (_input.contains('.')) {
        _input += '.';
      }
      _display = _input;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1.0),
        toolbarHeight: 100,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoSizeText(
                    _input,
                    style: const TextStyle(fontSize: 28, color: Colors.black),
                    maxLines: 1,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AutoSizeText(
                    _display,
                    style: const TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    minFontSize: 15,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              _buildButton('C'),
              _buildBackspace(Icons.backspace),
              _buildButton('%'),
              _buildButton('/'),
            ],
          ),
          Row(
            children: [
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('*'),
            ],
          ),
          Row(
            children: [
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('-'),
            ],
          ),
          Row(
            children: [
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('+'),
            ],
          ),
          Row(
            children: [
              _buildButton('.'),
              _buildButton('0'),
              _buildEqualButton(),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label) {
    Color textColor = Colors.black;
    if (label == 'C' ||
        label == '+' ||
        label == '-' ||
        label == '*' ||
        label == '/' ||
        label == '%') {
      textColor = Colors.indigo;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
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
            } else if (label == '%') {
              _calculatePercentage();
            }
          },
          style: ElevatedButton.styleFrom(
            elevation: 0.5,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            minimumSize: const Size.square(50),
          ),
          child: Text(
            label,
            style: TextStyle(fontSize: 24, color: textColor),
          ),
        ),
      ),
    );
  }

  Widget _buildEqualButton() {
    return Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: ElevatedButton(
            onPressed: _calculate,
            style: ElevatedButton.styleFrom(
              elevation: 0.5,
              backgroundColor: Colors.indigo,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              minimumSize: const Size.square(50),
            ),
            child: const Text(
              '=',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  backgroundColor: Colors.indigo),
            ),
          ),
        ));
  }

  Widget _buildBackspace(IconData icon) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ElevatedButton(
        onPressed: _backspace,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          minimumSize: const Size.square(50),
        ),
        child: Icon(
          icon,
          size: 24,
          color: Colors.indigo,
        ),
      ),
    ));
  }
}

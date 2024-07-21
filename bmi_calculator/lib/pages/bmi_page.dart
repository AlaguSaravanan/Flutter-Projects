
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/calculator.dart';
import '../widgets/Info_card.dart';

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  double? _deviceWidth;
  double? _deviceHeight;
  int _age = 20, _height = 160, _weight = 65, _gender = 0;

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ageSelectWidget(),
                _weightSelectWidget(),
              ],
            ),
            _heightSelectWidget(),
            _genderSelectWidget(),
            CupertinoButton.filled(
              child: const Text('Calculate BMI'),
              onPressed: () {
                if (_age > 0 && _weight > 0 && _height > 0) {
                  double _bmi = calculateBMI(_height, _weight);
                  _showBmiWidget(_bmi);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _ageSelectWidget() {
    return InfoCard(
      width: _deviceWidth! * 0.45,
      height: _deviceHeight! * 0.20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Age yrs',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            _age.toString(),
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _age--;
                  });
                },
                child: const Text(
                  '-',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _age++;
                  });
                },
                child: const Text(
                  '+',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _weightSelectWidget() {
    return InfoCard(
      width: _deviceWidth! * 0.45,
      height: _deviceHeight! * 0.20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Weight kgs',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            _weight.toString(),
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _weight--;
                  });
                },
                child: const Text(
                  '-',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _weight++;
                  });
                },
                child: const Text(
                  '+',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heightSelectWidget() {
    return InfoCard(
      width: _deviceWidth! * 0.90,
      height: _deviceHeight! * 0.15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Height cms',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            _height.toString(),
            style: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: _deviceWidth! * 0.80,
            child: CupertinoSlider(
              max: 272,
              min: 0,
              divisions: 272,
              value: _height.toDouble(),
              onChanged: (_value) {
                setState(() {
                  _height = _value.toInt();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderSelectWidget() {
    return InfoCard(
      width: _deviceWidth! * 0.90,
      height: _deviceHeight! * 0.11,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Gender',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          CupertinoSlidingSegmentedControl(
              groupValue: _gender,
              children: const {
                0: Text('Male'),
                1: Text('Female'),
              },
              onValueChanged: (_value) {
                setState(() {
                  _gender = _value as int;
                });
              })
        ],
      ),
    );
  }

  void _showBmiWidget(double _bmi) {
    String? _status;
    if (_bmi < 18.5) {
      _status = 'UnderWeight';
    } else if (_bmi > 18.5 && _bmi < 25) {
      _status = 'Normal';
    } else if (_bmi > 25 && _bmi < 30) {
      _status = 'OverWeigth';
    } else if (_bmi >= 30) {
      _status = 'Obese';
    }
    showCupertinoDialog(
      context: context,
      builder: (BuildContext _context) {
        return CupertinoAlertDialog(
          title: Text(_status!),
          content: Text(
            _bmi.toStringAsFixed(2),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                _saveResult(_bmi.toString(), _status!);
                Navigator.pop(_context);
              },
            ),
          ],
        );
      },
    );
  }

  void _saveResult(String _bmi, String _status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'bmi_date',
      DateTime.now().toString(),
    );
    await prefs.setStringList(
      'bmi_data',
      <String>[
        _bmi,
        _status,
      ],
    );
  }
}

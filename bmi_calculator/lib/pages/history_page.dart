
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/Info_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  double? _deviceHeight;

  double? _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return CupertinoPageScaffold(
      child: _dataCard(),
    );
  }

  Widget _dataCard() {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          final _prefs = _snapshot.data as SharedPreferences;
          final _data = _prefs.getStringList('bmi_data');
          final _date = _prefs.getString('bmi_date');
          return Center(
            child: InfoCard(
              height: _deviceHeight! * 0.25,
              width: _deviceWidth! * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _statusText(
                    _data![1],
                  ),
                  _dateText(_date!),
                  _bmiText(_data[0]),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        }
      },
    );
  }

  Widget _statusText(String _status) {
    return Text(
      _status,
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _dateText(String _date) {
    DateTime _parsedDate = DateTime.parse(_date);
    return Text(
      '${_parsedDate.day}/${_parsedDate.month}/${_parsedDate.year}',
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _bmiText(String _bmi) {
    return Text(
      double.parse(_bmi).toStringAsFixed(2),
      style: const TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

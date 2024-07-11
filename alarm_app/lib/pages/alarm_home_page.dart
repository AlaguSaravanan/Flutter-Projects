import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmHomePage extends StatefulWidget {
  @override
  _AlarmHomePageState createState() => _AlarmHomePageState();
}

class _AlarmHomePageState extends State<AlarmHomePage> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _alarmTime = '';
  String _labelText = 'Enter Label';
  String _selectedRingtone = 'Default';
  bool _isAlarmOn = false;
  bool _isExpanded = false;
  final List<String> _selectedDays = [];
  final List<String> _weekDays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];
  final List<String> _ringtones = ['Default', 'Alarm 1', 'Alarm 2', 'Alarm 3'];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    final InitializationSettings initializationSettings =
        const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((TimeOfDay? time) {
      if (time != null) {
        setState(() {
          _selectedTime = time;
          _alarmTime = time.format(context);
          _isExpanded = true;
        });
      }
    });
  }

  void _showLabelInput() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Label'),
          content: TextField(
            onChanged: (String value) {
              setState(() {
                _labelText = value;
              });
            },
            controller: TextEditingController(text: _labelText),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showRingtonePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Ringtone'),
          content: SingleChildScrollView(
            child: Column(
              children: _ringtones.map((String ringtone) {
                return ListTile(
                  title: Text(ringtone),
                  onTap: () {
                    setState(() {
                      _selectedRingtone = ringtone;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _deleteAlarm() {
    // Logic to delete the alarm
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _toggleDaySelection(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _showNotification() {
    // Set up the notification
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alarm_channel_id',
      'Alarm Channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    _flutterLocalNotificationsPlugin.show(
      0,
      'Alarm',
      'Your alarm is ringing!',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alarm',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        toolbarHeight: 100,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30,),
          Text(
            TimeOfDay.now().format(context),
            style: const TextStyle(fontSize: 40),
          ),
          Text(
            DateTime.now().toLocal().toString().split(' ')[0],
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.label),
                          GestureDetector(
                            onTap: _showLabelInput,
                            child: Text(
                              _labelText,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                          ),
                          IconButton(
                            icon: Icon(_isExpanded
                                ? Icons.arrow_upward
                                : Icons.arrow_downward),
                            onPressed: _toggleExpansion,
                          ),
                        ],
                      ),
                      if (_isExpanded) ...[
                        Text(
                          _alarmTime,
                          style: TextStyle(fontSize: 26),
                        ),
                        Switch(
                          value: _isAlarmOn,
                          onChanged: (bool value) {
                            setState(() {
                              _isAlarmOn = value;
                              if (_isAlarmOn) {
                                _showNotification();
                              }
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _weekDays.map((String day) {
                            return IconButton(
                              icon: Icon(_selectedDays.contains(day)
                                  ? Icons.check_circle
                                  : Icons.circle),
                              onPressed: () => _toggleDaySelection(day),
                            );
                          }).toList(),
                        ),
                        ListTile(
                          title: Text('Ringtone'),
                          subtitle: Text(_selectedRingtone),
                          onTap: _showRingtonePicker,
                        ),
                        TextButton(
                          onPressed: _deleteAlarm,
                          child: Text('Delete'),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTimePicker,
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'dart:async';
import 'dart:typed_data';  // Import this for Int32List

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../models/alarm.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _timeString;
  late String _dateString;
  final List<Alarm> _alarms = [];
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _checkAlarms());
  }

  void _initializeNotifications() async {
    // Define initialization settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid, iOS: null, macOS: null);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          // Handle notification taps and snooze actions
          if (response.payload != null) {
            final String time = response.payload!;
            _showSnoozeDialog(time);
          }
        });

    // Create the notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'alarm_channel', // id
      'Alarms', // title
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _showNotification(Alarm alarm) async {
    // Define notification details
     AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'alarm_channel',
      'Alarms',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      additionalFlags: Int32List.fromList(<int>[4]), // Use `Int32List.fromList` here
    );
    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails, iOS: null);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Alarm',
      'Alarm for ${alarm.time.format(context)}',
      notificationDetails,
      payload: alarm.time.format(context),
    );

    // Set the alarm to inactive after showing the notification
    setState(() {
      alarm.isActive = false;
    });
  }

  Future<void> _showSnoozeDialog(String time) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Snooze Alarm'),
          content: const Text('Would you like to snooze the alarm for 5 minutes?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Snooze'),
              onPressed: () {
                Navigator.of(context).pop();
                final TimeOfDay originalTime = TimeOfDay(
                  hour: int.parse(time.split(':')[0]),
                  minute: int.parse(time.split(':')[1]),
                );
                final DateTime now = DateTime.now();
                final DateTime snoozeTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  originalTime.hour,
                  originalTime.minute,
                ).add(const Duration(minutes: 5));
                setState(() {
                  _alarms.add(Alarm(
                    isActive: true,
                    time: TimeOfDay.fromDateTime(snoozeTime),
                  ));
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = _formatTime(now);
    final String formattedDate = _formatDate(now);
    setState(() {
      _timeString = formattedTime;
      _dateString = formattedDate;
    });
  }

  void _checkAlarms() {
    final DateTime now = DateTime.now();
    for (var alarm in _alarms) {
      if (alarm.isActive &&
          now.hour == alarm.time.hour &&
          now.minute == alarm.time.minute &&
          now.second == 0) {
        _showNotification(alarm);
      }
    }
  }

  String _formatTime(DateTime datetime) {
    return DateFormat('hh:mm:ss a').format(datetime);
  }

  String _formatDate(DateTime datetime) {
    return DateFormat('dd/MM/yyyy').format(datetime);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              _currentTime(),
              _currentDate(),
              const SizedBox(height: 30),
              _alarmList(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0.5,
          onPressed: () {
            _showTimePicker();
          },
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _currentTime() {
    return Text(
      _timeString,
      style: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    );
  }

  Widget _currentDate() {
    return Text(
      _dateString,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: Colors.black,
      ),
    );
  }

  Future<TimeOfDay?> _showTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _alarms.add(Alarm(time: picked, isActive: true));
      });
    }
    return null;
  }

  Widget _alarmList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _alarms.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _alarms[index].time.format(context),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            trailing: Switch(
              value: _alarms[index].isActive,
              onChanged: (bool value) {
                setState(() {
                  _alarms[index].isActive = value;
                });
              },
            ),
          );
        },
      ),
    );
  }
}

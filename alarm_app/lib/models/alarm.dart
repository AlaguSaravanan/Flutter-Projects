import 'package:flutter/material.dart';

class Alarm {
  TimeOfDay time;
  String label;
  String ringtone;
  bool isActive;

  Alarm(
      {required this.time,
      this.label = '',
      this.isActive = true,
      this.ringtone = 'Default'});
}

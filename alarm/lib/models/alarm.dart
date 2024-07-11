import 'package:flutter/material.dart';

class Alarm {
  TimeOfDay time;
  bool isActive;

  Alarm({required this.time, this.isActive = true});
}

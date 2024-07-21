
import 'package:bmi_calculator/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI',
      routes: {
        '/': (BuildContext _context) => HomePage(),
      },
      initialRoute: '/',
    );
  }
}

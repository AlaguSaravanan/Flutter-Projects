import 'package:flutter/material.dart';
import 'package:trivia/pages/start_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Frivia',
      theme: ThemeData(
        fontFamily: 'PlaywriteNigeriaModern',
        scaffoldBackgroundColor: const Color.fromRGBO(31, 31, 31, 1.0),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StartPage(),
    );
  }
}

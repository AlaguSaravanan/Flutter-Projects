import 'package:bmi_calculator/pages/home_page.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'IBMI',
      routes: {
        '/': (BuildContext _context) => HomePage(),
      },
      initialRoute: '/',
    );
  }
}

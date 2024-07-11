import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'bmi_page.dart';
import 'history_page.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _tabs = [
    BMIPage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('IBMI'),
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: "BMI",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: "History",
            ),
          ],
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            builder: (context) {
              return _tabs[index];
            },
          );
        },
      ),
    );
  }
}
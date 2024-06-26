import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double _buttonRadius = 100;
  final Tween<double> _backgroundScale = Tween<double>(begin: 0.0, end: 1.0);
  AnimationController? _starIcon;

  @override
  void initState() {
    super.initState();
    _starIcon =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _starIcon!.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _pageBackground(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _circularAnimationButton(),
                _starIconWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageBackground() {
    return TweenAnimationBuilder(
      tween: _backgroundScale,
      curve: Curves.decelerate,
      duration: const Duration(seconds: 1),
      builder: (_context, double _scale, _child) {
        return Transform.scale(
          scale: _scale,
          child: _child,
        );
      },
      child: Container(
        color: Colors.blue,
      ),
    );
  }

  Widget _circularAnimationButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _buttonRadius += _buttonRadius == 200 ? -100 : 100;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.bounceInOut,
          height: _buttonRadius,
          width: _buttonRadius,
          decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(_buttonRadius)),
          child: const Center(
              child: Text(
            'Basic!',
            style: TextStyle(color: Colors.white),
          )),
        ),
      ),
    );
  }

  Widget _starIconWidget() {
    return AnimatedBuilder(
      animation: _starIcon!.view,
      builder: (_buildContext, _child) {
        return Transform.rotate(
          angle: _starIcon!.value * 2 * pi,
          child: _child,
        );
      },
      child: const Icon(
        Icons.star,
        color: Colors.white,
        size: 100,
      ),
    );
  }
}

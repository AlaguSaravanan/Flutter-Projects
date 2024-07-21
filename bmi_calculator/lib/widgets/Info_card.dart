import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard(
      {super.key,
        required this.child,
        required this.width,
        required this.height});

  final Widget child;
  final double width, height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
            )
          ]),
      child: child,
    );
  }
}

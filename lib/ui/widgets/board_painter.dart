import 'dart:math';

import 'package:flutter/material.dart';

class WheelPainter extends CustomPainter {
  WheelPainter({Key key, @required this.activeArc});

  final int activeArc;

  Path getWheelPath(
      double wheelSize, double fromRadius, double toRadius, bool isActive) {
    return new Path()
      ..moveTo(wheelSize, wheelSize)
      ..arcTo(
          Rect.fromCircle(
              radius: isActive ? wheelSize + 10 : wheelSize,
              center: Offset(wheelSize, wheelSize)),
          fromRadius,
          toRadius,
          false)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    double wheelSize = 150;
    double nbElem = 4;
    double radius = (2 * pi) / nbElem;

    for (int i = 0; i < nbElem; i++) {
      if (activeArc == i) {
        canvas.drawShadow(getWheelPath(wheelSize, radius * i + 4, radius, true),
            Colors.grey[900], 10.0, true);
        canvas.drawPath(getWheelPath(wheelSize, radius * i + 4, radius, true),
            new Paint()..color = Color(0xFFB5D3F3));
      } else {
        canvas.drawPath(getWheelPath(wheelSize, radius * i + 4, radius, false),
            new Paint()..color = Color(0x88999DA0));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

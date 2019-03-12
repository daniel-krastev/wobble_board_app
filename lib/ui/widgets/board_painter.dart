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
    double radius =  5 * pi / 4;

    for (int i = 0; i < 4; i++) {
      if (activeArc == i) {
        canvas.drawShadow(getWheelPath(wheelSize, radius + (i * pi/2), pi/2, true),
            Colors.grey[900], 10.0, true);
        canvas.drawPath(getWheelPath(wheelSize, radius + (i * pi/2), pi/2, true),
            new Paint()..color = Color(0xFFB5D3F3));
      } else {
        canvas.drawPath(getWheelPath(wheelSize, radius + (i * pi/2), pi/2, false),
            new Paint()..color = Color(0x88999DA0));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

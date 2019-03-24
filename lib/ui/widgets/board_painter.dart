import 'dart:math';

import 'package:flutter/material.dart';

class WheelPainter extends CustomPainter {
  WheelPainter({Key key, @required this.activeArc, @required this.type});

  final int activeArc;
  final String type;

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
    double radius = 5 * pi / 4;
    int colourSector = activeArc;

    if (type == 'repeat-y') {
      colourSector = (colourSector % 2 == 0) ? 0 : 2;
    } else if (type == 'repeat-x') {
      colourSector = (colourSector % 2 == 0) ? 1 : 3;
    }

    for (int i = 0; i < 4; i++) {
      if (colourSector == i || (type == 'balance' && i == 2)) {
        canvas.drawShadow(
            getWheelPath(wheelSize, radius + (i * pi / 2), pi / 2, true),
            Colors.grey[900],
            10.0,
            true);
        canvas.drawPath(
            getWheelPath(wheelSize, radius + (i * pi / 2), pi / 2, true),
            new Paint()..color = Color(0xFFB5D3F3));
      } else {
        canvas.drawPath(
            getWheelPath(wheelSize, radius + (i * pi / 2), pi / 2, false),
            new Paint()..color = Color(0x88999DA0));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

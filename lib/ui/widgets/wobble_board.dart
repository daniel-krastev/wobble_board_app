import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wobble_board/ui/widgets/board_painter.dart';

class WobbleBoard extends StatelessWidget {
  WobbleBoard(
      {Key key, @required this.x, @required this.y, @required this.currentStep})
      : super(key: key);

  final int x;
  final int y;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final double _size = 300.0;
    final double _iconSize = 50.0;
    final double _iconOff = 10.0;
    final double _iconMidOff = ((_size - _iconSize) / 2);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Stack(
          alignment: AlignmentDirectional(x / -21.0, y / -21.0),
          children: <Widget>[
            CustomPaint(
              child: Container(
                height: _size,
                width: _size,
                child: Center(
                    child: Container(
                        width: _size / 2,
                        height: _size / 2,
                        child: Image.asset('assets/images/circle.png'))),
              ),
              painter: WheelPainter(activeArc: currentStep),
            ),
            Positioned(
              child: Icon(
                Icons.keyboard_arrow_up,
                size: _iconSize,
                color: Colors.white,
              ),
              top: _iconOff,
              left: _iconMidOff,
            ),
            Positioned(
              child: Icon(
                Icons.keyboard_arrow_left,
                size: _iconSize,
                color: Colors.white,
              ),
              top: _iconMidOff,
              left: _iconOff,
            ),
            Positioned(
              child: Icon(
                Icons.keyboard_arrow_right,
                size: _iconSize,
                color: Colors.white,
              ),
              top: 125.0,
              right: _iconOff,
            ),
            Positioned(
              child: Icon(
                Icons.keyboard_arrow_down,
                size: _iconSize,
                color: Colors.white,
              ),
              bottom: _iconOff,
              left: _iconMidOff,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wobble_board/ui/widgets/board_painter.dart';


/// The Widget that represents the wobble board.
class WobbleBoard extends StatelessWidget {
  WobbleBoard(
      {Key key,
      @required this.x,
      @required this.y,
      @required this.currentStep,
      @required this.type})
      : super(key: key);

  final int x;
  final int y;
  final int currentStep;
  final String type;

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
              painter: WheelPainter(activeArc: currentStep, type: type),
            ),
            Positioned(
              child: type == 'circle'
                  ? RotatedBox(
                      quarterTurns: 1,
                      child: Icon(
                        Icons.autorenew,
                        size: _iconSize * 2.5,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : new Container(),
              top: _size / 3.5,
              left: _size / 3.5,
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

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
    Widget boardCircle = new Container(
      width: 300.0,
      height: 300.0,
      decoration: new BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
      ),
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Stack(
          alignment: AlignmentDirectional(x / -21.0, y / -21.0),
          children: <Widget>[
            CustomPaint(
              child: Container(
                height: 300.0,
                width: 300.0,
                child: Image.asset('assets/circle-png.png'),
              ),
              painter: WheelPainter(activeArc: currentStep),
            ),
            Positioned(
              child: Icon(
                Icons.keyboard_arrow_up,
                size: 50,
                color: Colors.white,
              ),
              top: 10.0,
              left: 130.0,
            ),
            Positioned(
              child: Icon(
                Icons.keyboard_arrow_left,
                size: 50,
                color: Colors.white,
              ),
              top: 120.0,
              left: 10.0,
            ),
            Positioned(
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 50,
                color: Colors.white,
              ),
              top: 120.0,
              right: 10.0,
            ),
            Positioned(
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 50,
                color: Colors.white,
              ),
              top: 240.0,
              left: 130.0,
            ),
          ],
        ),
      ),
    );

//    return Transform(
//      transform: Matrix4.identity()
//        ..setEntry(3, 2, 0.001)
//        ..rotateX(y / -21.0)
//        ..rotateY(x / 21.0),
//      alignment: FractionalOffset.center,
//      child: Center(
//        child: Stack(
//          alignment: AlignmentDirectional(x / -21.0, y / -21.0),
//          children: <Widget>[
//            boardCircle,
//            Positioned(
//              child: Icon(Icons.keyboard_arrow_up, size: 50),
//              top: 10.0,
//              left: 130.0,
//            ),
//            Positioned(
//              child: Icon(Icons.keyboard_arrow_left, size: 50),
//              top: 120.0,
//              left: 10.0,
//            ),
//            Positioned(
//              child: Icon(Icons.keyboard_arrow_right, size: 50),
//              top: 120.0,
//              right: 10.0,
//            ),
//            Positioned(
//              child: Icon(Icons.keyboard_arrow_down, size: 50),
//              top: 240.0,
//              left: 130.0,
//            ),
//            Positioned(
//              child: Icon(Icons.my_location, size: 25),
//            )
//          ],
//        ),
//      ),
//    );
  }
}

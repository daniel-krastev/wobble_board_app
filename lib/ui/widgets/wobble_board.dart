import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WobbleBoard extends StatelessWidget {
  WobbleBoard({Key key, @required this.x, @required this.y}) : super(key: key);

  final int x;
  final int y;

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
      child: Stack(
        alignment: AlignmentDirectional(x / -21.0, y / -21.0),
        children: <Widget>[
          boardCircle,
          Positioned(
            child: Icon(Icons.keyboard_arrow_up, size: 50),
            top: 10.0,
            left: 130.0,
          ),
          Positioned(
            child: Icon(Icons.keyboard_arrow_left, size: 50),
            top: 120.0,
            left: 10.0,
          ),
          Positioned(
            child: Icon(Icons.keyboard_arrow_right, size: 50),
            top: 120.0,
            right: 10.0,
          ),
          Positioned(
            child: Icon(Icons.keyboard_arrow_down, size: 50),
            top: 240.0,
            left: 130.0,
          ),
          Positioned(
            child: Icon(Icons.my_location, size: 25),
          )
        ],
      ),
    );
  }
}

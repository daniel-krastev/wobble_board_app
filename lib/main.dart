import 'package:flutter/material.dart';
import "package:flare_flutter/flare_actor.dart";

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MyApp> {
  double _value = 0.0;
  String _animation = "boardLevel";
  String _text= "Well done, board is level!";

  void _onChanged(double value) {
    setState(() {
      _value = value;
      if (value <= -0.1) {
        _animation = "moveUp";
        _text = "Lean forward!";
      } else if (value >= 0.1) {
        _animation = "moveDown";
        _text = "Lean backward!";
      } else {
        _animation = "boardLevel";
        _text= "Well done, board is level!";
      }
    });
  }

  double _editValue(double value) {
    return (value < 0) ? ((value * -1) - 1.0) * -1 : (value - 1.0) * -1;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Progress'),
        ),
        body: new Container(
            padding: new EdgeInsets.all(32.0),
            child: new Column(children: <Widget>[
              new Text(
                'Value received from BLE is \n ${_value}',
                textAlign: TextAlign.center,
              ),
              new Slider(
                min: -1.0,
                max: 1.0,
                value: _value,
                onChanged: (double value) {
                  _onChanged(value);
                },
              ),
              new Text(
                _text+'\n',
                textAlign: TextAlign.center,
              ),
              Transform.rotate(
                angle: 0,
//                angle: -1.57,
                alignment: Alignment.bottomRight,
                transformHitTests: false,
                child: new SizedBox(
                  child: new LinearProgressIndicator(
                    backgroundColor: Colors.lightBlue[50],
                    value: _editValue(_value),
                    semanticsLabel: 'front-back progress',
                    semanticsValue: '0.0',
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Colors.lightBlue[300]),
                  ),
                  height: 15.0,
                  width: 220.0,
                ),
              ),
              Expanded(
                child: FlareActor(
                  "animations/Circle.flr",
                  animation: _animation,
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                ),
              ),
            ])));
  }
}

//import 'package:flutter/material.dart';
//
//void main() => runApp(
//      MaterialApp(
//        home: Scaffold(
//          body: SafeArea(child: Demo()),
//        ),
//      ),
//    );
//
//class Demo extends StatefulWidget {
//  @override
//  _DemoState createState() => _DemoState();
//}
//
//class _DemoState extends State<Demo> {
//  String _animation = "";
//  String _animationX = "";
//
//  @override
//  Widget build(BuildContext context) {
//    return new Container(
//      decoration: new BoxDecoration(color: Colors.lightBlue[50]),
//      child: new Column(
//        children: <Widget>[
//          Expanded(
//            child: FlareActor(
//              "animations/Circle.flr",
//              animation: _animationX,
//              alignment: Alignment.center,
//              fit: BoxFit.contain,
//            ),
//          ),
//          Expanded(
//            child: FlareActor(
//              "animations/Wobble_Progress.flr",
//              animation: _animation,
//              alignment: Alignment.center,
//              fit: BoxFit.contain,
//            ),
//          ),
//          RaisedButton(
//            child: Text("Go"),
//            color: Colors.blue[300],
//            onPressed: () {
//              if (_animationX != "move") {
//                setState(() {
//                  _animationX = "move";
//                });
//              }
//            },
//          ),
//          RaisedButton(
//            child: Text("Down"),
//            color: Colors.blue[300],
//            onPressed: () {
//              setState(() {
//                _animation = "moveDown";
//              });
//            },
//          ),
//          RaisedButton(
//            child: Text("Left"),
//            color: Colors.blue[300],
//            onPressed: () {
//              setState(() {
//                _animation = "moveLeft";
//              });
//            },
//          ),
//          RaisedButton(
//            child: Text("Right"),
//            color: Colors.blue[300],
//            onPressed: () {
//              setState(() {
//                _animation = "moveRight";
//              });
//            },
//          ),
//        ],
//      ),
//    );
//  }
//}

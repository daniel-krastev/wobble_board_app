import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';

class Exercise extends StatefulWidget {
  @override
  _ExerciseState createState () => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  var exercises;
  int currentEx = 0;

  List<double> _accelerometerValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];

  @override
  Widget build(BuildContext context) {
//    final List<String> accelerometer =
//      _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$currentEx',
                style: TextStyle(fontSize: 30.0),
              ),
            ],
          ),
          Icon(Icons.keyboard_arrow_up, size: 50, color: getColor(0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.keyboard_arrow_left, size: 50, color: getColor(3)),
              Icon(Icons.keyboard_arrow_right, size: 50, color: getColor(1)),
            ],
          ),
          Icon(Icons.keyboard_arrow_down, size: 50, color: getColor(2)),
        ],
      ),
    );
  }


  Future<String> _loadExercisesAsset() async {
    return await rootBundle.loadString('assets/exercises.json');
  }

  void loadExercises() async {
    String json = await _loadExercisesAsset();
    _parseJson(json);
  }

  void _parseJson(String jsonString) {
    exercises = json.decode(jsonString);
  }

  Color getColor(int rowID) {
    Color color = (rowID == currentEx ? Colors.blue : Colors.black);
    return color;
  }

  void checkIfComplete() {
    var axisValue;
    var currentGoal;

    if(exercises != null && exercises is Map) {
      if(exercises['exercises'][0]['steps'][currentEx]['axis'] == 'x') {
        axisValue = _accelerometerValues[0];
      }
      else {
        axisValue = _accelerometerValues[1];
      }

      currentGoal = exercises['exercises'][0]['steps'][currentEx]['goal'];

      if((currentGoal < 0 && axisValue <= currentGoal) || (currentGoal > 0 && axisValue >= currentGoal)) {
        if(currentEx == exercises['exercises'][0]['steps'].length - 1) {
          currentEx = 0;
        }
        else {
          currentEx++;
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    loadExercises();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
            checkIfComplete();
          });
        })
    );
  }
}
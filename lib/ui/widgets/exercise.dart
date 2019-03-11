import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:wobble_board/bloc/bloc_provider.dart';
import 'package:wobble_board/bloc/data.dart' as bloc;
import 'package:wobble_board/ui/widgets/wobble_board.dart';
import 'package:wobble_board/utils/ble_utils.dart';

class Exercise extends StatefulWidget {
  final bool isGame;
  final Function(int) updateScore;

  Exercise(this.isGame, [this.updateScore]);

  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  // TODO: Clean up variables and functions inside whole class - most should be private,
  // TODO: some are not needed, some should be placed elsewhere
  var exercises;
  int currentStep = 0;
  int gameStep = 1;
  int currentEx = 0;
  var stopwatch = new Stopwatch();
  bool finishedLoading = false;
  String _dropdownValue;
  List<String> _exerciseNames;

  List<int> _accelerometerValues = [0, 0];
  StreamSubscription<dynamic> _streamSubscription;

  bloc.DataBlock bl;

  @override
  Widget build(BuildContext context) {
//    final List<String> accelerometer =
//      _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    if (finishedLoading) {
      setState(() {
        exercises = (widget.isGame)
            ? exercises.where((ex) => ex['type'].toString() == 'game').toList()
            : exercises.where((ex) => ex['type'].toString() != 'game').toList();
        _exerciseNames =
            exercises?.map<String>((item) => item['name'].toString())?.toList();
        _dropdownValue = _exerciseNames[currentEx];
      });
    }
    bl.dataEventSink.add(bloc.ContinueDataEvent());

    return finishedLoading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownButton<String>(
                        style: TextStyle(color: Colors.blue),
                        value: _dropdownValue,
                        onChanged: (String newValue) {
                          setState(() {
                            // set state to the selected exercise
                            currentEx = _exerciseNames.indexOf(newValue);
                            currentStep = 0;
                            gameStep = 0;
                          });
                        },
                        items: _exerciseNames.map((exercise) {
                          return DropdownMenuItem<String>(
                              child: Text(exercise), value: exercise);
                        }).toList()),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.isGame ? '$gameStep' : '$currentStep',
                    style: TextStyle(fontSize: 30.0, color: Colors.blue),
                  ),
                ],
              ),
              WobbleBoard(
                  x: _accelerometerValues[1],
                  y: _accelerometerValues[0],
                  currentStep: currentStep),
//                Icon(Icons.keyboard_arrow_up, size: 50, color: getColor(0)),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Icon(Icons.keyboard_arrow_left,
//                        size: 50, color: getColor(3)),
//                    Icon(Icons.keyboard_arrow_right,
//                        size: 50, color: getColor(1)),
//                  ],
//                ),
//                Icon(Icons.keyboard_arrow_down, size: 50, color: getColor(2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${stopwatch.elapsed}',
                    style: TextStyle(fontSize: 30.0),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${exercises[currentEx]['steps'][currentStep]['text']}',
                      style: TextStyle(fontSize: 15.0, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                      onPressed: () =>
                          bl.dataEventSink.add(bloc.StartDataEvent()),
                      child: Text("Start")),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  RaisedButton(
                      onPressed: () =>
                          bl.dataEventSink.add(bloc.StopDataEvent()),
                      child: Text("Stop")),
                ],
              ),
            ],
          )
        :
        // show a progress indicator if still loading in exercise data
        Center(
            child: CircularProgressIndicator(
            strokeWidth: 3.0,
          ));
  }

  void _loadExercises() {
    rootBundle.loadString('assets/exercises.json').then((obj) {
      print("_loadExercises");
      setState(() {
        exercises = json.decode(obj);
        finishedLoading = true;
      });
    });
  }

  Color getColor(int rowID) {
    // TODO: Come up with a better way of choosing the color - maybe not needed if using animation
    Color color;
    if (currentEx == 1) {
      color = ((rowID == 1 || rowID == 3) ? Colors.blue : Colors.black);
    } else {
      color = (rowID == currentStep ? Colors.blue : Colors.black);
    }
    return color;
  }

  void checkIfComplete() {
    var axisValue;
    var currentGoal;
    var timeToHold;
    var condition;
    var exType;

    if (exercises != null) {
      // check which axis value to monitor
      // TODO: Need better way of determining this
      if (exercises[currentEx]['steps'][currentStep]['axis'] == 'x') {
        axisValue = _accelerometerValues[1];
      } else if (exercises[currentEx]['steps'][currentStep]['axis'] == 'xy') {
        axisValue = [_accelerometerValues[0], _accelerometerValues[1]];
      } else {
        axisValue = _accelerometerValues[0];
      }

      currentGoal = exercises[currentEx]['steps'][currentStep]['goal'];
      timeToHold = exercises[currentEx]['steps'][currentStep]['time'];
      exType = exercises[currentEx]['type'];

      // TODO: Work on this - figure out how to store and compute different exercises conditions
      switch (exType) {
        case 'game':
        case 'movement':
          condition = ((currentGoal < 0 && axisValue <= currentGoal) ||
              (currentGoal > 0 && axisValue >= currentGoal));
          break;
        case 'balance':
          condition = ((axisValue[0] < currentGoal &&
                  axisValue[0] > -(currentGoal)) &&
              (axisValue[1] < currentGoal && axisValue[1] > -(currentGoal)));
          break;
      }

      if (condition) {
        // start the stopwatch
        stopwatch.start();

        // if time elapsed is longer than the required time to hold
        // exercise has been completed
        if (timeToHold != 0 && stopwatch.elapsedMilliseconds >= timeToHold) {
          // stop and reset stepwatch
          stopwatch.stop();
          stopwatch.reset();
          // this is the last step of the exercise
          if (currentStep == exercises[currentEx]['steps'].length - 1) {
            // reset step count
            setState(() {
              currentStep = 0;
            });
            // reset exercises if this is the last one
            if (currentEx == exercises.length - 1) {
              setState(() {
                currentEx = 0;
              });
            }
            // else move on to the next exercise
            else {
              setState(() {
                currentEx++;
              });
            }
            // stop data stream until next exercise is started
            bl.dataEventSink.add(bloc.StopDataEvent());
            setState(() {
              _accelerometerValues = [0, 0];
            });
          }
          // move to next step of the exercise
          else {
            setState(() {
              currentStep++;
            });
          }
        }
      }
      // if the accelerometer value is no longer within range then stop and reset the stopwatch
      else {
        if (stopwatch.isRunning) {
          // if game call the callback function to update the scores and increment the step count
          if (widget.isGame) {
            widget.updateScore(stopwatch.elapsedMilliseconds);
            // stop data stream until next user has started
            bl.dataEventSink.add(bloc.StopDataEvent());
            setState(() {
              _accelerometerValues = [0, 0];
              gameStep++;
            });
          }
          stopwatch.stop();
          stopwatch.reset();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  @override
  void dispose() {
    bl.dataEventSink.add(bloc.LeaveUiEvent());
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    bl = BlocProvider.of(context).dataBloc;
    _streamSubscription = (bl.data.listen((event) {
      setState(() {
        _accelerometerValues = <int>[event[AccAxis.X], event[AccAxis.Y]];
      });
      checkIfComplete();
    }));
    super.didChangeDependencies();
  }
}

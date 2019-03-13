import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wobble_board/bloc/bloc_provider.dart';
import 'package:wobble_board/bloc/data.dart' as bloc;
import 'package:wobble_board/ui/widgets/wobble_board.dart';
import 'package:wobble_board/utils/ble_utils.dart';

class Exercise extends StatefulWidget {
  //true if game
  final bool isGame;
  //func to update the game score
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
  int gameStep = 0;
  int currentEx = 0;
  bool finishedLoading = false;
  String _dropdownValue;
  List<String> _exerciseNames;
  double progress;

  var totalStopwatch =
      new Stopwatch(); // stopwatch that counts the total time to complete an exercise
  var stepStopwatch =
      new Stopwatch(); // stopwatch that counts the time to complete a single step

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

    //progress bar calculation
    if (totalStopwatch.isRunning) {
      if (widget.isGame) {
        progress = gameStep / 10;
      } else {
        if (stepStopwatch.isRunning) {
          progress = stepStopwatch.elapsedMilliseconds /
              exercises[currentEx]['steps'][currentStep]['time'];
        }
      }
    } else {
      progress = 0.0;
    }

    return finishedLoading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // exercise selector
              createCustomSelector(),
              // board
              WobbleBoard(
                  x: _accelerometerValues[1],
                  y: _accelerometerValues[0],
                  currentStep: currentStep),
              // instructions and progress bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        '${exercises[currentEx]['steps'][currentStep]['text']}',
                        style: TextStyle(fontSize: 15.0, color: Colors.blue),
                      ),
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 50,
                        lineHeight: 10.0,
                        percent: min(progress, 1.0),
                        progressColor: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
              // total time and start/stop button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${totalStopwatch.elapsed}',
                        style: TextStyle(fontSize: 30.0),
                      ),
                    ],
                  ),
                  RaisedButton(
                      onPressed: () => stopStartExercise(bl),
                      child: totalStopwatch.isRunning
                          ? Text("Pause")
                          : Text("Start")),
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

  void stopStartExercise(bloc.DataBlock bl) {
    if (!totalStopwatch.isRunning) {
      if (widget.isGame) {
        setState(() {
          currentStep = getRandomGameStep();
        });
      }
      totalStopwatch.start();
      bl.dataEventSink.add(bloc.StartDataEvent());
    } else {
      totalStopwatch.stop();
      bl.dataEventSink.add(bloc.StopDataEvent());
    }
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

  int getRandomGameStep() {
    Random r = new Random();
    int random = r.nextInt(4);
    while (currentStep == random) {
      random = r.nextInt(4);
    }
    return random;
  }

  // creates custom exercise selector
  Row createCustomSelector() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
              onPressed: () {
                // move back one exercise if not at the first one
                if (currentEx > 0) {
                  setState(() {
                    currentEx -= 1;
                    currentStep = 0;
                    gameStep = 0;
                  });
                }
              },
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 20,
              )),
          // this updates every time the currentEx index is changed
          Text('$_dropdownValue'),
          IconButton(
              onPressed: () {
                // move to the next exercise if not at the last one
                if (currentEx < _exerciseNames.length - 1) {
                  setState(() {
                    currentEx += 1;
                    currentStep = 0;
                    gameStep = 0;
                  });
                }
              },
              icon: Icon(
                Icons.keyboard_arrow_right,
                size: 20,
              ))
        ]);
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
        if (widget.isGame) {
          if (gameStep < 9) {
            setState(() {
              currentStep = getRandomGameStep();
              gameStep++;
            });
          } else {
            bl.dataEventSink.add(bloc.StopDataEvent());
            totalStopwatch.stop();
            setState(() {
              _accelerometerValues = [0, 0];
            });
          }
        }
        // start the stopwatch
        stepStopwatch.start();

        // if time elapsed is longer than the required time to hold
        // exercise has been completed
        if (timeToHold != 0 &&
            stepStopwatch.elapsedMilliseconds >= timeToHold) {
          // stop and reset stepwatch
          stepStopwatch.stop();
          stepStopwatch.reset();
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
            //reset total time stepwatch
            totalStopwatch.stop();
            totalStopwatch.reset();
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
        if (stepStopwatch.isRunning) {
          stepStopwatch.stop();
          stepStopwatch.reset();
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

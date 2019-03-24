import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wobble_board/bloc/bloc_provider.dart';
import 'package:wobble_board/bloc/data.dart' as bloc;
import 'package:wobble_board/ui/widgets/custom_dialog.dart';
import 'package:wobble_board/ui/widgets/custom_selector.dart';
import 'package:wobble_board/ui/widgets/wobble_board.dart';
import 'package:wobble_board/utils/ble_utils.dart';

class Exercise extends StatefulWidget {
  //true if game
  final bool isGame;

  //func to update the game score
  final Function(String, double) submitScore;

  Exercise(this.isGame, [this.submitScore]);

  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  var exercises;
  int currentStep = 0;
  int gameStep = 0;
  int currentEx = 0;
  bool finishedLoading = false;
  double progress = 0.0;

  var totalStopwatch =
      new Stopwatch(); // stopwatch that counts the total time to complete an exercise
  var stepStopwatch =
      new Stopwatch(); // stopwatch that counts the time to complete a single step

  List<int> _accelerometerValues = [0, 0];
  StreamSubscription<dynamic> _streamSubscription;

  bloc.DataBlock bl;

  @override
  Widget build(BuildContext context) {
    if (finishedLoading) {
      setState(() {
        exercises = (widget.isGame)
            ? exercises.where((ex) => ex['type'].toString() == 'game').toList()
            : exercises.where((ex) => ex['type'].toString() != 'game').toList();
      });
    }
    bl.dataEventSink.add(bloc.ContinueDataEvent());

    //progress bar calculation
    if (totalStopwatch.elapsedMilliseconds > 0) {
      if (widget.isGame) {
        progress = gameStep / 10;
      } else if (exercises[currentEx]['type'].startsWith('repeat')) {
        progress = currentStep / 10;
      } else {
        if (stepStopwatch.isRunning) {
          progress = stepStopwatch.elapsedMilliseconds /
              exercises[currentEx]['steps'][currentStep]['time'];
        } else {
          progress = 0.0;
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
              CustomSelector(exercises[currentEx]['name'], switchExercise),
              // stopwatch
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        '${totalStopwatch.elapsed}',
                        style: TextStyle(
                            fontSize: 24.0,
                            color:
                                Theme.of(context).primaryTextTheme.body1.color),
                      ),
                    ),
                  ],
                ),
              ),
              // instructions and progress bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        '${exercises[currentEx]['steps'][currentStep]['text']}',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .subtitle
                                .color),
                      ),
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 50,
                        lineHeight: 10.0,
                        percent: min(progress, 1.0),
                        progressColor: Theme.of(context).primaryColor,
                        backgroundColor:
                            Theme.of(context).primaryTextTheme.body1.color,
                      ),
                    ],
                  ),
                ],
              ),
              // board
              WobbleBoard(
                  x: _accelerometerValues[1],
                  y: _accelerometerValues[0],
                  currentStep: currentStep,
                  type: exercises[currentEx]["type"]),
              // start/stop button
              Padding(
                padding: const EdgeInsets.only(
                    right: 20.0, bottom: 20.0, left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                        child: RaisedButton(
                      onPressed: () => stopStartExercise(bl),
                      child: totalStopwatch.isRunning
                          ? Text(
                              'Pause',
                              style: Theme.of(context).primaryTextTheme.button,
                            )
                          : Text('Start',
                              style: Theme.of(context).primaryTextTheme.button),
                    )),
                  ],
                ),
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
      if (widget.isGame && gameStep == 0) {
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

  void switchExercise(int i) {
    if ((i < 0 && currentEx > 0) ||
        (i > 0 && currentEx < exercises.length - 1)) {
      setState(() {
        currentEx = currentEx + i;
        currentStep = 0;
        gameStep = 0;
      });
    }
  }

  void resetGame([String username]) {
    if (username != null) {
      widget.submitScore(username, totalStopwatch.elapsedMilliseconds / 1000);
    }
    totalStopwatch.reset();
    setState(() {
      gameStep = 0;
      currentStep = 0;
      _accelerometerValues = [0, 0];
    });
  }

  void checkIfComplete() {
    var axisValue;
    var currentGoal;
    var timeToHold;
    var condition;
    var exType;

    if (exercises != null) {
      // check which axis value to monitor
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

      switch (exType) {
        case 'game':
        case 'movement':
        case 'circle':
        case 'repeat-x':
        case 'repeat-y':
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
            gameStep++;
            bl.dataEventSink.add(bloc.StopDataEvent());
            totalStopwatch.stop();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(
                      totalStopwatch.elapsedMilliseconds / 1000, resetGame);
                }).then((val) {
              resetGame();
            });
          }
        }

        // start the stopwatch
        stepStopwatch.start();

        // if time elapsed is longer than the required time to hold
        // exercise has been completed
        if ((timeToHold != 0 &&
                stepStopwatch.elapsedMilliseconds >= timeToHold) ||
            exercises[currentEx]['type'] == 'circle' ||
            exercises[currentEx]['type'].startsWith('repeat')) {
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
      if (totalStopwatch.isRunning) {
        checkIfComplete();
      }
    }));
    super.didChangeDependencies();
  }
}

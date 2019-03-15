import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wobble_board/bloc/bloc_provider.dart' as native;
import 'package:wobble_board/bloc/go_page_bloc.dart';

class ExerciseGO extends StatefulWidget {
  @override
  _ExerciseGOState createState() => _ExerciseGOState();
}

class _ExerciseGOState extends State<ExerciseGO> {
  GoPageBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseEvent, ExerciseModel>(
      bloc: _bloc,
      builder: (ctx, mod) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LinearPercentIndicator(
                      backgroundColor:
                          Theme.of(context).primaryTextTheme.body1.color,
                      progressColor: Theme.of(context).primaryColor,
                      width: MediaQuery.of(context).size.width,
                      lineHeight: MediaQuery.of(context).size.height * 0.015,
                      percent: mod.progress,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image.asset(mod.image,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.55),
                      _getIconButton(mod, context)
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[_getStatusWidget(mod)]),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(mod.hint,
                            style: Theme.of(context).primaryTextTheme.body1),
                      ),
                    ],
                  ),
                ),
                _getButtons(mod)
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    _bloc = native.BlocProvider.of(context).goPageBloc;
    _bloc.dispatch(ExerciseEvent.init);
    super.didChangeDependencies();
  }

  Container _getButtons(ExerciseModel model) {
    List<Widget> buttons = [];
    if (model is TimerExerciseModel) {
      buttons.add(_getPauseCont(model));
      buttons.add(RaisedButton(
        onPressed: () => _bloc.dispatch(ExerciseEvent.next),
        child: Text("Skip"),
      ));
    } else {
      if ((model as RepsExerciseModel).reps != null) {
        buttons.add(RaisedButton(
          onPressed: () => _bloc.dispatch(ExerciseEvent.next),
          child: Text("Done"),
        ));
      } else {
        buttons.add(RaisedButton(
          onPressed: () =>
              Navigator.of(context).popUntil((r) => r.settings.name == "/"),
          child: Text("Back"),
        ));
      }
    }
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: buttons),
    );
  }

  Widget _getIconButton(ExerciseModel model, BuildContext context) {
    if (model is RepsExerciseModel && model.reps == null) {
      return Container();
    } else {
      return Positioned(
        top: 0.0,
        left: 0.0,
        child: IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _bloc.dispatch(ExerciseEvent.pause);
              _showExitDialog(context);
            }),
      );
    }
  }

  RaisedButton _getPauseCont(TimerExerciseModel mod) {
    if (!mod.isPaused) {
      return RaisedButton(
        onPressed: () => _bloc.dispatch(ExerciseEvent.pause),
        child: Text("Pause"),
      );
    } else {
      return RaisedButton(
        onPressed: () => _bloc.dispatch(ExerciseEvent.cont),
        child: Text("Continue"),
      );
    }
  }

  Widget _getStatusWidget(ExerciseModel model) {
    if (model is TimerExerciseModel) {
      return LinearPercentIndicator(
        backgroundColor: Theme.of(context).primaryTextTheme.body1.color,
        progressColor: Theme.of(context).primaryColor,
        center: Text("${model.remaining}/${model.totalSeconds}",
            style: Theme.of(context).primaryTextTheme.body2),
        width: MediaQuery.of(context).size.width * 0.8,
        lineHeight: 50.0,
        percent: model.progressTimer,
      );
    } else if (model is RepsExerciseModel && model.reps != null) {
      return Text("x${model.reps}",
          style: Theme.of(context).primaryTextTheme.body1);
    } else {
      return Container();
    }
  }

  _showExitDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) {
          return Dialog(
            child: Container(
              height: 200.0,
              width: 250.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Are you sure you want to cancel this practice?",
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Quit",
                            style: Theme.of(context).primaryTextTheme.button),
                        onPressed: () => Navigator.of(context)
                            .popUntil((r) => r.settings.name == "/"),
                      ),
                      RaisedButton(
                        child: Text("Continue",
                            style: Theme.of(context).primaryTextTheme.button),
                        onPressed: () {
                          _bloc.dispatch(ExerciseEvent.cont);
                          Navigator.of(context).pop('dialog');
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

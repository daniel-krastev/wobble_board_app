import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wobble_board/bloc/go_page_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wobble_board/bloc/bloc_provider.dart' as native;

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
                      backgroundColor: Theme.of(context).primaryTextTheme.body1.color,
                      progressColor: Theme.of(context).primaryColor,
                      width: MediaQuery.of(context).size.width,
                      lineHeight: MediaQuery.of(context).size.height * 0.015,
                      percent: mod.progress,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.asset(mod.image,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.55),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _getStatusWidget(mod)
                          ]
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(mod.hint, style: Theme.of(context).primaryTextTheme.body1),
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

  Widget _getStatusWidget(ExerciseModel model) {
    if(model is TimerExerciseModel) {
      return LinearPercentIndicator(
        backgroundColor: Theme.of(context).primaryTextTheme.body1.color,
        progressColor: Theme.of(context).primaryColor,
        center: Text("${model.remaining}/${model.totalSeconds}", style: Theme.of(context).primaryTextTheme.body2),
        width: MediaQuery.of(context).size.width * 0.8,
        lineHeight: 50.0,
        percent: model.progressTimer,
      );
    } else if(model is RepsExerciseModel && model.reps != null){
      return Text("x${model.reps}", style: Theme.of(context).primaryTextTheme.body1);
    } else {
      return Container();
    }
  }

  Container _getButtons(ExerciseModel model) {
    List<Widget> buttons = [];
    if(model is TimerExerciseModel) {
      buttons.add(_getPauseCont(model));
      buttons.add(RaisedButton(
        onPressed: () => _bloc.dispatch(ExerciseEvent.next),
        child: Text("Skip"),
      ));
    } else {
      if((model as RepsExerciseModel).reps != null) {
        buttons.add(RaisedButton(
          onPressed: () => _bloc.dispatch(ExerciseEvent.next),
          child: Text("Done"),
        ));
      } else {
        buttons.add(RaisedButton(
          onPressed: () => Navigator.of(context).popUntil((r) => r.settings.name == "/"),
          child: Text("Back"),
        ));
      }
    }
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons
      ),
    );
  }

  RaisedButton _getPauseCont(TimerExerciseModel mod) {
    if(!mod.isPaused) {
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

  @override
  void didChangeDependencies() {
    _bloc = native.BlocProvider.of(context).goPageBloc;
    _bloc.dispatch(ExerciseEvent.init);
    super.didChangeDependencies();
  }
}

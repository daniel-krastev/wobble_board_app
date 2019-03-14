import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wobble_board/bloc/go_page_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wobble_board/bloc/bloc_provider.dart' as native;

class ExerciseGO extends StatefulWidget {
  final List<Exercise> exercises;
  ExerciseGO({
    @required this.exercises
});

  @override
  _ExerciseGOState createState() => _ExerciseGOState();
}

class _ExerciseGOState extends State<ExerciseGO> {
  GoPageBloc _bloc;


  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (ctx, snap) {
        return Scaffold(
          body: SafeArea(child: Column(
            children: <Widget>[
              LinearPercentIndicator(
                width: 10.0,
                percent: snap.progress,
              ),
              Container(
                width: double.infinity,
                child: Image.asset(snap.imageUrl),
              ),
              ListTile(
                title: Text(snap.hint),
              ),
              //container for timer(progress bar) or reps(text)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () => _bloc.dispatch(ExerciseEvent.done),
                    child: Text("Done"),
                  ),
                  RaisedButton(
                    onPressed: () => _bloc.dispatch(ExerciseEvent.next),
                    child: Text("Next"),
                  ),
                ],
              )
            ],
          )),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    _bloc = native.BlocProvider.of(context).goPageBloc;
    _bloc.dispatch(ExerciseEvent.start);
    super.didChangeDependencies();
  }
}

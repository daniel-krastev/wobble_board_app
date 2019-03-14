import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class GoPageBloc extends Bloc<ExerciseEvent, GoPageModel> {

  GoPageModel get initialState => GoPageModel();

  @override
  Stream<GoPageModel> mapEventToState(
      GoPageModel currentState, ExerciseEvent event) async* {
    switch (event) {
      case ExerciseEvent.start:
        break;
      case ExerciseEvent.skip:
        break;
      case ExerciseEvent.done:
        break;
      case ExerciseEvent.next:
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

enum ExerciseEvent {start, skip, done, next }

class GoPageModel {

  double progress;
  String img;
}

class ExerciseRepo {
  static final List<Exercise> exerciseList = [
    Exercise(title: "Standing Balance", hint: "", img: "assets/images/standing_balance.png", dur: Duration(seconds: 20)),
    Exercise(title: "Squat Hold", hint: "", img: "assets/images/squat_hold.png", reps: 10),
    Exercise(title: "Squat", hint: "", img: "assets/images/squat.png", reps: 10),
    Exercise(title: "High Plank", hint: "", img: "assets/images/high_plank.png", dur: Duration(seconds: 20)),
    Exercise(title: "Low Plank", hint: "", img: "assets/images/low_plank.png", dur: Duration(seconds: 20)),
    Exercise(title: "Side to Side Rock", hint: "", img: "assets/images/side_to_side_rock.png", reps: 10),
    Exercise(title: "Push Up (Hands On)", hint: "", img: "assets/images/push_up_hands.png", reps: 10),
    Exercise(title: "Push Up (Feet On)", hint: "", img: "assets/images/push_up_feet.png", reps: 10),
    Exercise(title: "Single Leg Balance", hint: "", img: "assets/images/single_leg_balance.png", dur: Duration(seconds: 10)),
    Exercise(title: "Wall Sit", hint: "", img: "assets/images/wall_sit.png", dur: Duration(seconds: 10)),
  ];
}

class Exercise {
  Exercise(
      {@required this.title,
        @required this.hint,
        @required this.img,
        this.reps,
        this.dur});

  final String title;
  final String hint;
  final String img;
  final int reps;
  final Duration dur;
}
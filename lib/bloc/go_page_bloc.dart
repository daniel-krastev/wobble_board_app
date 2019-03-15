import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';


class GoPageBloc extends Bloc<ExerciseEvent, ExerciseModel> {
  Timer _timer;
  int _currentStep;

  @override
  ExerciseModel get initialState {
    return InitialExerciseModel(
      isPaused: false,
      currentSeconds: 0
    );
  }

  @override
  Stream<ExerciseModel> mapEventToState(
      ExerciseModel currentState, ExerciseEvent event) async* {
    switch (event) {
      case ExerciseEvent.init:
        _timer?.cancel();
        currentState = InitialExerciseModel(
          isPaused: false,
            currentSeconds: 0,
        );
        yield (currentState as TimerExerciseModel);
        _currentStep = 0;
        _timer = Timer.periodic(Duration(seconds: 1), (t) {
          dispatch(ExerciseEvent.update);
        });
        break;
      case ExerciseEvent.update:
        if(currentState is TimerExerciseModel) {
          if(currentState.peek()) {
            yield currentState..onMoreSecond();
          } else {
            _timer?.cancel();
            dispatch(ExerciseEvent.next);
          }
        }
        break;
      case ExerciseEvent.next:
        if(_currentStep >= ExerciseRepo.list.length) {
          dispatch(ExerciseEvent.finish);
        } else {
          yield _getModel(_currentStep);
          _currentStep++;
        }
        break;
      case ExerciseEvent.finish:
        yield _getFinishModel();
        break;
      case ExerciseEvent.pause:
        _timer?.cancel();
        yield (currentState as TimerExerciseModel)..isPaused = true;
        break;
      case ExerciseEvent.cont:
        _timer = Timer.periodic(Duration(seconds: 1), (t) {
          dispatch(ExerciseEvent.update);
        });
        yield (currentState as TimerExerciseModel)..isPaused = false;
        break;
    }
  }

  ExerciseModel _getFinishModel() {
    return RepsExerciseModel(
        currentStep: ExerciseRepo.list.length - 1,
        image: "assets/images/trophy.png",
        reps: null,
        hint: "Congratulations! Exercises completed!"
    );
  }

  ExerciseModel _getModel(final int count) {
    Exercise e = ExerciseRepo.list[count];
    if(e.reps != null) {
      return RepsExerciseModel(
        currentStep: count,
        image: e.img,
        reps: e.reps,
        hint: e.hint
      );
    } else {
      _timer?.cancel();
      _timer = Timer.periodic(Duration(seconds: 1), (t) {
        dispatch(ExerciseEvent.update);
      });
      return TimerExerciseModel(
        isPaused: false,
        currentSeconds: 0,
        image: e.img,
        currentStep: count,
        totalSeconds: e.dur,
        hint: e.hint
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

enum ExerciseEvent {finish, next, update, init, pause, cont}

class ExerciseModel {
  String image;
  int currentStep;
  String hint;

  ExerciseModel({
    @required this.image, @required this.currentStep, this.hint
  });

  double get progress => ((currentStep + 1) / ExerciseRepo.list.length);

  @override
  bool operator ==(other) => false;

  @override
  int get hashCode => 1;
}

class TimerExerciseModel extends ExerciseModel {
  int totalSeconds;
  int currentSeconds;
  bool isPaused;

  TimerExerciseModel({
    @required this.totalSeconds,
    @required this.currentSeconds,
    @required this.isPaused,
    @required image,
    @required currentStep,
    hint
  }) : assert(currentSeconds <= totalSeconds),
        super(image: image, currentStep: currentStep, hint: hint);

  bool peek() => totalSeconds != currentSeconds;
  onMoreSecond() => currentSeconds++;
  double get progressTimer => (currentSeconds / totalSeconds);
  int get remaining => totalSeconds - currentSeconds;
}

class InitialExerciseModel extends TimerExerciseModel {
  InitialExerciseModel({
    @required currentSeconds,
    @required isPaused,
  }) : assert(currentSeconds <= 5),
        super(isPaused: isPaused, totalSeconds: 5, currentSeconds: currentSeconds, image: "assets/images/trophy.png", currentStep: 0, hint: "Get ready to start!");

  @override
  double get progress => 0;
}

class RepsExerciseModel extends ExerciseModel {
  int reps;
  RepsExerciseModel({
    @required this.reps,
    @required image,
    @required currentStep,
    hint
  }) : super(image: image, currentStep: currentStep, hint: hint);
}


class ExerciseRepo {
  static final List<Exercise> list = [
    Exercise(title: "Standing Balance", hint: "Balance in upright position.", img: "assets/images/exercises/standing_balance.png", dur: 20),
    Exercise(title: "High Plank", hint: "Keep your hands straight.", img: "assets/images/exercises/high_plank.png", dur: 18),
    Exercise(title: "Low Plank", hint: "Put your elbows on the board.", img: "assets/images/exercises/low_plank.png", dur: 18),
    Exercise(title: "One Leg Squat Hold (left)", hint: "Stay on your left leg.", img: "assets/images/exercises/one_leg_squat_hold.png", dur: 8),
    Exercise(title: "One Leg Squat Hold (right)", hint: "Stay on your right leg.", img: "assets/images/exercises/one_leg_squat_hold.png", dur: 8),
    Exercise(title: "Push Up (Hands On)", hint: "Keep your elbows close to your chest.", img: "assets/images/exercises/push_ups_hands.png", reps: 10),
    Exercise(title: "Push Up (Feet On)", hint: "Put your legs on the board and do push ups.", img: "assets/images/trophy.png", reps: 10),
    Exercise(title: "Single Leg Balance", hint: "Stay on your right leg.", img: "assets/images/exercises/single_leg_balance.png", dur: 10),
    Exercise(title: "Single Leg Balance", hint: "Stay on your left leg.", img: "assets/images/exercises/single_leg_balance.png", dur: 10),
    Exercise(title: "Wall Sit", hint: "Put your back against the wall.", img: "assets/images/exercises/wall_sit.png", dur: 10),
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
  final int dur;
}
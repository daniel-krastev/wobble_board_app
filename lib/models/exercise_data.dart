import 'package:meta/meta.dart';
import 'package:wobble_board/resources/repository.dart';

final _repository = Repository();

class ExerciseModel {
  String image;
  int currentStep;
  String hint;

  ExerciseModel({@required this.image, @required this.currentStep, this.hint});

  @override
  int get hashCode => 1;

  double get progress => ((currentStep + 1) / _repository.getExercises().length);

  @override
  bool operator ==(other) => false;
}

class InitialExerciseModel extends TimerExerciseModel {
  InitialExerciseModel({
    @required currentSeconds,
    @required isPaused,
  })  : assert(currentSeconds <= 5),
        super(
          isPaused: isPaused,
          totalSeconds: 5,
          currentSeconds: currentSeconds,
          image: "assets/images/trophy.png",
          currentStep: 0,
          hint: "Get ready to start!");

  @override
  double get progress => 0;
}

class RepsExerciseModel extends ExerciseModel {
  int reps;
  RepsExerciseModel(
      {@required this.reps, @required image, @required currentStep, hint})
      : super(image: image, currentStep: currentStep, hint: hint);
}

class TimerExerciseModel extends ExerciseModel {
  int totalSeconds;
  int currentSeconds;
  bool isPaused;

  TimerExerciseModel(
      {@required this.totalSeconds,
        @required this.currentSeconds,
        @required this.isPaused,
        @required image,
        @required currentStep,
        hint})
      : assert(currentSeconds <= totalSeconds),
        super(image: image, currentStep: currentStep, hint: hint);

  double get progressTimer => (currentSeconds / totalSeconds);
  int get remaining => totalSeconds - currentSeconds;
  onMoreSecond() => currentSeconds++;
  bool peek() => totalSeconds != currentSeconds;
}
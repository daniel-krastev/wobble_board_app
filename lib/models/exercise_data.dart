import 'package:meta/meta.dart';
import 'package:wobble_board/resources/repository.dart';

final _repository = Repository();

/// This generic model is generated from the exercise info
/// and is directly passed to the user interface of the
/// Exercise page through the go page bloc.
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

/// Model used at the beginning.
class InitialExerciseModel extends TimerExerciseModel {
  InitialExerciseModel({
    @required currentSeconds,
    @required isPaused,
    @required image,
    @required hint,
    @required totalSeconds
  })  : assert(currentSeconds <= totalSeconds),
        super(
          isPaused: isPaused,
          totalSeconds: totalSeconds,
          currentSeconds: currentSeconds,
          image: image,
          currentStep: 0,
          hint: hint);

  @override
  double get progress => 0;
}

/// Exercise model that contains a number for the
/// repetitions.
class RepsExerciseModel extends ExerciseModel {
  int reps;
  RepsExerciseModel(
      {@required this.reps, @required image, @required currentStep, hint})
      : super(image: image, currentStep: currentStep, hint: hint);
}

/// Exercise model that contains a timer.
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
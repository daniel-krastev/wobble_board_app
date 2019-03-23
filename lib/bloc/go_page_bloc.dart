import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:bloc/bloc.dart';
import 'package:wobble_board/models/exercise_data.dart';
import 'package:wobble_board/models/exercise_info.dart';
import 'package:wobble_board/resources/repository.dart';

class GoPageBloc extends Bloc<ExerciseEvent, ExerciseModel> {
  final _repository = Repository();
  Timer _timer;
  int _currentStep;
  AudioCache player = AudioCache(prefix: 'sounds/');

  GoPageBloc() {
    player.loadAll(['cheer.mp3', 'horn.mp3', 'button.mp3', 'tick.mp3']);
  }

  @override
  ExerciseModel get initialState {
    return InitialExerciseModel(isPaused: false, currentSeconds: 0);
  }

  @override
  void dispose() {
    super.dispose();
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
        if (currentState is TimerExerciseModel) {
          if (currentState.peek()) {
            player.play("tick.mp3");
            yield currentState..onMoreSecond();
          } else {
            _timer?.cancel();
            dispatch(ExerciseEvent.next);
          }
        }
        break;
      case ExerciseEvent.next:
        if (_currentStep >= _repository.getExercises().length) {
          dispatch(ExerciseEvent.finish);
        } else {
          player.play("horn.mp3");
          yield _getModel(_currentStep);
          _currentStep++;
        }
        break;
      case ExerciseEvent.finish:
        player.play("cheer.mp3");
        yield _getFinishModel();
        break;
      case ExerciseEvent.pause:
        if (currentState is TimerExerciseModel) {
          player.play("button.mp3");
          _timer?.cancel();
          yield currentState..isPaused = true;
        }
        break;
      case ExerciseEvent.cont:
        if (currentState is TimerExerciseModel) {
          player.play("button.mp3");
          _timer?.cancel();
          _timer = Timer.periodic(Duration(seconds: 1), (t) {
            dispatch(ExerciseEvent.update);
          });
          yield currentState..isPaused = false;
        }
        break;
    }
  }

  ExerciseModel _getFinishModel() {
    return RepsExerciseModel(
        currentStep: _repository.getExercises().length - 1,
        image: "assets/images/trophy.png",
        reps: null,
        hint: "Congratulations! Exercises completed!");
  }

  ExerciseModel _getModel(final int count) {
    Exercise e = _repository.getExercises()[count];
    if (e.reps != null) {
      return RepsExerciseModel(
          currentStep: count, image: e.img, reps: e.reps, hint: e.hint);
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
          hint: e.hint);
    }
  }
}

enum ExerciseEvent { finish, next, update, init, pause, cont }

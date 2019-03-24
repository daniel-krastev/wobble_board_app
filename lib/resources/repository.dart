import 'package:wobble_board/models/exercise_info.dart';
import 'package:wobble_board/resources/exercises.dart';

class Repository {
  final _exerciseProvider = ExerciseRepo();

  Exercise getInitial() => _exerciseProvider.initial;
  List<Exercise> getExercises() => _exerciseProvider.exercises;
  List<Exercise> getExercisesWithRests() => _exerciseProvider.exercisesWithRests;
}
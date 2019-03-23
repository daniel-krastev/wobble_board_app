import 'package:wobble_board/models/exercise_info.dart';
import 'package:wobble_board/resources/exercises.dart';

class Repository {
  final _exerciseProvider = ExerciseRepo();

  List<Exercise> getExercises() => _exerciseProvider.list;
}
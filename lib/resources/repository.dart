import 'package:wobble_board/models/exercise_info.dart';
import 'package:wobble_board/resources/exercises.dart';


/// This class provides the access for the
/// exercise repository and eventually other repositories
/// that might exist in the application.
class Repository {
  final _exerciseProvider = ExerciseRepo();

  Exercise getInitial() => _exerciseProvider.initial;
  List<Exercise> getExercises() => _exerciseProvider.exercises;
  List<Exercise> getExercisesWithRests() => _exerciseProvider.exercisesWithRests;
}
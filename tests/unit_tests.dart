import 'package:flutter_test/flutter_test.dart';
import 'package:wobble_board/models/exercise_data.dart';
import 'package:wobble_board/models/exercise_info.dart';
import 'package:wobble_board/resources/repository.dart';
import 'package:wobble_board/ui/pages/home_page.dart';

/// Unit tests for the project.
///
/// Here we test the repository of exercises used for the
/// Exercise page, the exercise data objects and the
/// Home page menu options.

// Run unit tests
void main() {

  //Test the exercises from the repository
  _testExerciseInfoRepository();

  //Test the logic of the exercises data models
  _testExerciseDataModels();

  //Test the home page menu options validity
  _testHomePageMenuOptions();
}

_testExerciseDataModels() {
  group("Exercise models", () {
    TimerExerciseModel timerModel = TimerExerciseModel(
        totalSeconds: 30,
        currentSeconds: 6,
        isPaused: false,
        image: "/fake/path",
        currentStep: 2);
    RepsExerciseModel repsModel =
        RepsExerciseModel(reps: 12, image: "/fake/path", currentStep: 4);
    InitialExerciseModel initialModel = InitialExerciseModel(
        currentSeconds: 11,
        isPaused: true,
        image: "fake/path",
        hint: "nada",
        totalSeconds: 40);

    test("Initial model is a timer", () {
      expect(timerModel, predicate((s) => s is TimerExerciseModel));
    });

    test("Timer progress less than 1", () {
      expect(timerModel.progressTimer, lessThan(1));
    });

    test("Initial progress less than 1", () {
      expect(initialModel.progressTimer, lessThan(1));
    });

    test("Timer has more seconds", () {
      expect(timerModel.peek(), true);
    });

    test("Reps model instance of Exercise", () {
      expect(repsModel, predicate((s) => s is ExerciseModel));
    });
  });
}

_testExerciseInfoRepository() {
  group("Repository", () {
    final repo = Repository();

    test("The repo returns the inital item", () {
      expect(repo.getInitial().dur, 15);
    });

    test("Exercises are less, than exercises with rests", () {
      expect(repo.getExercises().length,
          lessThanOrEqualTo(repo.getExercisesWithRests().length));
    });

    test("Each element is Exercise", () {
      expect(repo.getExercisesWithRests(),
          everyElement(predicate((e) => e is Exercise)));
    });

    test("Each exercise in the repo has either duration or repetitions", () {
      expect(repo.getExercisesWithRests(),
          everyElement(predicate((e) => e.dur != null || e.reps != null)));
    });

    test("Each exercise in the repo has image", () {
      expect(repo.getExercisesWithRests(),
          everyElement(predicate((e) => e.img != null)));
    });
  });
}

_testHomePageMenuOptions() {
  group("Home page options", () {
    test("Has title", () {
      expect(RepoOptions.menuOpt.map((s) => s.title), everyElement(isNotEmpty));
    });

    test("Has subtitle", () {
      expect(
          RepoOptions.menuOpt.map((s) => s.subtitle), everyElement(isNotEmpty));
    });

    test("Has path", () {
      expect(RepoOptions.menuOpt.map((s) => s.path), everyElement(isNotEmpty));
    });

    test("Has image path", () {
      expect(RepoOptions.menuOpt.map((s) => s.img), everyElement(isNotEmpty));
    });
  });
}

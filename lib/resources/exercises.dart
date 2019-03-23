import 'package:wobble_board/models/exercise_info.dart';

class ExerciseRepo {
  final List<Exercise> _list = [
    Exercise(
        title: "Standing Balance",
        hint: "Balance in upright position.",
        img: "assets/images/exercises/standing_balance.png",
        dur: 20),
    Exercise(
        title: "High Plank",
        hint: "Keep your hands straight.",
        img: "assets/images/exercises/high_plank.png",
        dur: 18),
    Exercise(
        title: "Low Plank",
        hint: "Put your elbows on the board.",
        img: "assets/images/exercises/low_plank.png",
        dur: 18),
    Exercise(
        title: "One Leg Squat Hold (left)",
        hint: "Stay on your left leg.",
        img: "assets/images/exercises/one_leg_squat_hold.png",
        dur: 8),
    Exercise(
        title: "One Leg Squat Hold (right)",
        hint: "Stay on your right leg.",
        img: "assets/images/exercises/one_leg_squat_hold.png",
        dur: 8),
    Exercise(
        title: "Push Up (Hands On)",
        hint: "Keep your elbows close to your chest.",
        img: "assets/images/exercises/push_ups_hands.png",
        reps: 10),
    Exercise(
        title: "Single Leg Balance",
        hint: "Stay on your right leg.",
        img: "assets/images/exercises/single_leg_balance.png",
        dur: 10),
    Exercise(
        title: "Single Leg Balance",
        hint: "Stay on your left leg.",
        img: "assets/images/exercises/single_leg_balance.png",
        dur: 10),
    Exercise(
        title: "Wall Sit",
        hint: "Put your back against the wall.",
        img: "assets/images/exercises/wall_sit.png",
        dur: 10),
  ];

  List<Exercise> get list => _list;
}
import 'package:wobble_board/models/exercise_info.dart';

class ExerciseRepo {
  final List<Exercise> _list = [
    Exercise(
        title: "REST",
        hint: "Get ready to start!\nNext: Standing Balance",
        img: "assets/images/exercises/standing_balance.png",
        dur: 15),
    Exercise(
        title: "Standing Balance",
        hint: "Balance in upright position.",
        img: "assets/images/exercises/standing_balance.png",
        dur: 20),

    Exercise(
        title: "REST",
        hint: "Take a rest!\nNext: High Plank",
        img: "assets/images/exercises/high_plank.png",
        dur: 30),
    Exercise(
        title: "High Plank",
        hint: "Keep your hands straight.",
        img: "assets/images/exercises/high_plank.png",
        dur: 20),

    Exercise(
        title: "REST",
        hint: "Take a rest!\nNext: Low Plank",
        img: "assets/images/exercises/low_plank.png",
        dur: 30),
    Exercise(
        title: "Low Plank",
        hint: "Put your elbows on the board.",
        img: "assets/images/exercises/low_plank.png",
        dur: 20),

    Exercise(
        title: "REST",
        hint: "Take a rest!\nNext: Push Up (Hands On)",
        img: "assets/images/exercises/push_ups_hands.png",
        dur: 30),
    Exercise(
        title: "Push Up (Hands On)",
        hint: "Keep your elbows close to your chest.",
        img: "assets/images/exercises/push_ups_hands.png",
        reps: 10),

    Exercise(
        title: "REST",
        hint: "Take a rest!\nNext: One Leg Squat Hold (left)",
        img: "assets/images/exercises/one_leg_squat_hold.png",
        dur: 30),
    Exercise(
        title: "One Leg Squat Hold (left)",
        hint: "Stay on your left leg.",
        img: "assets/images/exercises/one_leg_squat_hold.png",
        dur: 10),

    Exercise(
        title: "REST",
        hint: "Take a rest!\nNext: One Leg Squat Hold (right)",
        img: "assets/images/exercises/one_leg_squat_hold.png",
        dur: 30),
    Exercise(
        title: "One Leg Squat Hold (right)",
        hint: "Stay on your right leg.",
        img: "assets/images/exercises/one_leg_squat_hold.png",
        dur: 10),

//    Exercise(
//        title: "REST",
//        hint: "Take a rest!\nNext: Single Leg Balance (right)",
//        img: "assets/images/exercises/single_leg_balance.png",
//        dur: 30),
//    Exercise(
//        title: "Single Leg Balance (right)",
//        hint: "Stay on your right leg.",
//        img: "assets/images/exercises/single_leg_balance.png",
//        dur: 10),
//
//    Exercise(
//        title: "REST",
//        hint: "Take a rest!\nNext: Single Leg Balance (left)",
//        img: "assets/images/exercises/single_leg_balance.png",
//        dur: 30),
//    Exercise(
//        title: "Single Leg Balance (left)",
//        hint: "Stay on your left leg.",
//        img: "assets/images/exercises/single_leg_balance.png",
//        dur: 10),

    Exercise(
        title: "REST",
        hint: "Take a rest!\nNext: Wall Sit",
        img: "assets/images/exercises/wall_sit.png",
        dur: 30),
    Exercise(
        title: "Wall Sit",
        hint: "Put your back against the wall.",
        img: "assets/images/exercises/wall_sit.png",
        dur: 10),
  ];


  List<Exercise> get exercises => _list.where((e) => e.title != "REST").toList();
  List<Exercise> get exercisesWithRests => _list.sublist(1);
  Exercise get initial => _list[0];
}
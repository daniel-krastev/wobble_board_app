import 'package:meta/meta.dart';

class Exercise {
  final String title;

  final String hint;
  final String img;
  final int reps;
  final int dur;
  Exercise(
      {@required this.title,
        @required this.hint,
        @required this.img,
        this.reps,
        this.dur});
}
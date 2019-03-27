import 'package:meta/meta.dart';


/// This class represents the data model for each
/// exercise in the Exercise flow.
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
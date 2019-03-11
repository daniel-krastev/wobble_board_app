import 'package:flutter/material.dart';
import 'package:wobble_board/ui/widgets/exercise.dart';

class ExercisePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Wobble Board Exercises'),
        ),
        body: Exercise(false));
  }
}

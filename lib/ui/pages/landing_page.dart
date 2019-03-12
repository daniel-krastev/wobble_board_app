import 'package:flutter/material.dart';
import 'package:wobble_board/ui/pages/exercise_page.dart';
import 'package:wobble_board/ui/pages/game_page.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Landing Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExercisePage()),
                  );
                },
                child: Text("Exercise")),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GamePage()),
                  );
                },
                child: Text("Game")),
          ],
        ),
      ),
    );
  }
}

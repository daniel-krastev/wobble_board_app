import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wobble_board/ui/widgets/exercise.dart';

/// User interface for the Game page.
class GamePage extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<GamePage> {
  int turn = 0;
  var scores = [0, 0];
  CollectionReference leaderboard =
      Firestore.instance.collection('leaderboard');

  submitScore(username, time) {
    leaderboard.document().setData({'firstname': username, 'time': time});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.125,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                      key: Key("back_arrow"),
                      alignment: Alignment.centerLeft,
                      iconSize: Theme.of(context).iconTheme.size,
                      padding: EdgeInsets.all(18.0),
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back)),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text('Game',
                        key: Key("page_title"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .body1
                                .color)),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Image.asset('assets/images/trophy.png', height: 60),
                  )),
                ],
              ),
            ),
            Exercise(true, submitScore),
          ],
        ),
      ),
    );
  }
}

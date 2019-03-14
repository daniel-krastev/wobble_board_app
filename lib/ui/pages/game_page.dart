import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wobble_board/ui/widgets/exercise.dart';

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
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                      alignment: Alignment.centerLeft,
                      iconSize: Theme.of(context).iconTheme.size,
                      padding: EdgeInsets.all(18.0),
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back)),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text('Game',
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
//            Container(
////            width: 100.0,
//                height: 10,
//                child: TextField(
//                  textAlign: TextAlign.center,
//                  style: TextStyle(
//                      fontSize: 14.0,
//                      height: 1.0,
//                      color: Theme.of(context).primaryTextTheme.title.color),
//                  decoration: InputDecoration(
//                      border: OutlineInputBorder(borderSide: BorderSide()),
//                      labelText: 'Name'),
//                )),
            Exercise(true, submitScore),
          ],
        ),
      ),
    );

    // return Scaffold(
    //     // appBar: AppBar(
    //     //   title: const Text('Wobble Board Game'),
    //     // ),
    //     body: ListView(
    //       children: <Widget>[
    //         Column(
    //           children: <Widget>[
    //             // Exercise(true, updateScore),

    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: <Widget>[
    //                 // Padding(
    //                 //   padding:
    //                 //   const EdgeInsets.only(bottom: 30.0, right: 10.0, top: 10.0),
    //                 //   child: Column(
    //                 //     children: <Widget>[
    //                 //       Text(
    //                 //         'P1',
    //                 //         style: TextStyle(
    //                 //             fontSize: 30.0,
    //                 //             color: (turn % 2 == 0 ? Colors.blue : Colors.black)),
    //                 //       ),
    //                 //       Text(
    //                 //         '${(scores[0] / 1000).toStringAsFixed(2)}',
    //                 //         style: TextStyle(fontSize: 30.0),
    //                 //       ),
    //                 //     ],
    //                 //   ),
    //                 // ),
    //                 // Padding(
    //                 //   padding:
    //                 //   const EdgeInsets.only(bottom: 30.0, left: 10.0, top: 10.0),
    //                 //   child: Column(
    //                 //     children: <Widget>[
    //                 //       Text(
    //                 //         'P2',
    //                 //         style: TextStyle(
    //                 //             fontSize: 30.0,
    //                 //             color: (turn % 2 == 1 ? Colors.blue : Colors.black)),
    //                 //       ),
    //                 //       Text(
    //                 //         '${(scores[1] / 1000).toStringAsFixed(2)}',
    //                 //         style: TextStyle(fontSize: 30.0),
    //                 //       ),
    //                 //     ],
    //                 //   ),
    //                 // )
    //               ],
    //             )
    //           ],
    //         ),
    //       ],
    //     ));
  }
}

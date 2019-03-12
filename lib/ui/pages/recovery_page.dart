import 'package:flutter/material.dart';
import 'package:wobble_board/ui/widgets/exercise.dart';

class GamePage extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<GamePage> {
  int turn = 0;
  var scores = [0, 0];

  updateScore(score) {
    setState(() {
      // only update score if it's higher than the current
      scores[turn % 2] = (scores[turn % 2] < score) ? score : scores[turn % 2];
      turn++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            style: TextStyle(fontSize: 30,color:Theme.of(context).primaryColorDark)),
                      )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(right:0),
                    child: Image.asset('assets/images/compete_icon.png',height:60),
                  )),
                ],
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(right: 100.0, left: 100.0),
              child: TextField(
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                      fontSize: 18.0, height: 1.0, color: Theme.of(context).primaryColorDark),
                  decoration: InputDecoration(
                      border:  OutlineInputBorder(
                          borderSide:  BorderSide()
                      ),
                      labelText: 'Name'
                  ),
            ))),
             Exercise(true, updateScore),
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

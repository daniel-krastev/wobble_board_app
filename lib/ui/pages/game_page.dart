import 'package:flutter/material.dart';
import 'package:wobble_board/ui/widgets/exercise.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
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
      appBar: AppBar(
        title: const Text('Wobble Board Game'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Exercise(true, updateScore),
          ),
          Text(
            'Top Scores',
            style: TextStyle(fontSize: 40.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 30.0, right: 10.0, top: 10.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'P1',
                      style: TextStyle(
                          fontSize: 30.0,
                          color: (turn % 2 == 0 ? Colors.blue : Colors.black)),
                    ),
                    Text(
                      '${(scores[0] / 1000).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 30.0, left: 10.0, top: 10.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'P2',
                      style: TextStyle(
                          fontSize: 30.0,
                          color: (turn % 2 == 1 ? Colors.blue : Colors.black)),
                    ),
                    Text(
                      '${(scores[1] / 1000).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

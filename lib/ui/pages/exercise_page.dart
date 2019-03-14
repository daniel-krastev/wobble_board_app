import 'package:flutter/material.dart';
import 'package:wobble_board/bloc/go_page_bloc.dart';

class ExercisePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Text(
                      "Exercise",
                      style: Theme.of(context).primaryTextTheme.title,
                    ),
                  ),
                  IconButton(
                      alignment: Alignment.centerLeft,
                      iconSize: Theme.of(context).iconTheme.size,
                      padding: EdgeInsets.all(18.0),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back)),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: ExerciseRepo.exerciseList.length,
                    itemBuilder: (context, count) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(ExerciseRepo.exerciseList[count].title),
                            subtitle: _getSubtitle(count),
                            //TODO add relevant images, when ready
                            trailing: Container(
                                height: 35.0,
                                width: 35.0,
                                child: Image.asset("assets/images/trophy.png")),
                          ),
                          Divider()
                        ],
                      );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                    width: double.infinity,
                  child: RaisedButton(
                    padding: const EdgeInsets.all(16.0),
                    onPressed: () {},
                    child: Text("GO"),
                  ),
                ),
              )
            ],
          ),
        ));
  }

Widget _getSubtitle(final int count) {
    if(ExerciseRepo.exerciseList[count].dur != null) {
      return Text(
          "${ExerciseRepo.exerciseList[count].dur.inSeconds} seconds"
      );
    } else {
      return Text(
          "x ${ExerciseRepo.exerciseList[count].reps}"
      );
    }
}
}
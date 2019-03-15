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
                    itemCount: ExerciseRepo.list.length,
                    itemBuilder: (context, count) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(ExerciseRepo.list[count].title, style: Theme.of(context).primaryTextTheme.body1),
                            subtitle: _getSubtitle(count, context),
                            //TODO add relevant images, when ready
                            trailing: Container(
                                height: 35.0,
                                width: 35.0,
                                child: Image.asset(ExerciseRepo.list[count].img)),
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
                    onPressed: () {
                      Navigator.of(context).pushNamed("/exercise/go");
                    },
                    child: Text("GO"),
                  ),
                ),
              )
            ],
          ),
        ));
  }

Widget _getSubtitle(final int count, BuildContext context) {
    if(ExerciseRepo.list[count].dur != null) {
      return Text(
          "${ExerciseRepo.list[count].dur} seconds"
          , style: Theme.of(context).primaryTextTheme.body2
      );
    } else {
      return Text(
          "x ${ExerciseRepo.list[count].reps}"
          , style: Theme.of(context).primaryTextTheme.body2
      );
    }
}
}
import 'package:flutter/material.dart';

class Exercise extends StatelessWidget {
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
            ],
          ),
        ));
  }
}

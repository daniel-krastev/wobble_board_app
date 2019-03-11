import 'package:flutter/material.dart';

class About extends StatelessWidget {
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
                  "About",
                  style: Theme.of(context).primaryTextTheme.title,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

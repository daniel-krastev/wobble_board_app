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
                height: MediaQuery.of(context).size.height * 0.125,
                child: Text(
                  "About",
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
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Image.asset(
              'assets/images/logo_portrait.png',
              height: 300,
            ),
          ),
          Text(
            'Making Wobble Board Smarter to Improve Exercise and Rehabilitation\n\nVersion: 0.1(BETA)\n\nAuthors:\n Daniel Krastev(dkk6)\nIvan Kasabov(ik99)\nNikola Ignatov(ni60)',
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.body2,
          ),
          Text(''),
          Text(''),
        ],
      ),
    ));
  }
}

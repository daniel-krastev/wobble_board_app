import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        right: 70.0, left: 20.0, top: 5.0),
                    child: Image.asset("assets/images/logo_landscape.png"),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.menu),
                  ),
                ],
              ),
            ),
            Text(
              "Balance. Strength. Recovery.",
              style: Theme.of(context).primaryTextTheme.title,
            ),
            SizedBox(
              height:30,
            ),
            // Row(
            //   children: <Widget>[
            //     Padding(
            //       padding: const EdgeInsets.only(left: 20.0, right: 5.0),
            //       child: Text(
            //         "Select",
            //         style: Theme.of(context).primaryTextTheme.body1,
            //       ),
            //     ),
            //     Text(
            //       "Activity:",
            //       style: Theme.of(context).primaryTextTheme.body2,
            //     ),
            //     Expanded(
            //       child: SizedBox(),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.only(right: 20.0),
            //       child: Icon(Icons.more_horiz),
            //     )
            //   ],
            // ),
            Expanded(
              child: ListView.builder(
                  itemCount: RepoOptions.menuOpt.length,
                  itemBuilder: (context, count) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 10.0, bottom: 5.0),
                      child: Container(
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  blurRadius: 20.0,
                                  color: Colors.black26,
                                  offset: Offset(0.0, 5.0))
                            ],
                            color: Theme.of(context).backgroundColor,
                          ),
                          height: 120.0,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 30.0, bottom: 10.0,),
                                child: Text(
                                  RepoOptions.menuOpt[count].title,
                                  style:
                                      Theme.of(context).primaryTextTheme.body1,
                                  textScaleFactor: 1.6,
                                ),
                              ),
                              Text(
                                RepoOptions.menuOpt[count].subtitle,
                                style: Theme.of(context).primaryTextTheme.body2,
                              ),
                            ],
                          )),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class RepoOptions {
  static final List<Option> menuOpt = [
    Option(
      title: "Exercise",
      subtitle: "Fitness exercises",
    ),
    Option(
      title: "Recovery",
      subtitle: "Rehabilitation exercises",
    ),
    Option(
      title: "Game",
      subtitle: "Timed competition",
    )
  ];
}

class Option {
  Option({@required this.title, @required this.subtitle, this.img});
  final String title;
  final String subtitle;
  final String img;
}

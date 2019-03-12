import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wobble_board/bloc/bloc_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _HomeState();
  
  // CollectionReference leaderboard =
  //     Firestore.instance.collection('leaderboard');

  //   leaderboard.snapshots().listen(
  //       (data) => data.documents.forEach((doc) => print(doc['firstname'])));
  //   leaderboard.document().setData({'firstname': 'Дани', 'time': 0.00333});
   
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Drawer _getDrawer() {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
//        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
              title: Text('Settings',
                  style: Theme.of(context).primaryTextTheme.body1),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/settings");
              },
              trailing: Icon(Icons.settings)),
          ListTile(
            title:
                Text('About', style: Theme.of(context).primaryTextTheme.body1),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/about");
            },
            trailing: Icon(Icons.info),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _getDrawer(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                      alignment: Alignment.centerLeft,
                      iconSize: Theme.of(context).iconTheme.size,
                      padding: EdgeInsets.all(18.0),
                      onPressed: () => _scaffoldKey.currentState.openDrawer(),
                      icon: Icon(Icons.menu)),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Image.asset("assets/images/logo_landscape.png"),
                  ))
                ],
              ),
            ),
            Text(
              "Balance. Strength. Recovery.",
              style: Theme.of(context).primaryTextTheme.title,
            ),
            SizedBox(
              height: 80.0,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 9.0),
                  child: Text(
                    "Select",
                    style: Theme.of(context).primaryTextTheme.body1,
                  ),
                ),
                Text(
                  "Activity:",
                  style: Theme.of(context).primaryTextTheme.body2,
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Icon(Icons.more_horiz),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: RepoOptions.menuOpt.length,
                  itemBuilder: (context, count) {
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
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
                          height: 140.0,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  RepoOptions.menuOpt[count].title,
                                  style:
                                      Theme.of(context).primaryTextTheme.body1,
                                  textScaleFactor: 1.5,
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

  @override
  void dispose() {
    BlocProvider.of(context).connectionBloc?.dispose();
    BlocProvider.of(context).dataBloc?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
//    _screenWidth = MediaQuery.of(context).size.width;
//    _screenHeight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }
}

class RepoOptions {
  static final List<Option> menuOpt = [
    Option(
      title: "Exercise",
      subtitle: "Practice your balance!",
    ),
    Option(
      title: "Recovery",
      subtitle: "Exercises to get back in shape!",
    ),
    Option(
      title: "Game",
      subtitle: "Compete with friends!",
    )
  ];
}

class Option {
  Option({@required this.title, @required this.subtitle, this.img});

  final String title;
  final String subtitle;
  final String img;
}

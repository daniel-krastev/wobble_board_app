import 'package:flutter/material.dart';
import 'package:wobble_board/bloc/bloc_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _HomeState();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _tappedPage = -1;

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
                Navigator.popAndPushNamed(context, '/settings');
              },
              trailing: Icon(Icons.settings)),
          ListTile(
            title:
                Text('About', style: Theme.of(context).primaryTextTheme.body1),
            onTap: () {
              Navigator.popAndPushNamed(context, '/about');
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
              height: MediaQuery.of(context).size.height * 0.15,
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
                    child: Image.asset('assets/images/logo_landscape.png'),
                  )),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              child: Text(
                'Balance. Strength. Recovery.',
                style: Theme.of(context).primaryTextTheme.title,
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView.builder(
                  physics: ScrollPhysics(),
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
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RepoOptions.menuOpt[count].path);
                                  setState(() {
                                    _tappedPage = -1;
                                  });
                                },
                                onTapDown: (_) {
                                  setState(() {
                                    _tappedPage = count;
                                  });
                                },
                                onTapCancel: () {
                                  setState(() {
                                    _tappedPage = -1;
                                  });
                                },
                                highlightColor: Theme.of(context).primaryColor,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              RepoOptions.menuOpt[count].title,
                                              style: _tappedPage != count
                                                  ? Theme.of(context)
                                                      .primaryTextTheme
                                                      .caption
                                                  : Theme.of(context)
                                                      .primaryTextTheme
                                                      .body1
                                                      .copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .backgroundColor),
                                              textScaleFactor: 1.5,
                                            ),
                                          ),
                                          Text(
                                            RepoOptions.menuOpt[count].subtitle,
                                            style: _tappedPage != count
                                                ? Theme.of(context)
                                                    .primaryTextTheme
                                                    .body2
                                                : Theme.of(context)
                                                    .primaryTextTheme
                                                    .body2
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .backgroundColor),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Image.asset(
                                          RepoOptions.menuOpt[count].img,
                                          height: 80,
                                          color: _tappedPage != count
                                              ? null
                                              : Theme.of(context)
                                                  .backgroundColor,
                                        ))
                                  ],
                                ),
                              ),
                            )));
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
        title: 'Exercise',
        subtitle: 'Practice your balance!',
        img: "assets/images/exercise.png",
        path: '/exercise'),
    Option(
        title: 'Recovery',
        subtitle: 'Exercises to get back in shape!',
        img: "assets/images/recovery.png",
        path: '/recovery'),
    Option(
        title: 'Game',
        subtitle: 'Compete with friends!',
        img: "assets/images/trophy.png",
        path: '/game')
  ];
}

class Option {
  Option(
      {@required this.title,
      @required this.subtitle,
      @required this.img,
      @required this.path});

  final String title;
  final String subtitle;
  final String path;
  final String img;
}

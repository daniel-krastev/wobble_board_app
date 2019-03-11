import 'package:flutter/material.dart';
import 'package:wobble_board/bloc/bloc_provider.dart';
import 'package:wobble_board/bloc/connection.dart' as bloc;

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bloc.ConnectionBlock bl;
  bool _searching = false;
  String _previousState = "_";


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
                      "Settings",
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
              Expanded(
                child: StreamBuilder(
                  initialData: "",
                  stream: bl.connection,
                  builder: (context, snapshot) {
                    final String state = snapshot.data ?? "";
                    _searching = (state == _previousState &&
                        state != bloc.ConnectionState.CONNECTED &&
                        state != bloc.ConnectionState.BLE_OFF);
                    _previousState = state;
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              blurRadius: 20.0,
                              color: Colors.black26,
                              offset: Offset(0.0, 5.0)
                          )
                        ],
                        color: Theme.of(context).backgroundColor,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _getStatus(_searching ? "Searching..." : state),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _getButton(
                                        (state == bloc.ConnectionState.DISCONNECTED ||
                                            state == bloc.ConnectionState.NOT_FOUND)
                                            ? () {
                                          bl.connectionEventSink
                                              .add(bloc.ConnectEvent());
                                          setState(() {
                                            _searching = true;
                                          });
                                        }
                                            : null,
                                        "Connect"),
                                    _getButton(
                                        state == bloc.ConnectionState.CONNECTED
                                            ? () => bl.connectionEventSink
                                            .add(bloc.DisconnectEvent())
                                            : null,
                                        "Disconnect")
                                  ],
                                ),
                              ],
                            ),
//                            _searching ? _getSearchIndicator() : Container(),
                          ],
                        ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    bl?.dispose();
    BlocProvider.of(context).dataBloc?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    bl = BlocProvider.of(context).connectionBloc;
//    _screenWidth = MediaQuery.of(context).size.width;
//    _screenHeight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  Widget _getStatus(final String status) {
    return Text(
      "Wobbly:  $status",
      style: Theme.of(context).primaryTextTheme.body1,
    );
  }

  RaisedButton _getButton(final VoidCallback onPressed, final String txt) {
    return RaisedButton(onPressed: onPressed, child: Text(txt));
  }

  Widget _getSearchIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Opacity(
          opacity: 0.65,
          child: Container(
            width: 250.0,
            height: 100.0,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
          ),
        ),
        CircularProgressIndicator()
      ],
    );
  }
}

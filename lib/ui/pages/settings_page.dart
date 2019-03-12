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
              IconButton(
                  alignment: Alignment.centerLeft,
                  iconSize: Theme.of(context).iconTheme.size,
                  padding: EdgeInsets.all(18.0),
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back)),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
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
                            offset: Offset(0.0, 5.0))
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
                                    ((state ==
                                        bloc.ConnectionState
                                            .DISCONNECTED ||
                                        state ==
                                            bloc.ConnectionState.NOT_FOUND) && !_searching)
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
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
          )
        ],
      ),
    ));
  }

  @override
  void didChangeDependencies() {
    bl = BlocProvider.of(context).connectionBloc;
    bl.connectionEventSink.add(bloc.GetStatusEvent());
//    _screenWidth = MediaQuery.of(context).size.width;
//    _screenHeight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  Widget _getStatus(final String status) {
    return Text(
      "Status:  $status",
      style: Theme.of(context).primaryTextTheme.body1,
    );
  }

  Widget _getButton(final VoidCallback onPressed, final String txt) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150.0,
        height: 30.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.0),
          gradient: LinearGradient(colors: <Color>[
            onPressed != null
                ? Theme.of(context).backgroundColor
                : Colors.grey[350],
            Colors.grey[350]
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          boxShadow: [
            BoxShadow(
                blurRadius: 1.5,
                color: Colors.black12,
                offset: Offset(0.0, 1.5))
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Text(txt, style: Theme.of(context).textTheme.body1),
            ),
          ),
        ),
      ),
    );
  }
}

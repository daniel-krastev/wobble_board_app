import 'package:flutter/material.dart';
import 'package:wobble_board/bloc/bloc_provider.dart';
import 'package:wobble_board/bloc/connection.dart' as bloc;
import 'package:wobble_board/ui/pages/landing_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bloc.ConnectionBlock bl;
  bool _searching = false;
  String _previousState = "_";

  _HomeState();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: "",
      stream: bl.connection,
      builder: (context, snapshot) {
        final String state = snapshot.data ?? "";
        _searching = (state == _previousState &&
            state != bloc.ConnectionState.CONNECTED &&
            state != bloc.ConnectionState.BLE_OFF);
        _previousState = state;
        return Scaffold(
          appBar: AppBar(
            title: Text("Wobbly"),
            centerTitle: true,
          ),
          floatingActionButton: state == bloc.ConnectionState.CONNECTED
              ? _getNextScreenButton()
              : Container(),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _getStatus(_searching ? "Searching..." : state),
                  Expanded(
                    child: Row(
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
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        _getButton(
                            state == bloc.ConnectionState.CONNECTED
                                ? () => bl.connectionEventSink
                                    .add(bloc.DisconnectEvent())
                                : null,
                            "Disconnect")
                      ],
                    ),
                  ),
                ],
              ),
              _searching ? _getSearchIndicator() : Container(),
            ],
          ),
        );
      },
    );
  }

  FloatingActionButton _getNextScreenButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Landing()),
        );
      },
      child: Icon(Icons.navigate_next),
    );
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
      style: TextStyle(fontSize: 18.0),
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

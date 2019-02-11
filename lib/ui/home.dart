import 'package:flutter/material.dart';
import 'package:wobble_board/bloc/bloc_provider.dart';
import 'package:wobble_board/bloc/connection.dart' as bloc;
import 'package:wobble_board/ui/niki_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bloc.ConnectionBlock bl;


  _HomeState() {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         HOME_CONSTRUCT");
  }

  @override
  Widget build(BuildContext context) {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         HOME_BUILD");
    bl = BlocProvider.of(context).connectionBloc;
    return StreamBuilder(
          initialData: "",
          stream: bl.connection,
          builder: (context, snapshot) {
            final String state = snapshot.data ?? "";
            return Scaffold(
              appBar: AppBar(
                title: Text("Wobbly"),
                centerTitle: true,
              ),
              floatingActionButton: state == bloc.ConnState.DEVICE_CONNECTED ? _getNextScreenButton() : Container(),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _getStatusTile(state),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                            onPressed: (state == bloc.ConnState.DEVICE_DISCONNECTED || state == bloc.ConnState.DEVICE_NOT_FOUND)
                                ? () => bl.connectionEventSink
                                .add(bloc.ConnectEvent())
                                : null,
                            child: Text("Connect")),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        RaisedButton(
                            onPressed: state == bloc.ConnState.DEVICE_CONNECTED
                                ? () => bl.connectionEventSink
                                .add(bloc.DisconnectEvent())
                                : null,
                            child: Text("Disconnect")),
                      ],
                    ),
                  )
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
          MaterialPageRoute(builder: (context) => Niki()),
        );
      },
      child: Icon(Icons.navigate_next),
    );
  }

  @override
  void dispose() {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         HOME_DISPOSE");
    bl?.dispose();
    super.dispose();
  }

  void initState() {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         HOME_INIT_STATE");
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _postCallback(context));
  }

  void _postCallback(BuildContext c) {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         HOME_POST_CALLBACK");
    BlocProvider.of(context).connectionBloc.connectionEventSink.add(bloc.StatusEvent());
  }


  @override
  void didUpdateWidget(Home oldWidget) {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         HOME_DID_UPDATE_WIDGET");
  }

  ListTile _getStatusTile(final String status) {
    return ListTile(
      title: Text(status),
      trailing: Icon(Icons.info),
    );
  }
}

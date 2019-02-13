import 'package:flutter/material.dart';
import 'package:wobble_board/bloc/bloc_provider.dart';
import 'package:wobble_board/bloc/connection.dart' as bloc;
import 'package:wobble_board/ui/niki_page.dart';
import 'package:wobble_board/utils/wobbly_data.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bloc.ConnectionBlock bl;


  _HomeState() {
    print("$DEBUG_TAG HOME_CONSTRUCT");
  }

  @override
  Widget build(BuildContext context) {
    print("$DEBUG_TAG HOME_BUILD");
    return StreamBuilder(
          initialData: "",
          stream: bl.connection,
          builder: (context, snapshot) {
            final String state = snapshot.data ?? "";
            print("$DEBUG_TAG $state");
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
    print("$DEBUG_TAG HOME_DISPOSE");
    bl?.dispose();
    BlocProvider.of(context).dataBloc?.dispose();
    super.dispose();
  }

  void initState() {
    print("$DEBUG_TAG HOME_INIT_STATE");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("$DEBUG_TAG HOME_DID_CHANGE_DEPENDENCIES");
    bl = BlocProvider.of(context).connectionBloc;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Home oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("$DEBUG_TAG HOME_DID_UPDATE_WIDGET");
  }

  ListTile _getStatusTile(final String status) {
    return ListTile(
      title: Text(status),
      trailing: Icon(Icons.info),
    );
  }
}

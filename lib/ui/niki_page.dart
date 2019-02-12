import 'package:flutter/material.dart';
import 'package:wobble_board/bloc/bloc_provider.dart';
import 'package:wobble_board/bloc/data.dart' as bloc;
import 'package:wobble_board/utils/ble_utils.dart';

class Niki extends StatefulWidget {
  @override
  _NikiState createState() => _NikiState();
}

class _NikiState extends State<Niki> {
  bloc.DataBlock bl;

  _NikiState() {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         NIKI_CONSTRUCT");
  }

  @override
  Widget build(BuildContext context) {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         NIKI_BUILD");
    bl = BlocProvider.of(context).dataBloc;
    return StreamBuilder(
        initialData: {
          AccAxis.X: 0.0,
          AccAxis.Y: 0.0
        },
        stream: bl.data,
        builder: (context, snapshot) {
          print(snapshot.data);
          return Scaffold(
            appBar: AppBar(
              title: Text("Exercise Page"),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("X: ${snapshot.data[AccAxis.X]}"),
                  Text("Y: ${snapshot.data[AccAxis.Y]}"),
                ],
              ),
            ),
          );
        });
  }

  void initState() {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         NIKI_INIT_STATE");
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _postCallback(context));
  }

  void _postCallback(BuildContext c) {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         NIKI_POST_CALLBACK");
    BlocProvider.of(context).dataBloc.dataEventSink.add(bloc.GetDataStream());
  }

  @override
  void dispose() {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         NIKI_DISPOSE");
//    bl?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Niki oldWidget) {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         NIKI_DID_UPDATE_WIDGET");
  }


}

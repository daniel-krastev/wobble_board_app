import 'package:flutter/material.dart';
import 'package:wobble_board/bloc/bloc_provider.dart';
import 'package:wobble_board/bloc/data.dart' as bloc;
import 'package:wobble_board/utils/ble_utils.dart';
import 'package:wobble_board/utils/wobbly_data.dart';

class Niki extends StatefulWidget {
  @override
  _NikiState createState() => _NikiState();
}

class _NikiState extends State<Niki> {
  bloc.DataBlock bl;

  _NikiState();

  @override
  Widget build(BuildContext context) {
    bl.dataEventSink.add(bloc.ContinueDataEvent());
    return StreamBuilder(
        initialData: {
          AccAxis.X: 0.0,
          AccAxis.Y: 0.0
        },
        stream: bl.data,
        builder: (context, snapshot) {
          print("$DEBUG_TAG ${snapshot.data}");
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                          onPressed: () => bl.dataEventSink.add(bloc.StartDataEvent()),
                          child: Text("Start")),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      RaisedButton(
                          onPressed: () => bl.dataEventSink.add(bloc.StopDataEvent()),
                          child: Text("Stop")),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    bl.dataEventSink.add(bloc.LeaveUiEvent());
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    bl = BlocProvider.of(context).dataBloc;
    super.didChangeDependencies();
  }
}

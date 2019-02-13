import 'dart:async';
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
  List<double> _accelerometerValues = [0.00, 0.00];
  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

  _NikiState() {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         NIKI_CONSTRUCT");
  }

  @override
  Widget build(BuildContext context) {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         NIKI_BUILD");
    bl = BlocProvider.of(context).dataBloc;
    return Scaffold(
      appBar: AppBar(
        title: Text("Exercise Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("X: ${_accelerometerValues[0]}"),
            Text("Y: ${_accelerometerValues[1]}"),
            RaisedButton(
                onPressed: _startListening,
                child: Text("Start")
            ),
            RaisedButton(
                onPressed: _stopListening,
                child: Text("Stop")
            ),
          ],
        ),
      ),
    );
  }

  void _postCallback(BuildContext c) {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         NIKI_POST_CALLBACK");
    BlocProvider.of(context).dataBloc.dataEventSink.add(bloc.GetDataStream());
  }

  void _startListening() {
    _streamSubscriptions
        .add(bl.data.listen((event) {
          debugPrint('$event');
          _accelerometerValues = <double>[event[AccAxis.X], event[AccAxis.Y]];
          debugPrint('${_accelerometerValues[0]}');
        })
    );
  }

  void _stopListening() {
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void didUpdateWidget(Niki oldWidget) {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         NIKI_DID_UPDATE_WIDGET");
  }

  @override
  void dispose() {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         NIKI_DISPOSE");
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    print("DEBUGDEBUGDEBUGDEBUGDEBUG:         NIKI_INIT_STATE");
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _postCallback(context));
  }
}

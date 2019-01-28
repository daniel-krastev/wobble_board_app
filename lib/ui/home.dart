import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  BluetoothState _bluetoothState = BluetoothState.unknown;
  StreamSubscription _stateSubscription;

  StreamSubscription _scanResults;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wobble"),
        actions: <Widget>[],
      ),
      body: StreamBuilder(
        stream: _flutterBlue.onStateChanged(),
        builder: (BuildContext ctx, AsyncSnapshot<BluetoothState> snap) {
          _bluetoothState = snap.data ?? _bluetoothState;
          return Column(
            children: <Widget>[
              getAlertTile(),
              Expanded(
                child: ListView(
                  children: <Widget>[],
                ),
              ),
              RaisedButton(
                child: Text("Scan"),
                onPressed: _bluetoothState != BluetoothState.on ? null : _scan,
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _flutterBlue.state.then((s) {
      setState(() => _bluetoothState = s);
    });
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      setState(() => _bluetoothState = s);
    });
  }

  Widget getAlertTile() {
    return Container(
      color: getInfoTileColor(),
      child: ListTile(
          title: Text(
            getInfoTileString(),
            style: Theme.of(context).primaryTextTheme.subhead,
          ),
          trailing: Icon(Icons.info,
              color: Theme.of(context).primaryTextTheme.subhead.color)),
    );
  }

  Color getInfoTileColor() {
    if (_bluetoothState == BluetoothState.off) {
      return Colors.red[400];
    } else {
      return Colors.blue[400];
    }
  }

  String getInfoTileString() {
    return "Bluetooth is ${_bluetoothState.toString().substring(15).toUpperCase()}";
  }

  void _scan() {
    
  }
}

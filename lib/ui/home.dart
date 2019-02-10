import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:wobble_board/utils/ble_utils.dart';

const List<String> status = [
  "Turn your bluetooth on.",
  "Connect to your Wobbly device.",
  "Connected."
];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //BLE
  static FlutterBlue _bleManager = FlutterBlue.instance;
  BleConnectionUtils _bleUtils = BleConnectionUtils(_bleManager);
  BluetoothState _bluetoothCurrentState = BluetoothState.unknown;
  StreamSubscription _bluetoothStateSubscription;

  //Wobbly
  BluetoothDeviceState _wobblyCurrentState;
  StreamSubscription _wobblyStateSubscription;
  StreamSubscription _wobblyDataStream;

  double _x = 0, _y = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Wobbly"),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _getStatusTile(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                      onPressed: _bluetoothCurrentState == BluetoothState.on
                          ? _onButton
                          : null,
                      child: Text(
                          (_wobblyCurrentState == BluetoothDeviceState.connected
                              ? "Disconnect"
                              : "Connect"))),
                  Text("X: $_x / Y: $_y")
                ],
              ),
            )
          ],
        ));
  }

  @override
  void dispose() {
    _bluetoothStateSubscription?.cancel();
    _wobblyStateSubscription?.cancel();
    _wobblyDataStream?.cancel();
    _bleUtils.onDispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _bleUtils.onInitState();
    _bleManager.state.then((state) {
      setState(() {
        _bluetoothCurrentState = state;
      });
    });
    _bluetoothStateSubscription = _bleManager.onStateChanged().listen((state) {
      setState(() {
        _bluetoothCurrentState = state;
      });
    });
  }

  void _connect() {
    _bleUtils.discoverWobbly().then((res) {
      if (res) {
        _wobblyStateSubscription = _bleUtils.connectToWobbly().listen((state) {
          setState(() {
            _wobblyCurrentState = state;
          });
          if (state == BluetoothDeviceState.connected) {
            _bleUtils.getWobblyData().then((stream) {
              _wobblyDataStream = stream.listen((data) {
                setState(() {
                  _x = data[AccAxis.X];
                  _y = data[AccAxis.Y];
                });
              });
            });
          }
        }, onDone: _disconnect);
      }
    });
  }

  void _disconnect() {
    _wobblyDataStream?.cancel();
    _wobblyDataStream = null;
    _wobblyStateSubscription?.cancel();
    _wobblyStateSubscription = null;
    _bleUtils.onDisconnect();
    setState(() {
      _wobblyCurrentState = BluetoothDeviceState.disconnected;
      _x = 0;
      _y = 0;
    });
  }

  ListTile _getStatusTile() {
    String txt;
    if (_bluetoothCurrentState == BluetoothState.on) {
      txt = _wobblyCurrentState == BluetoothDeviceState.connected
          ? status[2]
          : status[1];
    } else {
      txt = status[0];
    }
    return ListTile(
      title: Text(txt),
      trailing: Icon(Icons.info),
    );
  }

  void _onButton() {
    _wobblyCurrentState == BluetoothDeviceState.connected
        ? _disconnect()
        : _connect();
  }
}

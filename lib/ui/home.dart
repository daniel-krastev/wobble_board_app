import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

const String SERVICE_UUID = "19b10000-e8f2-537e-4f6c-d104768a1214";
const String CHARACTERISTIC_UUID = "19b10001-e8f2-537e-4f6c-d104768a1214";
const String DEVICE_NAME = "Wobbly";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  // State
  BluetoothState _bluetoothState = BluetoothState.unknown;
  StreamSubscription _stateSubscription;

  // Scanning
  StreamSubscription _scanSubscription;
  bool _isScanning = false;

  // Device
  BluetoothDevice wobbly;
  bool get isConnected => (wobbly != null);


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
                child: Text("Connect"),
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
            style: Theme
                .of(context)
                .primaryTextTheme
                .subhead,
          ),
          trailing: Icon(Icons.info,
              color: Theme
                  .of(context)
                  .primaryTextTheme
                  .subhead
                  .color)),
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
    return "Bluetooth is ${_bluetoothState.toString()
        .substring(15)
        .toUpperCase()}";
  }

  void _scan() {
    _scanSubscription = _flutterBlue
        .scan(
      timeout: const Duration(seconds: 5),
      withServices: [
          Guid(SERVICE_UUID)
        ]
    )
        .listen((scanResult) {
      if(scanResult.device.name == DEVICE_NAME) {
        wobbly = scanResult.device;
      }
    }, onDone: _stopScan);

    setState(() {
      _isScanning = true;
    });
  }

  _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    setState(() {
      _isScanning = false;
    });

  }
}

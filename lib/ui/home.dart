import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';


const String DEBUG_KEY = "DEBUGDEBUGDEBUGDEBUGDEBUG_";

const int SCAN_CONNECT_TIMEOUT = 6;
const String CHAR_UUID = "19b10001-e8f2-537e-4f6c-d104768a1214";
const String SERVICE_UUID = "19b10000-e8f2-537e-4f6c-d104768a1214";
const String DEVICE_NAME = "Wobbly";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  ByteData _buffer;
  Uint8List _midBuff;

  // State
  BluetoothState _bluetoothState = BluetoothState.unknown;
  StreamSubscription _stateSubscription;

  // Scanning
  StreamSubscription _scanSubscription;
  bool _tryingToConnect = false;

  // Device
  BluetoothDevice _wobbly;
  StreamSubscription _deviceConnection;
  StreamSubscription _deviceStateSubscription;
  StreamSubscription _charValueSubscription;
  BluetoothCharacteristic _wobblyChar;
  BluetoothDeviceState _deviceState = BluetoothDeviceState.disconnected;

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
                onPressed: _bluetoothState != BluetoothState.on
                    ? null
                    : _startConnectionSequence,
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

  void _connect() {
    print("$DEBUG_KEY _connect");
    if (_wobbly != null) {
      _deviceConnection = _flutterBlue
          .connect(_wobbly, timeout: Duration(seconds: SCAN_CONNECT_TIMEOUT))
          .listen(null, onDone: _disconnect);

      // Subscribe to connection changes
      _deviceStateSubscription = _wobbly.onStateChanged().listen((s) {
        _deviceState = s;
        if (s == BluetoothDeviceState.connected) {
          _discoverServices();
        }
      });
    }
  }

  void _decodeBuffer(List<int> valueList) {
    print(valueList);
    _midBuff = Uint8List.fromList(valueList);
    _buffer = _midBuff.buffer.asByteData();
    print(
        "X: ${_buffer.getFloat32(1, Endian.little)}; Y: ${_buffer.getFloat32(5, Endian.little)}");
  }

  _disconnect() {
    print("$DEBUG_KEY _disconnect");
    _charValueSubscription?.cancel();
    _charValueSubscription = null;
    _deviceStateSubscription?.cancel();
    _deviceStateSubscription = null;
    _deviceConnection = null;
    _deviceConnection?.cancel();
  }

  void _discoverServices() async {
    print("$DEBUG_KEY _discoverServices/1");
    _wobblyChar = (await _wobbly.discoverServices())
        .firstWhere((s) {
          return s.uuid.toString() == SERVICE_UUID;
        })
        .characteristics
        .firstWhere((ch) {
          return ch.uuid.toString() == CHAR_UUID;
        });

    print("$DEBUG_KEY _discoverServices/2");
    await _wobbly.readCharacteristic(_wobblyChar).then((v) {
      _decodeBuffer(v);
    });
    print("$DEBUG_KEY _discoverServices/3");
    await _wobbly.setNotifyValue(_wobblyChar, true);
    print("$DEBUG_KEY _discoverServices/4");
    _charValueSubscription = _wobbly.onValueChanged(_wobblyChar).listen((v) {
      _decodeBuffer(v);
    });
  }

  void _startConnectionSequence() async {
    print("$DEBUG_KEY _startConnectionSequence");
    _wobbly = (await _flutterBlue.scan(
            timeout: const Duration(seconds: SCAN_CONNECT_TIMEOUT),
            withServices: [Guid(SERVICE_UUID)]).firstWhere((scanR) {
      return scanR.device.name == DEVICE_NAME;
    }))
        .device;
    _connect();
  }
}

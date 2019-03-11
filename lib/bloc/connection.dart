import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:wobble_board/utils/ble_utils.dart';
import 'package:wobble_board/utils/wobbly_data.dart';

class ConnectionBlock {
  //BLE helper class
  BleConnectionUtils _bleUtils = BleConnectionUtils.instance;

  //Bluetooth state
  StreamSubscription _bluetoothStateSubscription;
  BluetoothState _bluetoothLastKnownState = BluetoothState.unknown;

  //Wobbly State
  StreamSubscription _wobblyConnectionSubscription;
  BluetoothDeviceState _wobblyLastKnownState =
      BluetoothDeviceState.disconnected;

  //Standard BLoC stream fields
  //Sink: this, Stream: Connection UI
  final _connectionStateController = StreamController<String>();
  StreamSink<String> get _inConnState => _connectionStateController.sink;
  Stream<String> get connection => _connectionStateController.stream;

  //Sink: Connection UI, Stream: this
  final _connectionEventController = StreamController<ConnectionEvent>();
  Sink<ConnectionEvent> get connectionEventSink =>
      _connectionEventController.sink;

  ConnectionBlock() {
    _connectionEventController.stream.listen(_mapEventToState);
    _bluetoothStateSubscription =
        _bleUtils.getBluetoothStateStream().listen(_handleBluetoothState);
    _bleUtils.getBleCurrentState().then(_handleBluetoothState);
  }

  void _mapEventToState(ConnectionEvent event) {
    if (event is ConnectEvent) {
      _connect();
    } else if (event is DisconnectEvent) {
      _disconnect();
    } else if (event is GetStatusEvent) {
      _getStatus();
    }
  }

  void _getStatus() {
    if (_bluetoothLastKnownState != BluetoothState.on) {
      _inConnState.add(ConnectionState.BLE_OFF);
    } else if (_wobblyLastKnownState == BluetoothDeviceState.connected) {
      _inConnState.add(ConnectionState.CONNECTED);
    } else {
      _inConnState.add(ConnectionState.DISCONNECTED);
    }
  }

  void _connect() {
    _bleUtils.discoverWobbly().then((res) async {
      if (res) {
        _wobblyConnectionSubscription =
            _bleUtils.connectToWobbly().listen((state) {
          if (state == BluetoothDeviceState.connected) {
            _bleUtils.discoverWobblyChar().then((res) {
              if (res) {
                _inConnState.add(ConnectionState.CONNECTED);
              }
            });
          } else {
            if (_bluetoothLastKnownState != BluetoothState.off) {
              _inConnState.add(ConnectionState.NOT_FOUND);
            }
          }
          _wobblyLastKnownState = state;
        }, onDone: _disconnect);
      } else {
        _inConnState.add(ConnectionState.NOT_FOUND);
      }
    });
  }

  void _handleBluetoothState(BluetoothState s) {
    _bluetoothLastKnownState = s;
    if (s == BluetoothState.off) {
      _wobblyConnectionSubscription?.cancel();
      _wobblyLastKnownState = BluetoothDeviceState.disconnected;
    }
    _getStatus();
  }

  void _disconnect() {
    _wobblyConnectionSubscription?.cancel();
    _inConnState.add(ConnectionState.DISCONNECTED);
  }

  void dispose() {
    _connectionStateController.close();
    _connectionEventController.close();
    _wobblyConnectionSubscription?.cancel();
    _bluetoothStateSubscription?.cancel();
    _inConnState.add(ConnectionState.DISCONNECTED);
  }
}

abstract class ConnectionEvent {}

class ConnectEvent extends ConnectionEvent {}

class DisconnectEvent extends ConnectionEvent {}

class GetStatusEvent extends ConnectionEvent {}

class ConnectionState {
  static const BLE_OFF = "Turn your bluetooth on";
  static const CONNECTED = "Connected";
  static const NOT_FOUND = "Not found. Please, make sure Wobbly is ON.";
  static const DISCONNECTED = "Disconnected";
}

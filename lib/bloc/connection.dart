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
  StreamSubscription _wobblyStateSubscription;
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
        _bleUtils.getBluetoothStateStream().listen((s) {
      _bluetoothLastKnownState = s;
      _getStatus();
    });
    _bleUtils.getBleCurrentState().then((s) {
      _bluetoothLastKnownState = s;
      _getStatus();
    });
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
      _inConnState.add(ConnectionState.DEVICE_CONNECTED);
    } else {
      _inConnState.add(ConnectionState.DEVICE_DISCONNECTED);
    }
  }

  void _connect() {
    _bleUtils.discoverWobbly().then((res) {
      if (res) {
        _wobblyStateSubscription = _bleUtils.connectToWobbly().listen((state) {
          if (state == BluetoothDeviceState.connected) {
            _bleUtils.discoverWobblyChar().then((res) {
              if(res) {
                _inConnState.add(ConnectionState.DEVICE_CONNECTED);
              }
            });
          } else {
            _inConnState.add(ConnectionState.DEVICE_DISCONNECTED);
          }
          _wobblyLastKnownState = state;
        }, onDone: _disconnect);
      } else {
        _inConnState.add(ConnectionState.DEVICE_NOT_FOUND);
      }
    });
  }

  void _disconnect() {
    _wobblyStateSubscription?.cancel();
    _inConnState.add(ConnectionState.DEVICE_DISCONNECTED);
  }

  void dispose() {
    print("$DEBUG_TAG CONNECT_BLOC_DESPOSING");
    _connectionStateController.close();
    _connectionEventController.close();
    _wobblyStateSubscription?.cancel();
    _bluetoothStateSubscription?.cancel();
    _inConnState.add(ConnectionState.DEVICE_DISCONNECTED);
  }
}

abstract class ConnectionEvent {}

class ConnectEvent extends ConnectionEvent {}

class DisconnectEvent extends ConnectionEvent {}

class GetStatusEvent extends ConnectionEvent {}

class ConnectionState {
  static const BLE_OFF = "Turn your bluetooth on";
  static const DEVICE_CONNECTED = "Connected";
  static const DEVICE_CONNECTING = "Connecting...";
  static const DEVICE_NOT_FOUND = "Device not found";
  static const DEVICE_DISCONNECTED = "Disconnected";
}

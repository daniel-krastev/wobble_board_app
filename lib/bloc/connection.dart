import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:wobble_board/utils/ble_utils.dart';

class ConnectionBlock {
  //BLE
  BleConnectionUtils _bleUtils = BleConnectionUtils.instance;
  StreamSubscription _bluetoothStateSubscription;
  BluetoothState _bluetoothLastKnownState = BluetoothState.unknown;

  //Wobbly
  StreamSubscription _wobblyStateSubscription;
  BluetoothDeviceState _wobblyLastKnownState =
      BluetoothDeviceState.disconnected;

  final _connectionStateController = StreamController<String>();
  StreamSink<String> get _inConnState => _connectionStateController.sink;
  Stream<String> get connection => _connectionStateController.stream;

  final _connectionEventController = StreamController<ConnectionEvent>();
  Sink<ConnectionEvent> get connectionEventSink =>
      _connectionEventController.sink;

  ConnectionBlock() {
    print("DEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUG:        CONNECT_BLOC_CONSTRUCTING");
    _connectionEventController.stream.listen(_mapEventToState);
    _bluetoothStateSubscription = _bleUtils.getBleStateStream().listen((s) {
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
    } else if (event is StatusEvent) {
      _getStatus();
    }
  }

  void _getStatus() {
    if (_bluetoothLastKnownState != BluetoothState.on) {
      _inConnState.add(ConnState.BLE_OFF);
    } else if (_wobblyLastKnownState == BluetoothDeviceState.connected) {
      _inConnState.add(ConnState.DEVICE_CONNECTED);
    } else {
      _inConnState.add(ConnState.DEVICE_DISCONNECTED);
    }
  }

  void _connect() {
      _bleUtils.discoverWobbly().then((res) {
        if (res) {
          _wobblyStateSubscription =
              _bleUtils.connectToWobbly().listen((state) {
            _wobblyLastKnownState = state;
            if (state == BluetoothDeviceState.connected || state == BluetoothDeviceState.connecting) {
              _inConnState.add(ConnState.DEVICE_CONNECTED);
            } else {
              _inConnState.add(ConnState.DEVICE_DISCONNECTED);
            }
          }, onDone: _disconnect);
        } else {
          _inConnState.add(ConnState.DEVICE_NOT_FOUND);
        }
      });
  }

  void _disconnect() {
    _wobblyStateSubscription?.cancel();
    _bleUtils.onDisconnect();
    _inConnState.add(ConnState.DEVICE_DISCONNECTED);
  }

  void dispose() {
    print("DEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUG:        CONNECT_BLOC_DESPOSING");
    _connectionStateController.close();
    _connectionEventController.close();
    _wobblyStateSubscription?.cancel();
    _bluetoothStateSubscription?.cancel();
    _bleUtils.onDispose();
    _inConnState.add(ConnState.DEVICE_DISCONNECTED);
  }
}

abstract class ConnectionEvent {}

class ConnectEvent extends ConnectionEvent {}

class DisconnectEvent extends ConnectionEvent {}

class StatusEvent extends ConnectionEvent {}

class ConnState {
  static const BLE_OFF = "Turn your bluetooth on.";
  static const DEVICE_CONNECTED = "Connected.";
  static const DEVICE_NOT_FOUND = "Device not found.";
  static const DEVICE_DISCONNECTED = "Disconnected.";
}

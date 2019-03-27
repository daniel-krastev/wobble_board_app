import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';

import 'wobbly_data.dart';

const int SCAN_CONNECT_TIMEOUT = 18;

enum AccAxis { X, Y }

/// This class contains the bluetooth functionalities we require.
class BleConnectionUtils {
  static final BleConnectionUtils _instance = BleConnectionUtils._internal();
  static BleConnectionUtils get instance => _instance;

  BleConnectionUtils._internal() {
    _flutterBlue = FlutterBlue.instance;
    _flutterBlue.setLogLevel(LogLevel.notice);
  }

  ByteData _buffer;
  FlutterBlue _flutterBlue;
  BluetoothDevice _wobbly;
  BluetoothCharacteristic _wobblyChar;

  /// Subscribe to the bluetooth state of this device.
  Stream<BluetoothState> getBluetoothStateStream() {
    return _flutterBlue.onStateChanged();
  }

  /// Returns a future with the current state of the
  /// Bluetooth of the device
  Future<BluetoothState> getBleCurrentState() {
    return _flutterBlue.state;
  }

  /// Discovers the board
  Future<bool> discoverTheBoard() async {
    _wobbly = (await _flutterBlue.scan(
            timeout: const Duration(seconds: SCAN_CONNECT_TIMEOUT),
            withServices: [Guid(SERVICE_UUID)]).firstWhere((scanR) {
      return scanR.device.name == DEVICE_NAME;
    }, orElse: () => null))
        ?.device;
    return _wobbly != null;
  }

  /// Connects to the board
  Stream<BluetoothDeviceState> connectToTheBoard() {
    return _flutterBlue.connect(_wobbly,
        timeout: Duration(seconds: SCAN_CONNECT_TIMEOUT), autoConnect: false);
  }

  /// Discovers the board's BLE characteristics
  Future<bool> discoverBoardsChar() async {
    _wobblyChar = (await _wobbly.discoverServices())
        .firstWhere((s) {
          return s.uuid.toString() == SERVICE_UUID;
        }, orElse: null)
        ?.characteristics
        ?.firstWhere((ch) {
          return ch.uuid.toString() == CHAR_UUID;
        }, orElse: null);
    return _wobblyChar != null;
  }

  /// Return the stream of accelerometer values and
  /// sets the notify value
  Future<Stream<Map<AccAxis, int>>> notifyAndGetStream() async {
    await _wobbly.setNotifyValue(_wobblyChar, true);
    return _getXyStream(_wobbly.onValueChanged(_wobblyChar));
  }

  /// Sets notify value of the BLE characteristic to false
  Future<bool> stopNotifications() async {
    return _wobbly.setNotifyValue(_wobblyChar, false);
  }

  /// Gets the stream of X and Y values
  Stream<Map<AccAxis, int>> _getXyStream(Stream<List<int>> source) async* {
    await for (var list in source) {
      _buffer = ByteData.view(Int8List.fromList(list).buffer);
      yield {
        AccAxis.X: _buffer.getInt8(1),
        AccAxis.Y: _buffer.getInt8(2)
      };
    }
  }
}

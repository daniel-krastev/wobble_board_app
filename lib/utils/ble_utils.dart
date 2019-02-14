import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';

import 'wobbly_data.dart';

const int SCAN_CONNECT_TIMEOUT = 18;

enum AccAxis { X, Y }

class BleConnectionUtils {
  static final BleConnectionUtils _instance = BleConnectionUtils._internal();
  static BleConnectionUtils get instance => _instance;

  BleConnectionUtils._internal() {
    _flutterBlue = FlutterBlue.instance;
  }

  ByteData _buffer;
  FlutterBlue _flutterBlue;
  BluetoothDevice _wobbly;
  BluetoothCharacteristic _wobblyChar;

  Stream<BluetoothState> getBluetoothStateStream() {
    return _flutterBlue.onStateChanged();
  }

  Future<BluetoothState> getBleCurrentState() {
    return _flutterBlue.state;
  }

  Future<bool> discoverWobbly() async {
    _wobbly = (await _flutterBlue.scan(
            timeout: const Duration(seconds: SCAN_CONNECT_TIMEOUT),
            withServices: [Guid(SERVICE_UUID)]).firstWhere((scanR) {
      return scanR.device.name == DEVICE_NAME;
    }, orElse: () => null))
        ?.device;
    return _wobbly != null;
  }

  Stream<BluetoothDeviceState> connectToWobbly() {
    return _flutterBlue.connect(_wobbly,
        timeout: Duration(seconds: SCAN_CONNECT_TIMEOUT), autoConnect: false);
  }

  Future<bool> discoverWobblyChar() async {
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

  Future<Stream<Map<AccAxis, double>>> notifyAndGetStream() async {
    await _wobbly.setNotifyValue(_wobblyChar, true);
    return _getXyStream(_wobbly.onValueChanged(_wobblyChar));
  }

  Future<bool> stopNotifications() async {
    return _wobbly.setNotifyValue(_wobblyChar, false);
  }

  Stream<Map<AccAxis, double>> _getXyStream(Stream<List<int>> source) async* {
    await for (var list in source) {
      _buffer = ByteData.view(Uint8List.fromList(list).buffer);
      yield {
        AccAxis.X: _normalize(_buffer.getFloat32(1, Endian.little)),
        AccAxis.Y: _normalize(_buffer.getFloat32(5, Endian.little))
      };
    }
  }

  double _normalize(double n) {
    return double.parse(n.toStringAsFixed(2));
  }
}

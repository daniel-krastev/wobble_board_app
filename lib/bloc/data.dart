import 'dart:async';

import 'package:wobble_board/utils/ble_utils.dart';
import 'package:wobble_board/utils/wobbly_data.dart';


/// This bloc deals with the transport of data
/// between the app and the board.
///
/// The sits bloc is between the UI and the BLE utils,
/// but unlike the connection bloc, this bloc
/// requires that you first connect and then use it.
class DataBlock {
  //BLE helper class
  BleConnectionUtils _bleUtils = BleConnectionUtils.instance;

  //Wobbly data
  StreamSubscription _wobblyDataSubscription;

  //Keeps the last streaming state before leaving the exercise page
  bool _streamingToUI;

  //Standard BLoC stream fields
  //Sink: this, Stream: Exercise UI (x & y data)
  final _dataController = StreamController<Map<AccAxis, int>>.broadcast();
  StreamSink<Map<AccAxis, int>> get _inData => _dataController.sink;
  Stream<Map<AccAxis, int>> get data => _dataController.stream;

  //Sink: Exercise UI, Stream: this
  final _dataEventController = StreamController<DataEvent>();
  Sink<DataEvent> get dataEventSink =>
      _dataEventController.sink;

  DataBlock() {
    _streamingToUI = false;
    _dataEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(DataEvent event) {
    if (event is StartDataEvent) {
      if(_wobblyDataSubscription == null) {
        _bleUtils.notifyAndGetStream().then((stream) {
          _wobblyDataSubscription = stream.listen((xY) {
            _inData.add(xY);
          });
        });
      }
    } else if (event is StopDataEvent) {
      _stopNotifications();
    } else if (event is ContinueDataEvent) {
      if(_streamingToUI) {
        _mapEventToState(StartDataEvent());
      }
    } else if (event is LeaveUiEvent) {
      _streamingToUI = _wobblyDataSubscription != null;
      _stopNotifications();
    }
  }

  /// Stops the notifications of the BLE
  void _stopNotifications() {
    _bleUtils.stopNotifications().then((r) {
      _wobblyDataSubscription?.cancel();
      _wobblyDataSubscription = null;
    });
  }

  void dispose() {
    _dataController.close();
    _dataEventController.close();
    _wobblyDataSubscription?.cancel();
  }
}

/// The events accepted from this bloc
abstract class DataEvent {}

class StartDataEvent extends DataEvent {}

class StopDataEvent extends DataEvent {}

class ContinueDataEvent extends DataEvent {}

class LeaveUiEvent extends DataEvent {}
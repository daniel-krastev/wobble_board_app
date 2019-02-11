import 'dart:async';

import 'package:wobble_board/utils/ble_utils.dart';

class DataBlock {
  //BLE
  BleConnectionUtils _bleUtils = BleConnectionUtils.instance;

  //Wobbly
  StreamSubscription _wobblyDataSubscription;

  final _dataController = StreamController<Map<AccAxis, double>>.broadcast();
  StreamSink<Map<AccAxis, double>> get _inData => _dataController.sink;
  Stream<Map<AccAxis, double>> get data => _dataController.stream;

  final _dataEventController = StreamController<DataEvent>();
  Sink<DataEvent> get dataEventSink =>
      _dataEventController.sink;

  DataBlock() {
    _dataEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(DataEvent event) {
    if (event is GetDataStream) {
      if(_wobblyDataSubscription == null) {
        _bleUtils.getWobblyData().then((s) {
          _wobblyDataSubscription = s;
          _wobblyDataSubscription.onData((s) {
            _inData.add(s);
          });
        });

      }
    } else if (event is DropDataStream) {
//      _wobblyDataSubscription.pause();
//      _wobblyDataSubscription?.cancel();
//      _wobblyDataSubscription = null;
    }
  }

  void dispose() {
    _dataController.close();
//    _dataEventController.close();
    _wobblyDataSubscription?.cancel();
    _wobblyDataSubscription = null;
  }
}

abstract class DataEvent {}

class GetDataStream extends DataEvent {}

class DropDataStream extends DataEvent {}
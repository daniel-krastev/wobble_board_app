import 'package:wobble_board/bloc/connection.dart';
import 'package:wobble_board/bloc/data.dart';

class AppBloc {
  ConnectionBlock _connection;
  DataBlock _data;

  AppBloc() {
    _connection = ConnectionBlock();
    _data = DataBlock();
  }

  ConnectionBlock get connectionBloc => _connection;
  DataBlock get dataBloc => _data;
}

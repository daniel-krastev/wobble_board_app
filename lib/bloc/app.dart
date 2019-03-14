import 'package:wobble_board/bloc/connection.dart';
import 'package:wobble_board/bloc/data.dart';
import 'package:wobble_board/bloc/go_page_bloc.dart';

class AppBloc {
  ConnectionBlock _connection;
  DataBlock _data;
  GoPageBloc _goPage;

  AppBloc() {
    _connection = ConnectionBlock();
    _data = DataBlock();
    _goPage = GoPageBloc();
  }

  ConnectionBlock get connectionBloc => _connection;
  DataBlock get dataBloc => _data;
  GoPageBloc get goPageBloc => _goPage;
}

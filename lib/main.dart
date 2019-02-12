import 'package:flutter/material.dart';
import 'package:wobble_board/bloc/app.dart';
import 'package:wobble_board/bloc/bloc_provider.dart';
import 'package:wobble_board/ui/home.dart';
import 'package:wobble_board/ui/exercise.dart';

main() {
  final appBloc = AppBloc();
  runApp(BlocProvider(
      bloc: appBloc, child: MaterialApp(title: "Wobble board", home: Home())));
}


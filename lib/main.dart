import 'package:flutter/material.dart';
import 'package:wobble_board/bloc/app.dart';
import 'package:wobble_board/bloc/bloc_provider.dart';
import 'package:wobble_board/ui/pages/home_page.dart';

main() {
  final appBloc = AppBloc();
  runApp(BlocProvider(
      bloc: appBloc,
      child: MaterialApp(
          theme: ThemeData.dark(), title: "RehApp", home: Home())));
}

import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'package:wobble_board/bloc/app.dart';
import 'package:wobble_board/bloc/bloc_provider.dart';
import 'package:wobble_board/ui/pages/home_page.dart';

main() {
  Screen.keepOn(true);
  final appBloc = AppBloc();
  runApp(BlocProvider(
      bloc: appBloc,
      child: MaterialApp(
          theme: ThemeData.light(), title: "RehApp", home: Home())));
}

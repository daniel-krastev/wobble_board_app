import 'package:flutter/material.dart';
import 'package:wobble_board/bloc/app.dart';
import 'package:wobble_board/bloc/bloc_provider.dart';
import 'package:wobble_board/ui/pages/exercise_page.dart';
import 'package:wobble_board/ui/pages/settings_page.dart';
import 'package:wobble_board/ui/pages/about_page.dart';
import 'package:wobble_board/ui/pages/home_page.dart';
import 'package:wobble_board/ui/widgets/exercise.dart';

const Color _backgroundColor = Color.fromARGB(255, 245, 245, 245);
const Color _lightTextColor = Color.fromARGB(255, 153, 157, 160);
const Color _darkTextColor = Color.fromARGB(255, 99, 101, 105);
const Color _primaryColor = Color.fromARGB(255, 181, 211, 243);


main() {
  final appBloc = AppBloc();
  runApp(BlocProvider(
      bloc: appBloc,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
        backgroundColor: _backgroundColor,
        primaryColor: _primaryColor,
        primaryColorLight: _lightTextColor,
        primaryColorDark: _darkTextColor,
        iconTheme: IconThemeData(
          color: _lightTextColor,
            size: 35.0
        ),
        fontFamily: "Roboto",
            primaryTextTheme: TextTheme(
              title: TextStyle(
                color: _primaryColor,
                fontSize: 25.0,
              ),
              body1: TextStyle(
                color: _lightTextColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w700
              ),
              body2: TextStyle(
                  color: _darkTextColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500
              ),
            )
      ), title: "RehApp",
          routes: <String, WidgetBuilder>{
            '/about': (_) => About(),
            '/settings': (_) => Settings(),
            '/exercise': (_) => ExercisePage(),
          },home: Home())));
}

import 'package:flutter/material.dart';

/// Custom router builder.
///
/// Used to define a new transition between pages.
class CustomPageRoute extends PageRouteBuilder {
  CustomPageRoute(final Widget widget, final bool isRightToLeft)
      : super(
      opaque: true,
      pageBuilder: getBuilder(widget),
      transitionDuration: const Duration(
          milliseconds: 300),
      transitionsBuilder: getTransition(isRightToLeft));

  static RouteTransitionsBuilder getTransition(final bool isRightToLeft) {
    return (_, Animation<double> animation, __, Widget child) {
      return SlideTransition(
        position: Tween(
          begin: Offset(isRightToLeft ? 1.0 : -1.0, 0.0),
          end: Offset(0.0, 0.0),
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      );
    };
  }

  static RoutePageBuilder getBuilder(final Widget widget) {
    return (BuildContext context, _, __) {
      return widget;
    };
  }
}
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penjualan/screen/login/login_controller.dart';
import 'package:penjualan/routing/router_const.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return routeTransition(screen: Login());
      default:
        return routeTransition(
          screen: Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

Route<T> routeTransition<T>({
  required Widget screen,
  bool animation = true,
}) {
  if (!animation) {
    return PageRouteBuilder(
      opaque: false,
      transitionDuration: Duration(milliseconds: 0),
      reverseTransitionDuration: Duration(milliseconds: 0),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
    );
  } else {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: (_) => screen);
    } else {
      return MaterialPageRoute(builder: (_) => screen);
    }
  }
}

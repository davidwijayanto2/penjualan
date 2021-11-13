import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penjualan/screen/home/home_controller.dart';
import 'package:penjualan/screen/login/login_controller.dart';
import 'package:penjualan/routing/router_const.dart';
import 'package:penjualan/screen/master/barang/form/add_master_barang_controller.dart';
import 'package:penjualan/screen/master/barang/master_barang_controller.dart';
import 'package:penjualan/screen/master/customer/form/add_master_customer_controller.dart';
import 'package:penjualan/screen/master/customer/master_customer_controller.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return routeTransition(screen: Login());
      case homeRoute:
        return routeTransition(screen: Home());
      case masterBarangRoute:
        return routeTransition(screen: MasterBarang());
      case addMasterBarangRoute:
        var args = settings.arguments as AddMasterBarang;
        return routeTransition(screen: args);
      case masterCustomerRoute:
        return routeTransition(screen: MasterCustomer());
      case addMasterCustomerRoute:
        var args = settings.arguments as AddMasterCustomer;
        return routeTransition(screen: args);
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
  } else if (Platform.isIOS) {
    return CupertinoPageRoute(builder: (_) => screen);
  } else {
    return PageRouteBuilder(
      opaque: false,
      transitionDuration: Duration(milliseconds: 300),
      reverseTransitionDuration: Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
        ),
        child: child,
      ),
    );
  }
}

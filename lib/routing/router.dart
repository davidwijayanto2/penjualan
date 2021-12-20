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
import 'package:penjualan/screen/master/kategori/form/add_master_kategori_controller.dart';
import 'package:penjualan/screen/master/kategori/master_kategori_controller.dart';
import 'package:penjualan/screen/master/satuan/master_satuan_controller.dart';
import 'package:penjualan/screen/master/satuan/form/add_master_satuan_controller.dart';
import 'package:penjualan/screen/transaksi/penjualan/form/add_penjualan_controller.dart';
import 'package:penjualan/screen/transaksi/penjualan/form/detail_jual/detail_jual_controller.dart';
import 'package:penjualan/screen/transaksi/penjualan/penjualan_controller.dart';
import 'package:penjualan/screen/transaksi/pembelian/pembelian_controller.dart';
import 'package:penjualan/screen/transaksi/pembelian/form/add_pembelian_controller.dart';

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
      case masterKategoriRoute:
        return routeTransition(screen: MasterKategori());
      case addMasterKategoriRoute:
        var args = settings.arguments as AddMasterKategori;
        return routeTransition(screen: args);
      case masterSatuanRoute:
        return routeTransition(screen: MasterSatuan());
      case addMasterSatuanRoute:
        var args = settings.arguments as AddMasterSatuan;
        return routeTransition(screen: args);
      case penjualanRoute:
        return routeTransition(screen: TransaksiPenjualan());
      case addPenjualanRoute:
        var args = settings.arguments as AddPenjualan;
        return routeTransition(screen: args);
      case detailJualRoute:
        var args = settings.arguments as DetailJual;
        return routeTransition(screen: args);
      case pembelianRoute:
        return routeTransition(screen: TransaksiPembelian());
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

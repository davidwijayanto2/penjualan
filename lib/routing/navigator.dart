import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/kategori.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/routing/router_const.dart';
import 'package:penjualan/screen/master/barang/form/add_master_barang_controller.dart';
import 'package:penjualan/screen/master/customer/form/add_master_customer_controller.dart';
import 'package:penjualan/screen/master/kategori/form/add_master_kategori_controller.dart';

goToHome(BuildContext context) async {
  Navigator.pushNamed(context, homeRoute);
}

replaceToHome(BuildContext context) async {
  Navigator.pushNamedAndRemoveUntil(context, homeRoute, (route) => false);
}

goToLogin(BuildContext context) async {
  Navigator.pushNamed(context, loginRoute);
}

replaceToLogin(BuildContext context) {
  Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
}

goToMasterBarang<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, masterBarangRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, masterBarangRoute);
  }
}

goToAddMasterBarang<R>({
  required BuildContext context,
  Stok? editStok,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, addMasterBarangRoute,
        arguments: AddMasterBarang(
          editStok: editStok,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, addMasterBarangRoute,
        arguments: AddMasterBarang(
          editStok: editStok,
        ));
  }
}

goToMasterCustomer<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, masterCustomerRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, masterCustomerRoute);
  }
}

goToAddMasterCustomer<R>({
  required BuildContext context,
  Customer? editCustomer,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, addMasterCustomerRoute,
        arguments: AddMasterCustomer(
          editCustomer: editCustomer,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, addMasterCustomerRoute,
        arguments: AddMasterCustomer(
          editCustomer: editCustomer,
        ));
  }
}

goToMasterKategori<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, masterKategoriRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, masterKategoriRoute);
  }
}

goToAddMasterKategori<R>({
  required BuildContext context,
  Kategori? editKategori,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, addMasterKategoriRoute,
        arguments: AddMasterKategori(
          editKategori: editKategori,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, addMasterKategoriRoute,
        arguments: AddMasterKategori(
          editKategori: editKategori,
        ));
  }
}

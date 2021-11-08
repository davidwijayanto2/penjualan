import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:penjualan/routing/router_const.dart';

goToHome(BuildContext context) async {
  Navigator.pushNamed(context, homeRoute);
}

goToLogin(BuildContext context) async {
  Navigator.pushNamed(context, loginRoute);
}

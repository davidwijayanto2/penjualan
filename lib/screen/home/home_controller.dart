import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penjualan/model/user.dart';
import 'package:penjualan/repositories/local_storage.dart';
import 'package:penjualan/routing/navigator.dart';

import 'home_view.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeView();
}

abstract class HomeController extends State<Home> {
  User? user;
  @override
  initState() {
    initForm();
    super.initState();
  }

  initForm() {
    setState(() {
      user = LocalStorage.userLogin();
    });
  }

  logoutDialog() {}

  logout() {
    LocalStorage().setIsLogin(false);
    LocalStorage().setUser(null);
    replaceToLogin(context);
  }
}

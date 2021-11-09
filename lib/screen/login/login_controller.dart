import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/screen/login/login_view.dart';
import 'package:sqflite/sqflite.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginView();
}

abstract class LoginController extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  initState() {
    super.initState();
  }

  loginCheck() async {
    Database? db = await DatabaseHelper.instance.database;
    print(passwordController.text.trim());
    print(utf8.encode(passwordController.text.trim()));
    print(md5.convert(utf8.encode(passwordController.text.trim())).toString());
    var result = await db?.rawQuery(
        "SELECT * FROM karyawan WHERE username = ? AND password = ?", [
      usernameController.text.trim(),
      md5.convert(utf8.encode(passwordController.text.trim()))
    ]);
    return result;
  }
}

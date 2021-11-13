import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/repositories/local_storage.dart';
import 'package:penjualan/routing/navigator.dart';
import 'package:penjualan/screen/login/login_view.dart';
import 'package:sqflite/sqflite.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginView();
}

abstract class LoginController extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormBuilderState>();

  @override
  initState() {
    super.initState();
  }

  loginCheck() async {
    formKey.currentState!.save();
    if (formKey.currentState!.validate()) {
      Database? db = await DatabaseHelper.instance.database;

      var result = await db?.rawQuery(
          "SELECT * FROM karyawan WHERE username = ? AND password = ?", [
        usernameController.text.trim(),
        md5
            .convert(utf8.encode(passwordController.text.trim() + "artindo"))
            .toString()
      ]);
      if ((result?.length ?? 0) > 0) {
        LocalStorage().setUser(result?[0]);
        LocalStorage().setIsLogin(true);

        Fluttertoast.showToast(msg: "Welcome, ${result?[0]['USERNAME'] ?? ''}");
        replaceToHome(context);
      } else {
        Fluttertoast.showToast(msg: "Login Failed! Wrong username / password");
      }
    }
  }
}

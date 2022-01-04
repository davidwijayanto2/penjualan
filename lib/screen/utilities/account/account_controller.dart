import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/repositories/local_storage.dart';
import 'package:penjualan/routing/navigator.dart';
import 'package:penjualan/screen/utilities/account/account_view.dart';
import 'package:sqflite/sqflite.dart';

class Account extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountView();
}

abstract class AccountController extends State<Account> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormBuilderState>();

  @override
  initState() {
    super.initState();
  }

  changeUsernamePass() async {
    formKey.currentState!.save();
    if (formKey.currentState!.validate()) {
      Database? db = await DatabaseHelper.instance.database;
      var user = LocalStorage.userLogin();
      await db?.rawUpdate(
          'UPDATE KARYAWAN set USERNAME = ?, PASSWORD = ? WHERE USERNAME = ?', [
        usernameController.text.trim(),
        md5
            .convert(utf8.encode(passwordController.text.trim() + "artindo"))
            .toString(),
        user?.username ?? ''
      ]).then((value) {
        logout();
      }).catchError((onError) {
        Fluttertoast.showToast(msg: 'Error gagal ubah data');
      });
    }
  }

  logout() {
    LocalStorage().setIsLogin(false);
    LocalStorage().setUser(null);
    replaceToLogin(context);
  }
}

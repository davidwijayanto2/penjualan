import 'package:flutter/material.dart';
import 'package:penjualan/screen/login/login_view.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginView();
}

abstract class LoginController extends State<Login> {}

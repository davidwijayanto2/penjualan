import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penjualan/screen/login/login_controller.dart';
import 'package:penjualan/utils/my_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white, // Color for Android
      statusBarBrightness:
          Brightness.dark, // Dark == white status bar -- for IOS.
    ));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: MyColors.dementialGray,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: MyColors.themeColor1,
        ),
        appBarTheme: AppBarTheme.of(context).copyWith(
          backgroundColor: MyColors.white,
        ),
      ),
      home: Login(),
    );
  }
}

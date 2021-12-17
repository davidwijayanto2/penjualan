import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penjualan/repositories/local_storage.dart';
import 'package:penjualan/routing/router.dart';
import 'package:penjualan/screen/home/home_controller.dart';
import 'package:penjualan/screen/login/login_controller.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, // Color for Android
      statusBarBrightness:
          Brightness.dark, // Dark == white status bar -- for IOS.
    ));
    bool isLogin = LocalStorage.isLogin() ?? false;
    Widget? initPage;
    if (isLogin) {
      initPage = Home();
    } else {
      initPage = Login();
    }
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('id', ''),
      ],
      onGenerateRoute: MyRouter.generateRoute,
      home: initPage,
    );
  }
}

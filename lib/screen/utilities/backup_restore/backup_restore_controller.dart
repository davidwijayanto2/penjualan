import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';
import 'backup_restore_view.dart';

class BackupRestore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BackupRestoreView();
}

abstract class BackupRestoreController extends State<BackupRestore> {
  static const platform = const MethodChannel('database');
  backupDatabase(BuildContext context) async {
    if (await Permission.storage.request().isGranted) {
      final loading = loadingDialog(context);
      if (Platform.isIOS) {
        try {
          var path;
          path = (await getApplicationDocumentsDirectory()).path;
          String dbpath = join(path, "db_ko_stefan");
          await File(dbpath).copy(join(path, "backup_db_ko_stefan"));
          await Future.delayed(Duration(seconds: 1), () {
            loading.dismiss();
          });
          Fluttertoast.showToast(msg: "Database berhasil direstore");
        } catch (e) {
          await Future.delayed(Duration(seconds: 1), () {
            loading.dismiss();
          });
          Fluttertoast.showToast(msg: "Database gagal direstore: $e");
        }
      } else if (Platform.isAndroid) {
        try {
          var message = await platform.invokeMethod('backupdatabase');
          await Future.delayed(Duration(seconds: 1), () {
            loading.dismiss();
          });
          Fluttertoast.showToast(msg: message);
        } on PlatformException catch (e) {
          await Future.delayed(Duration(seconds: 1), () {
            loading.dismiss();
          });
          print("Failed to backup: '${e.message}'.");
        }
      }
    }
  }

  restoreDatabase(BuildContext context) async {
    if (await Permission.storage.request().isGranted) {
      final loading = loadingDialog(context);
      if (Platform.isIOS) {
        try {
          var path;
          path = (await getApplicationDocumentsDirectory()).path;
          String dbpath = join(path, "backup_db_ko_stefan");
          await File(dbpath).copy(join(path, "db_ko_stefan"));
          await Future.delayed(Duration(seconds: 1), () {
            loading.dismiss();
          });
          Fluttertoast.showToast(msg: "Database berhasil direstore");
        } catch (e) {
          await Future.delayed(Duration(seconds: 1), () {
            loading.dismiss();
          });
          Fluttertoast.showToast(msg: "Database gagal direstore: $e");
        }
      } else if (Platform.isAndroid) {
        try {
          var message = await platform.invokeMethod('restoredatabase');
          await Future.delayed(Duration(seconds: 1), () {
            loading.dismiss();
          });
          Fluttertoast.showToast(msg: message);
        } on PlatformException catch (e) {
          await Future.delayed(Duration(seconds: 1), () {
            loading.dismiss();
          });
          print("Failed to restore: '${e.message}'.");
        }
      }
    }
  }
}

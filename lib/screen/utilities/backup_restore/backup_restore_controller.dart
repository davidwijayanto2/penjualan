import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import 'backup_restore_view.dart';

class BackupRestore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BackupRestoreView();
}

abstract class BackupRestoreController extends State<BackupRestore> {
  static const platform = const MethodChannel('database');
  backupDatabase() async {
    if (await Permission.storage.request().isGranted) {
      try {
        final loading = loadingDialog(context);
        var message = await platform.invokeMethod('backupdatabase');
        loading.dismiss();
        Fluttertoast.showToast(msg: message);
      } on PlatformException catch (e) {
        print("Failed to backup: '${e.message}'.");
      }
    }
  }

  restoreDatabase() async {
    if (await Permission.storage.request().isGranted) {
      try {
        final loading = loadingDialog(context);
        var message = await platform.invokeMethod('restoredatabase');
        loading.dismiss();
        Fluttertoast.showToast(msg: message);
      } on PlatformException catch (e) {
        print("Failed to restore: '${e.message}'.");
      }
    }
  }
}

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
      final loading = loadingDialog(context);
      try {
        var message = await platform.invokeMethod('backupdatabase');

        Fluttertoast.showToast(msg: message);
      } on PlatformException catch (e) {
        loading.dismiss();
        print("Failed to backup: '${e.message}'.");
      } finally {
        loading.dismiss();
      }
    }
  }

  restoreDatabase() async {
    if (await Permission.storage.request().isGranted) {
      final loading = loadingDialog(context);
      try {
        var message = await platform.invokeMethod('restoredatabase');
        Fluttertoast.showToast(msg: message);
      } on PlatformException catch (e) {
        loading.dismiss();
        print("Failed to restore: '${e.message}'.");
      } finally {
        loading.dismiss();
      }
    }
  }
}

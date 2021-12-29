import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:penjualan/utils/custom_datetime_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'backup_restore_sebagian_view.dart';

class BackupRestoreSebagian extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BackupRestoreSebagianView();
}

abstract class BackupRestoreSebagianController
    extends State<BackupRestoreSebagian> {
  String? filterStartDate;
  String? filterEndDate;
  String? filterPeriode;

  @override
  void initState() {
    initDate();
    setScheduleDateText();
  }

  initDate() {
    filterStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    filterEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void setScheduleDateText() {
    initializeDateFormatting('id', null);
    var startDate = DateTime.parse(filterStartDate!);
    var endDate = DateTime.parse(filterEndDate!);
    filterPeriode = DateFormat('dd ').format(startDate) +
        DateFormat.MMM('id').format(startDate) +
        DateFormat(' yyyy').format(startDate) +
        ' - ' +
        DateFormat('dd ').format(endDate) +
        DateFormat.MMM('id').format(endDate) +
        DateFormat(' yyyy').format(endDate);
  }

  Future<void> onPressDate() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    var picked = await CustomDateRangePicker.show(
        context: context,
        initialFirstdate: DateTime.parse(filterStartDate!),
        initialLastDate: DateTime.parse(filterEndDate!),
        firstDate:
            DateTime.parse(DateFormat('2010-01-01').format(DateTime.now())),
        lastDate: DateTime.parse("2100-01-01"));
    if (picked != null) {
      var formattedPicked1 = DateFormat('yyyy-MM-dd').format(picked[0]);
      var formattedPicked2 = picked.length < 2
          ? DateFormat('yyyy-MM-dd').format(picked[0])
          : DateFormat('yyyy-MM-dd').format(picked[1]);
      if (formattedPicked1 != filterStartDate ||
          formattedPicked2 != filterEndDate)
        setState(() {
          filterStartDate = DateFormat('yyyy-MM-dd').format(picked[0]);
          if (picked.length < 2)
            filterEndDate = DateFormat('yyyy-MM-dd').format(picked[0]);
          else
            filterEndDate = DateFormat('yyyy-MM-dd').format(picked[1]);
          setScheduleDateText();
        });
    } else {
      setState(() {
        filterStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        filterEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        setScheduleDateText();
      });
    }
  }

  restoreDatabase() async {
    if (await Permission.storage.request().isGranted) {
      final path = await ExternalPath.getExternalStorageDirectories();

      final File file = File('${path[0]}/backup_penjualan.txt');
      final line = await file.readAsLines();
      final string = await file.readAsString();
      print(line);
      print(string);
    }
  }
}

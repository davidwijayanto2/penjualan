import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/custom_datetime_picker.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqflite/sqflite.dart';
import 'backup_restore_sebagian_view.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

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

  backupDatabasePembelian() async {
    if (await Permission.storage.request().isGranted) {
      final loading = loadingDialog(context);
      Database? db = await DatabaseHelper.instance.database;
      var result = await db?.rawQuery(
          "SELECT * FROM h_beli WHERE date(TANGGAL_BELI) BETWEEN ? AND ?", [
        "$filterStartDate",
        "$filterEndDate",
      ]);
      if (result != null && result.isNotEmpty) {
        final path = Platform.isAndroid
            ? (await ExternalPath.getExternalStorageDirectories()).first
            : (await getApplicationDocumentsDirectory()).path;
        final File fileHeader = File(
            "$path/Backup_Header_Pembelian_${DateFormatter.toNumberDateText(context, DateTime.parse(filterStartDate!))}_sampai_${DateFormatter.toNumberDateText(context, DateTime.parse(filterEndDate!))}.txt");
        final File fileDetail = File(
            "$path/Backup_Detail_Pembelian_${DateFormatter.toNumberDateText(context, DateTime.parse(filterStartDate!))}_sampai_${DateFormatter.toNumberDateText(context, DateTime.parse(filterEndDate!))}.txt");
        String queryHeader = '';
        String queryDetail = '';
        for (int i = 0; i < result.length; i++) {
          var mapValue = result[i].entries.map((e) => e.value).toList();
          var resultDetail = await db?.rawQuery(
              "SELECT * FROM d_beli WHERE ID_HBELI = ?", ["${mapValue[0]}"]);
          if (resultDetail != null && resultDetail.isNotEmpty) {
            for (int a = 0; a < resultDetail.length; a++) {
              var mapValueDetail =
                  resultDetail[a].entries.map((e) => e.value).toList();
              for (int b = 0; b < mapValueDetail.length; b++) {
                queryDetail = queryDetail + mapValueDetail[b].toString() + '|';
              }
              queryDetail = queryDetail + '\n';
            }
          }
          for (int j = 0; j < mapValue.length; j++) {
            queryHeader = queryHeader + mapValue[j].toString() + '|';
          }
          queryHeader = queryHeader + '\n';
        }
        await fileHeader.writeAsString(queryHeader);
        await fileDetail.writeAsString(queryDetail);
        Fluttertoast.showToast(msg: 'Data berhasil dibackup');
      } else {
        Fluttertoast.showToast(msg: 'Tidak ada data yang dibackup');
      }
      await Future.delayed(Duration(seconds: 1), () {
        loading.dismiss();
      });
    }
  }

  backupDatabasePenjualan() async {
    if (await Permission.storage.request().isGranted) {
      final loading = loadingDialog(context);
      Database? db = await DatabaseHelper.instance.database;
      var result = await db?.rawQuery(
          "SELECT * FROM h_jual WHERE date(TGL_TRANSAKSI) BETWEEN ? AND ?", [
        "$filterStartDate",
        "$filterEndDate",
      ]);
      if (result != null && result.isNotEmpty) {
        final path = Platform.isAndroid
            ? (await ExternalPath.getExternalStorageDirectories()).first
            : (await getApplicationDocumentsDirectory()).path;
        final File fileHeader = File(
            "$path/Backup_Header_Penjualan_${DateFormatter.toNumberDateText(context, DateTime.parse(filterStartDate!))}_sampai_${DateFormatter.toNumberDateText(context, DateTime.parse(filterEndDate!))}.txt");
        final File fileDetail = File(
            "$path/Backup_Detail_Penjualan_${DateFormatter.toNumberDateText(context, DateTime.parse(filterStartDate!))}_sampai_${DateFormatter.toNumberDateText(context, DateTime.parse(filterEndDate!))}.txt");
        String queryHeader = '';
        String queryDetail = '';
        for (int i = 0; i < result.length; i++) {
          var mapValue = result[i].entries.map((e) => e.value).toList();
          var resultDetail = await db?.rawQuery(
              "SELECT * FROM d_jual WHERE ID_HJUAL = ?", ["${mapValue[0]}"]);
          if (resultDetail != null && resultDetail.isNotEmpty) {
            for (int a = 0; a < resultDetail.length; a++) {
              var mapValueDetail =
                  resultDetail[a].entries.map((e) => e.value).toList();
              for (int b = 0; b < mapValueDetail.length; b++) {
                queryDetail = queryDetail + mapValueDetail[b].toString() + '|';
              }
              queryDetail = queryDetail + '\n';
            }
          }
          for (int j = 0; j < mapValue.length; j++) {
            queryHeader = queryHeader + mapValue[j].toString() + '|';
          }
          queryHeader = queryHeader + '\n';
        }
        await fileHeader.writeAsString(queryHeader);
        await fileDetail.writeAsString(queryDetail);
        Fluttertoast.showToast(msg: 'Data berhasil dibackup');
      } else {
        Fluttertoast.showToast(msg: 'Tidak ada data yang dibackup');
      }
      await Future.delayed(Duration(seconds: 1), () {
        loading.dismiss();
      });
    }
  }

  restoreDatabasePenjualan() async {
    if (await Permission.storage.request().isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        if ((result.files.single.path ?? '').contains('.txt')) {
          final loading = loadingDialog(context);
          File file = File(result.files.single.path ?? '');

          final line = await file.readAsLines();
          bool onError = false;
          Database? db = await DatabaseHelper.instance.database;
          Batch batch = db!.batch();
          if ((result.files.single.path ?? '')
                  .toLowerCase()
                  .contains('header') &&
              (result.files.single.path ?? '')
                  .toLowerCase()
                  .contains('penjualan')) {
            for (int i = 0; i < line.length; i++) {
              final list = line[i].split('|');

              var result = await db.rawQuery(
                  "SELECT * FROM h_jual WHERE ID_HJUAL = ?", [list[0]]);
              if (result.isEmpty) {
                batch.rawInsert(
                    'INSERT INTO h_jual VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)', [
                  list[0],
                  list[1],
                  list[2],
                  list[3],
                  list[4],
                  list[5],
                  list[6],
                  list[7],
                  list[8],
                  list[9],
                  list[10],
                  list[11],
                  list[12],
                ]);
              } else {
                Fluttertoast.showToast(
                    msg: 'Restore error, ID ${list[0]} sudah ada.');
                onError = true;
                break;
              }
            }
            if (!onError) {
              batch.commit();
              Fluttertoast.showToast(msg: 'Data berhasil direstore');
            }
          } else if ((result.files.single.path ?? '')
                  .toLowerCase()
                  .contains('detail') &&
              (result.files.single.path ?? '')
                  .toLowerCase()
                  .contains('penjualan')) {
            for (int i = 0; i < line.length; i++) {
              final list = line[i].split('|');

              batch.rawInsert(
                  'INSERT INTO d_jual(ID_HJUAL, NM_BARANG, SATUAN, QUANTITY, HARGA_BARANG, SUBTOTAL) VALUES(?,?,?,?,?,?)',
                  [
                    list[1],
                    list[2],
                    list[3],
                    list[4],
                    list[5],
                    list[6],
                  ]);
            }
            if (!onError) {
              batch.commit();
              Fluttertoast.showToast(msg: 'Data berhasil direstore');
            }
          } else {
            Fluttertoast.showToast(msg: 'File backup salah');
          }
          await Future.delayed(Duration(seconds: 1), () {
            loading.dismiss();
          });
        } else {
          Fluttertoast.showToast(msg: 'Format salah');
        }
      } else {
        // User canceled the picker
      }
    }
  }

  restoreDatabasePembelian() async {
    if (await Permission.storage.request().isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        if ((result.files.single.path ?? '').contains('.txt')) {
          final loading = loadingDialog(context);
          File file = File(result.files.single.path ?? '');

          final line = await file.readAsLines();
          // print(line);
          bool onError = false;
          Database? db = await DatabaseHelper.instance.database;
          Batch batch = db!.batch();
          if ((result.files.single.path ?? '')
                  .toLowerCase()
                  .contains('header') &&
              (result.files.single.path ?? '')
                  .toLowerCase()
                  .contains('pembelian')) {
            for (int i = 0; i < line.length; i++) {
              final list = line[i].split('|');

              var result = await db.rawQuery(
                  "SELECT * FROM h_beli WHERE ID_HBELI = ?", [list[0]]);
              if (result.isEmpty) {
                batch.rawInsert('INSERT INTO h_beli VALUES(?,?,?,?,?,?,?,?)', [
                  list[0],
                  list[1],
                  list[2],
                  list[3],
                  list[4],
                  list[5],
                  list[6],
                  list[7],
                ]);
              } else {
                Fluttertoast.showToast(
                    msg: 'Restore error, ID ${list[0]} sudah ada.');
                onError = true;
                break;
              }
            }
            if (!onError) {
              batch.commit();
              Fluttertoast.showToast(msg: 'Data berhasil direstore');
            }
          } else if ((result.files.single.path ?? '')
                  .toLowerCase()
                  .contains('detail') &&
              (result.files.single.path ?? '')
                  .toLowerCase()
                  .contains('pembelian')) {
            for (int i = 0; i < line.length; i++) {
              final list = line[i].split('|');

              batch.rawInsert(
                  'INSERT INTO d_beli(ID_HBELI, NM_BARANG, SATUAN, QUANTITY, HARGA_BARANG, SUBTOTAL) VALUES(?,?,?,?,?,?)',
                  [
                    list[1],
                    list[2],
                    list[3],
                    list[4],
                    list[5],
                    list[6],
                  ]);
            }
            if (!onError) {
              batch.commit();
              Fluttertoast.showToast(msg: 'Data berhasil direstore');
            }
          } else {
            Fluttertoast.showToast(msg: 'File backup salah');
          }
          await Future.delayed(Duration(seconds: 1), () {
            loading.dismiss();
          });
        } else {
          Fluttertoast.showToast(msg: 'Format salah');
        }
      } else {
        // User canceled the picker
      }
    }
  }

  restoreDatabaseMaster() async {
    if (await Permission.storage.request().isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        if ((result.files.single.path ?? '').contains('.txt')) {
          final loading = loadingDialog(context);
          File file = File(result.files.single.path ?? '');

          final line = await file.readAsLines();
          print(line);
          bool onError = false;
          Database? db = await DatabaseHelper.instance.database;
          Batch batch = db!.batch();
          if ((result.files.single.path ?? '')
              .toLowerCase()
              .contains('customer')) {
            for (int i = 0; i < line.length; i++) {
              final list = line[i].split('|');

              var result = await db.rawQuery(
                  "SELECT * FROM customer WHERE ID_CUSTOMER = ?", [list[0]]);
              if (result.isEmpty) {
                batch.rawInsert('INSERT INTO customer VALUES(?,?,?,?,?,?,?)', [
                  list[0],
                  list[1],
                  list[2],
                  list[3],
                  list[4],
                  list[5],
                  list[6],
                ]);
              } else {
                Fluttertoast.showToast(
                    msg: 'Restore error, ID ${list[0]} sudah ada.');
                onError = true;
                break;
              }
            }
            if (!onError) {
              batch.commit();
              Fluttertoast.showToast(msg: 'Data berhasil direstore');
            }
          } else if ((result.files.single.path ?? '')
              .toLowerCase()
              .contains('stok')) {
            for (int i = 0; i < line.length; i++) {
              final list = line[i].split('|');

              var result = await db
                  .rawQuery("SELECT * FROM stok WHERE ID_STOK = ?", [list[0]]);
              if (result.isEmpty) {
                batch.rawInsert('INSERT INTO stok VALUES(?,?,?,?,?,?)', [
                  list[0],
                  list[1],
                  list[2],
                  list[3],
                  list[4],
                  list[5],
                ]);
              } else {
                Fluttertoast.showToast(
                    msg: 'Restore error, ID ${list[0]} sudah ada.');
                onError = true;
                break;
              }
            }
            if (!onError) {
              batch.commit();
              Fluttertoast.showToast(msg: 'Data berhasil direstore');
            }
          } else if ((result.files.single.path ?? '')
              .toLowerCase()
              .contains('satuan')) {
            for (int i = 0; i < line.length; i++) {
              final list = line[i].split('|');

              var result = await db
                  .rawQuery("SELECT * FROM satuan WHERE ID = ?", [list[0]]);
              if (result.isEmpty) {
                batch.rawInsert('INSERT INTO satuan VALUES(?,?)', [
                  list[0],
                  list[1],
                ]);
              } else {
                Fluttertoast.showToast(
                    msg: 'Restore error, ID ${list[0]} sudah ada.');
                onError = true;
                break;
              }
            }
            if (!onError) {
              batch.commit();
              Fluttertoast.showToast(msg: 'Data berhasil direstore');
            }
          } else if ((result.files.single.path ?? '')
              .toLowerCase()
              .contains('karyawan')) {
            for (int i = 0; i < line.length; i++) {
              final list = line[i].split('|');

              var result = await db.rawQuery(
                  "SELECT * FROM karyawan WHERE ID_KARYAWAN = ?", [list[0]]);
              if (result.isEmpty) {
                batch.rawInsert(
                    'INSERT INTO karyawan VALUES(?,?,?,?,?,?,?,?,?)', [
                  list[0],
                  list[1],
                  list[2],
                  list[3],
                  list[4],
                  list[5],
                  list[6],
                  list[7],
                  list[8],
                ]);
              } else {
                Fluttertoast.showToast(
                    msg: 'Restore error, ID ${list[0]} sudah ada.');
                onError = true;
                break;
              }
            }
            if (!onError) {
              batch.commit();
              Fluttertoast.showToast(msg: 'Data berhasil direstore');
            }
          } else {
            Fluttertoast.showToast(msg: 'File backup salah');
          }
          await Future.delayed(Duration(seconds: 1), () {
            loading.dismiss();
          });
        } else {
          Fluttertoast.showToast(msg: 'Format salah');
        }
      } else {
        // User canceled the picker
      }
    }
  }

  showDialogDelete(_param) {
    if (_param == "beli") {
      PopupDialog(
        context: context,
        titleText: 'Hapus Data Pembelian sebagian',
        subtitleText:
            'Apakah Anda yakin akan menghapus data ? Lakukan Backup data dahulu ',
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.red,
        rightButtonAction: (_) async {
          Navigator.pop(context);
          deletePembelian(filterStartDate, filterEndDate);
        },
        rightButtonColor: Colors.red,
      );
    } else {
      PopupDialog(
        context: context,
        titleText: 'Hapus Data Penjualan sebagian',
        subtitleText:
            'Apakah Anda yakin akan menghapus data ? Lakukan Backup data dahulu ',
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.red,
        rightButtonAction: (_) async {
          Navigator.pop(context);
          deletePenjualan(filterStartDate, filterEndDate);
        },
        rightButtonColor: Colors.red,
      );
    }
  }

  deletePembelian(startdate, enddate) async {
    Database? db = await DatabaseHelper.instance.database;

    await db?.rawDelete(
        "DELETE FROM d_beli WHERE ID_HBELI IN ( SELECT ID_HBELI FROM h_beli where strftime('%Y-%m-%d',TANGGAL_BELI) BETWEEN  ? AND ?)",
        [
          "$startdate",
          "$enddate",
        ]);
    await db?.rawDelete(
        "DELETE FROM h_beli WHERE strftime('%Y-%m-%d',TANGGAL_BELI) BETWEEN  ? AND ?",
        [
          "$startdate",
          "$enddate",
        ]);
    Fluttertoast.showToast(msg: 'Data berhasil dihapus');
  }

  deletePenjualan(startdate, enddate) async {
    Database? db = await DatabaseHelper.instance.database;

    await db?.rawDelete(
        "DELETE FROM d_jual WHERE ID_HJUAL IN ( SELECT ID_HJUAL FROM h_jual where strftime('%Y-%m-%d',TGL_TRANSAKSI) BETWEEN  ? AND ?)",
        [
          "$startdate",
          "$enddate",
        ]);
    await db?.rawDelete(
        "DELETE FROM h_jual WHERE strftime('%Y-%m-%d',TGL_TRANSAKSI) BETWEEN  ? AND ?",
        [
          "$startdate",
          "$enddate",
        ]);
    Fluttertoast.showToast(msg: 'Data berhasil dihapus');
  }
}

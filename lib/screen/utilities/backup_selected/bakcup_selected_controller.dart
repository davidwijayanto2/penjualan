import 'dart:io';

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:penjualan/model/pembelian.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/model/stok_keluar.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/screen/laporan/penjualan/laporan_penjualan_view.dart';
import 'package:penjualan/screen/laporan/stok_keluar/laporan_stok_keluar_view.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/custom_datetime_picker.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import 'backup_selected_view.dart';

class BackupSelected extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BackupSelectedView();
}

abstract class BackupSelectedController extends State<BackupSelected> {
  final debouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');
  final TextEditingController searchController = TextEditingController();
  String? filterStartDate;
  String? filterEndDate;
  String? filterPeriode;

  String? text;
  String? filterStart;
  String? filterEnd;
  // String? month;
  // String? year;

  List<HJual>? listPenjualan = <HJual>[];
  List<HBeli>? listPembelian = <HBeli>[];
  // String? yearPicked = '0';
  // String? monthPicked = '0';
  String? backupPicked = 'Penjualan';
  List<String>? listYear;
  List<String>? listMonth = [
    '0',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];
  List<String>? listBackup = [
    'Penjualan',
    'Pembelian',
  ];

  var result;
  @override
  void initState() {
    searchController.addListener(() {
      if (mounted) {
        debouncer.value = searchController.text.trim().toLowerCase();
      }
    });
    debouncer.values.listen((text) {
      if (mounted) {
        fetchData();
      }
    });
    initDate();
    setScheduleDateText();
    fetchData();
    fetchYearMonth();
    super.initState();
  }

  fetchData() {
    if (backupPicked == 'Penjualan') {
      fetchDataPenjualan();
    } else if (backupPicked == 'Pembelian') {
      fetchDataPembelian();
    }
  }

  fetchYearMonth() async {
    Database? db = await DatabaseHelper.instance.database;

    var resultYear = await db?.rawQuery(
        "SELECT DISTINCT strftime('%Y',TGL_TRANSAKSI) as tahun FROM h_jual ORDER BY tahun ASC");

    if ((resultYear?.length ?? 0) > 0) {
      setState(() {
        listYear = List<String>.from(resultYear!.map((map) => map['tahun']));
      });
      listYear?.insert(0, '0');
    }
  }

  initDate() {
    filterStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    filterEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  fetchDataPembelian() async {
    Database? db = await DatabaseHelper.instance.database;

    String query =
        "SELECT ID_HBELI,BUKTI_NOTA,TANGGAL_BELI,NM_SUPPLIER,GRANDTOTAL FROM h_beli ";
    List<String?> params = [];
    bool containWhere = query.contains('WHERE');
    if (text != null && text != '') {
      if (!containWhere) {
        query = query + "WHERE ";
        containWhere = true;
      }

      query = query +
          "BUKTI_NOTA like ? OR lower(NM_SUPPLIER) like ? OR GRANDTOTAL like ?";
      params.addAll(["%$text%", "%$text%", "%$text%"]);
    }
    if (filterStart != null && filterEnd != null) {
      if (!containWhere) {
        query = query + "WHERE ";
        containWhere = true;
      } else {
        query = query + " AND ";
      }
      query = query + "date(TANGGAL_BELI) BETWEEN ? AND ?";
      params.addAll([
        "$filterStart",
        "$filterEnd",
      ]);
    }
    // if (year != null && month != null) {
    //   if (!containWhere) {
    //     query = query + "WHERE ";
    //     containWhere = true;
    //   } else {
    //     query = query + " AND ";
    //   }
    //   if (year != '0' && month != '0') {
    //     query = query +
    //         "strftime('%Y',TANGGAL_BELI) = ? AND strftime('%m', TANGGAL_BELI) = ?";
    //     params.addAll([
    //       "$year",
    //       "$month",
    //     ]);
    //   } else if (year != '0' && month == '0') {
    //     query = query + "strftime('%Y',TANGGAL_BELI) = ?";
    //     params.addAll([
    //       "$year",
    //     ]);
    //   } else if (year == '0' && month != '0') {
    //     query = query + "strftime('%m', TANGGAL_BELI) = ?";
    //     params.addAll([
    //       "$month",
    //     ]);
    //   }
    // }
    query = query + " ORDER BY TANGGAL_BELI DESC, BUKTI_NOTA DESC";

    if (params.length > 0) {
      result = await db?.rawQuery(query, params);
    } else {
      result = await db?.rawQuery(query);
    }

    // if ((result?.length ?? 0) > 0) {
    setState(() {
      listPembelian = List<HBeli>.from(result.map((map) => HBeli.fromMap(map)));
    });
  }

  fetchDataPenjualan() async {
    Database? db = await DatabaseHelper.instance.database;

    String query =
        "SELECT ID_HJUAL, NONOTA,TGL_TRANSAKSI,NM_CUSTOMER,GRANDTOTAL FROM h_jual ";
    List<String?> params = [];
    bool containWhere = query.contains('WHERE');
    if (text != null && text != '') {
      if (!containWhere) {
        query = query + "WHERE ";
        containWhere = true;
      }

      query = query +
          "NONOTA like ? OR lower(NM_CUSTOMER) like ? OR GRANDTOTAL like ?";
      params.addAll(["%$text%", "%$text%", "%$text%"]);
    }
    if (filterStart != null && filterEnd != null) {
      if (!containWhere) {
        query = query + "WHERE ";
        containWhere = true;
      }
      query = query + "date(TGL_TRANSAKSI) BETWEEN ? AND ?";
      params.addAll([
        "$filterStart",
        "$filterEnd",
      ]);
    }
    // if (year != null && month != null) {
    //   if (!containWhere) {
    //     query = query + "WHERE ";
    //     containWhere = true;
    //   }
    //   if (year != '0' && month != '0') {
    //     query = query +
    //         "strftime('%Y',TGL_TRANSAKSI) = ? AND strftime('%m', TGL_TRANSAKSI) = ?";
    //     params.addAll([
    //       "$year",
    //       "$month",
    //     ]);
    //   } else if (year != '0' && month == '0') {
    //     query = query + "strftime('%Y',TGL_TRANSAKSI) = ?";
    //     params.addAll([
    //       "$year",
    //     ]);
    //   } else if (year == '0' && month != '0') {
    //     query = query + "strftime('%m', TGL_TRANSAKSI) = ?";
    //     params.addAll([
    //       "$month",
    //     ]);
    //   }
    // }
    query = query + " ORDER BY TGL_TRANSAKSI DESC, ID_HJUAL DESC";

    if (params.length > 0) {
      result = await db?.rawQuery(query, params);
    } else {
      result = await db?.rawQuery(query);
    }

    // if ((result?.length ?? 0) > 0) {
    setState(() {
      listPenjualan = List<HJual>.from(result.map((map) => HJual.fromMap(map)));
    });
  }

  getDetailPenjualan(int index) async {
    Database? db = await DatabaseHelper.instance.database;

    var result;
    if (listPenjualan != null) {
      if (listPenjualan![index].dJualList == null) {
        result = await db?.rawQuery("SELECT * FROM d_jual WHERE ID_HJUAL = ?",
            [listPenjualan![index].idHjual]);
        listPenjualan![index].dJualList =
            List<DJual>.from(result.map((map) => DJual.fromMap(map)));
      }
    }
  }

  showDialogDelete(_idHjual) {
    PopupDialog(
      context: context,
      titleText: 'Hapus Data',
      subtitleText: 'Apakah Anda yakin akan menghapus data ini?',
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
      rightButtonAction: (_) async {
        Navigator.pop(context);
        deletePenjualan(_idHjual);
      },
      rightButtonColor: Colors.red,
    );
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
          filterStart = filterStartDate;
          filterEnd = filterEndDate;
          fetchData();
        });
    } else {
      setState(() {
        filterStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        filterEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        setScheduleDateText();
        fetchData();
      });
    }
  }

  deletePenjualan(_idHjual) async {
    Database? db = await DatabaseHelper.instance.database;

    await db?.rawDelete("DELETE FROM h_jual WHERE ID_HJUAL = ?", [_idHjual]);

    fetchData();
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

  backupData() {
    if (backupPicked == 'Penjualan') {
      backupDatabasePenjualan();
    } else {
      backupDatabasePembelian();
    }
  }

  backupDatabasePembelian() async {
    if (await Permission.storage.request().isGranted) {
      final loading = loadingDialog(context);
      Database? db = await DatabaseHelper.instance.database;

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
      // var result = await db?.rawQuery(
      //     "SELECT * FROM h_jual WHERE date(TGL_TRANSAKSI) BETWEEN ? AND ?", [
      //   "$filterStart",
      //   "$filterEnd",
      // ]);
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
}

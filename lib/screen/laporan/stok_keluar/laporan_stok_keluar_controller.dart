import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/model/stok_keluar.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/screen/laporan/stok_keluar/laporan_stok_keluar_view.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/custom_datetime_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class LaporanStokKeluar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LaporanStokKeluarView();
}

abstract class LaporanStokKeluarController extends State<LaporanStokKeluar> {
  final debouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');
  final TextEditingController searchController = TextEditingController();
  String? filterStartDate;
  String? filterEndDate;
  String? filterPeriode;
  List<StokKeluar>? listStokKeluar = <StokKeluar>[];
  String? yearPicked = '0';
  String? monthPicked = '0';
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
  int total = 0;

  @override
  void initState() {
    searchController.addListener(() {
      if (mounted) {
        debouncer.value = searchController.text.trim().toLowerCase();
      }
    });
    debouncer.values.listen((text) {
      if (mounted) {
        fetchDataStokKeluar(text: text);
      }
    });
    initDate();
    setScheduleDateText();
    fetchDataStokKeluar();
    fetchYearMonth();
    super.initState();
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

  fetchDataStokKeluar(
      {String? text,
      String? filterStart,
      String? filterEnd,
      String? month,
      String? year}) async {
    Database? db = await DatabaseHelper.instance.database;

    var result, resultTotal;
    if (text != null && text != '') {
      result = await db?.rawQuery(
          "SELECT stok.NAMA_BARANG,IFNULL(SUM(d_jual.quantity),0) as JUMLAH FROM stok LEFT JOIN d_jual ON stok.NAMA_BARANG = d_jual.NM_BARANG LEFT JOIN h_jual ON d_jual.ID_HJUAL = h_jual.ID_HJUAL WHERE lower(NM_BARANG) like ? GROUP BY stok.NAMA_BARANG",
          ["%$text%"]);
      resultTotal = await db?.rawQuery(
          "SELECT IFNULL(SUM(d_jual.quantity),0) as JUMLAH FROM d_jual WHERE lower(NM_BARANG) like ?",
          ["%$text%"]);
      print(result);
    } else if (filterStart != null && filterEnd != null) {
      result = await db?.rawQuery(
          "SELECT stok.NAMA_BARANG,IFNULL(SUM(d_jual.quantity),0) as JUMLAH FROM stok LEFT JOIN d_jual ON stok.NAMA_BARANG = d_jual.NM_BARANG LEFT JOIN h_jual ON d_jual.ID_HJUAL = h_jual.ID_HJUAL WHERE date(TGL_TRANSAKSI) BETWEEN ? AND ? GROUP BY stok.NAMA_BARANG",
          [
            "$filterStart",
            "$filterEnd",
          ]);
      resultTotal = await db?.rawQuery(
          "SELECT IFNULL(SUM(d_jual.quantity),0) as JUMLAH FROM d_jual LEFT JOIN h_jual ON d_jual.ID_HJUAL = h_jual.ID_HJUAL WHERE date(TGL_TRANSAKSI) BETWEEN ? AND ?",
          [
            "$filterStart",
            "$filterEnd",
          ]);
    } else if (year != null && month != null) {
      if (year != '0' && month != '0') {
        result = await db?.rawQuery(
            "SELECT stok.NAMA_BARANG,IFNULL(SUM(d_jual.quantity),0) as JUMLAH FROM stok LEFT JOIN d_jual ON stok.NAMA_BARANG = d_jual.NM_BARANG LEFT JOIN h_jual ON d_jual.ID_HJUAL = h_jual.ID_HJUAL WHERE strftime('%Y',TGL_TRANSAKSI) = ? AND strftime('%m', TGL_TRANSAKSI) = ? GROUP BY stok.NAMA_BARANG",
            [
              "$year",
              "$month",
            ]);
        resultTotal = await db?.rawQuery(
            "SELECT IFNULL(SUM(d_jual.quantity),0) as JUMLAH FROM d_jual LEFT JOIN h_jual ON d_jual.ID_HJUAL = h_jual.ID_HJUAL WHERE strftime('%Y',TGL_TRANSAKSI) = ? AND strftime('%m', TGL_TRANSAKSI) = ?",
            [
              "$year",
              "$month",
            ]);
      } else if (year != '0' && month == '0') {
        result = await db?.rawQuery(
            "SELECT stok.NAMA_BARANG,IFNULL(SUM(d_jual.quantity),0) as JUMLAH FROM stok LEFT JOIN d_jual ON stok.NAMA_BARANG = d_jual.NM_BARANG LEFT JOIN h_jual ON d_jual.ID_HJUAL = h_jual.ID_HJUAL WHERE strftime('%Y',TGL_TRANSAKSI) = ? GROUP BY stok.NAMA_BARANG",
            [
              "$year",
            ]);
        resultTotal = await db?.rawQuery(
            "SELECT IFNULL(SUM(d_jual.quantity),0) as JUMLAH FROM d_jual LEFT JOIN h_jual ON d_jual.ID_HJUAL = h_jual.ID_HJUAL WHERE strftime('%Y',TGL_TRANSAKSI) = ?",
            [
              "$year",
            ]);
      } else if (year == '0' && month != '0') {
        result = await db?.rawQuery(
            "SELECT stok.NAMA_BARANG,IFNULL(SUM(d_jual.quantity),0) as JUMLAH FROM stok LEFT JOIN d_jual ON stok.NAMA_BARANG = d_jual.NM_BARANG LEFT JOIN h_jual ON d_jual.ID_HJUAL = h_jual.ID_HJUAL WHERE strftime('%m', TGL_TRANSAKSI) = ? GROUP BY stok.NAMA_BARANG",
            [
              "$month",
            ]);
        resultTotal = await db?.rawQuery(
            "SELECT IFNULL(SUM(d_jual.quantity),0) as JUMLAH FROM d_jual LEFT JOIN h_jual ON d_jual.ID_HJUAL = h_jual.ID_HJUAL WHERE strftime('%m', TGL_TRANSAKSI) = ?",
            [
              "$month",
            ]);
      }
    } else {
      result = await db?.rawQuery(
          "SELECT stok.NAMA_BARANG,IFNULL(SUM(d_jual.quantity),0) as JUMLAH FROM stok LEFT JOIN d_jual ON stok.NAMA_BARANG = d_jual.NM_BARANG GROUP BY stok.NAMA_BARANG");
      resultTotal = await db?.rawQuery(
          "SELECT IFNULL(SUM(d_jual.quantity),0) as JUMLAH FROM d_jual");
    }

    // if ((result?.length ?? 0) > 0) {
    setState(() {
      listStokKeluar =
          List<StokKeluar>.from(result.map((map) => StokKeluar.fromMap(map)));
      total = resultTotal[0]['JUMLAH'];
    });
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
          fetchDataStokKeluar(
              filterStart: filterStartDate, filterEnd: filterEndDate);
        });
    } else {
      setState(() {
        filterStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        filterEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        setScheduleDateText();
        fetchDataStokKeluar();
      });
    }
  }

  deletePenjualan(_idHjual) async {
    Database? db = await DatabaseHelper.instance.database;

    await db?.rawDelete("DELETE FROM h_jual WHERE ID_HJUAL = ?", [_idHjual]);

    fetchDataStokKeluar();
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
}

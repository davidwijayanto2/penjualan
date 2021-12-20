import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/pembelian.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/custom_datetime_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'pembelian_view.dart';

class TransaksiPembelian extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PembelianView();
}

abstract class PembelianController extends State<TransaksiPembelian> {
  final debouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');
  final TextEditingController searchController = TextEditingController();
  String? filterStartDate;
  String? filterEndDate;
  String? filterPeriode;
  List<HBeli>? listPembelian = <HBeli>[];

  @override
  void initState() {
    searchController.addListener(() {
      if (mounted) {
        debouncer.value = searchController.text.trim().toLowerCase();
      }
    });
    debouncer.values.listen((text) {
      if (mounted) {
        fetchDataPembelian(text: text);
      }
    });
    initDate();
    setScheduleDateText();
    fetchDataPembelian();
    super.initState();
  }

  initDate() {
    filterStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    filterEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  fetchDataPembelian(
      {String? text, String? filterStart, String? filterEnd}) async {
    Database? db = await DatabaseHelper.instance.database;

    var result;
    if (text != null && text != '') {
      result = await db?.rawQuery(
          "SELECT * FROM h_beli WHERE (ID_HBELI like ? OR lower(NM_SUPPLIER) like ? OR TANGGAL_BELI like ? OR GRANDTOTAL like ? OR KETERANGAN like ?) Order By TANGGAL_BELI",
          ["%$text%", "%$text%", "%$text%", "%$text%", "%$text%"]);
      print(result);
    } else if (filterStart != null && filterEnd != null) {
      result = await db?.rawQuery(
          "SELECT * FROM h_beli WHERE date(TANGGAL_BELI) BETWEEN ? AND ?", [
        "$filterStart",
        "$filterEnd",
      ]);
    } else {
      result = await db?.rawQuery("SELECT * FROM h_beli");
    }

    // if ((result?.length ?? 0) > 0) {
    setState(() {
      listPembelian = List<HBeli>.from(result.map((map) => HBeli.fromMap(map)));
    });
  }

  showDialogDelete(_idHbeli) {
    PopupDialog(
      context: context,
      titleText: 'Hapus Data',
      subtitleText: 'Apakah Anda yakin akan menghapus data ini?',
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
      rightButtonAction: (_) async {
        Navigator.pop(context);
        deletePenjualan(_idHbeli);
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
      setState(() {
        filterStartDate = DateFormat('yyyy-MM-dd').format(picked[0]);
        if (picked.length < 2)
          filterEndDate = DateFormat('yyyy-MM-dd').format(picked[0]);
        else
          filterEndDate = DateFormat('yyyy-MM-dd').format(picked[1]);
        setScheduleDateText();
        fetchDataPembelian(
            filterStart: filterStartDate, filterEnd: filterEndDate);
      });
    } else {
      fetchDataPembelian();
    }
  }

  deletePenjualan(_idHbeli) async {
    Database? db = await DatabaseHelper.instance.database;

    await db?.rawDelete(
        "UPDATE h_jual SET STATUS = 0 WHERE ID_HJUAL = ?", [_idHbeli]);

    fetchDataPembelian();
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

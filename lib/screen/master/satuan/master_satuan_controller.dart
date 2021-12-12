import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/kategori.dart';
import 'package:penjualan/model/satuan.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:sqflite/sqflite.dart';

import 'master_satuan_view.dart';

class MasterSatuan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MasterSatuanView();
}

abstract class MasterSatuanController extends State<MasterSatuan> {
  final debouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');
  final TextEditingController searchController = TextEditingController();
  List<Satuan>? listSatuan = <Satuan>[];
  @override
  void initState() {
    searchController.addListener(() {
      if (mounted) {
        debouncer.value = searchController.text.trim().toLowerCase();
      }
    });
    debouncer.values.listen((text) {
      if (mounted) {
        fetchDataSatuan(text: text);
      }
    });
    fetchDataSatuan();
    super.initState();
  }

  fetchDataSatuan({String? text}) async {
    Database? db = await DatabaseHelper.instance.database;

    var result;
    if (text != null && text != '') {
      result = await db?.rawQuery(
          "SELECT * FROM satuan WHERE (ID like ? OR lower(NAMA_SATUAN) like ?)",
          ["%$text%", "%$text%"]);
      print(result);
    } else {
      result = await db?.rawQuery("SELECT * FROM satuan");
    }

    // if ((result?.length ?? 0) > 0) {
    setState(() {
      listSatuan = List<Satuan>.from(result.map((map) => Satuan.fromMap(map)));
    });
  }

  showDialogDelete(_idSatuan) {
    PopupDialog(
      context: context,
      titleText: 'Hapus Data',
      subtitleText: 'Apakah Anda yakin akan menghapus data ini?',
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
      rightButtonAction: (_) async {
        Navigator.pop(context);
        deleteSatuan(_idSatuan);
      },
      rightButtonColor: Colors.red,
    );
  }

  deleteSatuan(_idSatuan) async {
    Database? db = await DatabaseHelper.instance.database;

    await db?.rawDelete("DELETE FROM SATUAN WHERE ID = ?", [_idSatuan]);

    fetchDataSatuan();
  }
}

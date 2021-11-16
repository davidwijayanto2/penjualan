import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/kategori.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:sqflite/sqflite.dart';

import 'master_kategori_view.dart';

class MasterKategori extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MasterKategoriView();
}

abstract class MasterKategoriController extends State<MasterKategori> {
  final debouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');
  final TextEditingController searchController = TextEditingController();
  List<Kategori>? listKategori = <Kategori>[];
  @override
  void initState() {
    searchController.addListener(() {
      if (mounted) {
        debouncer.value = searchController.text.trim().toLowerCase();
      }
    });
    debouncer.values.listen((text) {
      if (mounted) {
        fetchDataKategori(text: text);
      }
    });
    fetchDataKategori();
    super.initState();
  }

  fetchDataKategori({String? text}) async {
    Database? db = await DatabaseHelper.instance.database;

    var result;
    if (text != null && text != '') {
      result = await db?.rawQuery(
          "SELECT * FROM kategori WHERE (ID_KATEGORI like ? OR lower(NM_KATEGORI) like ?)",
          ["%$text%", "%$text%"]);
      print(result);
    } else {
      result = await db?.rawQuery("SELECT * FROM kategori");
    }

    // if ((result?.length ?? 0) > 0) {
    setState(() {
      listKategori =
          List<Kategori>.from(result.map((map) => Kategori.fromMap(map)));
    });
  }

  showDialogDelete(_idStok) {
    PopupDialog(
      context: context,
      titleText: 'Hapus Data',
      subtitleText: 'Apakah Anda yakin akan menghapus data ini?',
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
      rightButtonAction: (_) async {
        Navigator.pop(context);
        deleteBarang(_idStok);
      },
      rightButtonColor: Colors.red,
    );
  }

  deleteBarang(_idKategori) async {
    Database? db = await DatabaseHelper.instance.database;

    await db?.rawDelete(
        "UPDATE kategori SET STATUS = 0 WHERE ID_KATEGORI = ?", [_idKategori]);

    fetchDataKategori();
  }
}

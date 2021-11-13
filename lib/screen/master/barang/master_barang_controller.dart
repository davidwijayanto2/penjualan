import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:sqflite/sqflite.dart';

import 'master_barang_view.dart';

class MasterBarang extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MasterBarangView();
}

abstract class MasterBarangController extends State<MasterBarang> {
  final debouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');
  final TextEditingController searchController = TextEditingController();
  List<Stok>? listStok = <Stok>[];
  @override
  void initState() {
    searchController.addListener(() {
      if (mounted) {
        debouncer.value = searchController.text.trim().toLowerCase();
      }
    });
    debouncer.values.listen((text) {
      if (mounted) {
        fetchDataBarang(text: text);
      }
    });
    fetchDataBarang();
    super.initState();
  }

  fetchDataBarang({String? text}) async {
    Database? db = await DatabaseHelper.instance.database;

    var result;
    if (text != null && text != '') {
      result = await db?.rawQuery(
          "SELECT stok.ID_STOK,stok.ID_KATEGORI,stok.NAMA_BARANG,stok.QUANTITY, stok.HARGA,stok.status,kategori.NM_KATEGORI FROM stok LEFT JOIN kategori ON stok.ID_KATEGORI = kategori.ID_KATEGORI WHERE stok.STATUS = 1 AND (stok.ID_STOK like ? OR kategori.ID_KATEGORI = ? OR lower(stok.NAMA_BARANG) like ? OR stok.QUANTITY like ? OR stok.HARGA like ?)",
          ["%$text%", "%$text%", "%$text%", "%$text%", "%$text%"]);
      print(result);
    } else {
      result = await db?.rawQuery(
          "SELECT stok.ID_STOK,stok.ID_KATEGORI,stok.NAMA_BARANG,stok.QUANTITY, stok.HARGA,stok.status,kategori.NM_KATEGORI FROM stok LEFT JOIN kategori ON stok.ID_KATEGORI = kategori.ID_KATEGORI WHERE stok.STATUS = 1");
    }

    // if ((result?.length ?? 0) > 0) {
    setState(() {
      listStok = List<Stok>.from(result.map((map) => Stok.fromMap(map)));
    });
    // }
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

  deleteBarang(_idStok) async {
    Database? db = await DatabaseHelper.instance.database;

    await db
        ?.rawDelete("UPDATE stok SET STATUS = 0 WHERE ID_STOK = ?", [_idStok]);

    fetchDataBarang();
  }
}

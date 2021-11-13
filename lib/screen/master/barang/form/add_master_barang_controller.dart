import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:penjualan/model/kategori.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'add_master_barang_view.dart';

class AddMasterBarang extends StatefulWidget {
  final Stok? editStok;
  AddMasterBarang({this.editStok});
  @override
  State<StatefulWidget> createState() => AddMasterBarangView();
}

abstract class AddMasterBarangController extends State<AddMasterBarang> {
  final formKey = GlobalKey<FormBuilderState>();
  final TextEditingController namaBarangController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  int? kategori = 0;
  List<Kategori>? listKategori;
  bool onError = false;

  @override
  void initState() {
    initForm();

    super.initState();
  }

  initForm() {
    fetchKategori();
    if (widget.editStok != null) {
      setState(() {
        kategori = widget.editStok?.idKategori;
        namaBarangController.text = widget.editStok?.namaBarang ?? '';
        quantityController.text = widget.editStok?.quantity.toString() ?? '';
        hargaController.text = widget.editStok?.harga.toString() ?? '';
      });
    } else {}
  }

  fetchKategori() async {
    Database? db = await DatabaseHelper.instance.database;

    var result = await db?.rawQuery("SELECT * FROM KATEGORI");
    print(result);
    if ((result?.length ?? 0) > 0) {
      setState(() {
        listKategori =
            List<Kategori>.from(result!.map((map) => Kategori.fromMap(map)));
        listKategori?.insert(
            0, Kategori(idKategori: 0, nmKategori: '', status: ''));
      });
    }
  }

  submitForm() async {
    if (formKey.currentState!.validate()) {
      Database? db = await DatabaseHelper.instance.database;
      if (widget.editStok != null) {
        await db?.rawUpdate(
            'UPDATE stok set ID_KATEGORI = ?, NAMA_BARANG = ?,QUANTITY = ?,HARGA =? WHERE ID_STOK = ?',
            [
              kategori ?? 0,
              namaBarangController.text.trim().toUpperCase(),
              int.parse(quantityController.text.trim()),
              int.parse(hargaController.text.trim()),
              widget.editStok?.idStok ?? 0
            ]).then((value) {
          Navigator.pop(context);
        }).catchError((onError) {
          Fluttertoast.showToast(msg: 'Error when store to database');
        });
      } else {
        await db?.rawInsert(
            'INSERT INTO stok(ID_KATEGORI, NAMA_BARANG,QUANTITY,HARGA,STATUS) VALUES(?, ?, ? ,?, 1)',
            [
              kategori ?? 0,
              namaBarangController.text.trim().toUpperCase(),
              int.parse(quantityController.text.trim()),
              int.parse(hargaController.text.trim()),
            ]).then((value) {
          Navigator.pop(context);
        }).catchError((onError) {
          Fluttertoast.showToast(msg: 'Error when store to database');
        });
      }
    } else {
      setState(() {
        onError = true;
      });
    }
  }
}

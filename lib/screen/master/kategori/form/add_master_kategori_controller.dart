import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/kategori.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'add_master_kategori_view.dart';

class AddMasterKategori extends StatefulWidget {
  final Kategori? editKategori;
  AddMasterKategori({this.editKategori});
  @override
  State<StatefulWidget> createState() => AddMasterKategoriView();
}

abstract class AddMasterKategoriController extends State<AddMasterKategori> {
  final formKey = GlobalKey<FormBuilderState>();
  final TextEditingController namaKategoriController = TextEditingController();
  bool onError = false;

  @override
  void initState() {
    initForm();

    super.initState();
  }

  initForm() {
    if (widget.editKategori != null) {
      setState(() {
        namaKategoriController.text = widget.editKategori?.nmKategori ?? '';
      });
    }
  }

  submitForm() async {
    if (formKey.currentState!.validate()) {
      Database? db = await DatabaseHelper.instance.database;
      if (widget.editKategori != null) {
        await db?.rawUpdate(
            'UPDATE kategori set NM_KATEGORI = ? WHERE ID_KATEGORI = ?', [
          namaKategoriController.text.trim().toUpperCase(),
          widget.editKategori?.idKategori ?? 0,
        ]).then((value) {
          Navigator.pop(context);
        }).catchError((onError) {
          Fluttertoast.showToast(msg: 'Error when store to database');
        });
      } else {
        await db?.rawInsert(
            'INSERT INTO kategori(NM_KATEGORI,STATUS) VALUES(?, 1)', [
          namaKategoriController.text.trim(),
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

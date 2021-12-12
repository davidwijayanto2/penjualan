import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:penjualan/model/satuan.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'add_master_satuan_view.dart';

class AddMasterSatuan extends StatefulWidget {
  final Satuan? editSatuan;
  AddMasterSatuan({this.editSatuan});
  @override
  State<StatefulWidget> createState() => AddMasterSatuanView();
}

abstract class AddMasterSatuanController extends State<AddMasterSatuan> {
  final formKey = GlobalKey<FormBuilderState>();
  final TextEditingController namaSatuanController = TextEditingController();
  bool onError = false;

  @override
  void initState() {
    initForm();

    super.initState();
  }

  initForm() {
    if (widget.editSatuan != null) {
      setState(() {
        namaSatuanController.text = widget.editSatuan?.nmSatuan ?? '';
      });
    }
  }

  submitForm() async {
    if (formKey.currentState!.validate()) {
      Database? db = await DatabaseHelper.instance.database;
      if (widget.editSatuan != null) {
        await db?.rawUpdate('UPDATE satuan set NAMA_SATUAN = ? WHERE ID = ?', [
          namaSatuanController.text.trim().toUpperCase(),
          widget.editSatuan?.idSatuan ?? 0,
        ]).then((value) {
          Navigator.pop(context);
        }).catchError((onError) {
          Fluttertoast.showToast(msg: 'Error when store to database');
        });
      } else {
        await db?.rawInsert('INSERT INTO satuan(NAMA_SATUAN) VALUES(?)', [
          namaSatuanController.text.trim(),
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

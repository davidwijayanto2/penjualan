import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'add_penjualan_view.dart';

class AddPenjualan extends StatefulWidget {
  final HJual? editHJual;
  AddPenjualan({this.editHJual});
  @override
  State<StatefulWidget> createState() => AddPenjualanView();
}

abstract class AddPenjualanController extends State<AddPenjualan> {
  final formKey = GlobalKey<FormBuilderState>();
  final TextEditingController noNotaController = TextEditingController();
  final TextEditingController namaCustomerController = TextEditingController();
  final TextEditingController namaBarangController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  bool onError = false;

  @override
  void initState() {
    initForm();

    super.initState();
  }

  initForm() {
    if (widget.editHJual != null) {
      setState(() {
        noNotaController.text = widget.editHJual?.nonota ?? '';
        namaCustomerController.text = widget.editHJual?.nmCustomer ?? '';
        keteranganController.text = widget.editHJual?.keterangan ?? '';
      });
    }
  }

  submitForm() async {
    if (formKey.currentState!.validate()) {
      Database? db = await DatabaseHelper.instance.database;
      if (widget.editHJual != null) {
        await db?.rawUpdate(
            'UPDATE customer set NM_CUSTOMER = ?,NO_TLP = ?,ALAMAT =?, EMAIL = ?, HARGA_KHUSUS = ? WHERE ID_CUSTOMER = ?',
            [
              namaCustomerController.text.trim().toUpperCase(),
            ]).then((value) {
          Navigator.pop(context);
        }).catchError((onError) {
          Fluttertoast.showToast(msg: 'Error when store to database');
        });
      } else {
        await db?.rawInsert(
            'INSERT INTO customer(NM_CUSTOMER, NO_TLP,ALAMAT,EMAIL,STATUS,HARGA_KHUSUS) VALUES(?, ?, ? ,?, 1,?)',
            [
              namaCustomerController.text.trim().toUpperCase(),
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

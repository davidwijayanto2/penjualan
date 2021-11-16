import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/kategori.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'add_master_customer_view.dart';

class AddMasterCustomer extends StatefulWidget {
  final Customer? editCustomer;
  AddMasterCustomer({this.editCustomer});
  @override
  State<StatefulWidget> createState() => AddMasterCustomerView();
}

abstract class AddMasterCustomerController extends State<AddMasterCustomer> {
  final formKey = GlobalKey<FormBuilderState>();
  final TextEditingController namaCustomerController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? hargaKhusus = '';
  List<DropdownMenuItem<String>> listHargaKhusus = [
    DropdownMenuItem<String>(value: '', child: Text('')),
    DropdownMenuItem<String>(value: 'YA', child: Text('YA')),
    DropdownMenuItem<String>(value: 'TIDAK', child: Text('TIDAK')),
  ];
  bool onError = false;

  @override
  void initState() {
    initForm();

    super.initState();
  }

  initForm() {
    if (widget.editCustomer != null) {
      setState(() {
        namaCustomerController.text = widget.editCustomer?.nmCustomer ?? '';
        noTelpController.text = widget.editCustomer?.noTelp ?? '';
        alamatController.text = widget.editCustomer?.alamat ?? '';
        emailController.text = widget.editCustomer?.email ?? '';
        hargaKhusus = widget.editCustomer?.hargaKhusus;
      });
    }
  }

  submitForm() async {
    if (formKey.currentState!.validate()) {
      Database? db = await DatabaseHelper.instance.database;
      if (widget.editCustomer != null) {
        await db?.rawUpdate(
            'UPDATE customer set NM_CUSTOMER = ?,NO_TLP = ?,ALAMAT =?, EMAIL = ?, HARGA_KHUSUS = ? WHERE ID_CUSTOMER = ?',
            [
              namaCustomerController.text.trim().toUpperCase(),
              noTelpController.text.trim(),
              alamatController.text.trim(),
              emailController.text.trim(),
              hargaKhusus,
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
              noTelpController.text.trim(),
              alamatController.text.trim(),
              emailController.text.trim(),
              hargaKhusus,
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

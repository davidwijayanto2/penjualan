import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:sqflite/sqflite.dart';

import 'master_customer_view.dart';

class MasterCustomer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MasterCustomerView();
}

abstract class MasterCustomerController extends State<MasterCustomer> {
  final debouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');
  final TextEditingController searchController = TextEditingController();
  List<Customer>? listCustomer = <Customer>[];
  @override
  void initState() {
    searchController.addListener(() {
      if (mounted) {
        debouncer.value = searchController.text.trim().toLowerCase();
      }
    });
    debouncer.values.listen((text) {
      if (mounted) {
        fetchDataCustomer(text: text);
      }
    });
    fetchDataCustomer();
    super.initState();
  }

  fetchDataCustomer({String? text}) async {
    Database? db = await DatabaseHelper.instance.database;

    var result;
    if (text != null && text != '') {
      result = await db?.rawQuery(
          "SELECT * FROM customer WHERE (ID_CUSTOMER like ? OR lower(NM_CUSTOMER) like ? OR NO_TLP like ? OR ALAMAT like ? OR EMAIL like ? OR HARGA_KHUSUS like ?)",
          ["%$text%", "%$text%", "%$text%", "%$text%", "%$text%", "%$text%"]);
      print(result);
    } else {
      result = await db?.rawQuery("SELECT * FROM customer");
    }

    // if ((result?.length ?? 0) > 0) {
    setState(() {
      listCustomer =
          List<Customer>.from(result.map((map) => Customer.fromMap(map)));
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

  deleteBarang(_idCustomer) async {
    Database? db = await DatabaseHelper.instance.database;

    await db?.rawDelete(
        "UPDATE customer SET STATUS = 0 WHERE ID_CUSTOMER = ?", [_idCustomer]);

    fetchDataCustomer();
  }
}

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/kategori.dart';
import 'package:penjualan/model/pembelian.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/repositories/local_storage.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:penjualan/utils/select_barang.dart';
import 'package:penjualan/utils/select_customer.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'package:sqflite/sqflite.dart';
import 'add_pembelian_view.dart';

class AddPembelian extends StatefulWidget {
  final HBeli? editHbeli;
  AddPembelian({this.editHbeli, HBeli? editHBeli});
  @override
  State<StatefulWidget> createState() => AddPembelianView();
}

abstract class AddPembelianController extends State<AddPembelian> {
  final formKey = GlobalKey<FormBuilderState>();
  final discountDebouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');
  final dibayarDebouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');
  final TextEditingController noNotaController = TextEditingController();

  final TextEditingController keteranganController = TextEditingController();
  final TextEditingController kotaController = TextEditingController();
  final TextEditingController keterangan2Controller = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController grandTotalController = TextEditingController();
  final TextEditingController dibayarkanController = TextEditingController();
  final TextEditingController sisaController = TextEditingController();

  bool onError = false;
  bool showFormBarang = false;
  List<DJual>? djualList = <DJual>[];
  int? kategori = 0;
  int quantityTotal = 0;
  String dateTextStr = '';
  DateTime datePicked = DateTime.now();
  HBeli? supllier;
  List<Kategori>? listKategori;

  showDialogSupplier(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return popupDialogAutoComplete(context, 
      selectWidget: selectWidget
      )
  }
}

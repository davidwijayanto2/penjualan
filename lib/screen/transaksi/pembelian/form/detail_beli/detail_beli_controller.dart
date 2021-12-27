import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/kategori.dart';
import 'package:penjualan/model/pembelian.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/model/satuan.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:penjualan/utils/select_barang.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'package:sqflite/sqflite.dart';
import 'detail_beli_view.dart';

class DetailBeli extends StatefulWidget {
  final Dbeli? editDBeli;
  DetailBeli({this.editDBeli});
  @override
  State<StatefulWidget> createState() => DetailBeliView();
}

abstract class DetailBeliController extends State<DetailBeli> {
  final formKey = GlobalKey<FormBuilderState>();
}

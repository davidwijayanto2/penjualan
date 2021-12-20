import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/pembelian.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/custom_datetime_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'detailpenjualan_view.dart';

class DetailTransaksiPenjualan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DetailPenjualanView();
}

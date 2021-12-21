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

class TransaksiPenjualanDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TransaksiDetailPenjulalanView();
}

abstract class DetailPenjualanController
    extends State<TransaksiPenjualanDetail> {
  String? filterStartDate;
  String? filterEndDate;
  String? filterPeriode;

  Future<void> onPressDate() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    var picked = await CustomDateRangePicker.show(
        context: context,
        initialFirstdate: DateTime.parse(filterStartDate!),
        initialLastDate: DateTime.parse(filterEndDate!),
        firstDate:
            DateTime.parse(DateFormat('2010-01-01').format(DateTime.now())),
        lastDate: DateTime.parse("2100-01-01"));
    if (picked != null) {
      setState(() {
        filterStartDate = DateFormat('yyyy-MM-dd').format(picked[0]);
        if (picked.length < 2)
          filterEndDate = DateFormat('yyyy-MM-dd').format(picked[0]);
        else
          filterEndDate = DateFormat('yyyy-MM-dd').format(picked[1]);
      });
    } else {}
  }
}

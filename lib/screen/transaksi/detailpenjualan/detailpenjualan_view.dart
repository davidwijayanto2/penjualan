import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/pembelian.dart';
import 'package:penjualan/routing/navigator.dart';
import 'package:penjualan/screen/transaksi/detailpenjualan/detailpenjualan_controller.dart';
import 'package:penjualan/screen/transaksi/penjualan/form/detail_jual/detail_jual_controller.dart';
import 'package:penjualan/screen/transaksi/penjualan/penjualan_controller.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:penjualan/utils/string_formatter.dart';

class TransaksiDetailPenjulalanView extends DetailPenjualanController {
  @override
  Widget build(BuildContext context) {
    return CommonWidgets.baseFormContainer(
      context: context,
      child: SafeArea(
        child: Scaffold(
            appBar: CommonWidgets.noAppBar(
              systemUiOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            backgroundColor: MyColors.white,
            body: _transaksiDetailPenjualanBody(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              backgroundColor: MyColors.themeColor1,
              child: Icon(
                FontAwesomeIcons.plus,
                size: 24,
              ),
              onPressed: () {
                goToAddTransaksiPenjualan(
                    context: context, afterOpen: (value) {});
              },
            )),
      ),
    );
  }

  _transaksiDetailPenjualanBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          CommonWidgets.horizontalDivider(),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: CommonWidgets.textIconButton(
              height: 36,
              suffixIcon: Icon(
                FontAwesomeIcons.calendarAlt,
                color: MyColors.themeColor1,
                size: 20,
              ),
              text: filterPeriode,
              onPressed: onPressDate,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          CommonWidgets.horizontalDivider(),
        ],
      ),
    );
  }
}

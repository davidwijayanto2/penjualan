import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/routing/navigator.dart';
import 'package:penjualan/screen/transaksi/detailpenjualan/detailpenjualan_controller.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:penjualan/utils/string_formatter.dart';

class DetailPenjualanView extends DetailTransaksiPenjualan {
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
}

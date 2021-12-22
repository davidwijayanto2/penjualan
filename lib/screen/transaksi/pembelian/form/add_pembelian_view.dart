import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/pembelian.dart';
import 'package:penjualan/routing/navigator.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:intl/intl.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'add_pembelian_controller.dart';

class AddPembelianView extends AddPembelianController {
  @override
  Widget build(BuildContext context) {
    return CommonWidgets.baseFormContainer(
      context: context,
      child: SafeArea(
        child: Scaffold(
          appBar: CommonWidgets.customAppBar(context,
              titleText: widget.editHbeli != null
                  ? 'Detail Transaksi Pembelian'
                  : 'Add Transaksi Pembelian'),
          backgroundColor: MyColors.white,
          body: _addTransaksiPembelian(),
        ),
      ),
    );
  }

  _addTransaksiPembelian() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 15,
      ),
      child: FormBuilder(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonText.text(
                text: "No Nota",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
              FormBuilderTextField(
                name: 'nonota',
                maxLines: 1,
                controller: noNotaController,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(context),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Pelanggan",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

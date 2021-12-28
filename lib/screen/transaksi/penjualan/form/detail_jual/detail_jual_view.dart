import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/screen/transaksi/penjualan/form/detail_jual/detail_jual_controller.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'detail_jual_controller.dart';

class DetailJualView extends DetailJualController {
  @override
  Widget build(BuildContext context) {
    return CommonWidgets.baseFormContainer(
      context: context,
      child: SafeArea(
        child: Scaffold(
          appBar: CommonWidgets.customAppBar(context,
              titleText: widget.editDJual != null
                  ? 'Edit Detail Penjualan'
                  : 'Add Detail Penjualan'),
          backgroundColor: MyColors.white,
          body: _addDetailJual(),
        ),
      ),
    );
  }

  _addDetailJual() {
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
                  text: 'Nama Barang',
                  style: CommonText.body1(color: MyColors.textGray)),
              CommonWidgets.textIconButton(
                allBorder: false,
                borderColor: MyColors.formColor,
                suffixIcon: Icon(
                  FontAwesomeIcons.chevronDown,
                  size: 12,
                  color: MyColors.themeColor1,
                ),
                padding: EdgeInsets.zero,
                text: barang?.namaBarang ?? '',
                onPressed: () => showDialogBarang(context),
              ),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Kategori",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
              DropdownButton<String>(
                value: kategori.toString(),
                icon: Icon(Icons.arrow_drop_down),
                isExpanded: true,
                iconSize: 24,
                elevation: 16,
                style: CommonText.body1(color: MyColors.black),
                underline: Container(
                  height: 1,
                  color: MyColors.gray,
                ),
                onChanged: (String? data) {
                  setState(() {
                    kategori = int.parse(data ?? '0');
                  });
                },
                items: listKategori?.map((data) {
                  return DropdownMenuItem<String>(
                    value: data.idKategori.toString(),
                    child: Text(
                      (data.nmKategori ?? ''),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Satuan",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
              DropdownButton<String>(
                value: idSatuan.toString(),
                icon: Icon(Icons.arrow_drop_down),
                isExpanded: true,
                iconSize: 24,
                elevation: 16,
                style: CommonText.body1(color: MyColors.black),
                underline: Container(
                  height: 1,
                  color: MyColors.gray,
                ),
                onChanged: (String? data) {
                  setState(() {
                    idSatuan = int.parse(data ?? '0');
                  });
                },
                items: listSatuan?.map((data) {
                  return DropdownMenuItem<String>(
                    value: data.idSatuan.toString(),
                    child: Text(
                      (data.nmSatuan ?? ''),
                    ),
                  );
                }).toList(),
              ),
              if (onError && idSatuan == 0) CommonWidgets.errorMessage(context),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Qty",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
              CustomMoneyField(
                maxLines: 1,
                controller: quantityController,
                inputFormatters: [
                  FilteringTextInputFormatter.deny('-'),
                ],
                onChange: (value) {
                  calculateSubtotal(
                    harga: hargaController.text.isEmpty
                        ? 0
                        : int.parse(
                            extractNumber(
                              value: hargaController.text,
                            ),
                          ),
                    qty: value.isEmpty
                        ? 0
                        : int.parse(
                            extractNumber(
                              value: value,
                            ),
                          ),
                  );
                },
                separator: ThousandSeparator.Period,
              ),
              if (onError && quantityController.text.isEmpty)
                CommonWidgets.errorMessage(context),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Harga",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
              CustomMoneyField(
                maxLines: 1,
                controller: hargaController,
                inputFormatters: [
                  FilteringTextInputFormatter.deny('-'),
                ],
                onChange: (value) {
                  calculateSubtotal(
                    harga: hargaController.text.isEmpty
                        ? 0
                        : int.parse(
                            extractNumber(
                              value: hargaController.text,
                            ),
                          ),
                    qty: value.isEmpty
                        ? 0
                        : int.parse(
                            extractNumber(
                              value: value,
                            ),
                          ),
                  );
                },
                separator: ThousandSeparator.Period,
              ),
              if (onError && hargaController.text.isEmpty)
                CommonWidgets.errorMessage(context),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Subtotal",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CupertinoTextField(
                maxLines: 1,
                controller: subtotalController,
                enabled: false,
                style: CommonText.body1(color: MyColors.gray),
              ),
              SizedBox(
                height: 20,
              ),
              CommonWidgets.containedButton(
                text: widget.editDJual == null ? 'Add' : 'Edit',
                onPressed: submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

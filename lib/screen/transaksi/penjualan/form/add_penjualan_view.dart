import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/routing/navigator.dart';

import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:intl/intl.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'add_penjualan_controller.dart';

class AddPenjualanView extends AddPenjualanController {
  @override
  Widget build(BuildContext context) {
    return CommonWidgets.baseFormContainer(
      context: context,
      child: SafeArea(
        child: Scaffold(
          appBar: CommonWidgets.customAppBar(context,
              titleText: widget.editHJual != null
                  ? 'Detail Transaksi Penjualan'
                  : 'Add Transaksi Penjualan'),
          backgroundColor: MyColors.white,
          body: _addTransaksiPenjualan(),
        ),
      ),
    );
  }

  _addTransaksiPenjualan() {
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
              CommonWidgets.textIconButton(
                allBorder: false,
                borderColor: MyColors.formColor,
                suffixIcon: Icon(
                  FontAwesomeIcons.chevronDown,
                  size: 12,
                  color: MyColors.themeColor1,
                ),
                padding: EdgeInsets.zero,
                text: customer?.nmCustomer ?? '',
                onPressed: () => showDialogCustomer(context),
              ),
              if (onError && customer == null)
                CommonWidgets.errorMessage(context),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Tanggal",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
              CommonWidgets.textIconButton(
                allBorder: false,
                borderColor: MyColors.formColor,
                suffixIcon: Icon(
                  FontAwesomeIcons.calendarAlt,
                  size: 20,
                  color: MyColors.themeColor1,
                ),
                text: dateTextStr,
                padding: EdgeInsets.zero,
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: datePicked,
                    firstDate: DateTime.parse(
                      DateFormat('2010-01-01').format(
                        DateTime.now(),
                      ),
                    ),
                    lastDate: DateTime.parse(
                      DateFormat('2100-01-01').format(
                        DateTime.now(),
                      ),
                    ),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        datePicked = value;
                        dateTextStr =
                            DateFormatter.toLongDateText(context, value);
                      });
                    }
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              CommonText.text(
                text: "Detail Transaksi",
                style: CommonText.body1(
                  color: MyColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onError && (djualList ?? <DJual>[]).isEmpty)
                CommonWidgets.errorMessage(context),
              if ((djualList?.length ?? 0) > 0) ...[
                _djualList(),
                CommonWidgets.horizontalDivider(),
              ],
              SizedBox(
                height: 10,
              ),
              CommonWidgets.textIconButton(
                expandedText: false,
                prefixIcon: Icon(
                  FontAwesomeIcons.plus,
                  color: MyColors.themeColor1,
                  size: 15,
                ),
                borderColor: MyColors.themeColor1,
                borderRadius: BorderRadius.circular(8.0),
                text: "Tambah Barang",
                textColor: MyColors.themeColor1,
                onPressed: () {
                  goToAddDetailJual(
                    context: context,
                    afterOpen: (value) {
                      if (value != null) {
                        addDjualList(value, null);
                        calculateTotal();
                      }
                    },
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Keterangan",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
              FormBuilderTextField(
                name: 'keterangan',
                maxLines: 1,
                controller: keteranganController,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Kota",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
              FormBuilderTextField(
                name: 'kota',
                maxLines: 1,
                controller: kotaController,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Keterangan 2",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
              FormBuilderTextField(
                name: 'keterangan2',
                maxLines: 4,
                controller: keterangan2Controller,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
              ),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Total",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CupertinoTextField(
                maxLines: 1,
                controller: totalController,
                enabled: false,
                style: CommonText.body1(color: MyColors.gray),
              ),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Discount",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomMoneyField(
                maxLines: 1,
                controller: discountController,
                separator: ThousandSeparator.Period,
              ),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Grand Total",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CupertinoTextField(
                maxLines: 1,
                controller: grandTotalController,
                enabled: false,
                style: CommonText.body1(color: MyColors.gray),
              ),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Dibayarkan",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomMoneyField(
                maxLines: 1,
                controller: dibayarkanController,
                separator: ThousandSeparator.Period,
              ),
              if (onError && dibayarkanController.text.trim().isEmpty)
                CommonWidgets.errorMessage(context),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Sisa",
                style: CommonText.body1(
                  color: MyColors.textGray,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CupertinoTextField(
                maxLines: 1,
                controller: sisaController,
                enabled: false,
                style: CommonText.body1(color: MyColors.gray),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: CommonWidgets.outlinedButton(
                      text: 'Cetak',
                      onPressed: () {
                        goToPrintNota(
                            context: context,
                            hJual: getHjualFromForm(),
                            dJualList: djualList ?? <DJual>[]);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: CommonWidgets.containedButton(
                      text: widget.editHJual == null ? 'Add' : 'Edit',
                      onPressed: submitForm,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _djualList() {
    return Flexible(
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 10),
        itemCount: djualList?.length ?? 0,
        separatorBuilder: (context, int index) {
          return Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: CommonWidgets.horizontalDivider());
        },
        itemBuilder: (BuildContext context, int index) {
          return _dJualItem(index, djualList?[index]);
        },
      ),
    );
  }

  _dJualItem(int index, DJual? djual) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText.text(
                text: djual?.nmBarang ?? '',
                style: CommonText.body1(
                  color: MyColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  CommonText.text(
                    text: thousandSeparator(djual?.hargaBarang ?? 0,
                        separator: '.'),
                    style: CommonText.body2(
                      color: MyColors.textGray,
                    ),
                  ),
                  CommonText.text(
                    text: ' | ',
                    style: CommonText.body2(
                      color: MyColors.textGray,
                    ),
                  ),
                  CommonText.text(
                    text: (djual?.satuan ?? '').isEmpty
                        ? '-'
                        : djual?.satuan ?? '-',
                    style: CommonText.body2(
                      color: MyColors.textGray,
                    ),
                  ),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText.text(
                text: "Subtotal: ${formatMoney(value: djual?.subtotal ?? 0)}",
                style: CommonText.body1(
                  color: MyColors.themeColor1,
                ),
              ),
              CustomStepper(
                initialValue: djual?.quantity ?? 0,
                minValue: 0,
                maxValue: 9999,
                step: 1,
                decimalPlaces: 0,
                buttonSize: 24,
                onChanged: (value) {
                  setState(() {
                    if (value > 0) {
                      djual?.quantity = value as int;
                    } else {
                      djualList?.remove(djual);
                    }
                    calculateSubtotal(djual: djual!);
                    calculateTotal();
                  });
                },
              )
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: () => showDialogDelete(djual!),
                child: CommonText.text(
                  text: 'Delete',
                  style: CommonText.body1(
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              InkWell(
                onTap: () {
                  goToAddDetailJual(
                    context: context,
                    editDJual: djual,
                    afterOpen: (value) {
                      if (value != null) {
                        addDjualList(value, index);
                        calculateTotal();
                      }
                    },
                  );
                },
                child: CommonText.text(
                  text: 'edit',
                  style: CommonText.body1(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}

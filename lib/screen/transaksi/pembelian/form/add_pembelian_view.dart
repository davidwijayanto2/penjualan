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
                  name: 'nonota', maxLines: 1, controller: noNotaController),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Supplier",
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
                text: supllier?.nmSupplier ?? '',
                onPressed: () => showDialogSupplier(context),
              ),
              if (onError && supllier == null)
                CommonWidgets.errorMessage(context),
              SizedBox(
                height: 15,
              ),
              CommonText.text(
                text: "Tanggal Beli",
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
              if (onError && (dbeliList ?? <Dbeli>[]).isEmpty)
                CommonWidgets.errorMessage(context),
              if ((dbeliList?.length ?? 0) > 0) ...[
                _dbeliList(),
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
                  goToAddDetailBeli(
                    context: context,
                    afterOpen: (value) {
                      if (value != null) {
                        addDbeliList(value, null);
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
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: CommonWidgets.outlinedButton(
                      text: 'Cetak',
                      onPressed: () {
                        goToPrintNotaBeli(
                            context: context,
                            hBeli: getHbeliFromForm(),
                            dBeliList: dbeliList ?? <Dbeli>[]);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: CommonWidgets.outlinedButton(
                      text: 'Cetak Dengan Logo',
                      onPressed: () {
                        goToPrintNotaBeliLogo(
                            context: context,
                            hBeli: getHbeliFromForm(),
                            dBeliList: dbeliList ?? <Dbeli>[]);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: CommonWidgets.containedButton(
                      text: widget.editHbeli == null ? 'Add' : 'Edit',
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

  _dbeliList() {
    return Flexible(
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 10),
        itemCount: dbeliList?.length ?? 0,
        separatorBuilder: (context, int index) {
          return Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: CommonWidgets.horizontalDivider());
        },
        itemBuilder: (BuildContext context, int index) {
          return _dBeliItem(index, dbeliList?[index]);
        },
      ),
    );
  }

  _dBeliItem(int index, Dbeli? dbeli) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText.text(
                text: dbeli?.nmBarang ?? '',
                style: CommonText.body1(
                  color: MyColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  CommonText.text(
                    text: thousandSeparator(dbeli?.hargaBarang ?? 0,
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
                    text: (dbeli?.satuan ?? '').isEmpty
                        ? '-'
                        : dbeli?.satuan ?? '-',
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
                text: "Subtotal: ${formatMoney(value: dbeli?.subtotal ?? 0)}",
                style: CommonText.body1(
                  color: MyColors.themeColor1,
                ),
              ),
              CustomStepper(
                initialValue: dbeli?.quantity ?? 0,
                minValue: 0,
                maxValue: 9999,
                step: 1,
                decimalPlaces: 0,
                buttonSize: 24,
                onChanged: (value) {
                  setState(() {
                    if (value > 0) {
                      dbeli?.quantity = value as int;
                    } else {
                      dbeliList?.remove(dbeli);
                    }
                    calculateSubtotal(dbeli: dbeli!);
                    calculateTotal();
                  });
                },
              )
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: () => showDialogDelete(dbeli!),
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
                  goToAddDetailBeli(
                    context: context,
                    editDBeli: dbeli,
                    afterOpen: (value) {
                      if (value != null) {
                        addDbeliList(value, index);
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

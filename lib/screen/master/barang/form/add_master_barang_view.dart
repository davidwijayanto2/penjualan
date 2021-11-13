import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/routing/navigator.dart';
import 'package:penjualan/screen/master/barang/form/add_master_barang_controller.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/my_colors.dart';

class AddMasterBarangView extends AddMasterBarangController {
  @override
  Widget build(BuildContext context) {
    return CommonWidgets.baseFormContainer(
      context: context,
      child: SafeArea(
        child: Scaffold(
          appBar: CommonWidgets.customAppBar(context,
              titleText: 'Add Master Barang'),
          backgroundColor: MyColors.white,
          body: _addMasterBarangBody(),
        ),
      ),
    );
  }

  _addMasterBarangBody() {
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
            children: [
              CommonText.text(
                text: "Kode Barang",
                style: CommonText.body1(
                  color: MyColors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              CupertinoTextField(
                maxLines: 1,
                enabled: false,
                placeholder: widget.editStok != null
                    ? widget.editStok?.idStok.toString()
                    : "AUTO",
              ),
              SizedBox(
                height: 20,
              ),
              CommonText.text(
                text: "Kategori",
                style: CommonText.body1(
                  color: MyColors.black,
                ),
              ),
              SizedBox(
                height: 8,
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
                      child: Text(data.nmKategori ?? ''));
                }).toList(),
              ),
              if (kategori == 0 && onError)
                Container(
                  padding: EdgeInsets.only(top: 4),
                  child: CommonText.text(
                      text: 'This field is required',
                      style: CommonText.body1(color: Colors.red)),
                ),
              SizedBox(
                height: 20,
              ),
              CommonText.text(
                text: "Nama Barang",
                style: CommonText.body1(
                  color: MyColors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              FormBuilderTextField(
                name: 'namabarang',
                maxLines: 1,
                controller: namaBarangController,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(context),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CommonText.text(
                text: "Quantity",
                style: CommonText.body1(
                  color: MyColors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              FormBuilderTextField(
                name: 'quantity',
                maxLines: 1,
                maxLength: 10,
                controller: quantityController,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(context),
                  ],
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              CommonText.text(
                text: "Harga",
                style: CommonText.body1(
                  color: MyColors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              FormBuilderTextField(
                name: 'harga',
                maxLines: 1,
                maxLength: 10,
                controller: hargaController,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(context),
                  ],
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 30,
              ),
              CommonWidgets.containedButton(
                text: widget.editStok == null ? 'Add' : 'Edit',
                onPressed: submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

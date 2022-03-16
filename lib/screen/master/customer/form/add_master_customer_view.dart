import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:penjualan/routing/navigator.dart';
import 'package:penjualan/screen/master/barang/form/add_master_barang_controller.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/my_colors.dart';

import 'add_master_customer_controller.dart';

class AddMasterCustomerView extends AddMasterCustomerController {
  @override
  Widget build(BuildContext context) {
    return CommonWidgets.baseFormContainer(
      context: context,
      child: SafeArea(
        child: Scaffold(
          appBar: CommonWidgets.customAppBar(context,
              titleText: 'Add Master Customer'),
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
                text: "Nama Customer",
                style: CommonText.body1(
                  color: MyColors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              FormBuilderTextField(
                name: 'namacustomer',
                maxLines: 1,
                controller: namaCustomerController,
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
                text: "Alamat",
                style: CommonText.body1(
                  color: MyColors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              FormBuilderTextField(
                name: 'alamat',
                maxLines: 1,
                maxLength: 10,
                controller: alamatController,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(context),
                  ],
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 20,
              ),
              CommonText.text(
                text: "Telp",
                style: CommonText.body1(
                  color: MyColors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              FormBuilderTextField(
                name: 'notelp',
                maxLines: 1,
                maxLength: 10,
                controller: noTelpController,
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
                text: "Email",
                style: CommonText.body1(
                  color: MyColors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              FormBuilderTextField(
                name: 'email',
                maxLines: 1,
                maxLength: 10,
                controller: emailController,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(context),
                  ],
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 20,
              ),
              CommonText.text(
                text: "Harga Khusus",
                style: CommonText.body1(
                  color: MyColors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              DropdownButton<String>(
                value: hargaKhusus,
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
                    hargaKhusus = data;
                  });
                },
                items: listHargaKhusus,
              ),
              if ((hargaKhusus ?? '').isEmpty && onError)
                Container(
                  padding: EdgeInsets.only(top: 4),
                  child: CommonText.text(
                      text: 'This field is required',
                      style: CommonText.body1(color: Colors.red)),
                ),
              SizedBox(
                height: 30,
              ),
              CommonWidgets.containedButton(
                text: widget.editCustomer == null ? 'Add' : 'Edit',
                onPressed: submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

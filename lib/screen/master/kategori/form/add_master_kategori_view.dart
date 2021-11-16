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

import 'add_master_kategori_controller.dart';

class AddMasterKategoriView extends AddMasterKategoriController {
  @override
  Widget build(BuildContext context) {
    return CommonWidgets.baseFormContainer(
      context: context,
      child: SafeArea(
        child: Scaffold(
          appBar: CommonWidgets.customAppBar(context,
              titleText: 'Add Master Kategori'),
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
                text: "Nama Kategori",
                style: CommonText.body1(
                  color: MyColors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              FormBuilderTextField(
                name: 'namakategori',
                maxLines: 1,
                controller: namaKategoriController,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(context),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CommonWidgets.containedButton(
                text: widget.editKategori == null ? 'Add' : 'Edit',
                onPressed: submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

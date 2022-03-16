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
import 'add_master_satuan_controller.dart';

class AddMasterSatuanView extends AddMasterSatuanController {
  @override
  Widget build(BuildContext context) {
    return CommonWidgets.baseFormContainer(
      context: context,
      child: SafeArea(
        child: Scaffold(
          appBar: CommonWidgets.customAppBar(context,
              titleText: 'Add Master Satuan'),
          backgroundColor: MyColors.white,
          body: _addMasterSatuanBody(),
        ),
      ),
    );
  }

  _addMasterSatuanBody() {
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
                text: "Nama Satuan",
                style: CommonText.body1(
                  color: MyColors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              FormBuilderTextField(
                name: 'namasatuan',
                maxLines: 1,
                controller: namaSatuanController,
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
                text: widget.editSatuan == null ? 'Add' : 'Edit',
                onPressed: submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

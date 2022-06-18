import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penjualan/screen/utilities/account/account_controller.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AccountView extends AccountController {
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
          body: _changeBody(),
        ),
      ),
    );
  }

  _changeBody() {
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
              SizedBox(
                height: 20,
              ),
              CommonText.text(
                text: "Change Username Password",
                style: CommonText.title(
                  color: MyColors.black,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CommonText.text(
                text: "Username",
                style: CommonText.body1(
                  color: MyColors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              FormBuilderTextField(
                name: 'username',
                maxLines: 1,
                controller: usernameController,
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
                text: "Password",
                style: CommonText.body1(
                  color: MyColors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              FormBuilderTextField(
                name: 'password',
                maxLines: 1,
                obscureText: true,
                controller: passwordController,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(context),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              CommonWidgets.containedButton(
                text: 'Update',
                onPressed: () => changeUsernamePass(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penjualan/screen/login/login_controller.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoginView extends LoginController {
  @override
  Widget build(BuildContext context) {
    return CommonWidgets.baseFormContainer(
      context: context,
      child: SafeArea(
        child: Scaffold(
          appBar: CommonWidgets.noAppBar(
            systemUiOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          body: LoginBody(),
        ),
      ),
    );
  }
}

class LoginBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 15,
      ),
      color: MyColors.white,
      child: FormBuilder(
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            CommonText.text(
              text: "Login",
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
            CupertinoTextField(),
            SizedBox(
              height: 40,
            ),
            CommonWidgets.containedButton(
              text: 'Login',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

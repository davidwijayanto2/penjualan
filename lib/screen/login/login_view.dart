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
          body: LoginBody(
            loginCheck: loginCheck,
            usernameController: usernameController,
            passwordController: passwordController,
          ),
        ),
      ),
    );
  }
}

class LoginBody extends StatelessWidget {
  final Function() loginCheck;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  LoginBody(
      {required this.loginCheck,
      required this.passwordController,
      required this.usernameController});
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
              maxLines: 1,
              controller: usernameController,
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
            ),
            SizedBox(
              height: 40,
            ),
            CommonWidgets.containedButton(
              text: 'Login',
              onPressed: () => loginCheck(),
            ),
          ],
        ),
      ),
    );
  }
}

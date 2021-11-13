import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/my_colors.dart';

class CommonWidgets {
  static noAppBar(
      {SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle.dark}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(
        0.0,
      ),
      child: AppBar(
        systemOverlayStyle: systemUiOverlayStyle,
        elevation: 0.0,
        backgroundColor: MyColors.transparent,
        automaticallyImplyLeading: false,
      ),
    );
  }

  static Widget containedButton({
    Color textColor = MyColors.white,
    Color? backgroundColor = MyColors.themeColor1,
    double width = double.infinity,
    double height = 40,
    TextAlign textAlign = TextAlign.center,
    int maxLines = 100,
    TextOverflow textOverflow = TextOverflow.ellipsis,
    TextStyle? textStyle,
    double radius = 8,
    BorderRadius? borderRadius,
    double? horizontalPadding,
    Color? highlightColor,
    Color? splashColor,
    double? fontSize,
    String text = "",
    Widget? child,
    required Function()? onPressed,
    double? maxWidth,
    double? maxHeight,
  }) {
    return Container(
      constraints: BoxConstraints(
        minWidth: width,
        maxWidth: maxWidth ?? width,
        minHeight: height,
        maxHeight: maxHeight ?? height,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(radius),
          ),
          elevation: 0,
          primary: backgroundColor,
          onPrimary: highlightColor ?? null,
          onSurface: splashColor ?? null,
          padding: horizontalPadding == null
              ? null
              : EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
        ),
        onPressed: onPressed,
        child: child ??
            CommonText.text(
              text: text,
              align: textAlign,
              maxLines: maxLines,
              overflow: textOverflow,
              style: textStyle == null
                  ? CommonText.customSize(
                      color: textColor,
                      fontSize: fontSize ?? 14,
                    )
                  : textStyle,
            ),
      ),
    );
  }

  static Widget outlinedButton({
    Color textColor = MyColors.themeColor1,
    Color borderColor = MyColors.themeColor1,
    Color backgroundColor = MyColors.white,
    double? width = double.infinity,
    double? height = 40,
    TextAlign textAlign = TextAlign.center,
    int maxLines = 100,
    TextOverflow textOverflow = TextOverflow.ellipsis,
    TextStyle? textStyle,
    double radius = 8,
    double borderWidth = 1.0,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    Widget? child,
    required String? text,
    required Function()? onPressed,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(radius),
            side: BorderSide(
              color: borderColor,
              width: borderWidth,
            ),
          ),
          elevation: 0,
          primary: backgroundColor,
          padding: padding,
        ),
        onPressed: onPressed,
        child: child ??
            CommonText.text(
              text: text!,
              align: textAlign,
              maxLines: maxLines,
              overflow: textOverflow,
              style: textStyle == null
                  ? CommonText.body2(
                      color: textColor,
                    )
                  : textStyle,
            ),
      ),
    );
  }

  static Widget baseContainer({required Widget child}) {
    return Container(
      color: MyColors.white,
      child: child,
    );
  }

  static Widget baseFormContainer({
    required BuildContext context,
    required Widget child,
    Color color = MyColors.white,
  }) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Container(
        color: color,
        child: child,
      ),
    );
  }

  static customAppBar(
    BuildContext context, {
    required String titleText,
    void Function()? leadingAction,
    Widget? trailing,
    Color backgroundColor = MyColors.white,
    bool enableBorder = true,
  }) {
    Border? border = (enableBorder)
        ? Border(
            bottom: BorderSide(
              color: MyColors.dementialGray,
              width: 1,
              style: BorderStyle.solid,
            ),
          )
        : null;

    return CupertinoNavigationBar(
      automaticallyImplyLeading: false,
      border: border,
      backgroundColor: backgroundColor,
      transitionBetweenRoutes: false,
      leading: Container(
        transform: Matrix4.translationValues(-6.5, 0, 0),
        child: iconButton(
          icon: FontAwesomeIcons.chevronLeft,
          iconSize: 19,
          iconColor: MyColors.black,
          height: 32,
          width: 32,
          backgroundColor: MyColors.transparent,
          onPressed: leadingAction ?? () => Navigator.pop(context),
        ),
      ),
      middle: CommonText.text(
        text: titleText,
        style: CommonText.title(
          color: MyColors.themeColor1,
        ),
      ),
      trailing: trailing,
    );
  }

  static iconButton({
    required IconData icon,
    required Function()? onPressed,
    Color iconColor = MyColors.white,
    double iconSize = 17,
    Color backgroundColor = MyColors.themeColor1,
    double width = 34,
    double height = 34,
    double radius = 100,
    double elevation = 0.0,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      child: new RawMaterialButton(
        fillColor: backgroundColor,
        shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        elevation: elevation,
        child: Center(
          child: Icon(
            icon,
            color: iconColor,
            size: iconSize,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  static Widget roundedContainer({
    Key? key,
    double radius = 8,
    Color backgroundColor = MyColors.white,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16.0),
    Widget? child,
    Color borderColor = MyColors.dementialGray,
    double borderWidth = 1,
    bool bordered = false,
  }) {
    return Container(
      key: key,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: bordered
            ? Border.all(width: borderWidth, color: borderColor)
            : null,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: child,
    );
  }

  static horizontalDivider({
    Color? color,
    double? height,
    double? padding,
  }) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: padding == null ? 0.0 : padding),
      child: Container(
        height: height == null ? 1 : height,
        width: double.infinity,
        color: color == null ? MyColors.dementialGray : color,
      ),
    );
  }

  static verticalDivider({color, width}) {
    return Container(
      height: double.infinity,
      width: width == null ? 1 : width,
      color: color == null ? MyColors.dementialGray : color,
    );
  }
}

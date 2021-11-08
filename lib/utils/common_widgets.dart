import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  }) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Container(
        color: MyColors.white,
        child: child,
      ),
    );
  }
}

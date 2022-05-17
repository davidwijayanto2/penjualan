import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/utils/common_helper.dart';
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

  static outlinedIconButton({
    required IconData icon,
    required Function() onPressed,
    Color iconColor = MyColors.textGray,
    double iconSize = 17,
    Color backgroundColor = MyColors.white,
    Color borderColor = MyColors.textGray,
    double borderWidth = 0.5,
    double width = 34,
    double height = 34,
    double radius = 100,
  }) {
    return Container(
      width: width,
      height: height,
      child: new RawMaterialButton(
        fillColor: backgroundColor,
        shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        elevation: 0.0,
        child: Center(
          child: Transform.translate(
            offset: Offset(0.25, 0),
            child: Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
          ),
        ),
        onPressed: onPressed,
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

  static textIconButton({
    required String? text,
    required Function() onPressed,
    double? width,
    double height = 45,
    double borderWidth = 1.0,
    Color borderColor = MyColors.dementialGray,
    Color backgroundColor = MyColors.white,
    Color textColor = MyColors.black,
    BorderRadius? borderRadius,
    Icon? prefixIcon,
    Icon? suffixIcon,
    Function()? prefixPress,
    Function()? suffixPress,
    bool expandedText = true,
    bool allBorder = true,
    TextStyle? textStyle,
    EdgeInsets? padding,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          width: width ?? double.infinity,
          height: height,
          decoration: BoxDecoration(
            borderRadius:
                !allBorder ? null : borderRadius ?? BorderRadius.circular(8),
            color: backgroundColor,
            border: allBorder
                ? Border.all(
                    width: borderWidth,
                    color: borderColor,
                  )
                : Border(
                    bottom: BorderSide(
                      width: borderWidth,
                      color: borderColor,
                    ),
                  ),
          ),
          padding: padding != null
              ? padding
              : allBorder
                  ? EdgeInsets.symmetric(
                      horizontal: 16,
                    )
                  : EdgeInsets.only(
                      left: 0,
                      right: 0,
                      bottom: 6,
                      top: 18,
                    ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (prefixIcon != null)
                GestureDetector(onTap: prefixPress, child: prefixIcon),
              if (prefixIcon != null)
                SizedBox(
                  width: 8,
                ),
              expandedText
                  ? Expanded(
                      child: CommonText.text(
                        text: text!,
                        maxLines: 1,
                        style: textStyle ?? CommonText.body1(color: textColor),
                      ),
                    )
                  : CommonText.text(
                      text: text!,
                      maxLines: 1,
                      style: textStyle ?? CommonText.body1(color: textColor),
                    ),
              if (suffixIcon != null)
                SizedBox(
                  width: 8,
                ),
              if (suffixIcon != null)
                GestureDetector(onTap: suffixPress, child: suffixIcon),
            ],
          )),
    );
  }

  static errorMessage(
    context, {
    String? fieldName,
    String? message = 'This field is required',
    TextStyle? textStyle,
    double iconSize = 15.0,
  }) {
    if (fieldName != null &&
        (message == null ||
            message == "" ||
            message == "This field is required")) {
      message = "$fieldName is required";
    } else {
      message = message;
    }

    return Container(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            FontAwesomeIcons.exclamationCircle,
            color: MyColors.red,
            size: iconSize,
          ),
          SizedBox(width: 4),
          Flexible(
            child: CommonText.text(
              text: message ?? '',
              style: textStyle ?? CommonText.body2(color: MyColors.red),
            ),
          ),
        ],
      ),
    );
  }
}

typedef void CounterChangeCallback(num value);

// ignore: must_be_immutable
class CustomStepper extends StatelessWidget {
  final CounterChangeCallback onChanged;

  CustomStepper({
    Key? key,
    required num? initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.decimalPlaces,
    this.color,
    this.textStyle,
    this.step = 1,
    this.buttonSize = 25,
    this.enableText = true,
  })  : assert(initialValue != null),
        assert(maxValue > minValue),
        assert(initialValue! >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedValue = initialValue!,
        super(key: key);

  ///min value user can pick
  final num minValue;

  ///max value user can pick
  final num maxValue;

  /// decimal places required by the counter
  final int decimalPlaces;

  ///Currently selected integer value
  num selectedValue;

  bool enableText;

  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final num step;

  /// indicates the color of fab used for increment and decrement
  Color? color;

  /// text syle
  TextStyle? textStyle;

  final double buttonSize;

  void _incrementCounter() {
    if (selectedValue + step <= maxValue) {
      onChanged((selectedValue + step));
    }
  }

  void _decrementCounter() {
    if (selectedValue - step >= minValue) {
      onChanged((selectedValue - step));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    color = color ?? themeData.accentColor;
    textStyle = textStyle ?? CommonText.body1(color: MyColors.textGray);

    return new Container(
      padding: new EdgeInsets.all(4.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: buttonSize,
            height: buttonSize,
            child: new RawMaterialButton(
              fillColor: MyColors.white,
              shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(
                  color: selectedValue > minValue
                      ? MyColors.textGray
                      : MyColors.dementialGray,
                  width: 2.0,
                ),
              ),
              elevation: 0.0,
              child: Icon(
                Icons.remove,
                color: selectedValue > minValue
                    ? MyColors.textGray
                    : MyColors.dementialGray,
                size: 20,
              ),
              onPressed: _decrementCounter,
            ),
          ),
          if (enableText)
            SizedBox(
              width: 12,
            ),
          if (enableText)
            new Container(
              padding: EdgeInsets.all(4.0),
              child: new Text(
                '${num.parse((selectedValue).toStringAsFixed(decimalPlaces))}',
                style: textStyle,
              ),
            ),
          SizedBox(
            width: 12,
          ),
          Container(
            width: buttonSize,
            height: buttonSize,
            child: new RawMaterialButton(
              fillColor: MyColors.white,
              shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(
                  color: selectedValue < maxValue
                      ? MyColors.textGray
                      : MyColors.dementialGray,
                  width: 2.0,
                ),
              ),
              elevation: 0.0,
              child: Icon(
                Icons.add,
                color: selectedValue < maxValue
                    ? MyColors.textGray
                    : MyColors.dementialGray,
                size: 20,
              ),
              onPressed: _incrementCounter,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomStepperWithBorder extends StatelessWidget {
  final CounterChangeCallback onChanged;

  CustomStepperWithBorder({
    Key? key,
    required num initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.decimalPlaces,
    this.allBorder = true,
    this.color,
    this.textStyle,
    this.step = 1,
    this.borderWidth = 1,
    this.buttonSize = 25,
    this.padding,
  })  : assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedValue = initialValue,
        super(key: key);

  ///min value user can pick
  final num minValue;

  ///max value user can pick
  final num maxValue;

  /// decimal places required by the counter
  final int decimalPlaces;

  ///Currently selected integer value
  num selectedValue;

  final bool allBorder;

  final EdgeInsets? padding;

  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final num step;

  /// indicates the color of fab used for increment and decrement
  Color? color;

  /// text style
  TextStyle? textStyle;

  /// border width
  final double borderWidth;

  final double buttonSize;

  void _incrementCounter() {
    if (selectedValue + step <= maxValue) {
      onChanged((selectedValue + step));
    }
  }

  void _decrementCounter() {
    if (selectedValue - step >= minValue) {
      onChanged((selectedValue - step));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    color = color ?? themeData.accentColor;
    textStyle = textStyle ?? CommonText.body1(color: MyColors.textGray);

    return new Container(
      height: 45,
      decoration: BoxDecoration(
        border: allBorder
            ? Border.all(
                width: borderWidth,
                color: MyColors.dementialGray,
              )
            : Border(
                bottom: BorderSide(
                  width: borderWidth,
                  color: MyColors.dementialGray,
                ),
              ),
        borderRadius: allBorder ? BorderRadius.circular(10) : null,
      ),
      padding: padding != null
          ? padding
          : EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonText.text(
            text:
                '${num.parse((selectedValue).toStringAsFixed(decimalPlaces))}',
            maxLines: 1,
            style: CommonText.body1(color: MyColors.black),
          ),
          Row(
            children: <Widget>[
              Container(
                width: buttonSize,
                height: buttonSize,
                child: new RawMaterialButton(
                  fillColor: MyColors.white,
                  shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(
                      color: selectedValue > 0
                          ? MyColors.textGray
                          : MyColors.dementialGray,
                      width: 2.0,
                    ),
                  ),
                  elevation: 0.0,
                  child: Icon(
                    Icons.remove,
                    color: selectedValue > 0
                        ? MyColors.textGray
                        : MyColors.dementialGray,
                    size: 20,
                  ),
                  onPressed: _decrementCounter,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Container(
                width: buttonSize,
                height: buttonSize,
                child: new RawMaterialButton(
                  fillColor: MyColors.white,
                  shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(
                      color: MyColors.textGray,
                      width: 2.0,
                    ),
                  ),
                  elevation: 0.0,
                  child: Icon(
                    Icons.add,
                    color: MyColors.textGray,
                    size: 20,
                  ),
                  onPressed: _incrementCounter,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomStepperStringValue extends StatelessWidget {
  final CounterChangeCallback onChanged;

  CustomStepperStringValue({
    Key? key,
    required num initialValue,
    this.prefix,
    this.zeroValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.decimalPlaces,
    this.color,
    this.textStyle,
    this.step = 1,
    this.buttonSize = 25,
    this.enableText = true,
  })  : assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedValue = initialValue,
        super(key: key);

  ///min value user can pick
  final num minValue;

  ///max value user can pick
  final num maxValue;

  /// decimal places required by the counter
  final int decimalPlaces;

  ///Currently selected integer value
  num selectedValue;

  bool enableText;

  final String? prefix;

  final String? zeroValue;

  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final num step;

  /// indicates the color of fab used for increment and decrement
  Color? color;

  /// text syle
  TextStyle? textStyle;

  final double buttonSize;

  void _incrementCounter() {
    if (selectedValue + step <= maxValue) {
      onChanged((selectedValue + step));
    }
  }

  void _decrementCounter() {
    if (selectedValue - step >= minValue) {
      onChanged((selectedValue - step));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    color = color ?? themeData.accentColor;
    textStyle = textStyle ?? CommonText.body1(color: MyColors.textGray);

    return new Container(
      padding: new EdgeInsets.all(4.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: buttonSize,
            height: buttonSize,
            child: new RawMaterialButton(
              fillColor: MyColors.white,
              shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(
                  color: selectedValue > minValue
                      ? MyColors.textGray
                      : MyColors.dementialGray,
                  width: 2.0,
                ),
              ),
              elevation: 0.0,
              child: Icon(
                Icons.remove,
                color: selectedValue > minValue
                    ? MyColors.textGray
                    : MyColors.dementialGray,
                size: 20,
              ),
              onPressed: _decrementCounter,
            ),
          ),
          // if (enableText)
          //   SizedBox(
          //     width: 12,
          //   ),
          // if (enableText)
          new Container(
            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
            width: 60,
            alignment: Alignment.center,
            child: new Text(
              int.parse(selectedValue.toString()) > 0
                  ? '${prefix ?? ''} ${num.parse((selectedValue).toStringAsFixed(decimalPlaces))}'
                  : zeroValue!,
              style: textStyle,
            ),
          ),
          // SizedBox(
          //   width: 12,
          // ),
          Container(
            width: buttonSize,
            height: buttonSize,
            child: new RawMaterialButton(
              fillColor: MyColors.white,
              shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(
                  color: MyColors.textGray,
                  width: 2.0,
                ),
              ),
              elevation: 0.0,
              child: Icon(
                Icons.add,
                color: MyColors.textGray,
                size: 20,
              ),
              onPressed: _incrementCounter,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomMoneyField extends StatefulWidget {
  final TextEditingController controller;
  final InputDecoration decoration;
  final TextStyle? style;
  final int maxLines;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final bool enableZero;
  final ThousandSeparator separator;
  final Widget? errorWidget;
  final Function(String)? onChange;
  final List<Widget> validators;
  final Function(bool)? onFieldValid;
  final int? maxLength;

  const CustomMoneyField({
    Key? key,
    required this.controller,
    this.decoration = const InputDecoration(),
    this.style,
    this.maxLines = 1,
    this.initialValue,
    this.inputFormatters,
    this.enableZero = false,
    this.separator = ThousandSeparator.Comma,
    this.errorWidget,
    this.onChange,
    this.validators = const [],
    this.onFieldValid,
    this.maxLength,
  }) : super(key: key);

  @override
  _CustomMoneyFieldState createState() => _CustomMoneyFieldState();
}

class _CustomMoneyFieldState extends State<CustomMoneyField> {
  final _isValid = ValueNotifier<bool>(true);
  Widget? _errorMessage;

  @override
  void initState() {
    if (widget.initialValue != null) {
      widget.controller.text = toCurrencyString(
        widget.initialValue!,
        mantissaLength: 0,
        thousandSeparator: widget.separator,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          decoration: widget.decoration,
          style: widget.style,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.deny('-'),
            MoneyInputFormatter(
              thousandSeparator: widget.separator,
              mantissaLength: 0,
            ),
            if (widget.inputFormatters != null) ...widget.inputFormatters!,
          ],
          onChanged: (val) {
            CommonHelpers.moneyFieldNormalizer(
              controller: widget.controller,
              enableZero: widget.enableZero,
              separator: widget.separator,
              notifier: () => setState(() {}),
            );

            if (widget.onChange != null) widget.onChange!(val);
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _isValid,
          builder: (_, isValid, child) => Visibility(
            visible: !isValid,
            child: child!,
          ),
          child: _errorMessage ?? Container(),
        ),
      ],
    );
  }
}

YYDialog loadingDialog(BuildContext context) {
  return YYDialog().build(context)
    ..barrierDismissible = false
    ..borderRadius = 24.0
    ..widget(
      Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(),
        ),
      ),
    )
    ..show();
}

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({
    Key? key,
    required this.child,
    required this.value,
    required this.onChanged,
    this.validatorValue = false,
    this.checkBoxColor = MyColors.orange,
    this.isExpand = true,
    this.padding,
  });

  final bool? value;
  final bool validatorValue;
  final Widget child;
  final Function() onChanged;
  final Color checkBoxColor;
  final bool isExpand;
  final EdgeInsetsGeometry? padding;

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: widget.onChanged,
      child: Container(
        padding: widget.padding ??
            EdgeInsets.only(
                top: widget.isExpand ? 10 : 0,
                bottom: widget.isExpand ? 10 : 0,
                right: 10
                //horizontal: 10,
                ),
        child: Row(
          crossAxisAlignment: widget.isExpand
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: <Widget>[
            widget.isExpand
                ? Expanded(
                    child: widget.child,
                  )
                : widget.child,
            SizedBox(
              width: 8,
            ),
            Icon(
              widget.value!
                  ? FontAwesomeIcons.solidCheckSquare
                  : FontAwesomeIcons.square,
              color: widget.validatorValue && !widget.value!
                  ? MyColors.red
                  : widget.checkBoxColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

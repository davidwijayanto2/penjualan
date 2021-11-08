import 'package:flutter/material.dart';

class CommonText {
  static Text text({
    Key? key,
    required String text,
    required TextStyle style,
    TextAlign? align,
    TextOverflow? overflow,
    int? maxLines,
    bool? softWrap,
  }) {
    return Text(
      text,
      key: key,
      style: style,
      overflow: overflow == null ? TextOverflow.ellipsis : overflow,
      maxLines: maxLines == null ? 100 : maxLines,
      textAlign: align == null ? TextAlign.start : align,
      softWrap: softWrap == null ? false : softWrap,
    );
  }

  static TextStyle title({
    required Color color,
    TextDecoration? underline,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      color: color,
      fontWeight: fontWeight ?? FontWeight.bold,
      fontSize: 20,
      decoration: underline ?? underline,
    );
  }

  static TextStyle body1({
    required Color color,
    TextDecoration? underline,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      color: color,
      fontWeight: fontWeight ?? FontWeight.normal,
      fontSize: 16,
      decoration: underline ?? underline,
      fontStyle: fontStyle,
    );
  }

  static TextStyle body2({
    required Color color,
    TextDecoration? underline,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      color: color,
      fontWeight: fontWeight ?? FontWeight.normal,
      fontSize: 14,
      decoration: underline ?? underline,
      fontStyle: fontStyle,
    );
  }

  static TextStyle body3({
    required Color color,
    TextDecoration? underline,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      color: color,
      fontWeight: fontWeight ?? FontWeight.normal,
      fontSize: 12,
      decoration: underline ?? underline,
      fontStyle: fontStyle,
    );
  }

  static TextStyle customSize({
    required Color color,
    required double fontSize,
    TextDecoration? underline,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      color: color,
      fontWeight: fontWeight ?? FontWeight.normal,
      fontSize: fontSize,
      decoration: underline ?? underline,
      fontStyle: fontStyle,
    );
  }
}

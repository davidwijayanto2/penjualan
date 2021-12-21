import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class CommonHelpers {
  static moneyFieldNormalizer({
    required TextEditingController? controller,
    ThousandSeparator separator = ThousandSeparator.Comma,
    Function? notifier,
    bool enableZero = false,
  }) {
    assert(
      separator == ThousandSeparator.Comma ||
          separator == ThousandSeparator.Period,
      "moneyFieldNormalizer@CommonHelpers: Separator must be Period or Comma.",
    );
    if (controller == null) return;

    var char = ",";
    if (separator == ThousandSeparator.Period) char = ".";

    final val = int.tryParse(controller.text.replaceAll(char, "").trim()) ?? 0;
    if (val == 0) {
      if (!enableZero) controller.text = "";
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }

    if (controller.text.length >= 2) {
      final str = controller.text.substring(0, 1);
      final temp = int.tryParse(str.replaceAll(char, "")) ?? 0;
      if (temp == 0) {
        controller.text = toCurrencyString(
          "$val",
          mantissaLength: 0,
          thousandSeparator: separator,
        );
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      }
    }
    if (notifier != null) notifier();
  }

  static double convertMMtoPx({required double mm}) {
    return mm * 3.7795275591;
  }
}

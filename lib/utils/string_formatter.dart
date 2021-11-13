import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

String formatMoney({required num value}) {
  return value.toCurrencyString(
    leadingSymbol: 'Rp. ',
    thousandSeparator: ThousandSeparator.Comma,
    mantissaLength: 0,
    useSymbolPadding: false,
  );
}

String thousandSeparator(var number, {separator = ','}) {
  if (number > -1000 && number < 1000) return number.round().toString();
  final String digits = number.round().abs().toString();
  final StringBuffer result = StringBuffer(number < 0 ? '-' : '');
  final int maxDigitIndex = digits.length - 1;
  for (int i = 0; i <= maxDigitIndex; i += 1) {
    result.write(digits[i]);
    if (i < maxDigitIndex && (maxDigitIndex - i) % 3 == 0)
      result.write(separator);
  }
  return result.toString();
}

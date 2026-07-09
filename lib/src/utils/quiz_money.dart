/// Formats an integer amount with non-breaking-space thousands separators.
///
/// `60000` → `60 000`, `10000` → `10 000`. Keeps the number on one line.
String formatQuizAmount(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(digits[i]);
  }
  return value < 0 ? '-$buffer' : buffer.toString();
}

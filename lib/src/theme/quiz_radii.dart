import 'package:flutter/painting.dart';

/// Design tokens — radii and spacing constants.
class QuizRadii {
  const QuizRadii._();

  static const Radius sm = Radius.circular(10);
  static const Radius md = Radius.circular(14);
  static const Radius lg = Radius.circular(20);
  static const Radius xl = Radius.circular(28);
  static const Radius pill = Radius.circular(999);

  static const BorderRadius brSm = BorderRadius.all(sm);
  static const BorderRadius brMd = BorderRadius.all(md);
  static const BorderRadius brLg = BorderRadius.all(lg);
  static const BorderRadius brXl = BorderRadius.all(xl);
  static const BorderRadius brPill = BorderRadius.all(pill);

  static const double contentPadding = 20;
  static const double gridGap = 12;
}

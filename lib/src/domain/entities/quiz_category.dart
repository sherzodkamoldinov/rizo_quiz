import 'package:equatable/equatable.dart';

class QuizCategory extends Equatable {
  const QuizCategory({
    required this.id,
    required this.key,
    required this.name,
    required this.subtitle,
    required this.glyph,
    required this.sortOrder,
  });

  final String id;

  /// Stable slug, e.g. 'mix', 'science'. Used for analytics, not for i18n.
  final String key;

  /// Localized display name for the current language.
  final String name;

  /// Localized short tagline shown under the title.
  final String subtitle;

  /// Single character / short glyph drawn in serif font on the category card.
  final String glyph;

  final int sortOrder;

  @override
  List<Object?> get props => [id, key, name, subtitle, glyph, sortOrder];
}

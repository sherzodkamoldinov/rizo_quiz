import 'package:flutter/material.dart';

import '../../localization/quiz_strings.dart';
import '../../theme/quiz_colors.dart';
import '../../theme/quiz_radii.dart';
import '../../theme/quiz_typography.dart';
import '../widgets/atoms/quiz_eyebrow.dart';
import '../widgets/atoms/quiz_serif_heading.dart';

/// Открывает статичный информационный bottom sheet о еженедельных наградах.
///
/// Не читает данные из Supabase — таблица победителей закрыта RLS. Показывает
/// только правила акции (топ-10 недели получают промокод, как и где забрать).
Future<void> showQuizAwardsSheet({
  required BuildContext context,
  required String lang,
}) {
  final colors = QuizColorsScope.of(context);
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.bg,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: QuizRadii.xl),
    ),
    builder: (_) => QuizAwardsSheet(lang: lang),
  );
}

class QuizAwardsSheet extends StatelessWidget {
  const QuizAwardsSheet({required this.lang, super.key});

  final String lang;

  static const List<_AwardItem> _items = [
    _AwardItem(Icons.emoji_events_rounded, 'awards_row1_title', 'awards_row1_text'),
    _AwardItem(Icons.bolt_rounded, 'awards_row2_title', 'awards_row2_text'),
    _AwardItem(Icons.event_rounded, 'awards_row3_title', 'awards_row3_text'),
    _AwardItem(Icons.card_giftcard_rounded, 'awards_row4_title', 'awards_row4_text'),
  ];

  @override
  Widget build(BuildContext context) {
    final strings = QuizStrings.of(lang);
    final colors = QuizColorsScope.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          QuizRadii.contentPadding,
          16,
          QuizRadii.contentPadding,
          MediaQuery.of(context).viewInsets.bottom + 28,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.line2,
                  borderRadius: QuizRadii.brPill,
                ),
              ),
            ),
            const SizedBox(height: 20),
            QuizEyebrow(strings.get('awards_eyebrow')),
            const SizedBox(height: 10),
            QuizSerifHeading(
              text: strings.get('awards_title_part_1'),
              accent: strings.get('awards_title_part_2'),
            ),
            const SizedBox(height: 10),
            Text(
              strings.get('awards_subtitle'),
              style: QuizTypography.body.copyWith(color: colors.ink2),
            ),
            const SizedBox(height: 22),
            for (var i = 0; i < _items.length; i++)
              _AwardInfoRow(
                item: _items[i],
                strings: strings,
                isLast: i == _items.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _AwardItem {
  const _AwardItem(this.icon, this.titleKey, this.textKey);

  final IconData icon;
  final String titleKey;
  final String textKey;
}

class _AwardInfoRow extends StatelessWidget {
  const _AwardInfoRow({
    required this.item,
    required this.strings,
    required this.isLast,
  });

  final _AwardItem item;
  final QuizStrings strings;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.claySoft,
              borderRadius: QuizRadii.brMd,
            ),
            alignment: Alignment.center,
            child: Icon(item.icon, size: 20, color: colors.clay2),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.get(item.titleKey),
                  style: QuizTypography.bodyMedium.copyWith(color: colors.ink),
                ),
                const SizedBox(height: 2),
                Text(
                  strings.get(item.textKey),
                  style: QuizTypography.bodySmall.copyWith(color: colors.mute),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

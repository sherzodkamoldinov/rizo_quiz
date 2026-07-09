import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/quiz_bloc.dart';
import '../../domain/entities/quiz_prize_tier.dart';
import '../../localization/quiz_strings.dart';
import '../../theme/quiz_colors.dart';
import '../../theme/quiz_radii.dart';
import '../../theme/quiz_typography.dart';
import '../../utils/quiz_money.dart';
import '../widgets/atoms/quiz_eyebrow.dart';
import '../widgets/atoms/quiz_serif_heading.dart';

/// Открывает статичный информационный bottom sheet о еженедельных наградах.
///
/// Правила акции — статика (топ-10 недели получают промокод, как и где забрать).
/// Призовой фонд по местам — из `state.prizeTiers` (таблица `quiz_prize_tiers`).
/// Промокоды не читаются: `quiz_weekly_winners` закрыта RLS.
Future<void> showQuizAwardsSheet({
  required BuildContext context,
  required String lang,
}) {
  final colors = QuizColorsScope.of(context);
  final bloc = context.read<QuizBloc>();
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.bg,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: QuizRadii.xl),
    ),
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: QuizAwardsSheet(lang: lang),
    ),
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
      child: SingleChildScrollView(
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
            BlocBuilder<QuizBloc, QuizGameState>(
              buildWhen: (a, b) => a.prizeTiers != b.prizeTiers,
              builder: (context, state) => state.prizeTiers.isEmpty
                  ? const SizedBox.shrink()
                  : _PrizePool(tiers: state.prizeTiers, strings: strings),
            ),
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

class _PrizePool extends StatelessWidget {
  const _PrizePool({required this.tiers, required this.strings});

  final List<QuizPrizeTier> tiers;
  final QuizStrings strings;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.get('awards_prize_title'),
          style: QuizTypography.bodyMedium.copyWith(color: colors.ink),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: QuizRadii.brLg,
            border: Border.all(color: colors.line),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Column(
            children: [
              for (var i = 0; i < tiers.length; i++)
                _PrizeRow(
                  tier: tiers[i],
                  strings: strings,
                  showDivider: i != tiers.length - 1,
                ),
            ],
          ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}

class _PrizeRow extends StatelessWidget {
  const _PrizeRow({
    required this.tier,
    required this.strings,
    required this.showDivider,
  });

  final QuizPrizeTier tier;
  final QuizStrings strings;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Container(
      decoration: BoxDecoration(
        border: showDivider
            ? Border(bottom: BorderSide(color: colors.line))
            : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _PrizeBadge(rank: tier.rankFrom),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              strings.prizePlaceLabel(tier.rankFrom, tier.rankTo),
              style: QuizTypography.bodyMedium.copyWith(color: colors.ink),
            ),
          ),
          Text(
            '${formatQuizAmount(tier.amount)} ${strings.currencyLabel(tier.currency)}',
            style: QuizTypography.bodyMedium.copyWith(color: colors.clay2),
          ),
        ],
      ),
    );
  }
}

class _PrizeBadge extends StatelessWidget {
  const _PrizeBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final medal = switch (rank) {
      1 => '🥇',
      2 => '🥈',
      3 => '🥉',
      _ => null,
    };
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: colors.claySoft,
        borderRadius: QuizRadii.brSm,
      ),
      alignment: Alignment.center,
      child: medal != null
          ? Text(medal, style: const TextStyle(fontSize: 17))
          : Icon(Icons.workspace_premium_outlined, size: 18, color: colors.clay2),
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

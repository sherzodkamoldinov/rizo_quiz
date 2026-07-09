import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../domain/entities/quiz_my_win.dart';
import '../../localization/quiz_strings.dart';
import '../../theme/quiz_colors.dart';
import '../../theme/quiz_radii.dart';
import '../../theme/quiz_typography.dart';
import '../../utils/quiz_money.dart';
import '../widgets/atoms/quiz_cta_ghost.dart';
import '../widgets/atoms/quiz_cta_primary.dart';
import '../widgets/atoms/quiz_eyebrow.dart';

/// Callback the host implements to share the rendered win card (PNG bytes) —
/// e.g. to Instagram Stories. If null, the share button is hidden.
typedef QuizShareWinCallback = Future<void> Function(Uint8List imagePng);

/// One-time congratulation sheet for a weekly win. Shows the place + prize
/// (no promocode) and a share button that captures a branded card to PNG.
Future<void> showQuizCongratsSheet({
  required BuildContext context,
  required QuizMyWin win,
  required String lang,
  required String playerName,
  QuizShareWinCallback? onShareWin,
}) {
  final colors = QuizColorsScope.of(context);
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.bg,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: QuizRadii.xl),
    ),
    builder: (_) => QuizCongratsSheet(
      win: win,
      lang: lang,
      playerName: playerName,
      onShareWin: onShareWin,
    ),
  );
}

class QuizCongratsSheet extends StatefulWidget {
  const QuizCongratsSheet({
    required this.win,
    required this.lang,
    required this.playerName,
    this.onShareWin,
    super.key,
  });

  final QuizMyWin win;
  final String lang;
  final String playerName;
  final QuizShareWinCallback? onShareWin;

  @override
  State<QuizCongratsSheet> createState() => _QuizCongratsSheetState();
}

class _QuizCongratsSheetState extends State<QuizCongratsSheet> {
  final GlobalKey _cardKey = GlobalKey();
  bool _sharing = false;

  Future<void> _share() async {
    final cb = widget.onShareWin;
    if (cb == null || _sharing) return;
    setState(() => _sharing = true);
    try {
      final boundary =
          _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      // 270×480 logical at ratio 4 → exactly 1080×1920 (Instagram Story size).
      final image = await boundary.toImage(pixelRatio: 4);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) return;
      await cb(data.buffer.asUint8List());
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = QuizStrings.of(widget.lang);
    final colors = QuizColorsScope.of(context);
    final place = strings.prizePlaceLabel(widget.win.rank, widget.win.rank);
    final prize =
        '${formatQuizAmount(widget.win.prizeAmount)} '
        '${strings.currencyLabel(widget.win.prizeCurrency)}';

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          QuizRadii.contentPadding,
          16,
          QuizRadii.contentPadding,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            const SizedBox(height: 18),
            Center(child: QuizEyebrow(strings.get('congrats_eyebrow'))),
            const SizedBox(height: 10),
            Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${strings.get('congrats_title_part_1')} ',
                      style: QuizTypography.sectionH2
                          .copyWith(fontSize: 30, color: colors.ink),
                    ),
                    TextSpan(
                      text: strings.get('congrats_title_part_2'),
                      style: QuizTypography.sectionH2.copyWith(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        color: colors.clay,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 270,
                child: RepaintBoundary(
                  key: _cardKey,
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: _ShareCard(
                      tag: strings.get('eyebrow_top_week'),
                      place: place,
                      prizeLabel: strings.get('congrats_prize_label'),
                      prize: prize,
                      playerName: widget.playerName,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              strings.get('congrats_promocode_hint'),
              style: QuizTypography.body.copyWith(color: colors.ink2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (widget.onShareWin != null) ...[
              QuizCtaPrimary(
                label: _sharing ? '…' : strings.get('congrats_share'),
                onTap: _share,
              ),
              const SizedBox(height: 10),
            ],
            QuizCtaGhost(
              label: strings.get('congrats_close'),
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Branded 9:16 card rendered to PNG for Instagram Stories.
class _ShareCard extends StatelessWidget {
  const _ShareCard({
    required this.tag,
    required this.place,
    required this.prizeLabel,
    required this.prize,
    required this.playerName,
  });

  final String tag;
  final String place;
  final String prizeLabel;
  final String prize;
  final String playerName;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.ink, colors.ink2],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: QuizRadii.brXl,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ─── Top: brand + tag ─────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RIZO GO',
                  style: QuizTypography.sectionH2.copyWith(
                    fontSize: 17,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  tag,
                  style: QuizTypography.eyebrowSmall.copyWith(color: colors.claySoft),
                ),
              ],
            ),
            const Spacer(),
            // ─── Center: trophy + place + prize ───────────────────────────
            const Text('🏆', style: TextStyle(fontSize: 68, height: 1)),
            const SizedBox(height: 18),
            Text(
              place,
              textAlign: TextAlign.center,
              style: QuizTypography.displayH1.copyWith(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              prizeLabel.toUpperCase(),
              style: QuizTypography.eyebrowSmall.copyWith(
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '+ $prize',
              style: QuizTypography.displayH1.copyWith(
                fontSize: 30,
                color: colors.claySoft,
              ),
            ),
            const Spacer(),
            // ─── Bottom: player + wordmark ────────────────────────────────
            Text(
              playerName,
              style: QuizTypography.bodyMedium.copyWith(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'rizogo.uz',
              style: QuizTypography.monoMeta.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

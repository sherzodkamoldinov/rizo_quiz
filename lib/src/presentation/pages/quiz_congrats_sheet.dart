import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
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

const String _instagramHandle = '@rizo_go';

/// One-time congratulation sheet for a weekly win. The sheet itself is text
/// only (congrats + share CTA); the shareable 9:16 marketing card is rendered
/// off-screen and captured to PNG when the user taps share.
Future<void> showQuizCongratsSheet({
  required BuildContext context,
  required QuizMyWin win,
  required String lang,
  QuizShareWinCallback? onShareWin,
  ImageProvider<Object>? logo,
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
      onShareWin: onShareWin,
      logo: logo,
    ),
  );
}

class QuizCongratsSheet extends StatefulWidget {
  const QuizCongratsSheet({
    required this.win,
    required this.lang,
    this.onShareWin,
    this.logo,
    super.key,
  });

  final QuizMyWin win;
  final String lang;
  final QuizShareWinCallback? onShareWin;
  final ImageProvider<Object>? logo;

  @override
  State<QuizCongratsSheet> createState() => _QuizCongratsSheetState();
}

class _QuizCongratsSheetState extends State<QuizCongratsSheet> {
  final GlobalKey _cardKey = GlobalKey();
  bool _sharing = false;
  bool _precached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final logo = widget.logo;
    if (!_precached && logo != null) {
      _precached = true;
      precacheImage(logo, context);
    }
  }

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
    } on Object catch (error, stack) {
      // Never crash the UI on a share failure — log for diagnosis.
      debugPrint('Quiz win share failed: $error\n$stack');
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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Off-screen 9:16 card — laid out & painted, captured on share.
          Positioned(
            left: -2000,
            top: 0,
            child: RepaintBoundary(
              key: _cardKey,
              child: SizedBox(
                width: 270,
                height: 480,
                child: _ShareCard(
                  logo: widget.logo,
                  place: place,
                  prize: prize,
                  ctaText: strings.get('share_card_cta'),
                  instagramHandle: _instagramHandle,
                ),
              ),
            ),
          ),
          Padding(
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    place,
                    style: QuizTypography.sectionH2
                        .copyWith(fontSize: 24, color: colors.ink),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    '+ $prize',
                    style: QuizTypography.bodyMedium.copyWith(color: colors.clay2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  strings.get('congrats_invite'),
                  style: QuizTypography.body.copyWith(color: colors.ink2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),
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
        ],
      ),
    );
  }
}

/// Branded 9:16 marketing card rendered to PNG for Instagram Stories.
class _ShareCard extends StatelessWidget {
  const _ShareCard({
    required this.logo,
    required this.place,
    required this.prize,
    required this.ctaText,
    required this.instagramHandle,
  });

  final ImageProvider<Object>? logo;
  final String place;
  final String prize;
  final String ctaText;
  final String instagramHandle;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return ClipRRect(
      borderRadius: QuizRadii.brXl,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.ink, colors.ink2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(painter: _CardDecorPainter()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (logo != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Image(
                        image: logo!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const Spacer(),
                  const Text('🏆', style: TextStyle(fontSize: 58, height: 1)),
            const SizedBox(height: 14),
            Text(
              place,
              textAlign: TextAlign.center,
              style: QuizTypography.displayH1.copyWith(
                fontSize: 38,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '+ $prize',
              style: QuizTypography.displayH1.copyWith(
                fontSize: 28,
                color: colors.claySoft,
              ),
            ),
            const Spacer(),
            Text(
              ctaText,
              textAlign: TextAlign.center,
              style: QuizTypography.bodyMedium.copyWith(
                color: Colors.white,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _InstagramMark(size: 18, color: Colors.white),
                const SizedBox(width: 7),
                Text(
                  instagramHandle,
                  style: QuizTypography.bodyMedium.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
          ],
        ),
      ),
    );
  }
}

/// Five parallel white lines forming a rounded corner, going border-to-border:
/// top→left in the top-left, and (mirrored) bottom→right in the bottom-right.
class _CardDecorPainter extends CustomPainter {
  const _CardDecorPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.14);
    final w = size.width;
    final h = size.height;
    final gap = w * 0.028;
    const r = 22.0;
    for (var i = 0; i < 5; i++) {
      final cx = w * 0.28 + i * gap;
      final cy = h * 0.16 + i * gap;
      // Top-left: top edge → rounded bend → left edge.
      canvas.drawPath(
        Path()
          ..moveTo(cx, 0)
          ..lineTo(cx, cy - r)
          ..quadraticBezierTo(cx, cy, cx - r, cy)
          ..lineTo(0, cy),
        paint,
      );
      // Bottom-right (mirror): bottom edge → rounded bend → right edge.
      final mx = w - cx;
      final my = h - cy;
      canvas.drawPath(
        Path()
          ..moveTo(mx, h)
          ..lineTo(mx, my + r)
          ..quadraticBezierTo(mx, my, mx + r, my)
          ..lineTo(w, my),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_CardDecorPainter oldDelegate) => false;
}

/// Minimalist Instagram glyph (rounded square + circle + dot).
class _InstagramMark extends StatelessWidget {
  const _InstagramMark({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _InstagramPainter(color)),
    );
  }
}

class _InstagramPainter extends CustomPainter {
  _InstagramPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.round
      ..color = color;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.08,
        size.height * 0.08,
        size.width * 0.84,
        size.height * 0.84,
      ),
      Radius.circular(size.width * 0.28),
    );
    canvas.drawRRect(rect, stroke);
    canvas.drawCircle(size.center(Offset.zero), size.width * 0.22, stroke);
    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.28),
      size.width * 0.055,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_InstagramPainter oldDelegate) => oldDelegate.color != color;
}

import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_typography.dart';

/// Билет с номером места — визуальный сигнал «этот игрок в призах».
///
/// Единый брендовый стиль (без золота/серебра): светлая заливка, бирюзовая
/// граница, номер как главный заголовок. В [detailed]-режиме (пьедестал) номер
/// крупный + подпись «Rizo GO» и корешок с перфорацией; компактный (список) —
/// только номер.
class QuizRankTicket extends StatelessWidget {
  const QuizRankTicket({
    required this.rank,
    this.width = 40,
    this.height = 24,
    this.detailed = false,
    super.key,
  });

  final int rank;
  final double width;
  final double height;
  final bool detailed;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _TicketPainter(
          fill: colors.card,
          border: colors.clay2,
          detailed: detailed,
        ),
        child: Padding(
          padding: EdgeInsets.only(right: detailed ? width * 0.30 : 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$rank',
                style: QuizTypography.monoLabel.copyWith(
                  color: colors.ink,
                  fontWeight: FontWeight.w700,
                  fontSize: height * (detailed ? 0.36 : 0.5),
                  height: 1,
                ),
              ),
              if (detailed) ...[
                SizedBox(height: height * 0.06),
                Text(
                  'Rizo GO',
                  style: QuizTypography.monoMeta.copyWith(
                    color: colors.clay2,
                    fontSize: height * 0.17,
                    letterSpacing: 0.4,
                    height: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TicketPainter extends CustomPainter {
  _TicketPainter({
    required this.fill,
    required this.border,
    required this.detailed,
  });

  final Color fill;
  final Color border;
  final bool detailed;

  @override
  void paint(Canvas canvas, Size size) {
    final notch = size.height * 0.16;
    final body = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(6)),
      );
    final leftNotch = Path()
      ..addOval(Rect.fromCircle(center: Offset(0, size.height / 2), radius: notch));
    final rightNotch = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(size.width, size.height / 2), radius: notch),
      );
    var ticket = Path.combine(PathOperation.difference, body, leftNotch);
    ticket = Path.combine(PathOperation.difference, ticket, rightNotch);

    canvas.drawPath(ticket, Paint()..color = fill);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = border;
    canvas.drawPath(ticket, stroke);

    if (detailed) _paintStub(canvas, size, stroke);
  }

  void _paintStub(Canvas canvas, Size size, Paint stroke) {
    final px = size.width * 0.70;
    // Dashed perforation between the main panel and the stub.
    for (var y = 5.0; y < size.height - 5; y += 4) {
      canvas.drawLine(Offset(px, y), Offset(px, y + 2), stroke);
    }
    // Short horizontal tick marks on the stub.
    final sx1 = px + (size.width - px) * 0.28;
    final sx2 = size.width - (size.width - px) * 0.28;
    const count = 4;
    final top = size.height * 0.34;
    final bottom = size.height * 0.66;
    for (var i = 0; i < count; i++) {
      final y = top + (bottom - top) * i / (count - 1);
      canvas.drawLine(Offset(sx1, y), Offset(sx2, y), stroke);
    }
  }

  @override
  bool shouldRepaint(_TicketPainter oldDelegate) =>
      oldDelegate.fill != fill ||
      oldDelegate.border != border ||
      oldDelegate.detailed != detailed;
}

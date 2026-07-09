import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_typography.dart';

/// Билет с номером места — визуальный сигнал «этот игрок в призах».
///
/// Рисуется геометрией (скруглённый прямоугольник + боковые насечки), заливка
/// металлик-градиентом по месту: 1 — золото, 2 — серебро, 3 — бронза, 4+ —
/// бирюзовый (призовой цвет). Показывается только для призовых мест.
class QuizRankTicket extends StatelessWidget {
  const QuizRankTicket({
    required this.rank,
    this.width = 40,
    this.height = 26,
    super.key,
  });

  final int rank;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final style = _styleFor(rank, colors);
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _TicketPainter(gradient: style.gradient, border: style.border),
        child: Center(
          child: Text(
            '$rank',
            style: QuizTypography.monoLabel.copyWith(
              color: style.text,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  _TicketStyle _styleFor(int rank, QuizColors c) {
    switch (rank) {
      case 1:
        return const _TicketStyle(
          gradient: LinearGradient(
            colors: [Color(0xFFF3D989), Color(0xFFCFA23A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          text: Color(0xFF5A4510),
          border: Color(0xFFB98E2C),
        );
      case 2:
        return const _TicketStyle(
          gradient: LinearGradient(
            colors: [Color(0xFFEFEFEF), Color(0xFFBBC0C6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          text: Color(0xFF3A3F45),
          border: Color(0xFF9AA0A6),
        );
      case 3:
        return const _TicketStyle(
          gradient: LinearGradient(
            colors: [Color(0xFFE7BE95), Color(0xFFB1723E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          text: Colors.white,
          border: Color(0xFF97602F),
        );
      default:
        return _TicketStyle(
          gradient: LinearGradient(
            colors: [c.claySoft, c.clay],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          text: c.ink,
          border: c.clay2,
        );
    }
  }
}

class _TicketStyle {
  const _TicketStyle({
    required this.gradient,
    required this.text,
    required this.border,
  });

  final Gradient gradient;
  final Color text;
  final Color border;
}

class _TicketPainter extends CustomPainter {
  _TicketPainter({required this.gradient, required this.border});

  final Gradient gradient;
  final Color border;

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

    final rect = Offset.zero & size;
    canvas.drawPath(ticket, Paint()..shader = gradient.createShader(rect));
    canvas.drawPath(
      ticket,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = border,
    );
  }

  @override
  bool shouldRepaint(_TicketPainter oldDelegate) =>
      oldDelegate.gradient != gradient || oldDelegate.border != border;
}

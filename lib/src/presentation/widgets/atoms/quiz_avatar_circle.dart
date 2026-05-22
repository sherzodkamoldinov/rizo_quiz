import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_typography.dart';

/// Круглый аватар. Если задан [avatarUrl] — грузит фото; иначе и при ошибке
/// загрузки показывает заглавную букву [initial] на цветной подложке.
class QuizAvatarCircle extends StatelessWidget {
  const QuizAvatarCircle({
    required this.initial,
    this.avatarUrl,
    this.size = 36,
    this.background,
    this.foreground,
    super.key,
  });

  final String initial;
  final String? avatarUrl;
  final double size;
  final Color? background;
  final Color? foreground;

  bool get _hasUrl => avatarUrl != null && avatarUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final bg = background ?? colors.clay;
    final fg = foreground ?? Colors.white;

    final letter = _QuizAvatarLetter(
      initial: initial,
      size: size,
      foreground: fg,
    );

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: ColoredBox(
          color: bg,
          child: _hasUrl
              ? CachedNetworkImage(
                  imageUrl: avatarUrl!,
                  fit: BoxFit.cover,
                  width: size,
                  height: size,
                  placeholder: (_, __) => letter,
                  errorWidget: (_, __, ___) => letter,
                )
              : letter,
        ),
      ),
    );
  }
}

class _QuizAvatarLetter extends StatelessWidget {
  const _QuizAvatarLetter({
    required this.initial,
    required this.size,
    required this.foreground,
  });

  final String initial;
  final double size;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initial.isEmpty ? '?' : initial.substring(0, 1).toUpperCase(),
        style: TextStyle(
          fontFamily: QuizTypography.sans,
          package: 'rizo_quiz',
          fontSize: size * 0.42,
          fontWeight: FontWeight.w600,
          color: foreground,
          height: 1,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../localization/quiz_strings.dart';
import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';
import '../atoms/quiz_cta_ghost.dart';

/// Диалог подтверждения выхода из активного раунда.
///
/// Возвращает через `Navigator.pop`:
///   • `true`  — игрок подтвердил выход (баллы теряются),
///   • `false` / `null` — остаться в игре (тап «Продолжить» или вне карточки).
class QuizExitDialog extends StatelessWidget {
  const QuizExitDialog({required this.lang, super.key});

  final String lang;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final strings = QuizStrings.of(lang);

    return Dialog(
      backgroundColor: colors.card,
      shape: const RoundedRectangleBorder(borderRadius: QuizRadii.brXl),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.noSoft,
                borderRadius: QuizRadii.brMd,
              ),
              child: Icon(Icons.logout_rounded, color: colors.no, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              strings.get('exit_title'),
              style: QuizTypography.sectionH2.copyWith(color: colors.ink),
            ),
            const SizedBox(height: 8),
            Text(
              strings.get('exit_message'),
              style: QuizTypography.body.copyWith(color: colors.mute),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: QuizCtaGhost(
                    label: strings.get('exit_cancel'),
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ExitButton(
                    label: strings.get('exit_confirm'),
                    onTap: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Деструктивная (красная) кнопка выхода — заполненная, в стиле CTA-primary.
class _ExitButton extends StatelessWidget {
  const _ExitButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Material(
      color: colors.no,
      borderRadius: QuizRadii.brPill,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          // См. QuizCtaGhost: половина ширины диалога может не вместить подпись.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: QuizTypography.optionLabel.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

/// Открывает диалог выхода. `true` — выйти, `false`/`null` — остаться.
///
/// Мягкий барьер (ink ~55%), тап вне карточки трактуется как «остаться».
Future<bool?> showQuizExitDialog({
  required BuildContext context,
  required String lang,
}) {
  final barrier = QuizColorsScope.of(context).ink.withValues(alpha: 0.55);
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: barrier,
    builder: (_) => QuizExitDialog(lang: lang),
  );
}

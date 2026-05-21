import 'package:flutter/material.dart';

import '../../../localization/quiz_strings.dart';
import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';
import '../atoms/quiz_config_toggle_card.dart';

/// Диалог настроек квиза. Две toggle-карточки в ряд: звук и вибрация.
///
/// Состояние хранится в [QuizEntry], сюда оно прокидывается через
/// `soundEnabled`/`vibrationEnabled` и колбэки.
class QuizConfigDialog extends StatelessWidget {
  const QuizConfigDialog({
    required this.lang,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.onToggleSound,
    required this.onToggleVibration,
    super.key,
  });

  final String lang;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final VoidCallback onToggleSound;
  final VoidCallback onToggleVibration;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final strings = QuizStrings.of(lang);

    return Dialog(
      backgroundColor: colors.card,
      shape: const RoundedRectangleBorder(borderRadius: QuizRadii.brXl),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.get('config_title'),
              style: QuizTypography.sectionH2.copyWith(color: colors.ink),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: QuizConfigToggleCard(
                    label: strings.get('config_sound'),
                    iconOn: Icons.volume_up_rounded,
                    iconOff: Icons.volume_off_rounded,
                    enabled: soundEnabled,
                    onTap: onToggleSound,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: QuizConfigToggleCard(
                    label: strings.get('config_vibration'),
                    iconOn: Icons.vibration_rounded,
                    iconOff: Icons.mobile_off_rounded,
                    enabled: vibrationEnabled,
                    onTap: onToggleVibration,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: colors.clay,
                  textStyle: QuizTypography.bodyMedium,
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(strings.get('config_done')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Открыть диалог конфигурации.
Future<void> showQuizConfigDialog({
  required BuildContext context,
  required String lang,
  required bool soundEnabled,
  required bool vibrationEnabled,
  required VoidCallback onToggleSound,
  required VoidCallback onToggleVibration,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => StatefulBuilder(
      builder: (ctx, setLocal) {
        // Локальный StatefulBuilder — чтобы перерисовать карточки сразу
        // после тапа, не дожидаясь rebuild всего экрана.
        return QuizConfigDialog(
          lang: lang,
          soundEnabled: soundEnabled,
          vibrationEnabled: vibrationEnabled,
          onToggleSound: () {
            onToggleSound();
            setLocal(() {
              soundEnabled = !soundEnabled;
            });
          },
          onToggleVibration: () {
            onToggleVibration();
            setLocal(() {
              vibrationEnabled = !vibrationEnabled;
            });
          },
        );
      },
    ),
  );
}

import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';

/// Wraps [child] in a continuously sweeping linear-gradient shimmer.
///
/// Uses `ShaderMask` over the existing child opacity, so any rectangles
/// underneath visually pulse without needing per-widget animation.
class QuizShimmer extends StatefulWidget {
  const QuizShimmer({
    required this.child,
    this.duration = const Duration(milliseconds: 1400),
    super.key,
  });

  final Widget child;
  final Duration duration;

  @override
  State<QuizShimmer> createState() => _QuizShimmerState();
}

class _QuizShimmerState extends State<QuizShimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration)..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final base = colors.bg2;
    final highlight = colors.line2;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final t = _controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment(-1.0 + t * 2, -0.3),
            end: Alignment(0.0 + t * 2, 0.3),
            colors: [base, highlight, base],
            stops: const [0.1, 0.5, 0.9],
          ).createShader(rect),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

import 'package:flutter/material.dart';

/// Wraps [child] in a horizontal shake animation triggered when [trigger]
/// changes. Used to flash the question card on a wrong answer.
class ShakeWrapper extends StatefulWidget {
  const ShakeWrapper({
    required this.trigger,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    super.key,
  });

  final Object? trigger;
  final Widget child;
  final Duration duration;

  @override
  State<ShakeWrapper> createState() => _ShakeWrapperState();
}

class _ShakeWrapperState extends State<ShakeWrapper> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);

  @override
  void didUpdateWidget(ShakeWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger && widget.trigger != null) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final t = _controller.value;
        // Sequence: 0, -6, +6, -4, +4, -2, +2, 0
        final offset = _shakeOffsetForT(t);
        return Transform.translate(offset: Offset(offset, 0), child: child);
      },
      child: widget.child,
    );
  }

  double _shakeOffsetForT(double t) {
    if (t == 0 || t == 1) return 0;
    const steps = [0.0, -6, 6, -4, 4, -2, 2, 0];
    final idx = (t * (steps.length - 1)).floor().clamp(0, steps.length - 1);
    return steps[idx].toDouble();
  }
}

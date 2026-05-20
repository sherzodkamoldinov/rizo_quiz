import 'package:flutter/material.dart';

/// `scale 1 → 1.06 → 1` infinite — пульс таймера в опасной зоне (≤3 сек).
class PulseAnimation extends StatefulWidget {
  const PulseAnimation({
    required this.child,
    this.enabled = true,
    this.duration = const Duration(milliseconds: 900),
    super.key,
  });

  final Widget child;
  final bool enabled;
  final Duration duration;

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 1.06), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 1.06, end: 1), weight: 1),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _controller.repeat();
  }

  @override
  void didUpdateWidget(PulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}

import 'package:flutter/material.dart';

/// `translateY 20→0 + opacity 0→1` за 250ms ease-out.
/// Используется для всплытия фидбек-тостов после ответа.
class RiseAnimation extends StatefulWidget {
  const RiseAnimation({
    required this.child,
    this.duration = const Duration(milliseconds: 250),
    super.key,
  });

  final Widget child;
  final Duration duration;

  @override
  State<RiseAnimation> createState() => _RiseAnimationState();
}

class _RiseAnimationState extends State<RiseAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);

  late final Animation<double> _opacity =
      CurvedAnimation(parent: _controller, curve: Curves.easeOut);

  late final Animation<Offset> _offset = Tween<Offset>(
    begin: const Offset(0, 0.15),
    end: Offset.zero,
  ).animate(_opacity);

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}

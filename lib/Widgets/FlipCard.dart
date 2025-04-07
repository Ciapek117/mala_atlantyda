import 'dart:math';

import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final bool flipped;
  final Widget front;
  final Widget back;
  final VoidCallback onTap;

  const FlipCard({
    Key? key,
    required this.flipped,
    required this.front,
    required this.back,
    required this.onTap,
  }) : super(key: key);

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    if (widget.flipped) _controller.forward();
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flipped != oldWidget.flipped) {
      if (widget.flipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isFront = _animation.value < 0.5;
          final display = isFront ? widget.back : widget.front;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(_animation.value * pi),
            child: display,
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';

class AnimatedGestureDetector extends StatefulWidget {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget child;
  final Duration? duration;
  final bool isLongPressEnd;

  AnimatedGestureDetector({
    required this.child,
      this.duration,
      this.onTap,
      this.onLongPress,
      this.isLongPressEnd = false
  });

  @override
  AnimatedGestureDetectorState createState() => AnimatedGestureDetectorState();
}

class AnimatedGestureDetectorState extends State<AnimatedGestureDetector> with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _animate;

  @override
  void initState() {
    _animate = AnimationController(
        vsync: this,
        duration: Durations.milliseconds_short,
        lowerBound: 0.0,
        upperBound: 0.1)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animate.value;
    return GestureDetector(
        onTap: _onTap,
        onLongPress: _onLongPress,
        onTapDown : (_) =>  onLongTapStart(),
        onLongPressEnd: (_) =>  onLongTapEnd(),
        child: Transform.scale(
          scale: _scale,
          child: widget.child,
        ));
  }

  void _onTap() {
    if(!_animate.isAnimating)
      _animate.forward();

    Future.delayed(
        widget.duration != null ? widget.duration! : Duration(milliseconds: 100), () {
      _animate.reverse();

      if (widget.onTap != null) widget.onTap!();
    });
  }

  void _onLongPress() {
    Future.delayed(
        widget.duration != null ? widget.duration! : Duration(milliseconds: 100), () {
          if(widget.isLongPressEnd)
            _animate.reverse();

      if (widget.onLongPress != null) widget.onLongPress!();
    });
  }

  void onLongTapStart() {
    if(!_animate.isAnimating)
      _animate.forward();
  }

  void onLongTapEnd() {
    _animate.reverse();
  }
}
import 'package:flutter/material.dart';
import 'dart:math';

class RadialBar extends StatelessWidget {
  final double progress;

  final double? dimensions;

  final double maxProgress;

  final double startAngle;

  final double sweepAngle;

  final double foregroundStrokeWidth;

  final double backgroundStrokeWidth;

  final Color foregroundColor;

  final Color backgroundColor;

  final StrokeCap corners;

  final double seekSize;

  final Color seekColor;

  final Alignment circleCenterAlignment;

  final bool animation;

  final Duration animationDuration;

  final Curve animationCurve;

  final void Function()? onAnimationEnd;

  final Widget? child;

  final ValueNotifier<double>? valueNotifier;

  const RadialBar(
      {Key? key,
      this.dimensions,
      this.progress = 0,
      this.maxProgress = 100,
      this.startAngle = 0,
      this.sweepAngle = 360,
      this.foregroundStrokeWidth = 2,
      this.backgroundStrokeWidth = 2,
      this.foregroundColor = Colors.blue,
      this.backgroundColor = Colors.grey,
      this.corners = StrokeCap.round,
      this.seekSize = 0,
      this.seekColor = Colors.blue,
      this.circleCenterAlignment = Alignment.center,
      this.animation = false,
      this.animationDuration = const Duration(milliseconds: 800),
      this.animationCurve = Curves.easeOut,
      this.onAnimationEnd,
      this.child,
      this.valueNotifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: dimensions,
      height: dimensions,
      child: _buildProgressBar(),
    );
  }

  Widget _buildProgressBar() {
    return TweenAnimationBuilder(
      duration: animationDuration,
      tween: Tween<double>(begin: 0, end: progress),
      curve: animationCurve,
      onEnd: onAnimationEnd,
      builder: (BuildContext context, double animatedProgress, __) {
        valueNotifier?.value = animatedProgress;
        return CustomPaint(
            painter: _buildPainter(animatedProgress),
            child: (child != null) ? Center(child: child!) : null);
      },
    );
  }

  ProgressBar _buildPainter(double progress) {
    return ProgressBar(
      progress: progress,
      maxProgress: maxProgress,
      foregroundStrokeWidth: foregroundStrokeWidth,
      backgroundStrokeWidth: backgroundStrokeWidth,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      corners: corners,
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progress;

  final double maxProgress;

  final double foregroundStrokeWidth;

  final double backgroundStrokeWidth;


  final Color foregroundColor;

  final Color backgroundColor;

  final StrokeCap corners;

  const ProgressBar({
    required this.progress,
    required this.maxProgress,
    required this.foregroundStrokeWidth,
    required this.backgroundStrokeWidth,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.corners,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint circle = Paint()
      ..strokeWidth = backgroundStrokeWidth
      ..color = backgroundColor
      ..style = PaintingStyle.stroke;
    Offset center = Offset(size.width / 2, size.height / 2);
    double minEdge = min(size.width, size.height) / 2;

    double radius =
        minEdge - (max(foregroundStrokeWidth, backgroundStrokeWidth) / 2);
    canvas.drawCircle(center, radius, circle);

    Paint animationArc = Paint()
      ..strokeWidth = foregroundStrokeWidth
      ..color = foregroundColor
      ..style = PaintingStyle.stroke
      ..strokeCap = corners;
    double angle = 2 * pi * (progress / maxProgress);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, animationArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

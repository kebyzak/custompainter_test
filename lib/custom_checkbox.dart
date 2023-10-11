import 'dart:math';

import 'package:flutter/material.dart';

class CustomCheckbox extends CustomPainter {
  final Animation<Color?> _color;
  final Color color;

  CustomCheckbox({
    required Animation<double> animation,
    required this.color,
  })  : _color = ColorTween(begin: Colors.white, end: color).animate(animation),
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var outlineBrush = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    var inlineBrush = Paint()
      ..color = _color.value!
      ..style = PaintingStyle.fill;

    var firstLineBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.5;

    var secondLineBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.5;

    canvas.drawCircle(center, radius, outlineBrush);
    canvas.drawCircle(center, radius, inlineBrush);
    canvas.drawLine(const Offset(11, 18), const Offset(7, 13), firstLineBrush);
    canvas.drawLine(const Offset(12, 19), const Offset(18, 7), secondLineBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MySizedBox extends StatelessWidget {
  final CustomPainter painter;
  final EdgeInsetsGeometry padding; // Add a padding property

  MySizedBox({
    Key? key,
    required this.painter,
    this.padding = EdgeInsets.zero, // Default padding is set to none
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding, // Apply the specified padding
      child: SizedBox(
        width: 25,
        height: 25,
        child: CustomPaint(
          painter: painter,
        ),
      ),
    );
  }
}

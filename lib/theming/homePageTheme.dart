import 'package:flutter/material.dart';

class CirclePaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    var path = Path();
    canvas.drawPath(path, paint);
    path.lineTo(size.width, size.height);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

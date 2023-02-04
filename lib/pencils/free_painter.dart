import 'dart:ui';

import 'package:flutter/material.dart';

class FreeDrawPainter extends CustomPainter {

  final List<List<Offset?>> frees;

  
  FreeDrawPainter({required this.frees});

  final Paint pencil = Paint()..color = Colors.black.. strokeWidth = 2.0..isAntiAlias = true..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    // Paint background = Paint()..color = Colors.white;
    // Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // canvas.drawRect(rect, background);

    for (var points in frees) {
        _drawLine(points, canvas);
    }
  }

  @override
  bool shouldRepaint (covariant FreeDrawPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics (covariant FreeDrawPainter oldDelegate) => false;

  _drawLine(List<Offset?> points, Canvas canvas){
    for (int i = 0; i < points.length-1; i++) {
      if(points[i] != null && points[i+1] != null){
        canvas.drawLine(points[i]!, points[i+1]!, pencil);
      } else if (points[i] != null && points[i+1] == null){
        canvas.drawPoints(PointMode.points, [points[i]!], pencil);
      }
    }
  }
}
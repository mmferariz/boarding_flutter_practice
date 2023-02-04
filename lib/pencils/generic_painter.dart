import 'dart:ui';

import 'package:boarding_flutter_practice/bloc/sketch_bloc.dart';
import 'package:boarding_flutter_practice/model/sketch.dart';
import 'package:flutter/material.dart';

class GenericPainter extends CustomPainter {

  final Sketch? sketch;

  GenericPainter({this.sketch});

  final Paint pencil = Paint()..color = Colors.black.. strokeWidth = 2.0..isAntiAlias = true..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
  final textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
    );

  @override
  void paint(Canvas canvas, Size size) {
    if(sketch != null){
      for (List<Offset?> points in sketch!.frees) {
        _drawFree(points, canvas);
      }
      for (List<Offset?> points in sketch!.lines) {
        if(points.first != null && points.last != null){
          _drawLine(points.first!, points.last!, size, canvas);
        } /* else if (points.first != null && points.last == null){
          _drawLine(points.first!, points[points.length-2]!, size, canvas);
        } */
      }
      for (List<Offset?> points in sketch!.squares) {
        if(points.first != null && points.last != null){
          _drawSquare(points.first!, points.last!, size, canvas);
        }
      }
      for (List<Offset?> points in sketch!.circles) {
        if(points.first != null && points.last != null){
          _drawCircle(points.first!, points.last!, size, canvas);
        }
      }
    }
  }

  @override
  bool shouldRepaint(GenericPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(GenericPainter oldDelegate) => false;

  _drawLine(Offset origin, Offset destiny, Size size, Canvas canvas){
    final TextSpan textSpan = TextSpan(
      text: '${SketchBloc.twoPointsDistance(origin, destiny).toStringAsFixed(2)}m',
      style: textStyle
    );
    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr
    )..layout(minWidth: 0, maxWidth: size.width);
    //TODO: Evaluar dirección de la linea para saber posición del texto
    textPainter.paint(canvas, Offset((origin.dx + destiny.dx)/2, (origin.dy + destiny.dy)/2));
    canvas.drawLine(origin, destiny, pencil);
  }

  _drawFree(List<Offset?> points, Canvas canvas){
    for (int i = 0; i < points.length-1; i++) {
      if(points[i] != null && points[i+1] != null){
        canvas.drawLine(points[i]!, points[i+1]!, pencil);
      } else if (points[i] != null && points[i+1] == null){
        canvas.drawPoints(PointMode.points, [points[i]!], pencil);
      }
    }
  }

  _drawSquare(Offset origin, Offset destiny, Size size, Canvas canvas){
    final TextSpan textSpanX = TextSpan(
      text: '${SketchBloc.twoPointsDistance(origin, Offset(destiny.dx, origin.dy)).toStringAsFixed(2)}m',
      style: textStyle
    );
    final TextSpan textSpanY = TextSpan(
      text: '${SketchBloc.twoPointsDistance(origin, Offset(origin.dx, destiny.dy)).toStringAsFixed(2)}m',
      style: textStyle
    );
    TextPainter textPainterB = TextPainter(
      text: textSpanX,
      textDirection: TextDirection.ltr
    )..layout(minWidth: 0, maxWidth: size.width);
    TextPainter textPainterH = TextPainter(
      text: textSpanY,
      textDirection: TextDirection.ltr
    )..layout(minWidth: 0, maxWidth: size.width);
    //TODO: Evaluar dirección de la linea para saber posición del texto
    textPainterB.paint(canvas, Offset((origin.dx + destiny.dx)/2, destiny.dy));
    textPainterH.paint(canvas, Offset(origin.dx, (origin.dy + destiny.dy)/2));
    canvas.drawRect(origin & Size(destiny.dx - origin.dx, destiny.dy - origin.dy), pencil);
  }

  _drawCircle(Offset origin, Offset destiny, Size size, Canvas canvas){
    final TextSpan textSpanX = TextSpan(
      text: '${SketchBloc.twoPointsDistance(origin, Offset(destiny.dx, origin.dy)).toStringAsFixed(2)}m',
      style: textStyle
    );
    final TextSpan textSpanY = TextSpan(
      text: '${SketchBloc.twoPointsDistance(origin, Offset(origin.dx, destiny.dy)).toStringAsFixed(2)}m',
      style: textStyle
    );
    TextPainter textPainterB = TextPainter(
      text: textSpanX,
      textDirection: TextDirection.ltr
    )..layout(minWidth: 0, maxWidth: size.width);
    TextPainter textPainterH = TextPainter(
      text: textSpanY,
      textDirection: TextDirection.ltr
    )..layout(minWidth: 0, maxWidth: size.width);
    //TODO: Evaluar dirección de la linea para saber posición del texto
    textPainterB.paint(canvas, Offset((origin.dx + destiny.dx)/2, destiny.dy));
    textPainterH.paint(canvas, Offset(origin.dx, (origin.dy + destiny.dy)/2));
    canvas.drawOval(origin & Size(destiny.dx - origin.dx, destiny.dy - origin.dy), pencil);
  }

}
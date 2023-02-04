import 'package:boarding_flutter_practice/bloc/sketch_bloc.dart';
import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {

  final List<List<Offset?>> lines;

  LinePainter({required this.lines});

  final Paint pencil = Paint()..color = Colors.black.. strokeWidth = 2.0..isAntiAlias = true..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    for (List<Offset?> points in lines) {
      if(points.isNotEmpty){
        if(points.first != null && points.last != null){
          _drawLine(points.first!, points.last!, size, canvas);
        } /* else if (points.first != null && points.last == null){
          _drawLine(points.first!, points[points.length-2]!, size, canvas);
        } */
      }
    }
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(LinePainter oldDelegate) => false;

  _drawLine(Offset origin, Offset destiny, Size size, Canvas canvas){
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
    );
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
}
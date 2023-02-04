import 'dart:async';
import 'dart:math';

import 'package:boarding_flutter_practice/model/sketch.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class SketchBloc extends Bloc{

  final StreamController<PencilType> _scPencilType = BehaviorSubject();
  Stream<PencilType> get streamPencilType => _scPencilType.stream;
  StreamSink<PencilType> get sinkPencilType => _scPencilType.sink; 

  final StreamController<Sketch> _scSketch = BehaviorSubject();
  Stream<Sketch> get streamSketch => _scSketch.stream;
  StreamSink<Sketch> get sinkSketch => _scSketch.sink; 

  static num twoPointsDistance(Offset a, Offset b){
    final num dx = pow(b.dx - a.dx, 2);
    final num dy = pow(b.dy - a.dy, 2);
    return sqrt(dx + dy);
  }

  @override
  void dispose() {
    _scPencilType.close();
    _scSketch.close();
  }

}

enum PencilType{
  locked,
  free,
  line,
  square, 
  circle
}
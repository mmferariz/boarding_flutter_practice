import 'dart:ui';

import 'package:boarding_flutter_practice/bloc/sketch_bloc.dart';
import 'package:boarding_flutter_practice/model/sketch.dart';
import 'package:boarding_flutter_practice/pencils/generic_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SketchScreen extends StatefulWidget {
  const SketchScreen({Key? key}) : super(key: key);

  @override
  State<SketchScreen> createState() => _SketchScreenState();
}

class _SketchScreenState extends State<SketchScreen> {

  // List<Offset?> _auxPoints = [];
  final Sketch _sketch = Sketch();
  final SketchBloc _sketchBloc = SketchBloc();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InteractiveViewer(
            child: Container(
              height: 400,
              width: 400,
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: StreamBuilder<PencilType>(
                stream: _sketchBloc.streamPencilType,
                builder: (context, snapshotType) {
                  return GestureDetector(
                    onPanDown: snapshotType.data != PencilType.locked ? (DragDownDetails details) => _onPanDown(details, snapshotType.data!) : null,
                    onPanUpdate: snapshotType.data != PencilType.locked ? (DragUpdateDetails details) => _onPanUpdate(details, snapshotType.data!) : null,
                    onPanEnd: snapshotType.data != PencilType.locked ? (DragEndDetails details) => _onPanEnd(details, snapshotType.data!) : null,
                    onTap: () {
                      _sketch.auxPoints.add(null); 
                      _sketch.auxPoints = [];
                      _sketchBloc.sinkSketch.add(_sketch);
                    },
                    child: StreamBuilder<Sketch>(
                      stream: _sketchBloc.streamSketch,
                      builder: (context, snapshotSketch) {
                        return CustomPaint(
                          painter: GenericPainter(
                            sketch: snapshotSketch.data
                          ),
                        );
                      }
                    )
                  );
                }
              )
            )
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _sketchBloc.sinkPencilType.add(PencilType.locked), 
                  icon: const Icon(Icons.lock)
                ),
                IconButton(
                  onPressed: () => _sketchBloc.sinkPencilType.add(PencilType.free), 
                  icon: const Icon(Icons.precision_manufacturing_outlined)
                ),
                IconButton(
                  onPressed: () => _sketchBloc.sinkPencilType.add(PencilType.line),
                  icon: const Icon(Icons.linear_scale)
                ),
                IconButton(
                  onPressed: () => _sketchBloc.sinkPencilType.add(PencilType.square), 
                  icon: const Icon(Icons.crop_square)
                ),
                IconButton(
                  onPressed: () => _sketchBloc.sinkPencilType.add(PencilType.circle), 
                  icon: const Icon(Icons.circle_outlined)
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _onPanDown(DragDownDetails details, PencilType type){
    switch(type){
      case PencilType.line:{
        _sketch.lines.add(_sketch.auxPoints);
        _sketch.auxPoints.add(details.localPosition);
        // _sketchBloc.sinkAuxPoints.add(_auxPoints);
        _sketchBloc.sinkSketch.add(_sketch);
      } break;

      case PencilType.square:{
        _sketch.squares.add(_sketch.auxPoints);
        _sketch.auxPoints.add(details.localPosition);
        // _sketchBloc.sinkAuxPoints.add(_auxPoints);
        _sketchBloc.sinkSketch.add(_sketch);
      } break;
      
      case PencilType.circle:{
        _sketch.circles.add(_sketch.auxPoints);
        _sketch.auxPoints.add(details.localPosition);
        // _sketchBloc.sinkAuxPoints.add(_auxPoints);
        _sketchBloc.sinkSketch.add(_sketch);
      } break;
      
      case PencilType.free:{
        _sketch.frees.add(_sketch.auxPoints);
        _sketch.auxPoints.add(details.localPosition);
        // _sketchBloc.sinkAuxPoints.add(_auxPoints);
        _sketchBloc.sinkSketch.add(_sketch);
      } break;

      default: {

      }
    }
  }

  _onPanUpdate(DragUpdateDetails details, PencilType type){
    // switch(type){
    //   case PencilType.line:{

    //   } break;
      
    //   case PencilType.free:{

    //   } break;

    //   default: {

    //   }
    // }
    _sketch.auxPoints.add(details.localPosition);
    // _sketchBloc.sinkAuxPoints.add(_auxPoints);
    _sketchBloc.sinkSketch.add(_sketch);
  }

  _onPanEnd(DragEndDetails details, PencilType type){
    switch(type){
      case PencilType.line:{
        _sketch.lines.last = [_sketch.auxPoints.first, _sketch.auxPoints.last];
        _sketch.auxPoints = [];
        // _sketchBloc.sinkAuxPoints.add(_auxPoints);
        _sketchBloc.sinkSketch.add(_sketch);
        // _auxPoints.add(null);
      } break;

      case PencilType.square:{
        _sketch.squares.last = [_sketch.auxPoints.first, _sketch.auxPoints.last];
        _sketch.auxPoints = [];
        // _sketchBloc.sinkAuxPoints.add(_auxPoints);
        _sketchBloc.sinkSketch.add(_sketch);
        // _auxPoints.add(null);
      } break;

      case PencilType.circle:{
        _sketch.circles.last = [_sketch.auxPoints.first, _sketch.auxPoints.last];
        _sketch.auxPoints = [];
        // _sketchBloc.sinkAuxPoints.add(_auxPoints);
        _sketchBloc.sinkSketch.add(_sketch);
        // _auxPoints.add(null);
      } break;
      
      // case PencilType.free:{
      // } break;

      default: {
        _sketch.auxPoints.add(null); 
        _sketch.auxPoints = [];
        _sketchBloc.sinkSketch.add(_sketch);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _sketchBloc.sinkSketch.add(_sketch);
    _sketchBloc.sinkPencilType.add(PencilType.line);
  }
}
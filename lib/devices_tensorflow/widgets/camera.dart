import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;

typedef Callback = void Function(
    List<dynamic>? list, int h, int w, CameraController? controller);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final String model;

  const Camera(this.cameras, this.model, this.setRecognitions);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? controller;
  bool isDetecting = false;

  String stryolo = 'YOLO';
  String ssmobileNet = 'SSDMobileNet';

  @override
  void initState() {
    super.initState();

    if (widget.cameras == null || widget.cameras.isEmpty) {
    } else {
      controller = CameraController(
        widget.cameras[0],
        ResolutionPreset.high,
      );
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          var startTime = DateTime.now().millisecondsSinceEpoch;
          controller!.startImageStream((img) {
            if (!isDetecting) {
              var stopDetect =
                  PreferenceUtil.getStringValue(Constants.stop_detecting);

              if (stopDetect == 'YES') {
                controller!.stopImageStream();
              }

              isDetecting = true;
            }
          });
        });
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
//
//    return AspectRatio(
//        aspectRatio: controller.value.aspectRatio,
//        child: CameraPreview(controller));

    var tmp = MediaQuery.of(context).size;
    final screenH = math.max(tmp.height, tmp.width);
    final screenW = math.min(tmp.height, tmp.width);
    tmp = controller!.value.previewSize!;
    final previewH = math.max(tmp.height, tmp.width);
    final previewW = math.min(tmp.height, tmp.width);
    final screenRatio = screenH / screenW;
    final previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller!),
    );
  }
}

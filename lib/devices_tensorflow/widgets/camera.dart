import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/devices_tensorflow/models/tensorflow_model.dart';
import 'package:tflite/tflite.dart';

typedef void Callback(
    List<dynamic> list, int h, int w, CameraController controller);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final String model;

  Camera(this.cameras, this.model, this.setRecognitions);

  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No camera is found');
    } else {
      controller = new CameraController(
        widget.cameras[0],
        ResolutionPreset.medium,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          int startTime = new DateTime.now().millisecondsSinceEpoch;
          print("Start time ${startTime}");
          controller.startImageStream((CameraImage img) {
            if (!isDetecting) {
              print('Start camera');
              String stopDetect =
                  PreferenceUtil.getStringValue(Constants.stop_detecting);

              if (stopDetect == 'YES') {
                controller.stopImageStream();
              }

              print('Middle camera');

              isDetecting = true;

              if (widget.model == mobilenet) {
                Tflite.runModelOnFrame(
                  bytesList: img.planes.map((plane) {
                    return plane.bytes;
                  }).toList(),
                  imageHeight: img.height,
                  imageWidth: img.width,
                  numResults: 2,
                ).then((recognitions) {
                  int endTime = new DateTime.now().millisecondsSinceEpoch;
                  print("Detection took ${endTime - startTime}");

                  widget.setRecognitions(
                      recognitions, img.height, img.width, controller);

                  isDetecting = false;
                });
              } else if (widget.model == posenet) {
                Tflite.runPoseNetOnFrame(
                  bytesList: img.planes.map((plane) {
                    return plane.bytes;
                  }).toList(),
                  imageHeight: img.height,
                  imageWidth: img.width,
                  numResults: 2,
                ).then((recognitions) {
                  int endTime = new DateTime.now().millisecondsSinceEpoch;
                  print("Detection took ${endTime - startTime}");
                  print('End camera');

                  widget.setRecognitions(
                      recognitions, img.height, img.width, controller);

                  isDetecting = false;
                });
              } else {
                Tflite.detectObjectOnFrame(
                  bytesList: img.planes.map((plane) {
                    return plane.bytes;
                  }).toList(),
                  model: widget.model == yolo ? "YOLO" : "SSDMobileNet",
                  imageHeight: img.height,
                  imageWidth: img.width,
                  imageMean: widget.model == yolo ? 0 : 127.5,
                  imageStd: widget.model == yolo ? 255.0 : 127.5,
                  numResultsPerClass: 1,
                  threshold: widget.model == yolo ? 0.2 : 0.4,
                ).then((recognitions) {
                  int endTime = new DateTime.now().millisecondsSinceEpoch;
                  print("Detection took ${endTime - startTime}");
                  print('End camera');

                  if (endTime - startTime > 3000) {
                    widget.setRecognitions(
                        recognitions, img.height, img.width, controller);

                    print('Inside the block');
                  }
                  print(recognitions);

                  isDetecting = false;
                });
              }
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
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }
//
//    return AspectRatio(
//        aspectRatio: controller.value.aspectRatio,
//        child: CameraPreview(controller));

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller),
    );
  }
}

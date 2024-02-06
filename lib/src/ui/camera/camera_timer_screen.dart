import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/FlutterToast.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  _CameraPreviewScreenState createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  late CameraController controller;
  late Timer _timer;
  int _secondsRemaining = 30;
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    cameraInitialization();
  }

  void cameraInitialization() async {
    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    await controller.initialize();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          _takePicture();
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      final XFile image = await controller.takePicture();
      setState(() {
        imageFile = image;
      });
      _timer.cancel();
    } catch (e) {
      FlutterToast().getToast(e.toString(), Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
      return _buildCameraPreview();
  }

  Widget _buildCameraPreview() => Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar:  Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.cancel_outlined,
                size: 32,
              ),
            ),
            Visibility(
              visible: imageFile==null,
              child: ElevatedButton(
                onPressed: _takePicture,
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 32,
                ),
              ),
            ),
            Visibility(
              visible: imageFile!=null,
              child: IconButton(
                onPressed: (){
                  Navigator.of(context).pop(imageFile);
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
      body:  Stack(
        children: [
          Positioned.fill(
            child: imageFile != null
                ? Image.file(
              File(imageFile!.path),
              fit: BoxFit.cover,
            )
                : CameraPreview(controller),
          ),
          if(imageFile == null)
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '$_secondsRemaining',
                style: const TextStyle(fontSize: 25, color: Colors.red),
              ),
            ),
          ),

        ],
      ),
    );



  // void _retakePicture() {
  //   setState(() {
  //     imageFile = null;
  //     _secondsRemaining = 30;
  //   });
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     setState(() {
  //       if (_secondsRemaining > 0) {
  //         _secondsRemaining--;
  //       } else {
  //         _timer.cancel();
  //         _takePicture();
  //       }
  //     });
  //   });
  // }

  // void _acceptPicture() {
  //   Navigator.of(context).pop(imageFile);
  // }
}

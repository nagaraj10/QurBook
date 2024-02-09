import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:native_shutter_sound/native_shutter_sound.dart';
import 'package:native_shutter_sound/native_shutter_sound_platform_interface.dart';

import '../../utils/screenutils/size_extensions.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({super.key, required this.cameras});

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

  Future<void> cameraInitialization() async {
    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
    );
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
      final image = await controller.takePicture();

      setState(() {
        imageFile = image;
      });
      _timer.cancel();
      await NativeShutterSoundPlatform.instance.play();
    } catch (e) {
      debugPrint(e.toString());
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.cancel_outlined,
                  size: 32.0.sp,
                ),
              ),
              Visibility(
                visible: imageFile == null,
                child: Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: ElevatedButton(
                    onPressed: _takePicture,
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 32.0.sp,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: imageFile != null,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(imageFile);
                  },
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 32.0.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: imageFile != null
                  ? Image.file(
                      File(imageFile!.path),
                      fit: BoxFit.cover,
                    )
                  : CameraPreview(controller),
            ),
            if (imageFile == null)
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 1, end: 0),
                  duration: Duration(seconds: _secondsRemaining),
                  builder: (context, value, child) {
                    // Calculate the color based on the remaining time
                    Color color = _secondsRemaining <= 10 ? Colors.red : Colors.grey;
                    return Container(
                      width: 100,
                      height: 100,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            // decoration: BoxDecoration(
                            //   shape: BoxShape.circle,
                            //   border: Border.all(color: color, width: 3),
                            // ),
                            child: CircularProgressIndicator(
                              value: value,
                              color: Colors.white,
                              strokeWidth: 5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0), // Adjust the padding as needed
                            child: Text(
                              '$_secondsRemaining',
                              style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold // Adjust the color as needed
                                  ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      );
}

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/FlutterToast.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({super.key, required this.cameras});
  final List<CameraDescription> cameras;

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  late CameraController controller;
  late Timer _timer;
  int _secondsRemaining = 30;

  @override
  void initState() {
    super.initState();
    cameraInitialization();
  }

  cameraInitialization() async {
    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
    });

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
      Navigator.pop(context, image); // Sending the image path back
    } catch (e) {
      FlutterToast().getToast(e.toString(), Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const SizedBox(height: 100),
          Text(
            '$_secondsRemaining seconds left',
            style: const TextStyle(fontSize: 20, color: Colors.red),
          ),
          const SizedBox(height: 30),
          CameraPreview(controller),
          const SizedBox(height: 30),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _takePicture(),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 32,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

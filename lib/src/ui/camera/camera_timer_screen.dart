import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_shutter_sound/native_shutter_sound.dart';

import '../../utils/screenutils/size_extensions.dart';

// Define a StatefulWidget for the camera preview screen
class CameraPreviewScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPreviewScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

// Define the state for the camera preview screen
class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  late CameraController controller;
  late Timer _timer;
  int _secondsRemaining = 30; // Initialize remaining seconds
  XFile? imageFile; // Variable to store the captured image file
  bool isGalleryOpen = false;
  FlashMode flashMode = FlashMode.off; // State variable for flash mode

  @override
  void initState() {
    super.initState();
    cameraInitialization(); // Initialize camera
  }

  // Initialize the camera
  Future<void> cameraInitialization() async {
    controller = CameraController(
      widget.cameras[0], // Use the first camera from the list
      ResolutionPreset.high,
    );
    await controller.initialize(); // Initialize the camera controller
    await controller.setFlashMode(flashMode);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--; // Decrement remaining seconds
      } else {
        _timer.cancel(); // Cancel the timer when time is up
        _takePicture(); // Take the picture when time is up
      }
      setState(() {});
    });
  }

  // Function to open gallery and select image
  Future<void> _openGallery() async {
    isGalleryOpen = true;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = XFile(pickedFile.path); // Set the selected image file
    } else {
      _secondsRemaining = 30;
      isGalleryOpen = false;
    }
    setState(() {});
  }

  // Function to toggle flash mode
  void _toggleFlash() {
    setState(() {
      flashMode = flashMode == FlashMode.off ? FlashMode.always : FlashMode.off;
      controller.setFlashMode(flashMode);
    });
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose the camera controller
    _timer.cancel(); // Cancel the timer
    super.dispose();
  }

  // Function to capture a picture
  Future<void> _takePicture() async {
    try {
      final image = await controller.takePicture(); // Capture the picture

      imageFile = image; // Set the captured image file
      setState(() {});
      await NativeShutterSound.play(); // Play shutter sound
      _timer.cancel(); // Cancel the timer
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container(); // Return an empty container if camera is not initialized
    }
    return _buildCameraPreview(); // Build the camera preview
  }

  // Widget to build the camera preview screen
  Widget _buildCameraPreview() => Scaffold(
    backgroundColor: Colors.transparent,
    bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back when cancel button is pressed
            },
            child: Icon(
              Icons.cancel_outlined,
              size: 32.0.sp,
            ),
          ),
          Visibility(
            visible: imageFile == null,
            child: ElevatedButton(
              onPressed: () {
                _openGallery(); // Open gallery when gallery button is pressed
              },
              child: Icon(
                Icons.photo_library_outlined,
                size: 32.0.sp,
              ),
            ),
          ),
          Visibility(
            visible: imageFile == null, // Show the capture button only if no image is captured
            child: Padding(
              padding: const EdgeInsets.only(right: 50),
              child: ElevatedButton(
                onPressed: _takePicture,
                // Call _takePicture function when capture button is pressed
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 32.0.sp,
                ),
              ),
            ),
          ),
          Visibility(
            visible: imageFile != null, // Show the check button only if an image is captured
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop(imageFile); // Navigate back with the captured image file
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
    // floatingActionButton: FloatingActionButton(
    //   onPressed: _toggleFlash, // Toggle flash mode when the button is pressed
    //   child: Icon(
    //     flashMode == FlashMode.off ? Icons.flash_off : Icons.flash_on,
    //   ),
    // ),
    body: Stack(
      children: [
        Positioned.fill(
          child: imageFile != null
              ? Image.file(
            File(imageFile!.path),
            fit: BoxFit.cover,
          )
              : CameraPreview(controller), // Show camera preview if no image is captured
        ),
        if (imageFile == null && !isGalleryOpen) // Show countdown only if no image is captured
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1, end: 0),
              duration: Duration(seconds: _secondsRemaining),
              builder: (context, value, child) => Container(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: value,
                        color: Colors.white,
                        strokeWidth: 8,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        '$_secondsRemaining',
                        style: TextStyle(
                          fontSize: 25.0.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          // Adjust the color as needed
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

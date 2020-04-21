import 'dart:io';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:myfhb/common/OverLayCategoryDialog.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'DisplayPictureScreen.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final bool isFromSignUpPage;
  const TakePictureScreen({
    Key key,
    this.isFromSignUpPage,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isMultipleImages = false;
  bool isThumbnails = false;
  List<String> imagePaths = new List();

  int maxImageNo = 10;
  bool selectSingleImage = false;
  String _platformMessage = 'No Error';

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  String categoryName;
  String categoryID;
  BuildContext _context;

  @override
  void initState() {
    super.initState();

    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();

    initializeData();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        appBar: AppBar(title: getWidgetForTitle(context)),

        //appBar: AppBar(title: Text('Take a picture')),
        // Wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner
        // until the controller has finished initializing.
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return CameraPreview(_controller);
                } else {
                  // Otherwise, display a loading indicator.
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            isThumbnails
                ? Container(
                    height: 60,
                    color: Color(new CommonUtil().getMyPrimaryColor()),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Center(
                              //padding: EdgeInsets.all(20),
                              child: Stack(
                            alignment: Alignment.topRight,
                            children: <Widget>[
                              Image.file(
                                File(imagePaths[imagePaths.length - 1]),
                                width: 30,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                              /*  new Positioned(
                                    right: 0,
                                    top: 0,
                                    child:  */
                              new Container(
                                padding: EdgeInsets.all(2),
                                decoration: new BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 14,
                                  minHeight: 14,
                                ),
                                child: Text(
                                  (imagePaths.length).toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                //),
                              ),
                            ],
                          )),
                        ),
                        Expanded(
                          child: Center(
                            child: IconButton(
                              icon: new ImageIcon(
                                AssetImage('assets/icons/attach.png'),
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: () async {
                                // Take the Picture in a try / catch block. If anything goes wrong,
                                // catch the error.

                                if (isMultipleImages) {
                                  await getFilePath();
                                  callDisplayPictureScreen(context);
                                } else {
                                  try {
                                    var image = await FilePicker.getFile();
                                    imagePaths.add(image.path);
                                    callDisplayPictureScreen(context);
                                  } catch (e) {
                                    // If an error occurs, log the error to the console.
                                    print(e);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.camera,
                                color: Colors.white,
                                size: 40,
                              ),
                              onPressed: () async {
                                // Take the Picture in a try / catch block. If anything goes wrong,
                                // catch the error.
                                try {
                                  // Ensure that the camera is initialized.
                                  await _initializeControllerFuture;

                                  // Construct the path where the image should be saved using the
                                  // pattern package.
                                  final path = join(
                                    // Store the picture in the temp directory.
                                    // Find the temp directory using the `path_provider` plugin.
                                    (await getTemporaryDirectory()).path,
                                    'Prescription_${DateTime.now()}.jpg',
                                  );

                                  // Attempt to take a picture and log where it's been saved.
                                  await _controller.takePicture(path);
                                  imagePaths.add(path);
                                  setState(() {});
                                } catch (e) {
                                  // If an error occurs, log the error to the console.
                                  print(e);
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                            child: Center(
                                //padding: EdgeInsets.all(20),
                                child: IconButton(
                          icon: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DisplayPictureScreen(imagePath: imagePaths),
                              ),
                            ).then((value) {
                              Navigator.pop(context);
                            });
                          },
                        ))),
                      ],
                    ),
                  )
                : Container(
                    height: 60,
                    color: Color(new CommonUtil().getMyPrimaryColor()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.photo_library,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: () async {
                                // Take the Picture in a try / catch block. If anything goes wrong,
                                // catch the error.

                                if (isMultipleImages) {
                                  await loadAssets();
                                  callDisplayPictureScreen(context);
                                } else {
                                  try {
                                    String filePath;
                                    var image = await ImagePicker.pickImage(
                                        source: ImageSource.gallery);
                                    filePath = image.uri.path;
                                    imagePaths.add(filePath);
                                    callDisplayPictureScreen(context);
                                  } catch (e) {
                                    // If an error occurs, log the error to the console.
                                    print(e);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: IconButton(
                              icon: new ImageIcon(
                                AssetImage('assets/icons/attach.png'),
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: () async {
                                // Take the Picture in a try / catch block. If anything goes wrong,
                                // catch the error.

                                if (isMultipleImages) {
                                  await getFilePath();
                                  callDisplayPictureScreen(context);
                                } else {
                                  try {
                                    var image = await FilePicker.getFile();
                                    imagePaths.add(image.path);
                                    callDisplayPictureScreen(context);
                                  } catch (e) {
                                    // If an error occurs, log the error to the console.
                                    print(e);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.camera,
                                color: Colors.white,
                                size: 40,
                              ),
                              onPressed: () async {
                                // Take the Picture in a try / catch block. If anything goes wrong,
                                // catch the error.
                                try {
                                  // Ensure that the camera is initialized.
                                  await _initializeControllerFuture;

                                  // Construct the path where the image should be saved using the
                                  // pattern package.
                                  final path = join(
                                    // Store the picture in the temp directory.
                                    // Find the temp directory using the `path_provider` plugin.
                                    (await getTemporaryDirectory()).path,
                                    'Prescription_${DateTime.now()}.jpg',
                                  );

                                  // Attempt to take a picture and log where it's been saved.
                                  await _controller.takePicture(path);

                                  if (isMultipleImages) {
                                    isThumbnails = true;
                                    imagePaths.add(path);

                                    setState(() {});
                                  } else {
                                    // If the picture was taken, display it on a new screen.
                                    imagePaths.add(path);
                                    callDisplayPictureScreen(context);
                                  }
                                } catch (e) {
                                  // If an error occurs, log the error to the console.
                                  print(e);
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                new IconButton(
                                    icon: new ImageIcon(
                                      AssetImage('assets/icons/img_multi.png'),
                                      size: 24,
                                      color: isMultipleImages
                                          ? Colors.white
                                          : Colors.white54,
                                      //color: Colors.white,
                                    ),
                                    onPressed: () {
                                      isMultipleImages = true;
                                      setState(() {});
                                    }),
                                Visibility(
                                    visible: isMultipleImages ? true : false,
                                    child: Container(
                                      height: 5,
                                      width: 5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                new IconButton(
                                    icon: new ImageIcon(
                                      AssetImage('assets/icons/img_single.png'),
                                      color: isMultipleImages
                                          ? Colors.white54
                                          : Colors.white,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      isMultipleImages = false;
                                      setState(() {});
                                    }),
                                Visibility(
                                    visible: isMultipleImages ? false : true,
                                    child: Container(
                                      height: 5,
                                      width: 5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ));
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#6d35de",
          //actionBarTitle: "Example App",
          //allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    for (Asset asset in resultList) {
      String filePath =
          await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      imagePaths.add(filePath);
    }
  }

  void callDisplayPictureScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(imagePath: imagePaths),
      ),
    ).then((value) {
      Navigator.pop(context);
    });
  }

  getWidgetForTitle(BuildContext context) {
    return InkWell(
      child: Text(categoryName),
      onTap: () {
        _showOverlay(context);
      },
    );
  }

  void initializeData() {
    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
    categoryID = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYID);
    if (categoryName == Constants.STR_DEVICES) {
      PreferenceUtil.saveString(Constants.stop_detecting, 'NO');

      Navigator.pushNamed(_context, '/take_picture_screen_for_devices')
          .then((value) {
        Navigator.pop(_context);
      });
    } else {
      setState(() {});
    }
  }

  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(OverlayCategoryDialog()).then((value) {
      initializeData();
    });
  }

  Future<void> getFilePath() async {
    List<File> filePaths = await FilePicker.getMultiFile(fileExtension: 'pdf');

    for (File file in filePaths) {
      String filePath = await FlutterAbsolutePath.getAbsolutePath(file.path);
      imagePaths.add(filePath);
    }
  }
}

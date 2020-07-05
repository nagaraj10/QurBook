import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/OverLayCategoryDialog.dart';
import 'package:myfhb/common/OverlayDeviceDialog.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/devices_tensorflow/widgets/camera.dart';
import 'package:myfhb/src/utils/alert.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';

import 'CropAndRotateScreen.dart';
import 'DisplayPictureScreen.dart';

class TakePictureScreenForDevices extends StatefulWidget {
  final List<CameraDescription> cameras;
  final bool isFromSignUpPage;

  const TakePictureScreenForDevices({
    Key key,
    this.isFromSignUpPage,
    @required this.cameras,
  }) : super(key: key);

  @override
  TakePictureScreenForDevicesState createState() =>
      TakePictureScreenForDevicesState();
}

class TakePictureScreenForDevicesState
    extends State<TakePictureScreenForDevices> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isMultipleImages = false;
  bool isThumbnails = false;
  List<String> imagePaths = new List();
  String categoryName;
  String deviceName;
  String chosenDevice;
  bool isObjectDetecting = true;

  int maxImageNo = 10;
  bool selectSingleImage = false;
  String _platformMessage = 'No Error';

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  TextEditingController fileName;

  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.

    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
    deviceName = PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME) == null
        ? Constants.IS_CATEGORYNAME_DEVICES
        : PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME);
    
    isObjectDetecting =
        PreferenceUtil.getStringValue(Constants.allowDeviceRecognition) ==
                'false'
            ? false
            : true;

    initilzeData();

    if (isObjectDetecting == false) {
      _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        widget.cameras[0],
        // Define the resolution to use.
        ResolutionPreset.medium,
      );

//      _controller.initialize().then((value) {
//        setState(() {});
//      });

      //  Next, initialize the controller. This returns a Future.
      _initializeControllerFuture = _controller.initialize();
    } else {
      loadModel();
    }
  }

  void initilzeData() {
    

    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
    deviceName = PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME) == null
        ? Constants.IS_CATEGORYNAME_DEVICES
        : PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  loadModel() async {
    String res;
    res = await Tflite.loadModel(
        model: "assets/device_detection.tflite",
        labels: "assets/devicelabels.txt");
  }

  @override
  Widget build(BuildContext context) {
    initilzeData();
    Size screen = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: getWidgetForTitle(context),
          flexibleSpace: GradientAppBar(),
        ),
        body: SafeArea(
            child: Stack(children: <Widget>[
          isObjectDetecting == true ||
                  PreferenceUtil.getStringValue(
                          Constants.allowDeviceRecognition) ==
                      null ||
                  PreferenceUtil.getStringValue(
                          Constants.allowDeviceRecognition) ==
                      'true'
              ? Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                )
              : FutureBuilder<void>(
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
          isObjectDetecting == false
              ? Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      width: double.infinity,
                      color: Color(new CommonUtil().getMyPrimaryColor()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 220,
                            height: 40,
                            margin: EdgeInsets.all(10),
                            constraints: BoxConstraints(maxWidth: 220),
                            child: GestureDetector(
                              child: DottedBorder(
                                color: Colors.white,
                                dashPattern: [9, 5],
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(),
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      _recognitions != null
                                          ? _recognitions.length > 0
                                              ? deviceNames(_recognitions[0]
                                                          ["detectedClass"]) !=
                                                      "Choose Device"
                                                  ? deviceNames(_recognitions[0]
                                                      ["detectedClass"])
                                                  : deviceName
                                              : deviceName
                                          : deviceName,
                                      maxFontSize: 14,
                                      minFontSize: 10,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
                              onTap: () {
                                _showOverlay(context);
                              },
                            ),
                          )
                        ],
                      )),
                )
              : Container(),
          Align(
              alignment: Alignment.bottomCenter,
              child: isObjectDetecting == true
                  ? _recognitions == null
                      ? Container(
                          height: 60,
                          color: Color(new CommonUtil().getMyPrimaryColor()),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(CommonConstants.detecting_the_devices,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400)),
                                Container(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator(
                                        backgroundColor: Colors.white))
                              ]))
                      : _recognitions.length == 0 ||
                              _recognitions[0]["detectedClass"] == "Others"
                          ? Container(
                              height: 80,
                              color:
                                  Color(new CommonUtil().getMyPrimaryColor()),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                          CommonConstants.not_finding_devices,
                                          softWrap: true,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                    _showChooseButton(context)
                                  ]))
                          : Container(
                              height: 60,
                              color:
                                  Color(new CommonUtil().getMyPrimaryColor()),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                          'We find the device is ${deviceNames(_recognitions[0]["detectedClass"])}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                    _showConfirmButton(context)
                                  ]))
                  : isThumbnails
                      ? Container(
                          height: 60,
                          color: Colors.orange,
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
                                child: Container(),
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
                                      if (deviceName == 'Choose Device') {
                                        // Alert
                                        Alert.displayAlertPlain(context,
                                            title: "Devices",
                                            content:
                                                'Please choose the devices');
                                      } else {
                                        //imagePaths.removeLast();
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
                                            (await getTemporaryDirectory())
                                                .path,
                                            'Prescription_${DateTime.now()}.jpg',
                                          );

                                          // Attempt to take a picture and log where it's been saved.
                                          await _controller.takePicture(path);

                                          imagePaths.add(path);

                                          setState(() {});
                                        } catch (e) {
                                          // If an error occurs, log the error to the console.
                                        }
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
                                      builder: (context) => CropAndRotateScreen(
                                          imagePath: imagePaths),
                                    ),
                                  ).then((value) {
                                    categoryName =
                                        PreferenceUtil.getStringValue(
                                            Constants.KEY_CATEGORYNAME);
                                    if (value) {
                                      Navigator.of(context).pop(true);
                                    }
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
                              /*  Expanded(
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
                                          var image =
                                              await ImagePicker.pickImage(
                                                  source: ImageSource.gallery);
                                          filePath = image.uri.path;
                                          imagePaths.add(filePath);
                                          callDisplayPictureScreen(context);
                                        } catch (e) {
                                          // If an error occurs, log the error to the console.
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                               */
                              /*  Expanded(
                                child: Container(),
                              ), */
                              Expanded(
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.camera,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    onPressed: () async {
                                      if (deviceName == 'Choose Device') {
                                        // Alert
                                        Alert.displayAlertPlain(context,
                                            title: "Devices",
                                            content:
                                                'Please choose the device');
                                      } else {
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
                                            (await getTemporaryDirectory())
                                                .path,
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
                                            imagePaths.clear();
                                            imagePaths.add(path);
                                            callDisplayPictureScreen(context);
                                          }
                                        } catch (e) {
                                          // If an error occurs, log the error to the console.
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                              /*  Expanded(
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      new IconButton(
                                          icon: new ImageIcon(
                                            AssetImage(
                                                'assets/icons/img_multi.png'),
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
                                          visible:
                                              isMultipleImages ? true : false,
                                          child: Container(
                                            height: 5,
                                            width: 5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
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
                                            AssetImage(
                                                'assets/icons/img_single.png'),
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
                                          visible:
                                              isMultipleImages ? false : true,
                                          child: Container(
                                            height: 5,
                                            width: 5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Colors.white,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                             */
                            ],
                          ),
                        ))
        ])));
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
      imagePaths.clear();
      imagePaths.add(filePath);
    }
  }

  /*  void callDisplayPictureScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(imagePath: imagePaths),
      ),
    ).then((value) {
      Navigator.pop(context);
    });
  } */

  void callDisplayPictureScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropAndRotateScreen(imagePath: imagePaths),
      ),
    ).then((value) {
      categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);

      if (value) {
        Navigator.of(context).pop(true);
      }
    });
  }

  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(OverlayDeviceDialog()).then((value) {
      setFileName();
      setState(() {});
    });
  }

  void setFileName() {
    if (categoryName == CommonConstants.strDevice) {
      fileName = new TextEditingController(
          text:
              deviceName + '_${DateTime.now().toUtc().millisecondsSinceEpoch}');
    } else {
      fileName = new TextEditingController(
          text: categoryName +
              '_${DateTime.now().toUtc().millisecondsSinceEpoch}');
    }
  }

  setRecognitions(
      recognitions, imageHeight, imageWidth, CameraController control) {
    setState(() {
      recognitions.map((re) {
         _recognitions = recognitions;
      });

      _recognitions = recognitions;

      PreferenceUtil.saveString(Constants.KEY_DEVICENAME,
          deviceNames(_recognitions[0]["detectedClass"]));

      _controller = control;
    });
  }

  Widget _showChooseButton(BuildContext context) {
    final GestureDetector chooseButtonWithGesture = new GestureDetector(
      onTap: _chooseBtnTapped,
      child: new Container(
        width: 100,
        height: 40.0,
        decoration: new BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: new BorderRadius.all(Radius.circular(25.0)),
          border: Border.all(color: Colors.white),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: new Center(
          child: new Text(
            'Choose',
            style: new TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
        child: chooseButtonWithGesture);
  }

  void _chooseBtnTapped() {
    PreferenceUtil.saveString(Constants.stop_detecting, 'YES');

    setState(() {
      isObjectDetecting = false;
    });
  }

  Widget _showConfirmButton(BuildContext context) {
    final GestureDetector addButtonWithGesture = new GestureDetector(
      onTap: _confirmBtnTapped,
      child: new Container(
        width: 100,
        height: 40.0,
        decoration: new BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: new BorderRadius.all(Radius.circular(25.0)),
          border: Border.all(color: Colors.white),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: new Center(
          child: new Text(
            'Confirm',
            style: new TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
        child: addButtonWithGesture);
  }

  void _confirmBtnTapped() {
    PreferenceUtil.saveString(Constants.stop_detecting, 'YES');

    setState(() {
      isObjectDetecting = false;
    });
  }

  String deviceNames(String detectedClass) {
    String device;

    switch (detectedClass) {
      case "BP":
        device = "BP Monitor";
        break;
      case "WS":
        device = "Weighing Scale";
        break;
      case "DT":
        device = "Thermometer";
        break;
      case "GL":
        device = "Glucometer";
        break;
      case "PO":
        device = "Pulse Oximeter";
        break;
      case "Others":
        device = "Choose Device";
        break;
      default:
        device = "Choose Device";
        break;
    }

    return device;
  }

  getWidgetForTitle(BuildContext context) {
    return InkWell(
      child: Text(categoryName),
      onTap: () {
        _showOverlayCategory(context);
      },
    );
  }

  void initializeData(BuildContext _context) {
    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
    if (categoryName != Constants.STR_DEVICES) {
      Navigator.pushNamed(_context, '/take-picture-screen').then((value) {
        Navigator.pop(_context);
      });
    } else {
      setState(() {});
    }
  }

  void _showOverlayCategory(BuildContext context) {
    Navigator.of(context).push(OverlayCategoryDialog()).then((value) {
      initializeData(context);
    });
  }
}

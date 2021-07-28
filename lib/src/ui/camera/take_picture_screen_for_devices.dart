import 'dart:io';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/OverLayCategoryDialog.dart';
import 'package:myfhb/common/OverlayDeviceDialog.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/devices_tensorflow/widgets/camera.dart';
import 'package:myfhb/exception/FetchException.dart';
import 'package:myfhb/src/utils/alert.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';

import 'CropAndRotateScreen.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/router_variable.dart' as router;

import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/common_circular_indicator.dart';

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
  FlutterToast toast = FlutterToast();

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    Constants.mInitialTime = DateTime.now();
    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
    deviceName =
        (PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME) ?? '') == ''
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
    deviceName =
        (PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME) ?? '') == ''
            ? Constants.IS_CATEGORYNAME_DEVICES
            : PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    Constants.fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Take Picture Screen',
      'screenSessionTime':
          '${DateTime.now().difference(Constants.mInitialTime).inSeconds} secs'
    });
    super.dispose();
  }

  loadModel() async {
    await Tflite.loadModel(
        model: variable.strdflit, labels: variable.file_device);
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
            child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
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
                        return CommonCircularIndicator();
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
                              width: 220.0.w,
                              height: 40.0.h,
                              margin: EdgeInsets.all(10),
                              constraints: BoxConstraints(maxWidth: 220.0.w),
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
                                                ? deviceNames(_recognitions[0][
                                                            Constants
                                                                .keyDetectedClass]) !=
                                                        Constants
                                                            .IS_CATEGORYNAME_DEVICES
                                                    ? deviceNames(_recognitions[
                                                            0][
                                                        Constants
                                                            .keyDetectedClass])
                                                    : deviceName[0]
                                                            .toUpperCase() +
                                                        deviceName.substring(1)
                                                : deviceName[0].toUpperCase() +
                                                    deviceName.substring(1)
                                            : deviceName[0].toUpperCase() +
                                                deviceName.substring(1),
                                        maxFontSize: 14,
                                        minFontSize: 10,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0.sp,
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
                            height: 60.0.h,
                            color: Color(new CommonUtil().getMyPrimaryColor()),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(CommonConstants.detecting_the_devices,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400)),
                                  Container(
                                      width: 25.0.h,
                                      height: 25.0.h,
                                      child: CommonCircularIndicator())
                                ]))
                        : _recognitions.length == 0 ||
                                _recognitions[0][Constants.keyDetectedClass] ==
                                    variable.strOthers
                            ? Container(
                                height: 80.0.h,
                                color:
                                    Color(new CommonUtil().getMyPrimaryColor()),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(width: 10.0.w),
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
                                height: 60.0.h,
                                color:
                                    Color(new CommonUtil().getMyPrimaryColor()),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(width: 10.0.w),
                                      Flexible(
                                        child: Text(
                                            variable.strDeviceFound +
                                                ' ${deviceNames(_recognitions[0]["detectedClass"])}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      _showConfirmButton(context)
                                    ]))
                    : isThumbnails
                        ? Container(
                            height: 60.0.h,
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
                                        width: 30.0.w,
                                        height: 40.0.h,
                                        fit: BoxFit.cover,
                                      ),
                                      new Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: new BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 14.0.h,
                                          minHeight: 14.0.h,
                                        ),
                                        child: Text(
                                          (imagePaths.length).toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.0.sp,
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
                                              'Prescription_${DateTime.now().minute}.jpg',
                                            );

                                            // Attempt to take a picture and log where it's been saved.
                                            XFile xpath =
                                                await _controller.takePicture();

                                            imagePaths.add(xpath?.path);

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
                                        builder: (context) =>
                                            CropAndRotateScreen(
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
                            height: 60.0.h,
                            color: Color(new CommonUtil().getMyPrimaryColor()),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
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
                                            setState(() {
                                              imagePaths.clear();
                                            });
                                            // Ensure that the camera is initialized.
                                            await _initializeControllerFuture;

                                            // Construct the path where the image should be saved using the
                                            // pattern package.
                                            final path = join(
                                              // Store the picture in the temp directory.
                                              // Find the temp directory using the `path_provider` plugin.
                                              (await getTemporaryDirectory())
                                                  .path,
                                              'Prescription_${DateTime.now().minute}.jpg',
                                            );
                                            // Attempt to take a picture and log where it's been saved.
                                            XFile xpath =
                                                await _controller.takePicture();

                                            if (isMultipleImages) {
                                              isThumbnails = true;
                                              imagePaths.add(xpath.path);

                                              setState(() {});
                                            } else {
                                              // If the picture was taken, display it on a new screen.
                                              imagePaths.clear();
                                              imagePaths.add(xpath.path);
                                              setState(() {});
                                              callDisplayPictureScreen(context);
                                            }
                                          } catch (e) {
                                            (await getTemporaryDirectory())
                                                .delete(recursive: true);
                                            toast.getToast(
                                                'Something went wrong..Try again',
                                                Colors.red);
                                            // If an error occurs, log the error to the console.
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
          ],
        )));
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: variable.strChat),
        materialOptions: MaterialOptions(
          actionBarColor: fhbColors.actionColor,
          useDetailsView: false,
          selectCircleStrokeColor: fhbColors.colorBlack,
        ),
      );
    } on FetchException catch (e) {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    for (Asset asset in resultList) {
      String filePath =
          await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      imagePaths.add(filePath);
    }

    setState(() {
      images = resultList;
    });
  }

  void callDisplayPictureScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropAndRotateScreen(imagePath: imagePaths),
      ),
    ).then((value) {
      categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);

      if (value == true) {
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
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
      PreferenceUtil.saveString(
          Constants.KEY_DEVICENAME,
          deviceNames(_recognitions.length == 0
              ? ''
              : _recognitions[0][Constants.keyDetectedClass]));

      _controller = control;
    });
  }

  Widget _showChooseButton(BuildContext context) {
    final GestureDetector chooseButtonWithGesture = new GestureDetector(
      onTap: _chooseBtnTapped,
      child: new Container(
        width: 100.0.w,
        height: 40.0.h,
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
            variable.strChoose,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
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
    PreferenceUtil.saveString(Constants.stop_detecting, variable.strYES);

    setState(() {
      isObjectDetecting = false;
    });
  }

  Widget _showConfirmButton(BuildContext context) {
    final GestureDetector addButtonWithGesture = new GestureDetector(
      onTap: _confirmBtnTapped,
      child: new Container(
        width: 100.0.w,
        height: 40.0.h,
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
            variable.strConfirm,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
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
    PreferenceUtil.saveString(Constants.stop_detecting, variable.strYES);

    setState(() {
      isObjectDetecting = false;
    });
  }

  String deviceNames(String detectedClass) {
    String device;

    switch (detectedClass) {
      case variable.strBP:
        device = Constants.STR_BP_MONITOR;
        break;
      case variable.strWS:
        device = Constants.STR_WEIGHING_SCALE;
        break;
      case variable.strDT:
        device = Constants.STR_THERMOMETER;
        break;
      case variable.strGL:
        device = Constants.STR_GLUCOMETER;
        break;
      case variable.strPO:
        device = Constants.STR_PULSE_OXIMETER;
        break;
      case variable.strOthers:
        device = Constants.IS_CATEGORYNAME_DEVICES;
        break;
      default:
        device = Constants.IS_CATEGORYNAME_DEVICES;
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
      Navigator.pushNamed(_context, router.rt_TakePictureScreen).then((value) {
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

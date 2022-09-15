import 'dart:io';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/OverLayCategoryDialog.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/exception/FetchException.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'CropAndRotateScreen.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/common/common_circular_indicator.dart';

import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;

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

  BuildContext _cameraScreenContext;
  //final GlobalKey _titleCategory = GlobalKey();
  final GlobalKey _singleMultiImg = GlobalKey();
  final GlobalKey _attachments = GlobalKey();
  final GlobalKey _gallery = GlobalKey();

  int maxImageNo = 10;
  bool selectSingleImage = false;
  String _platformMessage = 'No Error';

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  String categoryName;
  String categoryID;
  BuildContext _context;

  bool isFlash = false;
  bool _hasFlashlight = false;
  String deviceName;
  @override
  void initState() {
    Constants.mInitialTime = DateTime.now();
    super.initState();

    initFlashlight();

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

/*
    var isFirstTime =
        PreferenceUtil.isKeyValid(Constants.KEY_SHOWCASE_CAMERASCREEN);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          Duration(milliseconds: 200),
          () => isFirstTime
              ? null
              : ShowCaseWidget.of(_cameraScreenContext)
                  .startShowCase([_gallery, _attachments, _singleMultiImg]));
    }); */
  }

  initFlashlight() async {
    // bool hasFlash = await Flashlight.hasFlashlight;
    categoryName =
        await PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
    setState(() {
      _hasFlashlight = false;
    });
  }

  @override
  void dispose() {
    Constants.fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Take Picture Screen',
      'screenSessionTime':
          '${DateTime.now().difference(Constants.mInitialTime).inSeconds} secs'
    });
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return ShowCaseWidget(onFinish: () {
      PreferenceUtil.saveString(
          Constants.KEY_SHOWCASE_CAMERASCREEN, variable.strtrue);
    }, builder: Builder(builder: (context) {
      _cameraScreenContext = context;
      return Scaffold(
          appBar: AppBar(
            flexibleSpace: GradientAppBar(),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 24.0.sp,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: getWidgetForTitle(context),
            actions: <Widget>[
              IconButton(
                  icon: isFlash ? Icon(Icons.flash_off) : Icon(Icons.flash_on),
                  onPressed: () {
                    //isFlash ? Flashlight.lightOff() : Flashlight.lightOn();
                    setState(() {
                      if (isFlash) {
                        isFlash = false;
                      } else {
                        isFlash = true;
                      }
                    });
                  })
            ],
          ),

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
                    return Column(
                      children: [
                        Expanded(
                          child: CameraPreview(_controller),
                        ),
                      ],
                    );
                  } else {
                    // Otherwise, display a loading indicator.
                    return CommonCircularIndicator();
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
                            child: Center(
                              child: Visibility(
                                child: IconButton(
                                  icon: new ImageIcon(
                                    AssetImage(variable.icon_attach),
                                    color: Colors.white,
                                    size: 32.0.sp,
                                  ),
                                  onPressed: () async {
                                    // Take the Picture in a try / catch block. If anything goes wrong,
                                    // catch the error.

                                    if (isMultipleImages) {
                                      await getFilePath();
                                      callDisplayPictureScreen(context);
                                    } else {
                                      try {
                                        var image = await FilePicker.platform
                                            .pickFiles(
                                                type: FileType.custom,
                                                allowedExtensions: [
                                              variable.strpdf
                                            ]);
                                        if ((image?.files?.length ?? 0) > 0) {
                                          imagePaths.add(image.files[0].path);
                                        }
                                        callDisplayPictureScreen(context);
                                      } catch (e) {
                                        // If an error occurs, log the error to the console.
                                      }
                                    }
                                  },
                                ),
                                visible: !isThumbnails ? true : false,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                  size: 40.0.sp,
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
                                      setFileName() +
                                          '${DateTime.now().second}.jpg'.trim(),
                                    );

                                    // Attempt to take a picture and log where it's been saved.
                                    XFile xpath =
                                        await _controller.takePicture();
                                    imagePaths.add(xpath?.path);
                                    setState(() {});
                                  } catch (e) {
                                    // If an error occurs, log the error to the console.
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
                              size: 40.0.sp,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CropAndRotateScreen(
                                      imagePath: imagePaths),
                                ),
                              ).then((value) {
                                categoryName = PreferenceUtil.getStringValue(
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
                          Expanded(
                            child: Center(
                              child: FHBBasicWidget.customShowCase(
                                  _gallery,
                                  Constants.GALLERY_DESC,
                                  IconButton(
                                    icon: Icon(
                                      Icons.photo_library,
                                      color: Colors.white,
                                      size: 32.0.sp,
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
                                          var image = await ImagePicker.platform
                                              .pickImage(
                                                  source: ImageSource.gallery);
                                          filePath = image.path;
                                          imagePaths.add(filePath);
                                          callDisplayPictureScreen(context);
                                        } catch (e) {
                                          // If an error occurs, log the error to the console.
                                        }
                                      }
                                    },
                                  ),
                                  Constants.GALLERY_TITLE),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: FHBBasicWidget.customShowCase(
                                  _attachments,
                                  Constants.ATTACH_DESC,
                                  Visibility(
                                    child: IconButton(
                                      icon: new ImageIcon(
                                        AssetImage(variable.icon_attach),
                                        color: Colors.white,
                                        size: 32.0.sp,
                                      ),
                                      onPressed: () async {
                                        // Take the Picture in a try / catch block. If anything goes wrong,
                                        // catch the error.

                                        if (isMultipleImages) {
                                          await getFilePath();
                                          callDisplayPictureScreen(context);
                                        } else {
                                          try {
                                            var image = await FilePicker
                                                .platform
                                                .pickFiles();
                                            if ((image?.files?.length ?? 0) > 0)
                                              imagePaths
                                                  .add(image.files[0].path);
                                            callDisplayPictureScreen(context);
                                          } catch (e) {
                                            // If an error occurs, log the error to the console.
                                          }
                                        }
                                      },
                                    ),
                                    visible: !isThumbnails ? true : false,
                                  ),
                                  Constants.ATTACH_TITLE),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                  size: 40.0.sp,
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
                                      setFileName() +
                                          '${DateTime.now().second}.jpg'.trim(),
                                    );

                                    // Attempt to take a picture and log where it's been saved.
                                    XFile xpath =
                                        await _controller.takePicture();

                                    if (isMultipleImages) {
                                      isThumbnails = true;
                                      imagePaths.add(xpath?.path);

                                      setState(() {});
                                    } else {
                                      // If the picture was taken, display it on a new screen.
                                      imagePaths.add(xpath?.path);
                                      callDisplayPictureScreen(context);
                                    }
                                  } catch (e) {
                                    // If an error occurs, log the error to the console.
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  FHBBasicWidget.customShowCase(
                                      _singleMultiImg,
                                      Constants.MULTI_IMG_DESC,
                                      new IconButton(
                                          icon: new ImageIcon(
                                            AssetImage(variable.icon_multi),
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
                                      Constants.MULTI_IMG_TITLE),
                                  Visibility(
                                      visible: isMultipleImages ? true : false,
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
                                        AssetImage(variable.icon_image_single),
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
                                          borderRadius:
                                              BorderRadius.circular(30),
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
    }));
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
    if (imagePaths.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CropAndRotateScreen(imagePath: imagePaths),
        ),
      ).then((value) {
        categoryName =
            PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
        if (value ?? false) {
          Navigator.of(context).pop(true);
        }
      });
    }
  }

  String setFileName() {
    if (categoryName == variable.strDevices) {
      return categoryName;
    } else {
      return categoryName;
    }
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
    deviceName =
        (PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME) ?? '') == ''
            ? Constants.IS_CATEGORYNAME_DEVICES
            : PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME);

    categoryID = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYID);
    if (categoryName == Constants.STR_DEVICES) {
      PreferenceUtil.saveString(Constants.stop_detecting, variable.strNO);

      Navigator.pushNamed(_context, router.rt_TakePictureForDevices)
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
    FilePickerResult filePaths = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [variable.strpdf],
    );
    if ((filePaths?.files?.length ?? 0) > 0) {
      for (PlatformFile file in filePaths?.files) {
        String filePath = await FlutterAbsolutePath.getAbsolutePath(file.path);
        imagePaths.add(filePath);
      }
    }
  }
}

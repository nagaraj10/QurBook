import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/OverLayCategoryDialog.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/widgets/RaisedGradientButton.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/ui/camera/DisplayPictureScreen.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class CropAndRotateScreen extends StatefulWidget {
  final List<String> imagePath;

  const CropAndRotateScreen({
    Key key,
    @required this.imagePath,
  }) : super(key: key);

  @override
  CropAndRotateScreenState createState() => CropAndRotateScreenState();
}

class CropAndRotateScreenState extends State<CropAndRotateScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  String categoryName, categoryNameClone;
  String categoryID;
  CarouselSlider carouselSlider;
  int _current = 0;

  String currentImagePath;

  bool _cropping = false;

  @override
  void initState() {
    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
    currentImagePath = widget.imagePath[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          title: getWidgetForTitleAndSwithUser()),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: getCarousalImage(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getWidgetForTitleAndSwithUser() {
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            child: Text(categoryName),
            onTap: () {
              _showOverlayCategoryDialog(context);
            },
          ),
        ),
        new SwitchProfile().buildActions(context, _keyLoader, callBackToRefresh)
      ],
    );
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
  }

  void _showOverlayCategoryDialog(BuildContext context) {
    Navigator.of(context).push(OverlayCategoryDialog()).then((value) {});
  }

  Widget getCarousalImage() {
    int index = _current + 1;

    return Container(
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: carouselSlider = CarouselSlider(
              height: 1.sh,
              initialPage: 0,
              enlargeCenterPage: true,
              reverse: false,
              enableInfiniteScroll: false,
              pauseAutoPlayOnTouch: Duration(seconds: 10),
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                setState(() {
                  _current = index;

                  currentImagePath = widget.imagePath[_current];
                });
              },
              items: widget.imagePath.map((imgUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: 1.sw,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(),
                        child: Container(
                          height: double.infinity,
                          child: imgUrl.contains(variable.strpdf)
                              ? Image.asset(variable.icon_attach)
                              : Image.file(
                                  File(imgUrl),
                                  fit: BoxFit.scaleDown,
                                ),
                        ));
                  },
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 10.0.h,
          ),
          Container(
            width: 50.0.w,
            height: 30.0.h,
            child: Text('$index /' + widget.imagePath.length.toString(),
                style: TextStyle(color: Colors.white)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              //color: _current == index ? Colors.redAccent : Colors.green,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(CommonUtil().getMyPrimaryColor()),
              Color(CommonUtil().getMyGredientColor())
            ])),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 24.0.sp,
                    ),
                    onPressed: goToPrevious,
                  ),
                  IconButton(
                    icon: Icon(Icons.crop, color: Colors.white),
                    onPressed: () {
                      cropImage(currentImagePath);
                    },
                  ),
                  index == widget.imagePath.length
                      ? IconButton(
                          onPressed: () {
                            callDisplayPictureScreen(context);
                          },
                          icon: Icon(Icons.check, color: Colors.white),
                        )
                      : IconButton(
                          onPressed: goToNext,
                          icon: Icon(Icons.arrow_forward_ios,
                              color: Colors.white),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void callDisplayPictureScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(imagePath: widget.imagePath),
      ),
    ).then((value) {
      categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);

      if (value) {
        Navigator.of(context).pop(true);
      }
    });
  }

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  Future<void> cropImage(String filePath) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: filePath,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: variable.strCropper,
            toolbarColor: Color(new CommonUtil().getMyPrimaryColor()),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: variable.strCropper,
        ));
    if (croppedFile != null) {
      widget.imagePath.removeAt(_current);
      setState(() {
        widget.imagePath.insert((_current), croppedFile.path);
      });
    }
  }

  Future showBusyingDialog() async {
    var primaryColor = Theme.of(context).primaryColor;
    return showDialog(
        context: context,
        barrierDismissible: false,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  strokeWidth: 2.0.sp,
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                ),
                SizedBox(
                  width: 10.0.w,
                ),
                Text(
                  variable.strCropping,
                  style: TextStyle(color: primaryColor),
                )
              ],
            ),
          ),
        ));
  }
}

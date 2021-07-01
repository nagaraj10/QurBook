import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import '../common/AudioWidget.dart';
import '../common/CommonConstants.dart';
import '../common/CommonUtil.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:typed_data';
import '../src/utils/screenutils/size_extensions.dart';
import '../common/FHBBasicWidget.dart';
import '../common/PreferenceUtil.dart';
import '../constants/fhb_constants.dart' as Constants;
import '../exception/FetchException.dart';
import 'FeedbacksSucess.dart';
import '../src/blocs/Media/MediaTypeBlock.dart';
import '../src/blocs/health/HealthReportListForUserBlock.dart';
import '../src/model/Category/CategoryData.dart';
import '../src/model/Category/CategoryResponseList.dart';
import '../src/model/Category/catergory_result.dart';
import '../src/model/Media/MediaData.dart';
import '../src/model/Media/MediaTypeResponse.dart';
import '../src/model/Media/media_data_list.dart';
import '../src/model/Media/media_result.dart';
import 'dart:convert';
import '../src/utils/colors_utils.dart';
import '../constants/variable_constant.dart' as variable;
import '../colors/fhb_colors.dart' as fhbColors;
import '../constants/fhb_parameters.dart' as parameters;

class Feedbacks extends StatefulWidget {
  const Feedbacks();
  @override
  _FeedbacksState createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
  List<Asset> resultList = <Asset>[];
  List<Asset> assests = <Asset>[];
  List<ByteData> byteDataList = List();

  List<dynamic> byteDataClonelist = [];
  List<Asset> images = <Asset>[];

  String audioPathMain = '';
  bool containsAudioMain = false;
  FHBBasicWidget fhbBasicWidget = FHBBasicWidget();
  List<String> imagePaths = List();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  CategoryResult categoryDataObj = CategoryResult();
  MediaResult mediaDataObj = MediaResult();

  final feedbackController = TextEditingController();
  bool isFeedBackEmptied = false;
  FocusNode feedbackFocus = FocusNode();
  final HealthReportListForUserBlock _healthReportListForUserBlock =
      HealthReportListForUserBlock();

  String currentDate = '_${DateTime.now().toUtc().millisecondsSinceEpoch}';

  Future<void> loadAssets() async {
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: assests,
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

    for (var asset in resultList) {
      var filePath =
          await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      imagePaths.add(filePath);
    }

    setState(() {
      images = resultList;
    });
  }

  Widget showListViiewBuilder() {
    final length = resultList.length.toDouble();
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemExtent: length,
      itemBuilder: (context, index) {
        final ByteData byteData = byteDataClonelist[index];
        return Container(
          height: 30.0.h,
          width: 30.0.h,
          child: Image.memory(
            byteData.buffer.asUint8List(),
            fit: BoxFit.fill,
          ),
        );
      },
    );
  }

  Widget buildGridView() {
    return images.isNotEmpty
        ? Container(
            height: 150.0.h,
            child: GridView.count(
              crossAxisCount: 1,
              scrollDirection: Axis.horizontal,
              children: List.generate(images.length, (index) {
                var asset = images[index];
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: AssetThumb(
                    asset: asset,
                    width: 100,
                    height: 100,
                  ),
                );
              }),
            ))
        : SizedBox(height: 0.0.h);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(CommonUtil().getMyGredientColor()),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24.0.sp,
            ),
            onPressed: () => Navigator.of(context).pop()),
        title: Text(''),
        centerTitle: false,
        elevation: 0,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  color: Color(CommonUtil().getMyGredientColor()),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /*  Container(
                          height: 60.0.h,
                        ), */
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(variable.icon_fhb,
                              width: 100.0.h, height: 100.0.h),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(variable.strFeedBack,
                                style: TextStyle(
                                    fontSize: 24.0.sp, color: Colors.white))),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            variable.strFeedbackExp,
                            softWrap: true,
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  )),
              Container(
                height: 10.0.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _showFeedbacktextFiled(),
                    Divider(),
                    Container(
                      height: 10.0.h,
                    ),
                    Container(
                      child: Text(variable.strAttachImage),
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Container(
                      height: 80.0.h,
                      width: 80.0.h,
                      color: ColorUtils.greycolor,
                      child: IconButton(
                        icon: ImageIcon(
                          AssetImage(variable.icon_attach),
                          color: Color(CommonUtil().getMyPrimaryColor()),
                          size: 32.0.sp,
                        ),
                        onPressed: loadAssets,
                      ),
                    ),
                    buildGridView(),
                    SizedBox(
                      height: 20.0.h,
                    ),
                    Container(
                      child: Text(variable.strAddVoice),
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    containsAudioMain
                        ? AudioWidget(audioPathMain,
                            (containsAudio, audioPath) {
                            audioPathMain = audioPath;
                            containsAudioMain = containsAudio;

                            setState(() {});
                          })
                        : Container(
                            height: 80.0.h,
                            width: 80.0.h,
                            color: ColorUtils.greycolor,
                            child: fhbBasicWidget.getMicIcon(
                                context, containsAudioMain, audioPathMain,
                                (containsAudio, audioPath) {
                              audioPathMain = audioPath;
                              containsAudioMain = containsAudio;
                              setState(() {});
                            })),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0.h),
                    fhbBasicWidget.getSaveButton(() {
                      setState(() {
                        feedbackController.text.isEmpty
                            ? isFeedBackEmptied = true
                            : isFeedBackEmptied = false;
                        isFeedBackEmptied
                            ? null
                            : onPostDataToServer(context, imagePaths);
                      });
                    }),
                    SizedBox(height: 20.0.h)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void onPostDataToServer(BuildContext context, List<String> imagePaths) async {
    await CommonUtil.showLoadingDialog(
        context, _keyLoader, variable.Please_Wait);

    final Map<String, dynamic> postMainData = {};
    final Map<String, dynamic> postMediaData = {};
    var userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    final catgoryDataList = PreferenceUtil.getCategoryType();

    final categoryID = CommonUtil()
        .getIdForDescription(catgoryDataList, Constants.STR_FEEDBACKS);
    categoryDataObj = CommonUtil()
        .getCategoryObjForSelectedLabel(categoryID, catgoryDataList);
    postMediaData[parameters.strhealthRecordCategory] =
        categoryDataObj.toJson();

    var _mediaTypeBlock = MediaTypeBlock();

    final mediaTypesResponse = await _mediaTypeBlock.getMediTypesList();

    final metaDataFromSharedPrefernce = mediaTypesResponse.result;

    mediaDataObj = CommonUtil().getMediaTypeInfoForParticularLabel(
        categoryID, metaDataFromSharedPrefernce, Constants.STR_FEEDBACKS);

    postMediaData[parameters.strhealthRecordType] = mediaDataObj.toJson();

    postMediaData[variable.strfeedback] = feedbackController.text;
    postMediaData[variable.strmemoText] = '';

    postMediaData[variable.strisDraft] = false;

    postMediaData[variable.strsourceName] = CommonConstants.strTridentValue;
    postMediaData[variable.strmemoTextRaw] = variable.strmemoTextRaw;

    final fileName = Constants.STR_FEEDBACKS + currentDate;

    postMediaData[variable.strfileName] = fileName;

    postMainData[variable.strmetaInfo] = postMediaData;
    var dateTime = DateTime.now();
    postMediaData[parameters.strStartDate] = dateTime.toUtc().toString();
    postMediaData[parameters.strEndDate] = dateTime.toUtc().toString();

    final params = json.encode(postMediaData);

    if (imagePaths != null && imagePaths.isNotEmpty) {
      await _healthReportListForUserBlock
          .createHealtRecords(params.toString(), imagePaths, audioPathMain)
          .then((value) {
        if (value.isSuccess) {
          _healthReportListForUserBlock.getHelthReportLists().then((value) {
            PreferenceUtil.saveCompleteData(Constants.KEY_COMPLETE_DATA, value);

            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            callFeedBackSuccess(context);
          });
        } else {
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        }
      });
    } else {
      await _healthReportListForUserBlock
          .createHealtRecords(params.toString(), imagePaths, audioPathMain)
          .then((savedMetaDataResponse) {
        if (savedMetaDataResponse.isSuccess) {
          PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, '');
          PreferenceUtil.saveMediaData(Constants.KEY_MEDIADATA, null);

          _healthReportListForUserBlock.getHelthReportLists().then((value) {
            PreferenceUtil.saveCompleteData(Constants.KEY_COMPLETE_DATA, value);

            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            callFeedBackSuccess(context);
          });
        } else {
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        }
      });
    }
  }

  void postAudioToServer(String mediaMetaID, BuildContext context) {
    final postImage = Map<String, dynamic>();

    postImage[variable.strmediaMetaId] = mediaMetaID;

    var k = 0;

    if (imagePaths != null && imagePaths.isNotEmpty) {
      for (var i = 0; i < imagePaths.length; i++) {
        _healthReportListForUserBlock
            .saveImage(imagePaths[i], mediaMetaID, '')
            .then((postImageResponse) {
          if ((audioPathMain != '' && k == imagePaths.length) ||
              (audioPathMain != '' && k == imagePaths.length - 1)) {
            _healthReportListForUserBlock
                .saveImage(audioPathMain, mediaMetaID, '')
                .then((postImageResponse) {
              _healthReportListForUserBlock.getHelthReportLists().then((value) {
                PreferenceUtil.saveCompleteData(
                    Constants.KEY_COMPLETE_DATA, value);

                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();
                callFeedBackSuccess(context);
              });
            });
          } else if (k == imagePaths.length - 1) {
            _healthReportListForUserBlock.getHelthReportLists().then((value) {
              PreferenceUtil.saveCompleteData(
                  Constants.KEY_COMPLETE_DATA, value);
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();

              callFeedBackSuccess(context);
            });
          } else if (k == imagePaths.length) {
            _healthReportListForUserBlock.getHelthReportLists().then((value) {
              PreferenceUtil.saveCompleteData(
                  Constants.KEY_COMPLETE_DATA, value);
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();

              callFeedBackSuccess(context);
            });
          }

          k++;
        });
      }
    } else {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      callFeedBackSuccess(context);
    }
  }

  void callFeedBackSuccess(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedbackSuccess()),
    ).then((value) {
      feedbackController.text = '';
      imagePaths.clear();
      images.clear();
      audioPathMain = '';
      containsAudioMain = false;
      setState(() {});
    });
  }

  void saveAudioFile(
      BuildContext context, String audioPath, String mediaMetaID) {
    if (audioPathMain != '') {
      _healthReportListForUserBlock
          .saveImage(audioPathMain, mediaMetaID, '')
          .then((postImageResponse) {
        _healthReportListForUserBlock.getHelthReportLists().then((value) {
          PreferenceUtil.saveCompleteData(Constants.KEY_COMPLETE_DATA, value);

          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

          callFeedBackSuccess(context);
        });
      });
    } else {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      callFeedBackSuccess(context);
    }
  }

  Widget _showFeedbacktextFiled() {
    return TextFormField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: feedbackController,
      keyboardType: TextInputType.text,
      focusNode: feedbackFocus,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (term) {
        feedbackFocus.unfocus();
      },
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor),
      decoration: InputDecoration(
        errorText: isFeedBackEmptied ? variable.strFeedbackEmpty : null,
        hintText: variable.strFeedBack,
        labelStyle: TextStyle(
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.myFamilyGreyColor),
        hintStyle: TextStyle(
          fontSize: 16.0.sp,
          color: ColorUtils.myFamilyGreyColor,
          fontWeight: FontWeight.w400,
        ),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
      ),
    );
  }
}

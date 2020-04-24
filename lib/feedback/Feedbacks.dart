import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:myfhb/common/AudioWidget.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:typed_data';

import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/feedback/FeedbacksSucess.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/model/Media/MediaTypeResponse.dart';
import 'dart:convert';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';

class Feedbacks extends StatefulWidget {
  Function refresh;

  Feedbacks();
  @override
  _FeedbacksState createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
  List<Asset> resultList = List<Asset>();
  List<Asset> assests = List<Asset>();
  List<ByteData> byteDataList = new List();

  List<dynamic> byteDataClonelist = new List();
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  String audioPathMain = '';
  bool containsAudioMain = false;
  FHBBasicWidget fhbBasicWidget = new FHBBasicWidget();
  List<String> imagePaths = new List();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  CategoryData categoryDataObj = new CategoryData();
  MediaData mediaDataObj = new MediaData();

  HealthReportListForUserBlock _healthReportListForUserBlock =
      new HealthReportListForUserBlock();

  Future<void> loadAssets() async {
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: assests,
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

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Widget showListViiewBuilder() {
    var length = resultList.length.toDouble();
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemExtent: length,
      itemBuilder: (BuildContext context, int index) {
        //Asset asset = resultList[index];

        ByteData byteData = byteDataClonelist[index];
        /*return AssetThumb(
          asset: asset,
          width: 50,
          height: 50,
        );*/
        return Container(
          height: 30,
          width: 30,
          child: Image.memory(
            byteData.buffer.asUint8List(),
            // Uint8List.fromList(byteData),
            fit: BoxFit.fill,
          ),
        );
      },
    );
  }

  Widget getAssestWidget() {
    ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemExtent: resultList.length.toDouble(),
      itemBuilder: (BuildContext context, int index) {
        //return Image.memory(resultList[index].buffer.asUint8List());
      },
    );
  }

  Widget buildGridView() {
    return images.length != 0
        ? Container(
            height: 150,
            child: GridView.count(
              crossAxisCount: 1,
              scrollDirection: Axis.horizontal,
              children: List.generate(images.length, (index) {
                Asset asset = images[index];
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
        : SizedBox(height: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(CommonUtil().getMyGredientColor()),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
        title: Text(''),
        centerTitle: false,
        elevation: 0,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                          height: 60,
                        ), */
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Image.asset('assets/launcher/myfhb.png',
                              width: 100, height: 100),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text('Feedback',
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white))),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            'We would like to hear from you on your experience with MyFHB',
                            softWrap: true,
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  )),
              Container(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text('Feedback'),
                    ),
                    Divider(),
                    Container(
                      height: 10,
                    ),
                    Container(
                      child: Text('Attach Image'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 80,
                      width: 80,
                      color: ColorUtils.greycolor,
                      child: IconButton(
                        icon: new ImageIcon(
                          AssetImage('assets/icons/attach.png'),
                          color: Color(new CommonUtil().getMyPrimaryColor()),
                          size: 32,
                        ),
                        onPressed: loadAssets,
                      ),
                    ),
                    buildGridView(),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Text('Add Voice'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    containsAudioMain
                        ? new AudioWidget(audioPathMain,
                            (containsAudio, audioPath) {
                            audioPathMain = audioPath;
                            containsAudioMain = containsAudio;

                            setState(() {});
                          })
                        : Container(
                            height: 80,
                            width: 80,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    fhbBasicWidget.getSaveButton(() {
                      onPostDataToServer(context, imagePaths);
                    }),
                    SizedBox(height: 20)
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

  void recordAudio() {
    print('Audio');
  }

  void onPostDataToServer(BuildContext context, List<String> imagePaths) {
    print('Save');

    CommonUtil.showLoadingDialog(context, _keyLoader, 'Please Wait');

    Map<String, dynamic> postMainData = new Map();
    Map<String, dynamic> postMediaData = new Map();
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    List<CategoryData> catgoryDataList = PreferenceUtil.getCategoryType();

    String categoryID = new CommonUtil()
        .getIdForDescription(catgoryDataList, Constants.STR_FEEDBACKS);
    categoryDataObj = new CommonUtil()
        .getCategoryObjForSelectedLabel(categoryID, catgoryDataList);
    postMediaData["categoryInfo"] = categoryDataObj.toJson();
    List<MediaData> metaDataFromSharedPrefernce = PreferenceUtil.getMediaType();

    mediaDataObj = new CommonUtil().getMediaTypeInfoForParticularLabel(
        categoryID, metaDataFromSharedPrefernce, Constants.STR_FEEDBACKS);

    postMediaData["mediaTypeInfo"] = mediaDataObj.toJson();

    postMediaData["memoText"] = '';

    postMediaData["isDraft"] = false;

    postMediaData["sourceName"] = CommonConstants.strTridentValue;
    postMediaData["memoTextRaw"] = 'memoTextRaw';

    String fileName = Constants.STR_FEEDBACKS +
        '_${DateTime.now().toUtc().millisecondsSinceEpoch}';

    postMediaData["fileName"] = fileName;

    postMainData['metaInfo'] = postMediaData;

    var params = json.encode(postMainData);

    print('params' + params.toString());

    if (imagePaths != null) {
      _healthReportListForUserBlock
          .submit(params.toString())
          .then((savedMetaDataResponse) {
        if (savedMetaDataResponse.success) {
          postAudioToServer(
              savedMetaDataResponse.response.data.mediaMetaID, context);
        }
      });
    } else {
      _healthReportListForUserBlock
          .submit(params.toString())
          .then((savedMetaDataResponse) {
        if (savedMetaDataResponse.success) {
          PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, "");
          PreferenceUtil.saveMediaData(Constants.KEY_MEDIADATA, null);

          saveAudioFile(context, audioPathMain,
              savedMetaDataResponse.response.data.mediaMetaID);
        }
      });
    }
  }

  void postAudioToServer(String mediaMetaID, BuildContext context) {
    Map<String, dynamic> postImage = new Map();

    postImage['mediaMetaId'] = mediaMetaID;
    print('I am here ' + mediaMetaID);
    print('I am here audioPath' + audioPathMain);
    int k = 0;
    for (int i = 0; i < imagePaths.length; i++) {
      _healthReportListForUserBlock
          .saveImage(imagePaths[i], mediaMetaID, '')
          .then((postImageResponse) {
        print('output image mediaMaster images' +
            postImageResponse.response.data.mediaMasterId);

        print('the value of k' +
            k.toString() +
            ' value of length' +
            imagePaths.length.toString());
        if ((audioPathMain != '' && k == imagePaths.length) ||
            (audioPathMain != '' && k == imagePaths.length - 1)) {
          _healthReportListForUserBlock
              .saveImage(audioPathMain, mediaMetaID, '')
              .then((postImageResponse) {
            print('output audio mediaMaster' +
                postImageResponse.response.data.mediaMasterId);

            _healthReportListForUserBlock.getHelthReportList().then((value) {
              PreferenceUtil.saveCompleteData(
                  Constants.KEY_COMPLETE_DATA, value.response.data);

              print('Sucess 1');
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              //PageNavigator.goTo(context, '/feedbacks_success');
              callFeedBackSuccess(context);
            });
          });
        } else if (k == imagePaths.length - 1) {
          _healthReportListForUserBlock.getHelthReportList().then((value) {
            PreferenceUtil.saveCompleteData(
                Constants.KEY_COMPLETE_DATA, value.response.data);
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            print('Sucess 2');

            callFeedBackSuccess(context);
            //PageNavigator.goTo(context, '/feedbacks_success');
          });
        } else if (k == imagePaths.length) {
          _healthReportListForUserBlock.getHelthReportList().then((value) {
            PreferenceUtil.saveCompleteData(
                Constants.KEY_COMPLETE_DATA, value.response.data);
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            print('Sucess 3');

            //PageNavigator.goTo(context, '/feedbacks_success');
            callFeedBackSuccess(context);
          });
        }

        k++;
      });
    }
  }

  void callFeedBackSuccess(BuildContext context) {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new FeedbackSuccess()),
    ).then((value) {
      setState(() {});
    });
  }

  void saveAudioFile(
      BuildContext context, String audioPath, String mediaMetaID) {
    if (audioPathMain != '') {
      _healthReportListForUserBlock
          .saveImage(audioPathMain, mediaMetaID, '')
          .then((postImageResponse) {
        print('output audio mediaMaster saveAudioFile' +
            postImageResponse.response.data.mediaMasterId);
        _healthReportListForUserBlock.getHelthReportList().then((value) {
          PreferenceUtil.saveCompleteData(
              Constants.KEY_COMPLETE_DATA, value.response.data);
          print('Sucess 4');

          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

          PageNavigator.goTo(context, '/feedbacks_success');
        });
      });
    }
  }
}

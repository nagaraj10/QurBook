import 'dart:io';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/bookmark_record/bloc/bookmarkRecordBloc.dart';
import 'package:myfhb/common/AudioWidget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/CommonDialogBox.dart';
import 'package:myfhb/common/PDFViewer.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/screens/FamilyListView.dart';
import 'package:myfhb/record_detail/bloc/deleteRecordBloc.dart';
import 'package:myfhb/record_detail/screens/record_info_card.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/ui/audio/audio_record_screen.dart';
import 'package:myfhb/src/ui/imageSlider.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:carousel_slider/carousel_slider.dart';
export 'package:myfhb/my_family/models/relationship_response_list.dart';
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'dart:typed_data';

class RecordDetailScreen extends StatefulWidget {
  final MediaMetaInfo data;

  const RecordDetailScreen({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  _RecordDetailScreenState createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends State<RecordDetailScreen> {
  DeleteRecordBloc _deleteRecordBloc;
  BookmarkRecordBloc _bookmarkRecordBloc;
  bool _isRecordBookmarked;
  bool containsAudio = false;
  String audioPath = '';
  HealthReportListForUserBlock _healthReportListForUserBlock;
  FamilyListBloc _familyListBloc;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  String categoryName, createdDate;
  var doctorsData, hospitalData, labData;
  bool isAudioDownload = false;

  String deviceName;
  CarouselSlider carouselSlider;
  int _current = 0;
  int index = 0;
  int length = 0;
  List<dynamic> imagesPathMain = new List();
  PermissionStatus permissionStatus = PermissionStatus.undetermined;
  final Permission _storagePermission =
      Platform.isAndroid ? Permission.storage : Permission.photos;
  bool firsTym = true;
  bool ispdfPresent = false;

  String audioMediaId;

  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();

  var pdfFile;
  List<MediaMasterIds> mediMasterId = new List();
  @override
  void initState() {
    super.initState();
    PreferenceUtil.init();
    _listenForPermissionStatus();
    _deleteRecordBloc = DeleteRecordBloc();
    _bookmarkRecordBloc = BookmarkRecordBloc();
    _isRecordBookmarked = widget.data.isBookmarked;
    _healthReportListForUserBlock = new HealthReportListForUserBlock();
    _familyListBloc = new FamilyListBloc();
    _familyListBloc.getFamilyMembersList();

    /* if (widget.data.mediaMasterIds.length > 0) {
      List<MediaMasterIds> mediMasterId =
          new CommonUtil().getMetaMasterIdList(widget.data);

      _healthReportListForUserBlock.getDocumentImageList(mediMasterId);
      if (checkIfMp3IsPresent(widget.data) != '') {
        widget.data.metaInfo.hasVoiceNotes = true;
      } else {
        widget.data.metaInfo.hasVoiceNotes = false;
      }
    } */

    mediMasterId = new CommonUtil().getMetaMasterIdList(widget.data);

    if (checkIfMp3IsPresent(widget.data) != '') {
      widget.data.metaInfo.hasVoiceNotes = true;
      showAudioWidgetIfVoiceNotesAvailable(widget.data);
    }

    String getMediaMasterIDForPdfTypeStr = new CommonUtil()
        .getMediaMasterIDForPdfTypeStr(widget.data.mediaMasterIds);
    if (getMediaMasterIDForPdfTypeStr != null &&
        getMediaMasterIDForPdfTypeStr.length > 0) {
      ispdfPresent = true;
      getPdfFileData(getMediaMasterIDForPdfTypeStr);
    } else {
      ispdfPresent = false;
    }

    if (mediMasterId.length > 0)
      _healthReportListForUserBlock.getDocumentImageList(mediMasterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(fhbColors.bgColorContainer),
        key: scaffold_state,
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          title: AutoSizeText(
            widget.data.metaInfo.fileName == null
                ? toBeginningOfSentenceCase(
                    widget.data.metaInfo.mediaTypeInfo.name)
                : toBeginningOfSentenceCase(widget.data.metaInfo.fileName),
            maxLines: 1,
            minFontSize: 12,
            maxFontSize: 16,
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                    constraints: BoxConstraints(maxHeight: 400),
                    color: Colors.black87,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            flex: 7,
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: (imagesPathMain.length > 0 &&
                                        imagesPathMain != null)
                                    ? getCarousalImage(imagesPathMain)
                                    : (widget.data.metaInfo.mediaTypeInfo
                                                    .name ==
                                                Constants.STR_VOICE_NOTES ||
                                            ispdfPresent == true)
                                        ? getCarousalImage(null)
                                        : getDocumentImageWidgetClone())),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  //Todo need to add action for this icon
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ImageSlider(
                                                imageList: imagesPathMain,
                                              ))),
                                  icon: Icon(
                                    Icons.fullscreen,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '$index /$length',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Builder(
                    builder: (BuildContext contxt) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: _isRecordBookmarked
                                  ? ImageIcon(
                                      AssetImage(
                                          'assets/icons/record_fav_active.png'),
                                      //TODO chnage theme
                                      color: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                    )
                                  : ImageIcon(
                                      AssetImage('assets/icons/record_fav.png'),
                                      color: Colors.black,
                                    ),
                              onPressed: () {
                                bookMarkRecord(widget.data);
                              }),
                          IconButton(
                              icon: ImageIcon(
                                AssetImage('assets/icons/record_switch.png'),
                                color: Colors.black,
                              ),
                              onPressed: () {
                                print('Profile Pressed');
                                //getAllFamilyMembers();
                                CommonUtil.showLoadingDialog(
                                    contxt, _keyLoader, 'Please Wait');

                                if (_familyListBloc != null) {
                                  _familyListBloc = null;
                                  _familyListBloc = new FamilyListBloc();
                                }
                                _familyListBloc
                                    .getFamilyMembersList()
                                    .then((familyMembersList) {
                                  Navigator.of(_keyLoader.currentContext,
                                          rootNavigator: true)
                                      .pop();

                                  getDialogBoxWithFamilyMember(
                                      familyMembersList.response.data);
                                });
                              }),
                          IconButton(
                              icon: ImageIcon(
                                AssetImage('assets/icons/record_edit.png'),
                                color: Colors.black,
                              ),
                              onPressed: () {
                                openAlertDialogBasedOnRecordDetails();
                              }),
                          IconButton(
                              icon: ImageIcon(
                                AssetImage('assets/icons/record_download.png'),
                                color: Colors.black,
                              ),
                              onPressed: () async {
                                requestPermission(_storagePermission)
                                    .then((status) {
                                  if (status == PermissionStatus.granted) {
                                    saveImageToGallery(imagesPathMain, contxt);
                                  } else {
                                    print(
                                        'storage permission has not been given by the user');
                                  }
                                });
                              }),
                          IconButton(
                              icon: ImageIcon(
                                AssetImage('assets/icons/record_delete.png'),
                                color: Colors.black,
                              ),
                              onPressed: () {
                                deleteRecord(widget.data.id);
                              })
                        ],
                      );
                    },
                  ),
                ),
                getCategoryInfo(widget.data.metaInfo),
                SizedBox(height: 80)
              ],
            ),
            containsAudio
                ? getAudioIconWithFile()
                : Container(
                    color: const Color(fhbColors.bgColorContainer),
                    child: widget.data.metaInfo.hasVoiceNotes != null &&
                            widget.data.metaInfo.hasVoiceNotes
                        ? isAudioDownload
                            ? getAudioIconWithFile()
                            : Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[200],
                                child: showProgressIndicator(widget.data))
                        : InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => AudioRecordScreen(
                                  fromVoice: false,
                                ),
                              ))
                                  .then((results) {
                                if (results != null) {
                                  if (results.containsKey('audioFile')) {
                                    containsAudio = true;
                                    audioPath = results['audioFile'];
                                    print('Audio Path' + audioPath);
                                    _healthReportListForUserBlock
                                        .saveImage(
                                            audioPath, widget.data.id, '')
                                        .then((postImageResponse) {
                                      print('output audio mediaMaster' +
                                          postImageResponse
                                              .response.data.mediaMasterId);

                                      audioMediaId = postImageResponse
                                          .response.data.mediaMasterId;

                                      _healthReportListForUserBlock
                                          .getHelthReportList()
                                          .then((value) {
                                        PreferenceUtil.saveCompleteData(
                                            Constants.KEY_COMPLETE_DATA,
                                            value.response.data);
                                        setState(() {});
                                      });
                                      //setState(() {});
                                    });
                                  }
                                }
                              });
                            },
                            child: Container(
                              height: 60,
                              color: Colors.white70,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.mic,
                                    color: Color(
                                        new CommonUtil().getMyPrimaryColor()),
                                  ),
                                  SizedBox(width: 10),
                                  Text('Add voice note',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(new CommonUtil()
                                            .getMyPrimaryColor()),
                                      ))
                                ],
                              ),
                            ),
                          ),
                  )
          ],
        ));
  }

  void _listenForPermissionStatus() async {
    final status = await _storagePermission.status;
    setState(() => permissionStatus = status);
  }

  void saveImageToGallery(List imagesPathMain, BuildContext contxt) async {
    //check the storage permission for both android and ios!
    Scaffold.of(contxt).showSnackBar(SnackBar(
      content: Text('Download Started'),
      backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
    ));

    if (imagesPathMain.length > 1) {
      for (int i = 0; i < imagesPathMain.length; i++) {
        await ImageGallerySaver.saveImage(imagesPathMain[i]);
      }
      Scaffold.of(contxt).showSnackBar(SnackBar(
        content: Text('All Files are downloaded, view in Gallery'),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
      ));
    } else {
      await ImageGallerySaver.saveImage(imagesPathMain[0]).then((res) {
        Scaffold.of(contxt).showSnackBar(SnackBar(
          content: Text('File downloaded, view in Gallery'),
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        ));
        return;
      });
    }
  }

  getCategoryInfo(MetaInfo metaInfo) {
    switch (metaInfo.categoryInfo.categoryDescription) {
      case 'Catcode001':
        return RecordInfoCard().getCardForPrescription(
            widget.data.metaInfo, widget.data.createdOn);
        break;
      case 'Catcode002':
        return RecordInfoCard()
            .getCardForDevices(widget.data.metaInfo, widget.data.createdOn);
        break;
      case 'Catcode003':
        return RecordInfoCard()
            .getCardForLab(widget.data.metaInfo, widget.data.createdOn);
        break;
      case 'Catcode004':
        return RecordInfoCard().getCardForMedicalRecord(
            widget.data.metaInfo, widget.data.createdOn);
        break;
      case 'Catcode005':
        return RecordInfoCard().getCardForBillsAndOthers(
            widget.data.metaInfo, widget.data.createdOn);
        break;
      case 'Catcode006':
        return RecordInfoCard()
            .getCardForIDDocs(widget.data.metaInfo, widget.data.createdOn);
        break;
      case 'Catcode007':
        return RecordInfoCard().getCardForBillsAndOthers(
            widget.data.metaInfo, widget.data.createdOn);
        break;
      case 'Catcode010':
        return RecordInfoCard().getCardForBillsAndOthers(
            widget.data.metaInfo, widget.data.createdOn);
        break;
      case 'Catcode011':
        return RecordInfoCard().getCardForBillsAndOthers(
            widget.data.metaInfo, widget.data.createdOn);
        break;

      default:
        return RecordInfoCard().getCardForPrescription(
            widget.data.metaInfo, widget.data.createdOn);
    }
  }

  deleteRecord(String id) {
    List<String> mediaIds = [];
    mediaIds.add(id);
    _deleteRecordBloc.deleteRecord(mediaIds).then((deleteRecordResponse) {
      if (deleteRecordResponse.success) {
        _healthReportListForUserBlock.getHelthReportList().then((value) {
          PreferenceUtil.saveCompleteData(
              Constants.KEY_COMPLETE_DATA, value.response.data);
          Navigator.of(context).pop();
        });
      }
    });
  }

  deleteMediRecord(String id) {
    List<String> mediaIds = [];
    mediaIds.add(id);
    _deleteRecordBloc
        .deleteRecordOnMediaMasterID(mediaIds)
        .then((deleteRecordResponse) {
      if (deleteRecordResponse.success) {
        _healthReportListForUserBlock.getHelthReportList().then((value) {
          PreferenceUtil.saveCompleteData(
              Constants.KEY_COMPLETE_DATA, value.response.data);
          widget.data.metaInfo.hasVoiceNotes = false;
          setState(() {});
        });
      }
    });
  }

  bookMarkRecord(MediaMetaInfo data) {
    List<String> mediaIds = [];
    mediaIds.add(data.id);

    if (_isRecordBookmarked) {
      _isRecordBookmarked = false;
    } else {
      _isRecordBookmarked = true;
    }

    _bookmarkRecordBloc
        .bookMarcRecord(mediaIds, _isRecordBookmarked)
        .then((bookmarkRecordResponse) {
      if (bookmarkRecordResponse.success) {
        setState(() {});

        _healthReportListForUserBlock.getHelthReportList().then((value) {
          PreferenceUtil.saveCompleteData(
              Constants.KEY_COMPLETE_DATA, value.response.data);
        });
      }
    });
  }

  Widget getAudioIconWithFile({String fpath}) {
    var path = (fpath != null || fpath != '') ? fpath : audioPath;
    print(
        '----------- audio path at getAudioIconWithFile $audioPath-------------');
    return Container(
        //height: 60,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new AudioWidget(audioPath, (containsAudioClone, audioPathClone) {
          containsAudio = containsAudioClone;
          audioPath = audioPathClone;
          // print('Delete Media Meta');
          deleteMediRecord(audioMediaId);
        }),
      ],
    ));
  }

  void deleteAudioFile() {
    print('inside delete');
    audioPath = null;
    containsAudio = false;
    setState(() {});
  }

  /* Future<Widget> getDialogBoxWithFamilyMember(FamilyData familyData) {
                                        return new FamilyListView(familyData).getDialogBoxWithFamilyMember(
                                            familyData, context, _keyLoader, (context, value) {
                                          /*PreferenceUtil.saveString(Constants.KEY_USERID, value).then((onValue) {
                                                                                                    Navigator.of(context).pop();
                                                                                                    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                                                                                                  });*/
                                          print('user id of the family member' + value.toString());
                                          print(widget.data.id);
                                          Navigator.of(context).pop();
                                          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                                    
                                          _healthReportListForUserBlock
                                              .switchDataToOtherUser(value, widget.data.id)
                                              .then((moveMetaDataResponse) {
                                            if (moveMetaDataResponse.success) {
                                              print('moveMetaDataResponse.success' + moveMetaDataResponse.message);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            } else {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            }
                                          });
                                        });
                                      } */

  Future<Widget> getDialogBoxWithFamilyMember(FamilyData familyData) {
    return new FamilyListView(familyData).getDialogBoxWithFamilyMember(
        familyData, context, _keyLoader, (context, userId, userName) {
      print('user id of the family member' + userId.toString());
      print(widget.data.id);
      //Navigator.of(context).pop();

      _healthReportListForUserBlock
          .switchDataToOtherUser(userId, widget.data.id)
          .then((moveMetaDataResponse) {
        if (moveMetaDataResponse.success) {
          print('moveMetaDataResponse.success' + moveMetaDataResponse.message);
          _healthReportListForUserBlock.getHelthReportList().then((value) {
            PreferenceUtil.saveCompleteData(
                Constants.KEY_COMPLETE_DATA, value.response.data);
            print('Saved data');

            Future.delayed(const Duration(seconds: 2), () {
              new FHBBasicWidget()
                  .showInSnackBar(moveMetaDataResponse.message, scaffold_state);
            });

            Navigator.pop(context);
            Navigator.pop(context);
          });
        } else {
          Navigator.pop(context);
          new FHBBasicWidget()
              .showInSnackBar(moveMetaDataResponse.message, scaffold_state);
        }
      });
    });
  }

  void openAlertDialogBasedOnRecordDetails() {
    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);

    if (widget.data.metaInfo.doctor != null)
      doctorsData = widget.data.metaInfo.doctor.toJson();
    if (widget.data.metaInfo.laboratory != null)
      labData = widget.data.metaInfo.laboratory.toJson();
    if (widget.data.metaInfo.hospital != null)
      hospitalData = widget.data.metaInfo.hospital.toJson();
    createdDateMethod();

    if (categoryName != Constants.STR_DEVICES) {
      String date = widget.data.metaInfo.dateOfVisit != null
          ? widget.data.metaInfo.dateOfVisit
          : '';

      if (date != '') {
        date = FHBUtils().getFormattedDateOnly(date);
      }
      switch (categoryName) {
        case Constants.STR_PRESCRIPTION:
          String fileName = widget.data.metaInfo.fileName;

          new CommonDialogBox().getDialogBoxForPrescription(
              context,
              new TextEditingController(
                  text: hospitalData != null ? hospitalData['name'] : ''),
              new TextEditingController(
                  text: doctorsData != null ? doctorsData['name'] : ''),
              new TextEditingController(text: date),
              containsAudio,
              audioPath, (containsAudio, audioPath) {
            setState(() {
              audioPath = audioPath;
              containsAudio = containsAudio;
            });
          }, () {
            setState(() {});
          }, (containsAudio, audioPath) {
            audioPath = audioPath;
            containsAudio = containsAudio;

            setState(() {});
          }, new List(), widget.data, true,
              new TextEditingController(text: fileName));

          // getDialogBoxForPrescription(context);
          break;

        case Constants.STR_BILLS:
          String fileName = widget.data.metaInfo.fileName;

          new CommonDialogBox().getDialogBoxForBillsAndOthers(
              context,
              containsAudio,
              audioPath,
              (containsAudio, audioPath) {
                setState(() {
                  audioPath = audioPath;
                  containsAudio = containsAudio;
                });
              },
              new List(),
              (containsAudio, audioPath) {
                audioPath = audioPath;
                containsAudio = containsAudio;

                setState(() {});
              },
              widget.data,
              true,
              new TextEditingController(text: fileName));

          break;

        case Constants.STR_LABREPORT:
          String fileName = widget.data.metaInfo.fileName;

          new CommonDialogBox().getDialogBoxForLabReport(
              context,
              new TextEditingController(
                  text: labData != null ? labData['name'] : ''),
              new TextEditingController(
                  text: doctorsData != null ? doctorsData['name'] : ''),
              new TextEditingController(text: date),
              containsAudio,
              audioPath, (containsAudio, audioPath) {
            print('Audio Path delete' + containsAudio.toString());
            print('Audio Path delete' + audioPath.toString());

            setState(() {
              audioPath = audioPath;
              containsAudio = containsAudio;
            });
          }, () {
            setState(() {});
          }, (containsAudio, audioPath) {
            print('Audio Path DisplayPicture' + containsAudio.toString());
            print('Audio Path DisplayPicture' + audioPath.toString());

            audioPath = audioPath;
            containsAudio = containsAudio;

            setState(() {});
          }, new List(), widget.data, true,
              new TextEditingController(text: fileName));
          break;
        case Constants.STR_MEDICALREPORT:
          String fileName = widget.data.metaInfo.fileName;

          new CommonDialogBox().getDialogBoxForPrescription(
              context,
              new TextEditingController(
                  text: hospitalData != null ? hospitalData['name'] : ''),
              new TextEditingController(
                  text: doctorsData != null ? doctorsData['name'] : ''),
              new TextEditingController(
                  text: widget.data.metaInfo.dateOfVisit != null
                      ? widget.data.metaInfo.dateOfVisit
                      : ''),
              containsAudio,
              audioPath, (containsAudio, audioPath) {
            print('Audio Path delete' + containsAudio.toString());
            print('Audio Path delete' + audioPath.toString());

            setState(() {
              audioPath = audioPath;
              containsAudio = containsAudio;
            });
          }, () {
            setState(() {});
          }, (containsAudio, audioPath) {
            print('Audio Path DisplayPicture' + containsAudio.toString());
            print('Audio Path DisplayPicture' + audioPath.toString());

            audioPath = audioPath;
            containsAudio = containsAudio;

            setState(() {});
          }, new List(), widget.data, true,
              new TextEditingController(text: fileName));

          break;
        case Constants.STR_CLAIMSRECORD:
          String fileName = widget.data.metaInfo.fileName;

          new CommonDialogBox().getDialogBoxForBillsAndOthers(
              context,
              containsAudio,
              audioPath,
              (containsAudio, audioPath) {
                print('Audio Path delete' + containsAudio.toString());
                print('Audio Path delete' + audioPath.toString());

                setState(() {
                  audioPath = audioPath;
                  containsAudio = containsAudio;
                });
              },
              new List(),
              (containsAudio, audioPath) {
                print('Audio Path DisplayPicture' + containsAudio.toString());
                print('Audio Path DisplayPicture' + audioPath.toString());

                audioPath = audioPath;
                containsAudio = containsAudio;

                setState(() {});
              },
              widget.data,
              true,
              new TextEditingController(text: fileName));

          break;
        case Constants.STR_IDDOCS:
          String fileName = widget.data.metaInfo.fileName;

          new CommonDialogBox().getDialogForIDDocs(
              context,
              containsAudio,
              audioPath,
              (containsAudio, audioPath) {
                print('Audio Path delete' + containsAudio.toString());
                print('Audio Path delete' + audioPath.toString());

                setState(() {
                  audioPath = audioPath;
                  containsAudio = containsAudio;
                });
              },
              new List(),
              (containsAudio, audioPath) {
                audioPath = audioPath;
                containsAudio = containsAudio;

                setState(() {});
              },
              widget.data,
              true,
              new TextEditingController(text: fileName),
              new TextEditingController(text: date),
              widget.data.metaInfo.idType);
          break;

        case Constants.STR_OTHERS:
          String fileName = widget.data.metaInfo.fileName;

          new CommonDialogBox().getDialogBoxForBillsAndOthers(
              context,
              containsAudio,
              audioPath,
              (containsAudio, audioPath) {
                setState(() {
                  audioPath = audioPath;
                  containsAudio = containsAudio;
                });
              },
              new List(),
              (containsAudio, audioPath) {
                audioPath = audioPath;
                containsAudio = containsAudio;

                setState(() {});
              },
              widget.data,
              true,
              new TextEditingController(text: fileName));

          break;
      }
    } else {
      deviceName = widget.data.metaInfo.mediaTypeInfo.name;
      print('pary deviceName' + deviceName);
      PreferenceUtil.saveString(Constants.KEY_DEVICENAME, deviceName)
          .then((value) {
        switch (deviceName) {
          case Constants.STR_GLUCOMETER:
            String glucoMeterValue = widget.data.metaInfo.deviceReadings != null
                ? widget.data.metaInfo.deviceReadings[0].value
                : '';
            String fileName = widget.data.metaInfo.fileName;
            List<bool> isSelected =
                widget.data.metaInfo.deviceReadings[1].unit == 'After'
                    ? [false, true]
                    : [true, false];
            new CommonDialogBox().getDialogBoxForGlucometer(
                context,
                deviceName,
                containsAudio,
                audioPath,
                (containsAudio, audioPath) {
                  setState(() {
                    audioPath = audioPath;
                    containsAudio = containsAudio;
                  });
                },
                new List(),
                (containsAudio, audioPath) {
                  audioPath = audioPath;
                  containsAudio = containsAudio;

                  setState(() {});
                },
                widget.data,
                true,
                new TextEditingController(text: glucoMeterValue),
                isSelected,
                new TextEditingController(text: fileName));
            break;

          case Constants.STR_THERMOMETER:
            String thermometerValue =
                widget.data.metaInfo.deviceReadings != null
                    ? widget.data.metaInfo.deviceReadings[0].value
                    : '';
            String fileName = widget.data.metaInfo.fileName;

            new CommonDialogBox().getDialogBoxForTemperature(
                context,
                deviceName,
                containsAudio,
                audioPath,
                (containsAudio, audioPath) {
                  setState(() {
                    audioPath = audioPath;
                    containsAudio = containsAudio;
                  });
                },
                new List(),
                (containsAudio, audioPath) {
                  audioPath = audioPath;
                  containsAudio = containsAudio;

                  setState(() {});
                },
                widget.data,
                true,
                new TextEditingController(text: thermometerValue),
                new TextEditingController(text: fileName));
            break;
          case Constants.STR_WEIGHING_SCALE:
            String weightInKgs = widget.data.metaInfo.deviceReadings != null
                ? widget.data.metaInfo.deviceReadings[0].value
                : '';
            String fileName = widget.data.metaInfo.fileName;

            new CommonDialogBox().getDialogBoxForWeightingScale(
                context,
                deviceName,
                containsAudio,
                audioPath,
                (containsAudio, audioPath) {
                  setState(() {
                    audioPath = audioPath;
                    containsAudio = containsAudio;
                  });
                },
                new List(),
                (containsAudio, audioPath) {
                  audioPath = audioPath;
                  containsAudio = containsAudio;

                  setState(() {});
                },
                widget.data,
                true,
                new TextEditingController(text: weightInKgs),
                new TextEditingController(text: fileName));
            break;

          case Constants.STR_PULSE_OXIMETER:
            String oxygenSaturation =
                widget.data.metaInfo.deviceReadings != null
                    ? widget.data.metaInfo.deviceReadings[0].value
                    : '';
            String pulse = widget.data.metaInfo.deviceReadings != null
                ? widget.data.metaInfo.deviceReadings[1].value
                : '';
            String fileName = widget.data.metaInfo.fileName;

            new CommonDialogBox().getDialogBoxForPulseOxidometer(
                context,
                deviceName,
                containsAudio,
                audioPath,
                (containsAudio, audioPath) {
                  setState(() {
                    audioPath = audioPath;
                    containsAudio = containsAudio;
                  });
                },
                new List(),
                (containsAudio, audioPath) {
                  audioPath = audioPath;
                  containsAudio = containsAudio;

                  setState(() {});
                },
                widget.data,
                true,
                new TextEditingController(text: oxygenSaturation),
                new TextEditingController(text: pulse),
                new TextEditingController(text: fileName));
            break;
          case Constants.STR_BP_MONITOR:
            String systolicPressure =
                widget.data.metaInfo.deviceReadings != null
                    ? widget.data.metaInfo.deviceReadings[0].value
                    : '';
            String diastolicPressure =
                widget.data.metaInfo.deviceReadings != null
                    ? widget.data.metaInfo.deviceReadings[1].value
                    : '';
            String pulse = widget.data.metaInfo.deviceReadings != null
                ? widget.data.metaInfo.deviceReadings[2].value
                : '';
            String fileName = widget.data.metaInfo.fileName;

            new CommonDialogBox().getDialogBoxForBPMonitor(
                context,
                deviceName,
                containsAudio,
                audioPath,
                (containsAudio, audioPath) {
                  setState(() {
                    audioPath = audioPath;
                    containsAudio = containsAudio;
                  });
                },
                new List(),
                (containsAudio, audioPath) {
                  audioPath = audioPath;
                  containsAudio = containsAudio;

                  setState(() {});
                },
                widget.data,
                true,
                new TextEditingController(text: systolicPressure),
                new TextEditingController(text: pulse),
                new TextEditingController(text: diastolicPressure),
                new TextEditingController(text: fileName));
            break;
        }
      });
    }
  }

  void postAudioToServer(String mediaMetaID) {
    Map<String, dynamic> postImage = new Map();

    postImage['mediaMetaId'] = mediaMetaID;
    print('I am here ' + mediaMetaID);
    print('I am here audioPath' + audioPath);
    if (audioPath != '') {
      _healthReportListForUserBlock
          .saveImage(audioPath, mediaMetaID, '')
          .then((postImageResponse) {
        print('output audio mediaMaster' +
            postImageResponse.response.data.mediaMasterId);

        _healthReportListForUserBlock.getHelthReportList().then((value) {
          PreferenceUtil.saveCompleteData(
              Constants.KEY_COMPLETE_DATA, value.response.data);
          setState(() {});
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(postImageResponse.message),
          ));
        });
      });
    } else {
      setState(() {});
    }
  }

  void createdDateMethod() {
    var parsedDate = DateTime.parse(widget.data.createdOn);
    final dateFormatter = DateFormat('dd/MM/yyyy');
    createdDate = dateFormatter.format(parsedDate);
  }

  Widget getCarousalImage(List<dynamic> imagesPath) {
    print('inside not clone');
    if (imagesPath != null && imagesPath.length > 0) {
      index = _current + 1;
      _current = 0;
      length = imagesPath.length;
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          widget.data.metaInfo.mediaTypeInfo.name != Constants.STR_VOICE_NOTES
              ? (imagesPath != null && imagesPath.length > 0)
                  ? Expanded(
                      child: carouselSlider = CarouselSlider(
                        height: 400,
                        //width: MediaQuery.of(context).size.width,
                        initialPage: 0,
                        enlargeCenterPage: true,
                        reverse: false,
                        enableInfiniteScroll: false,
                        pauseAutoPlayOnTouch: Duration(seconds: 10),
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index) {
                          setState(() {
                            _current = index;
                          });
                        },
                        items: imagesPath.map((imgUrl) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                height: double.infinity,
                                child: Image.memory(
                                  Uint8List.fromList(imgUrl),
                                  fit: BoxFit.fill,
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    )
                  : ispdfPresent
                      ? pdfFile == null
                          ? Container(child: CircularProgressIndicator())
                          : Container(
                              child: IconButton(
                                icon: ImageIcon(
                                    AssetImage('assets/icons/attach.png'),
                                    color: Colors.white),
                                onPressed: () {
                                  //print('pdf is pressed');
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PDFViewer(pdfFile),
                                  ));
                                },
                              ),
                            )
                      : Container(
                          child: Icon(
                            Icons.mic,
                            color: Color(new CommonUtil().getMyPrimaryColor()),
                          ),
                        )
              : Container(
                  child: Icon(Icons.mic, size: 60, color: Colors.white)),

          /* SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineB//utton(
                  onPressed: goToPrevious,
                  child: Text("<"),
                ),
                OutlineButton(
                  onPressed: goToNext,
                  child: Text(">"),
                ),
                SizedBox(
                  width: 35,
                ),
                Container(
                  width: 50.0,
                  height: 30.0,
                  child: Text('$index /' + imagesPath.length.toString()),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    //color: _current == index ? Colors.redAccent : Colors.green,
                  ),
                )
              ],
            ),*/
        ],
      ),
    );
  }

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  Widget getDocumentImageWidgetClone() {
    //print('inside clone');

    if (_healthReportListForUserBlock != null) {
      _healthReportListForUserBlock = null;
      _healthReportListForUserBlock = new HealthReportListForUserBlock();
    } else {
      _healthReportListForUserBlock = new HealthReportListForUserBlock();
    }

    _healthReportListForUserBlock.getDocumentImageList(mediMasterId);

    return StreamBuilder<ApiResponse<List<dynamic>>>(
      stream: _healthReportListForUserBlock.imageListStream,
      builder: (context, AsyncSnapshot<ApiResponse<List<dynamic>>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Center(
                  child: SizedBox(
                child: CircularProgressIndicator(),
                width: 30,
                height: 30,
              ));
              break;

            case Status.ERROR:
              return Center(
                  child: Text(Constants.STR_ERROR_LOADING_IMAGE,
                      style: TextStyle(color: Colors.red)));
              break;

            case Status.COMPLETED:
              /* if (ispdfPresent) {
                pdfFile = snapshot.data.data;
              } else {*/
              imagesPathMain.addAll(snapshot.data.data);
              /* }*/
              return getCarousalImage(snapshot.data.data);
              break;
          }
        } else {
          return Container(
            width: 100,
            height: 100,
          );
        }
      },
    );
  }

  Future<PermissionStatus> requestPermission(
      Permission storagePermission) async {
    final status = await storagePermission.request();

    setState(() {
      print(status);
      permissionStatus = status;
    });

    return status;
  }

  /*showAudioWidgetIfVoiceNotesAvailable(MediaMetaInfo data) {
                                        if (data.metaInfo.hasVoiceNotes) {
                                    
                                          String mediaMetaId= new CommonUtil().getMediaMasterIDForAudioFileType(data.mediaMasterIds);
                                          getWidgetForPlayingAudioFromServer(mediaMetaId);
                                          //getWidgetForPlayingAudioFromServer('5af2ee90-593e-4672-966d-a2871f70357a');
                                        }
                                      }*/

  showAudioWidgetIfVoiceNotesAvailable(MediaMetaInfo data) {
    if (data.metaInfo.hasVoiceNotes) {
      audioMediaId = checkIfMp3IsPresent(data);
      print(audioMediaId + ' inside showAudioWidgetIfVoiceNotesAvailable');
      getWidgetForPlayingAudioFromServer(audioMediaId);
    }
  }

  String checkIfMp3IsPresent(MediaMetaInfo data) {
    String mediaMetaId = "";

    mediaMetaId =
        new CommonUtil().getMediaMasterIDForAudioFileType(data.mediaMasterIds);
    return mediaMetaId;
  }

  Widget getWidgetForPlayingAudioFromServer(String audioMediaId) {
    print('audioMediaId' + audioMediaId);
    if (_healthReportListForUserBlock != null) {
      _healthReportListForUserBlock = null;
      _healthReportListForUserBlock = new HealthReportListForUserBlock();
    } else {
      _healthReportListForUserBlock = new HealthReportListForUserBlock();
    }
    _healthReportListForUserBlock.getDocumentImage(audioMediaId).then((res) {
      return downloadMedia(res, context);
    });
  }

  downloadMedia(List data, BuildContext context) {
    var path;
    FHBUtils.createFolderInAppDocDir('myFHB/Audio').then((filePath) {
      path = '$filePath${widget.data.metaInfo.fileName}.mp3';
      new File(path).writeAsBytesSync(data);
      containsAudio = true;
      audioPath = path;
      print('----------- audio path at download media $audioPath-------------');
      isAudioDownload = true;
      setState(() {});
    });
  }

  showProgressIndicator(MediaMetaInfo data) {
    showAudioWidgetIfVoiceNotesAvailable(data);
  }

  void getPdfFileData(String pdfFileMediaId) {
    if (_healthReportListForUserBlock != null) {
      _healthReportListForUserBlock = null;
      _healthReportListForUserBlock = new HealthReportListForUserBlock();
    } else {
      _healthReportListForUserBlock = new HealthReportListForUserBlock();
    }
    _healthReportListForUserBlock.getDocumentImage(pdfFileMediaId).then((res) {
      print('inside getPDFFIleData');
      pdfFile = res;
      setState(() {});
    });
  }
}

import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/bookmark_record/bloc/bookmarkRecordBloc.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/AudioWidget.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonDialogBox.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PDFViewer.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/FamilyData.dart';
import 'package:myfhb/my_family/screens/FamilyListView.dart';
import 'package:myfhb/record_detail/bloc/deleteRecordBloc.dart';
import 'package:myfhb/record_detail/model/ImageDocumentResponse.dart';
import 'package:myfhb/record_detail/screens/record_info_card.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Health/MediaMasterIds.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/MetaInfo.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/ui/audio/audio_record_screen.dart';
import 'package:myfhb/src/ui/imageSlider.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

export 'package:myfhb/my_family/models/relationship_response_list.dart';

typedef void OnError(Exception exception);

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
  List<ImageDocumentResponse> imagesPathMain = new List();
  // PermissionStatus permissionStatus = PermissionStatus.unknown;
  //final PermissionHandler _storagePermission = Platform.isAndroid ? Permission.storage : Permission.photos;
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
                                          variable.icon_record_fav_active),
                                      //TODO chnage theme
                                      color: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                    )
                                  : ImageIcon(
                                      AssetImage(variable.icon_record_fav),
                                      color: Colors.black,
                                    ),
                              onPressed: () {
                                bookMarkRecord(widget.data);
                              }),
                          IconButton(
                              icon: ImageIcon(
                                AssetImage(variable.icon_record_switch),
                                color: Colors.black,
                              ),
                              onPressed: () {
                                //getAllFamilyMembers();
                                if (PreferenceUtil.getFamilyData(
                                        Constants.KEY_FAMILYMEMBER) !=
                                    null) {
                                  getDialogBoxWithFamilyMember(
                                      PreferenceUtil.getFamilyData(
                                          Constants.KEY_FAMILYMEMBER));
                                } else {
                                  CommonUtil.showLoadingDialog(
                                      contxt, _keyLoader, variable.Please_Wait);

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
                                }
                              }),
                          IconButton(
                              icon: ImageIcon(
                                AssetImage(variable.icon_edit),
                                color: Colors.black,
                              ),
                              onPressed: () {
                                openAlertDialogBasedOnRecordDetails();
                              }),
                          IconButton(
                              icon: ImageIcon(
                                AssetImage(variable.icon_download),
                                color: Colors.black,
                              ),
                              onPressed: () async {
                                saveImageToGallery(imagesPathMain, contxt);

                                /*requestPermission(_storagePermission)
                                    .then((status) {
                                  if (status == PermissionStatus.granted) {
                                  }
                                });*/
                              }),
                          IconButton(
                              icon: ImageIcon(
                                AssetImage(variable.icon_delete),
                                color: Colors.black,
                              ),
                              onPressed: () {
                                new FHBBasicWidget()
                                    .showDialogWithTwoButtons(context, () {
                                  deleteRecord(widget.data.id);
                                }, 'Confirmation',
                                        'Are you sure you want to delete');
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
                                  if (results
                                      .containsKey(Constants.keyAudioFile)) {
                                    containsAudio = true;
                                    audioPath = results[Constants.keyAudioFile];
                                    _healthReportListForUserBlock
                                        .saveImage(
                                            audioPath, widget.data.id, '')
                                        .then((postImageResponse) {
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
                                  Text(variable.strAddVoiceNote,
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
    // final status = await _storagePermission.status;
    //setState(() => permissionStatus = status);
  }

  void saveImageToGallery(List imagesPathMain, BuildContext contxt) async {
    //check the storage permission for both android and ios!
    //request gallery permission
    String albumName = 'Media';
    bool downloadStatus = false;
    PermissionStatus storagePermission = Platform.isAndroid
        ? await Permission.storage.status
        : await Permission.photos.status;
    if (storagePermission.isUndetermined || storagePermission.isRestricted) {
      Platform.isAndroid
          ? await Permission.storage.request()
          : await Permission.photos.request();
    }
    var _currentImage;
    Scaffold.of(contxt).showSnackBar(SnackBar(
      content: const Text(variable.strDownloadStart),
      backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
    ));

    if (imagesPathMain.length > 1) {
      for (int i = 0; i < imagesPathMain.length; i++) {
        _currentImage = imagesPathMain[i];
        _currentImage =
            '${_currentImage.response.data.fileContent}.${_currentImage.response.data.fileType}';
        GallerySaver.saveImage(_currentImage, albumName: albumName)
            .then((value) => downloadStatus = value);
      }
      if (downloadStatus) {
        Scaffold.of(contxt).showSnackBar(SnackBar(
          content: const Text(variable.strFilesDownloaded),
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        ));
      }
    } else {
      _currentImage = imagesPathMain[0];
      _currentImage =
          '${_currentImage.response.data.fileContent}${_currentImage.response.data.fileType}';
      GallerySaver.saveImage(_currentImage, albumName: albumName).then((value) {
        if (value) {
          Scaffold.of(contxt).showSnackBar(SnackBar(
            content: const Text(variable.strFilesView),
            backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
          ));
        }
      });
//      var appDocDir = await getTemporaryDirectory();
//      await Dio().download(_currentImage, appDocDir.path);
//      await ImageGallerySaver.saveFile(appDocDir.path).then((res) {
//        print('image saving status $res');

//      });
    }
  }

  getCategoryInfo(MetaInfo metaInfo) {
    switch (metaInfo.categoryInfo.categoryDescription) {
      case CommonConstants.categoryDescriptionPrescription:
        return RecordInfoCard().getCardForPrescription(
            widget.data.metaInfo, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionDevice:
        return RecordInfoCard()
            .getCardForDevices(widget.data.metaInfo, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionLabReport:
        return RecordInfoCard()
            .getCardForLab(widget.data.metaInfo, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionMedicalReport:
        return RecordInfoCard().getCardForMedicalRecord(
            widget.data.metaInfo, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionBills:
        return RecordInfoCard().getCardForBillsAndOthers(
            widget.data.metaInfo, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionIDDocs:
        return RecordInfoCard()
            .getCardForIDDocs(widget.data.metaInfo, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionOthers:
        return RecordInfoCard().getCardForBillsAndOthers(
            widget.data.metaInfo, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionVoiceRecord:
        return RecordInfoCard().getCardForBillsAndOthers(
            widget.data.metaInfo, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionClaimsRecord:
        return RecordInfoCard().getCardForBillsAndOthers(
            widget.data.metaInfo, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionNotes:
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

    return Container(
        //height: 60,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new AudioWidget(audioPath, (containsAudioClone, audioPathClone) {
          containsAudio = containsAudioClone;
          audioPath = audioPathClone;
          deleteMediRecord(audioMediaId);
        }),
      ],
    ));
  }

  void deleteAudioFile() {
    audioPath = null;
    containsAudio = false;
    setState(() {});
  }

  Future<Widget> getDialogBoxWithFamilyMember(FamilyData familyData) {
    return new FamilyListView(familyData).getDialogBoxWithFamilyMember(
        familyData, context, _keyLoader, (context, userId, userName) {
      _healthReportListForUserBlock
          .switchDataToOtherUser(userId, widget.data.id)
          .then((moveMetaDataResponse) {
        if (moveMetaDataResponse.success) {
          _healthReportListForUserBlock.getHelthReportList().then((value) {
            PreferenceUtil.saveCompleteData(
                Constants.KEY_COMPLETE_DATA, value.response.data);

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
                  text: hospitalData != null
                      ? hospitalData[variable.strName]
                      : ''),
              new TextEditingController(
                  text:
                      doctorsData != null ? doctorsData[variable.strName] : ''),
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
                  text: labData != null ? labData[variable.strName] : ''),
              new TextEditingController(
                  text:
                      doctorsData != null ? doctorsData[variable.strName] : ''),
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
          break;
        case Constants.STR_MEDICALREPORT:
          String fileName = widget.data.metaInfo.fileName;

          new CommonDialogBox().getDialogBoxForPrescription(
              context,
              new TextEditingController(
                  text: hospitalData != null
                      ? hospitalData[variable.strName]
                      : ''),
              new TextEditingController(
                  text:
                      doctorsData != null ? doctorsData[variable.strName] : ''),
              new TextEditingController(
                  text: widget.data.metaInfo.dateOfVisit != null
                      ? widget.data.metaInfo.dateOfVisit
                      : ''),
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

          break;
        case Constants.STR_CLAIMSRECORD:
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
        case Constants.STR_IDDOCS:
          String fileName = widget.data.metaInfo.fileName;

          new CommonDialogBox().getDialogForIDDocs(
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

        case Constants.STR_NOTES:
          String fileName = widget.data.metaInfo.fileName;

          new CommonDialogBox().getDialogBoxForNotes(
              context,
              false,
              null,
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

      PreferenceUtil.saveString(Constants.KEY_DEVICENAME, deviceName)
          .then((value) {
        switch (deviceName) {
          case Constants.STR_GLUCOMETER:
            String glucoMeterValue = widget.data.metaInfo.deviceReadings != null
                ? widget.data.metaInfo.deviceReadings[0].value
                : '';
            String fileName = widget.data.metaInfo.fileName;
            List<bool> isSelected =
                widget.data.metaInfo.deviceReadings[1].unit == variable.strAfter
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

    postImage[parameters.strmediaMetaId] = mediaMetaID;

    if (audioPath != '') {
      _healthReportListForUserBlock
          .saveImage(audioPath, mediaMetaID, '')
          .then((postImageResponse) {
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
    final dateFormatter = DateFormat(variable.strDateFormatDay);
    createdDate = dateFormatter.format(parsedDate);
  }

  Widget getCarousalImage(List<ImageDocumentResponse> imagesPath) {
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
                                  child: Image.network(
                                    imgUrl.response.data.fileContent,
                                    height: 200,
                                    width: 200,
                                  ));
                              /*Container(
                                height: double.infinity,
                                child: Image.memory(
                                  Uint8List.fromList(imgUrl),
                                  fit: BoxFit.fill,
                                ),
                              );*/
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
                                    AssetImage(variable.icon_attach),
                                    color: Colors.white),
                                onPressed: () {
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

  Widget getDocumentImageWidgetCloneOld() {
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
              //imagesPathMain.addAll(snapshot.data.data);
              /* }*/
              return Container(); //getCarousalImage(snapshot.data.data);
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

  Widget getDocumentImageWidgetClone() {
    if (_healthReportListForUserBlock != null) {
      _healthReportListForUserBlock = null;
      _healthReportListForUserBlock = new HealthReportListForUserBlock();
    } else {
      _healthReportListForUserBlock = new HealthReportListForUserBlock();
    }

    _healthReportListForUserBlock.getDocumentImageList(mediMasterId);

    return StreamBuilder<ApiResponse<List<ImageDocumentResponse>>>(
      stream: _healthReportListForUserBlock.imageListStream,
      builder: (context,
          AsyncSnapshot<ApiResponse<List<ImageDocumentResponse>>> snapshot) {
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

  /*Future<PermissionStatus> requestPermission(
      Permission storagePermission) async {
    final status = await storagePermission.request();

    setState(() {
      permissionStatus = status;
    });

    return status;
  }*/

  showAudioWidgetIfVoiceNotesAvailable(MediaMetaInfo data) {
    if (data.metaInfo.hasVoiceNotes) {
      audioMediaId = checkIfMp3IsPresent(data);
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
    if (_healthReportListForUserBlock != null) {
      _healthReportListForUserBlock = null;
      _healthReportListForUserBlock = new HealthReportListForUserBlock();
    } else {
      _healthReportListForUserBlock = new HealthReportListForUserBlock();
    }
    _healthReportListForUserBlock.getDocumentImage(audioMediaId).then((res) {
      return downloadMedia(res.response.data.fileContent, context, '.mp3');
    });
  }

  downloadMedia(String url, BuildContext context, String fileType) async {
    var path;
    FHBUtils.createFolderInAppDocDir(variable.stAudioPath)
        .then((filePath) async {
      final bytes = await _loadFileBytes(url,
          onError: (Exception exception) =>
              debugPrint('audio_provider.load => exception ${exception}'));
      path = '$filePath${widget.data.metaInfo.fileName}' + fileType;
      new File(path).writeAsBytes(bytes);
      if (fileType == '.mp3') {
        //await path.writeAsBytes(bytes);

        containsAudio = true;
        audioPath = path;
        isAudioDownload = true;
      } else {
        pdfFile = path;
      }
      setState(() {});
    });
  }

  Future<Uint8List> _loadFileBytes(String url, {OnError onError}) async {
    Uint8List bytes;
    try {
      bytes = await readBytes(url);
    } on ClientException {
      rethrow;
    }
    return bytes;
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
      return downloadMedia(res.response.data.fileContent, context, '.pdf');
    });
  }
}

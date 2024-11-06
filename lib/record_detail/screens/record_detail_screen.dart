import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../bookmark_record/bloc/bookmarkRecordBloc.dart';
import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/AudioWidget.dart';
import '../../common/CommonConstants.dart';
import '../../common/CommonDialogBox.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../common/common_circular_indicator.dart';
import '../../common/errors_widget.dart';
import '../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_parameters.dart' as parameters;
import '../../constants/fhb_parameters.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../main.dart';
import '../../my_family/bloc/FamilyListBloc.dart';
import '../../my_family/models/FamilyMembersRes.dart';
import '../../my_family/screens/FamilyListView.dart';
import '../../src/blocs/health/HealthReportListForUserBlock.dart';
import '../../src/model/Health/PostImageResponse.dart';
import '../../src/model/Health/asgard/health_record_collection.dart';
import '../../src/model/Health/asgard/health_record_list.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../src/resources/network/api_services.dart';
import '../../src/ui/audio/AudioRecorder.dart';
import '../../src/ui/audio/AudioScreenArguments.dart';
import '../../src/ui/imageSlider.dart';
import '../../src/utils/FHBUtils.dart';
import '../../src/utils/language/language_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/chat/view/PDFModel.dart';
import '../../telehealth/features/chat/view/PDFView.dart';
import '../../widgets/GradientAppBar.dart';
import '../../widgets/ShowImage.dart';
import '../bloc/deleteRecordBloc.dart';
import '../model/ImageDocumentResponse.dart';
import '../services/downloadmultipleimages.dart';
import 'record_info_card.dart';

export 'package:myfhb/my_family/models/relationship_response_list.dart';

typedef OnError = void Function(Exception exception);

class RecordDetailScreen extends StatefulWidget {
  final HealthResult data;

  const RecordDetailScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _RecordDetailScreenState createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends State<RecordDetailScreen> {
  late DeleteRecordBloc _deleteRecordBloc;
  late BookmarkRecordBloc _bookmarkRecordBloc;
  bool? _isRecordBookmarked;
  bool containsAudio = false;
  String? audioPath = '';
  HealthReportListForUserBlock? _healthReportListForUserBlock;
  FamilyListBloc? _familyListBloc;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  String? categoryName, createdDate;
  var doctorsData, hospitalData, labData;
  bool isAudioDownload = false;

  String? deviceName;
  CarouselController? carouselSlider;
  int _current = 0;
  int index = 0;
  int length = 0;
  List<ImageDocumentResponse> imagesPathMain = [];

  bool firsTym = true;
  bool ispdfPresent = false;

  HealthRecordCollection? audioMediaId;
  late HealthRecordCollection pdfId;

  GlobalKey<ScaffoldMessengerState> scaffold_state =
      GlobalKey<ScaffoldMessengerState>();
  String? authToken;

  var pdfFile;
  var fileNetworkUrl;
  var fileTypeCommon;
  String? jpefFile;

  List<HealthRecordCollection> mediMasterId = [];
  FlutterToast toast = FlutterToast();

  String? tempUnit = "F";
  String? weightUnit = "kg";
  String? heightUnit = "feet";

  @override
  void initState() {
    super.initState();
    PreferenceUtil.init();
    _listenForPermissionStatus();
    setAuthToken();
    _deleteRecordBloc = DeleteRecordBloc();
    _bookmarkRecordBloc = BookmarkRecordBloc();
    _isRecordBookmarked = widget.data.isBookmarked;
    _healthReportListForUserBlock = HealthReportListForUserBlock();
    _familyListBloc = FamilyListBloc();
    _familyListBloc!.getFamilyMembersListNew();
    FABService.trackCurrentScreen(FBAMyRecordsDetailsScreen);

    if (checkIfMp3IsPresent(widget.data) != '') {
      widget.data.metadata!.hasVoiceNotes = true;
      showAudioWidgetIfVoiceNotesAvailable(widget.data);
    }

    if (widget.data.healthRecordCollection != null &&
        widget.data.healthRecordCollection!.isNotEmpty) {
      mediMasterId = CommonUtil().getMetaMasterIdList(widget.data);

      final getMediaMasterIDForPdfTypeStr = CommonUtil()
          .getMediaMasterIDForPdfTypeStr(widget.data.healthRecordCollection!);
      if (getMediaMasterIDForPdfTypeStr != null) {
        ispdfPresent = true;
        pdfId = getMediaMasterIDForPdfTypeStr;
        getPdfFileData(getMediaMasterIDForPdfTypeStr);
        length = 1;
        index = 1;
      } else {
        ispdfPresent = false;
      }
    }

    if (mediMasterId.isNotEmpty) {
      length = mediMasterId.length;
      index = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(fhbColors.bgColorContainer),
        key: scaffold_state,
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          title: Text(
            widget.data.metadata!.fileName == null
                ? toBeginningOfSentenceCase(
                    widget.data.metadata!.healthRecordType!.name)!
                : widget.data.metadata!.fileName!.contains('.pdf')
                    ? getFileNameForPdf(toBeginningOfSentenceCase(
                        widget.data.metadata!.fileName)!)
                    : toBeginningOfSentenceCase(
                        widget.data.metadata!.fileName)!,
            maxLines: 1,
            style: TextStyle(
              fontSize: CommonUtil().isTablet! ? tabFontTitle : mobileFontTitle,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            //maxFontSize: 16, FU2.5
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 24.0.sp,
              ),
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
                    constraints: BoxConstraints(
                      maxHeight: 400.0.h,
                    ),
                    color: Colors.black87,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            flex: 7,
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: (mediMasterId.isNotEmpty &&
                                        mediMasterId != null)
                                    ? getCarousalImage(mediMasterId)
                                    : (widget.data.metadata!.healthRecordType!
                                                    .name ==
                                                AppConstants.voiceNotes ||
                                            ispdfPresent == true)
                                        ? getCarousalImage(null)
                                        : widget.data.metadata?.sourceName ==
                                                'SHEELA'
                                            ? getCarousalImage(null)
                                            : getDocumentImageWidgetClone())),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                widget.data.metadata?.sourceName == 'SHEELA'
                                    ? SizedBox()
                                    : IconButton(
                                        onPressed: () {
                                          if (pdfFile != null) {
                                            moveToPDFViewer();
                                          } else {
                                            if (mediMasterId.isNotEmpty) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ImageSlider(
                                                            imageList:
                                                                mediMasterId,
                                                          )));
                                            }
                                          }
                                        },
                                        icon: Icon(
                                          Icons.fullscreen,
                                          color: Colors.white,
                                          size: 24.0.sp,
                                        ),
                                      ),
                                if (widget.data.metadata?.sourceName ==
                                    'SHEELA')
                                  SizedBox()
                                else
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
                    builder: (contxt) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: _isRecordBookmarked!
                                  ? ImageIcon(
                                      AssetImage(
                                          variable.icon_record_fav_active),
                                      //TODO chnage theme
                                      color: mAppThemeProvider.primaryColor,
                                    )
                                  : ImageIcon(
                                      AssetImage(variable.icon_record_fav),
                                      color: Colors.black,
                                    ),
                              onPressed: () {
                                bookMarkRecord(widget.data);
                              }),
                          if (widget.data.metadata!.sourceName ==
                              strsourceCARGIVER)
                            IconButton(
                              icon: ImageIcon(
                                AssetImage(variable.icon_record_switch),
                                color: Colors.grey,
                              ),
                              onPressed: () {},
                            )
                          else
                            IconButton(
                                icon: ImageIcon(
                                  AssetImage(variable.icon_record_switch),
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  //getAllFamilyMembers();

                                  CommonUtil.showLoadingDialog(
                                      contxt, _keyLoader, variable.Please_Wait);

                                  if (_familyListBloc != null) {
                                    _familyListBloc = null;
                                    _familyListBloc = FamilyListBloc();
                                  }
                                  _familyListBloc!
                                      .getFamilyMembersListNew()
                                      .then((familyMembersList) {
                                    Navigator.of(_keyLoader.currentContext!,
                                            rootNavigator: true)
                                        .pop();
                                    if (familyMembersList != null &&
                                        familyMembersList.result != null &&
                                        familyMembersList
                                                .result.sharedByUsers.length >
                                            0) {
                                      getDialogBoxWithFamilyMember(
                                          familyMembersList.result);
                                    } else {
                                      toast.getToast(
                                          Constants.NO_DATA_FAMIY_CLONE,
                                          Colors.black54);
                                    }
                                  });
                                }),
                          if (widget.data.metadata!.sourceName ==
                                  strsourceCARGIVER ||
                              widget.data.healthRecordCollection!.length == 0)
                            IconButton(
                              icon: ImageIcon(
                                AssetImage(variable.icon_edit),
                                color: Colors.grey,
                              ),
                              onPressed: () {},
                            )
                          else
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
                                saveImageToGallery(mediMasterId, contxt);

                                /*requestPermission(_storagePermission)
                                    .then((status) {
                                  if (status == PermissionStatus.granted) {
                                  }
                                });*/
                              }),
                          widget.data.metadata!.sourceName == strsourceCARGIVER
                              ? IconButton(
                                  icon: ImageIcon(
                                    AssetImage(variable.icon_delete),
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {},
                                )
                              : IconButton(
                                  icon: ImageIcon(
                                    AssetImage(variable.icon_delete),
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    FHBBasicWidget()
                                        .showDialogWithTwoButtons(context, () {
                                      deleteRecord(widget.data.id!,
                                          isDeviceReadings: widget
                                                  .data
                                                  .metadata!
                                                  .healthRecordCategory!
                                                  .categoryName ==
                                              'Devices');
                                    }, 'Confirmation',
                                            'Are you sure you want to delete');
                                  })
                        ],
                      );
                    },
                  ),
                ),
                getCategoryInfo(widget.data),
                SizedBox(
                  height: 80.0.h,
                )
              ],
            ),
            if (containsAudio)
              getAudioIconWithFile()
            else
              Container(
                color: const Color(fhbColors.bgColorContainer),
                child: widget.data.metadata!.hasVoiceNotes != null &&
                        widget.data.metadata!.hasVoiceNotes!
                    ? isAudioDownload
                        ? getAudioIconWithFile()
                        : showAudioWidgetIfVoiceNotesAvailable(widget.data)
                    /*Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[200],
                                child: showProgressIndicator(widget.data))*/
                    : getAudioWidget(),
              )
          ],
        ));
  }

  Widget getAudioWidget() {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => AudioRecorder(
              arguments: AudioScreenArguments(
                fromVoice: false,
              ),
            ),
          ),
        )
            .then((results) {
          if (results != null) {
            if (results.containsKey(Constants.keyAudioFile)) {
              containsAudio = true;
              audioPath = results[Constants.keyAudioFile];
              _healthReportListForUserBlock!
                  .updateFiles(audioPath, widget.data)
                  .then((postImageResponse) {
                /*audioMediaId = postImageResponse
                                          .response.data.mediaMasterId;*/

                _healthReportListForUserBlock!
                    .getHelthReportLists()
                    .then((value) {
                  checkTheSpecifiedMetaID(value!, null);

                  /*  PreferenceUtil.saveCompleteData(
                      Constants.KEY_COMPLETE_DATA, value);
                  setState(() {});
                */
                });
                //setState(() {});
              });
            }
          }
        });
      },
      child: Container(
        height: 60.0.h,
        color: Colors.white70,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.mic,
              color: mAppThemeProvider.primaryColor,
              size: 24.0.sp,
            ),
            SizedBox(width: 10.0.w),
            Text(
              variable.strAddVoiceNote,
              style: TextStyle(
                fontSize: 16.0.sp,
                color: mAppThemeProvider.primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _listenForPermissionStatus() async {
    // final status = await _storagePermission.status;
    //setState(() => permissionStatus = status);
  }

  void saveImageToGallery(
      List<HealthRecordCollection> imagesPathMain, BuildContext contxt) async {
    //check the storage permission for both android and ios!
    //request gallery permission
    final albumName = 'myfhb';
    var downloadStatus = false;
    final storagePermission = Platform.isAndroid
        ? await Permission.storage.status
        : await Permission.photos.status;
    if (storagePermission.isDenied || storagePermission.isRestricted) {
      Platform.isAndroid
          ? await Permission.storage.request()
          : await Permission.photos.request();
    }

    HealthRecordCollection _currentImage;
    ScaffoldMessenger.of(contxt).showSnackBar(
      SnackBar(
        content: const Text(
          variable.strDownloadStart,
        ),
        backgroundColor: mAppThemeProvider.primaryColor,
      ),
    );
    if (ispdfPresent) {
      print('audioPath' + pdfFile);
      if (Platform.isIOS) {
        final path = await CommonUtil.downloadFile(
            pdfId.healthRecordUrl!, pdfId.fileType);
        ScaffoldMessenger.of(contxt).showSnackBar(
          SnackBar(
            content: const Text(variable.strFileDownloaded),
            backgroundColor: mAppThemeProvider.primaryColor,
            action: SnackBarAction(
              label: 'Open',
              onPressed: () async {
                await OpenFilex.open(
                  path?.path,
                ); //FU2.5
                var pdfController = CommonUtil().onInitPDFViewController();
                final data = OpenPDF(
                    type: PDFLocation.Path,
                    path: path?.path,
                    title: widget.data.metadata?.fileName);
                pdfController.data = data;
                Get.to(() => PDFView());
              },
            ),
          ),
        );
      } else {
        CommonUtil.downloadFile(fileNetworkUrl, fileTypeCommon).then(
          (res) async {
            setState(() {
              downloadStatus = true;
            });
            ScaffoldMessenger.of(contxt).showSnackBar(
              SnackBar(
                content: const Text(
                  variable.strFileDownloaded,
                ),
                backgroundColor: mAppThemeProvider.primaryColor,
                action: SnackBarAction(
                  label: 'Open',
                  onPressed: () async {
                    await OpenFilex.open(
                      pdfFile,
                    ); //FU2.5
                  },
                ),
              ),
            );
          },
        );
      }
    } else {
      List<String?> imageList = [];

      if (imagesPathMain.length > 1) {
        DownloadMultipleImages(imagesPathMain).downloadFilesFromServer(contxt);
      } else {
        _currentImage = imagesPathMain[0];
        try {
          CommonUtil.downloadFile(_currentImage.healthRecordUrl ?? '',
                  _currentImage.fileType ?? '')
              .then(
            (res) async {
              setState(() {
                downloadStatus = true;
                jpefFile = res?.path;
              });
              imageList.add(jpefFile);
              ScaffoldMessenger.of(contxt).showSnackBar(
                SnackBar(
                  content: Text(
                    variable.strFileDownloaded,
                    style: TextStyle(
                      fontSize: 16.0.sp,
                    ),
                  ),
                  backgroundColor: mAppThemeProvider.primaryColor,
                  action: SnackBarAction(
                    label: 'Open',
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowImage(
                            filePathList: imageList,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
          print('$e exception thrown');
        }
      }
    }
  }

  getCategoryInfo(HealthResult metaInfo) {
    switch (metaInfo.metadata!.healthRecordCategory!.categoryDescription) {
      case CommonConstants.categoryDescriptionPrescription:
        return RecordInfoCard().getCardForPrescription(
            widget.data.metadata!, widget.data.createdOn, authToken);
        break;
      case CommonConstants.categoryDescriptionDevice:
        return RecordInfoCard()
            .getCardForDevices(widget.data.metadata!, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionLabReport:
        return RecordInfoCard()
            .getCardForLab(widget.data.metadata!, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionMedicalReport:
        return RecordInfoCard().getCardForMedicalRecord(
            widget.data.metadata!, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionBills:
        return RecordInfoCard().getCardForBillsAndOthers(
            widget.data.metadata!, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionIDDocs:
        return RecordInfoCard()
            .getCardForIDDocs(widget.data.metadata!, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionOthers:
        return RecordInfoCard().getCardForBillsAndOthers(
            widget.data.metadata!, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionVoiceRecord:
        return RecordInfoCard().getCardForBillsAndOthers(
            widget.data.metadata!, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionClaimsRecord:
        return RecordInfoCard().getCardForBillsAndOthers(
            widget.data.metadata!, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionNotes:
        return RecordInfoCard()
            .getCardForNotes(widget.data.metadata!, widget.data.createdOn);
        break;
      case CommonConstants.categoryDescriptionHospitalDocument:
        return RecordInfoCard().getCardForHospitalDocument(
            widget.data.metadata!, widget.data.createdOn);
        break;

      default:
        return RecordInfoCard().getCardForPrescription(
            widget.data.metadata!, widget.data.createdOn, authToken);
    }
  }

  deleteRecord(String metaId, {bool isDeviceReadings = false}) {
    _deleteRecordBloc.deleteRecord(metaId).then((deleteRecordResponse) {
      if (deleteRecordResponse!.success!) {
        _healthReportListForUserBlock!.getHelthReportLists().then((value) {
          PreferenceUtil.saveCompleteData(Constants.KEY_COMPLETE_DATA, value);
          Navigator.of(context).pop();
          Navigator.of(context).pop(true);
          toast.getToast(
              isDeviceReadings
                  ? 'Record deleted successfully. Latest record added through Sheela can be updated/deleted through Sheela itself'
                  : 'Record Deleted Successfully',
              Colors.green);
        });
      } else {
        toast.getToast('Failed to delete the record', Colors.red);
      }
    });
  }

  deleteMediRecord(HealthRecordCollection healthRecordCollection) {
    final mediaIds = <String?>[];
    mediaIds.add(healthRecordCollection.id);
    _deleteRecordBloc
        .deleteRecordOnMediaMasterID(healthRecordCollection.id!)
        .then((deleteRecordResponse) {
      if (deleteRecordResponse!.success!) {
        _healthReportListForUserBlock!.getHelthReportLists().then((value) {
          PreferenceUtil.saveCompleteData(Constants.KEY_COMPLETE_DATA, value);
          Navigator.of(context).pop(true);
          widget.data.metadata!.hasVoiceNotes = false;
          toast.getToast('Record deleted successfully', Colors.green);
          //setState(() {});
        });
      } else {
        toast.getToast('Failed to delete the record', Colors.red);
      }
    });
  }

  bookMarkRecord(HealthResult data) {
    var mediaIds = <String?>[];
    mediaIds.add(data.id);

    if (_isRecordBookmarked!) {
      _isRecordBookmarked = false;
    } else {
      _isRecordBookmarked = true;
    }

    _bookmarkRecordBloc
        .bookMarcRecord(mediaIds, _isRecordBookmarked)
        .then((bookmarkRecordResponse) {
      if (bookmarkRecordResponse!.success!) {
        setState(() {});

        _healthReportListForUserBlock!.getHelthReportLists().then((value) {
          PreferenceUtil.saveCompleteData(Constants.KEY_COMPLETE_DATA, value);
        });
      }
    });
  }

  Widget getAudioIconWithFile({String? fpath}) {
    final path = (fpath != null || fpath != '') ? fpath : audioPath;

    return Container(
        //height: 60.0.h,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        AudioWidget(audioPath, (containsAudioClone, audioPathClone) {
          containsAudio = containsAudioClone;
          audioPath = audioPathClone;
          FHBBasicWidget().showDialogWithTwoButtons(context, () {
            deleteMediRecord(audioMediaId!);
          }, 'Confirmation', 'Are you sure you want to delete');
        }),
      ],
    ));
  }

  void deleteAudioFile() {
    audioPath = '';
    containsAudio = false;
    setState(() {});
  }

  Future<Widget?> getDialogBoxWithFamilyMember(FamilyMemberResult? familyData) {
    return FamilyListView(familyData).getDialogBoxWithFamilyMember(
        familyData, context, _keyLoader, (context, userId, userName, _) {
      _healthReportListForUserBlock!
          .switchDataToOtherUser(userId, widget.data.id)
          .then((moveMetaDataResponse) {
        if (moveMetaDataResponse!.success!) {
          _healthReportListForUserBlock!.getHelthReportLists().then((value) {
            PreferenceUtil.saveCompleteData(Constants.KEY_COMPLETE_DATA, value);

            Future.delayed(const Duration(seconds: 2), () {
              FHBBasicWidget().showInSnackBar(
                  moveMetaDataResponse.message!, scaffold_state);
            });

            Navigator.pop(context);
            Navigator.pop(context);
          });
        } else {
          Navigator.pop(context);
          FHBBasicWidget()
              .showInSnackBar(moveMetaDataResponse.message!, scaffold_state);
        }
      });
    });
  }

  void openAlertDialogBasedOnRecordDetails() async {
    categoryName = widget.data.metadata!.healthRecordCategory!.categoryName;

    if (widget.data.metadata!.doctor != null) {
      doctorsData = widget.data.metadata!.doctor!.toJson();
    }
    if (widget.data.metadata!.laboratory != null) {
      labData = widget.data.metadata!.laboratory!.toJson();
    }
    if (widget.data.metadata!.hospital != null) {
      hospitalData = widget.data.metadata!.hospital!.toJson();
    }
    createdDateMethod();

    tempUnit = await PreferenceUtil.getStringValue(Constants.STR_KEY_TEMP);
    weightUnit = await PreferenceUtil.getStringValue(Constants.STR_KEY_WEIGHT);
    heightUnit = await PreferenceUtil.getStringValue(Constants.STR_KEY_HEIGHT);

    if (categoryName != Constants.STR_DEVICES) {
      var date = widget.data.metadata!.dateOfVisit ?? '';

      if (date != '') {
        date = FHBUtils().getFormattedDateOnly(date);
      }
      switch (categoryName) {
        case AppConstants.prescription:
          final fileName = widget.data.metadata!.fileName;

          CommonDialogBox().getDialogBoxForPrescription(
              context,
              TextEditingController(
                  text: hospitalData != null
                      ? hospitalData[variable.strHealthOrganizationName]
                      : ''),
              TextEditingController(
                  text: doctorsData != null
                      ? doctorsData[variable.strName] != '' &&
                              doctorsData[variable.strName] != null
                          ? doctorsData[variable.strName]
                          : doctorsData[variable.strFirstName] +
                              ' ' +
                              doctorsData[variable.strLastName]
                      : ''),
              TextEditingController(text: date),
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
          }, [], widget.data, true, TextEditingController(text: fileName));

          break;

        case AppConstants.bills:
          final fileName = widget.data.metadata!.fileName;

          CommonDialogBox().getDialogBoxForBillsAndOthers(
              context,
              containsAudio,
              audioPath,
              (containsAudio, audioPath) {
                setState(() {
                  audioPath = audioPath;
                  containsAudio = containsAudio;
                });
              },
              [],
              (containsAudio, audioPath) {
                audioPath = audioPath;
                containsAudio = containsAudio;

                setState(() {});
              },
              widget.data,
              true,
              TextEditingController(text: fileName));

          break;

        case Constants.STR_LABREPORT:
          var fileName = widget.data.metadata!.fileName;

          CommonDialogBox().getDialogBoxForLabReport(
              context,
              TextEditingController(
                  text: labData != null
                      ? labData[variable.strHealthOrganizationName]
                      : ''),
              TextEditingController(
                  text: doctorsData != null
                      ? doctorsData[variable.strName] != '' &&
                              doctorsData[variable.strName] != null
                          ? doctorsData[variable.strName]
                          : doctorsData[variable.strFirstName] +
                              ' ' +
                              doctorsData[variable.strLastName]
                      : ''),
              TextEditingController(text: date),
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
          }, [], widget.data, true, TextEditingController(text: fileName));
          break;
        case Constants.STR_MEDICALREPORT:
          final fileName = widget.data.metadata!.fileName;

          CommonDialogBox().getDialogBoxForPrescription(
              context,
              TextEditingController(
                  text: hospitalData != null
                      ? hospitalData[variable.strHealthOrganizationName]
                      : ''),
              TextEditingController(
                  text: doctorsData != null
                      ? doctorsData[variable.strName] != '' &&
                              doctorsData[variable.strName] != null
                          ? doctorsData[variable.strName]
                          : doctorsData[variable.strFirstName] +
                              ' ' +
                              doctorsData[variable.strLastName]
                      : ''),
              TextEditingController(
                  text: widget.data.metadata!.dateOfVisit ?? ''),
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
          }, [], widget.data, true, TextEditingController(text: fileName));

          break;
        case Constants.STR_CLAIMSRECORD:
          var fileName = widget.data.metadata!.fileName;

          CommonDialogBox().getDialogBoxForBillsAndOthers(
              context,
              containsAudio,
              audioPath,
              (containsAudio, audioPath) {
                setState(() {
                  audioPath = audioPath;
                  containsAudio = containsAudio;
                });
              },
              [],
              (containsAudio, audioPath) {
                audioPath = audioPath;
                containsAudio = containsAudio;

                setState(() {});
              },
              widget.data,
              true,
              TextEditingController(text: fileName));

          break;
        case Constants.STR_IDDOCS:
          final fileName = widget.data.metadata!.fileName;

          CommonDialogBox().getDialogForIDDocs(
              context,
              containsAudio,
              audioPath,
              (containsAudio, audioPath) {
                setState(() {
                  audioPath = audioPath;
                  containsAudio = containsAudio;
                });
              },
              [],
              (containsAudio, audioPath) {
                audioPath = audioPath;
                containsAudio = containsAudio;

                setState(() {});
              },
              widget.data,
              true,
              TextEditingController(text: fileName),
              TextEditingController(text: date),
              // widget.data.metaInfo.idType
              widget.data.healthRecordTypeId);
          break;

        case Constants.STR_OTHERS:
          var fileName = widget.data.metadata!.fileName;

          CommonDialogBox().getDialogBoxForBillsAndOthers(
              context,
              containsAudio,
              audioPath,
              (containsAudio, audioPath) {
                setState(() {
                  audioPath = audioPath;
                  containsAudio = containsAudio;
                });
              },
              [],
              (containsAudio, audioPath) {
                audioPath = audioPath;
                containsAudio = containsAudio;

                setState(() {});
              },
              widget.data,
              true,
              TextEditingController(text: fileName));

          break;
        case AppConstants.voiceRecords:
          var fileName = widget.data.metadata!.fileName;

          CommonDialogBox().getDialogBoxForBillsAndOthers(
              context,
              containsAudio,
              audioPath,
              (containsAudio, audioPath) {
                setState(() {
                  audioPath = audioPath;
                  containsAudio = containsAudio;
                });
              },
              [],
              (containsAudio, audioPath) {
                audioPath = audioPath;
                containsAudio = containsAudio;

                setState(() {});
              },
              widget.data,
              true,
              TextEditingController(text: fileName));

          break;

        case AppConstants.notes:
          final fileName = widget.data.metadata!.fileName;

          CommonDialogBox().getDialogBoxForNotes(
              context,
              containsAudio,
              audioPath,
              (containsAudio, audioPath) {
                setState(() {
                  audioPath = audioPath;
                  containsAudio = containsAudio;
                });
              },
              [],
              (containsAudio, audioPath) {
                audioPath = audioPath;
                containsAudio = containsAudio;

                setState(() {});
              },
              widget.data,
              true,
              TextEditingController(text: fileName),
              (value) {
                if (value) {
                  setState(() {});
                }
              });

          break;
      }
    } else {
      deviceName = widget.data.metadata!.healthRecordType!.name;

      PreferenceUtil.saveString(Constants.KEY_DEVICENAME, deviceName!)
          .then((value) {
        switch (deviceName) {
          case Constants.STR_GLUCOMETER:
            //String glucoMeterValue = '';
            final fileName = widget.data.metadata!.fileName;
            //List<bool> isSelected;
            final String? glucoMeterValue =
                widget.data.metadata!.deviceReadings != null
                    ? widget.data.metadata!.deviceReadings![0].value
                    : '';
            var isSelected = widget.data.metadata!.deviceReadings![1].unit ==
                    variable.strAfter
                ? [false, true]
                : [true, false];
            CommonDialogBox().getDialogBoxForGlucometer(
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
                [],
                (containsAudio, audioPath) {
                  audioPath = audioPath;
                  containsAudio = containsAudio;

                  setState(() {});
                },
                widget.data,
                true,
                TextEditingController(text: glucoMeterValue),
                isSelected,
                TextEditingController(text: fileName));
            break;

          case Constants.STR_THERMOMETER:
            //String thermometerValue = '';
            final String? thermometerValue =
                widget.data.metadata!.deviceReadings != null
                    ? widget.data.metadata!.deviceReadings![0].value
                    : '';
            final fileName = widget.data.metadata!.fileName;

            CommonDialogBox().getDialogBoxForTemperature(
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
                [],
                (containsAudio, audioPath) {
                  audioPath = audioPath;
                  containsAudio = containsAudio;

                  setState(() {});
                },
                widget.data,
                true,
                TextEditingController(text: thermometerValue),
                TextEditingController(text: fileName),
                tempMainUnit: tempUnit,
                updateUnit: (unitValue) async {
                  tempUnit = unitValue;

                  setState(() {});
                });
            break;
          case Constants.STR_WEIGHING_SCALE:
            var weightInKgs = widget.data.metadata!.deviceReadings != null
                ? widget.data.metadata!.deviceReadings![0].value
                : '';
            var fileName = widget.data.metadata!.fileName;

            CommonDialogBox().getDialogBoxForWeightingScale(
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
                [],
                (containsAudio, audioPath) {
                  audioPath = audioPath;
                  containsAudio = containsAudio;

                  setState(() {});
                },
                widget.data,
                true,
                TextEditingController(text: weightInKgs.toString()),
                TextEditingController(text: fileName),
                weightUnit: weightUnit,
                updateUnit: (unitValue) async {
                  weightUnit = unitValue;

                  setState(() {});
                });
            break;

          case Constants.STR_PULSE_OXIMETER:
            //String oxygenSaturation = '';
            final String? oxygenSaturation =
                widget.data.metadata!.deviceReadings != null
                    ? widget.data.metadata!.deviceReadings![0].value
                    : '';
            //String pulse = '';
            final String? pulse = widget.data.metadata!.deviceReadings != null
                ? widget.data.metadata!.deviceReadings![1].value
                : '';
            final fileName = widget.data.metadata!.fileName;

            CommonDialogBox().getDialogBoxForPulseOxidometer(
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
                [],
                (containsAudio, audioPath) {
                  audioPath = audioPath;
                  containsAudio = containsAudio;

                  setState(() {});
                },
                widget.data,
                true,
                TextEditingController(text: oxygenSaturation),
                TextEditingController(text: pulse),
                TextEditingController(text: fileName));
            break;
          case Constants.STR_BP_MONITOR:
            /*String systolicPressure = '';
            String diastolicPressure = '';
            String pulse = '';*/
            final String systolicPressure =
                widget.data.metadata!.deviceReadings != null
                    ? widget.data.metadata!.deviceReadings![0].value.toString()
                    : '';
            final String diastolicPressure =
                widget.data.metadata!.deviceReadings != null
                    ? widget.data.metadata!.deviceReadings![1].value.toString()
                    : '';
            final String pulse = widget.data.metadata!.deviceReadings != null
                ? widget.data.metadata!.deviceReadings![2].value.toString()
                : '';
            var fileName = widget.data.metadata!.fileName;

            CommonDialogBox().getDialogBoxForBPMonitor(
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
                [],
                (containsAudio, audioPath) {
                  audioPath = audioPath;
                  containsAudio = containsAudio;

                  setState(() {});
                },
                widget.data,
                true,
                TextEditingController(text: systolicPressure),
                TextEditingController(text: pulse),
                TextEditingController(text: diastolicPressure),
                TextEditingController(text: fileName));
            break;
        }
      });
    }
  }

  void postAudioToServer(String mediaMetaID) {
    final Map<String, dynamic> postImage = {};

    postImage[parameters.strmediaMetaId] = mediaMetaID;

    if (audioPath != '') {
      _healthReportListForUserBlock!
          .saveImage(audioPath!, mediaMetaID, '')
          .then((postImageResponse) {
        _healthReportListForUserBlock!.getHelthReportLists().then((value) {
          checkTheSpecifiedMetaID(value!, postImageResponse);
        });
      });
    } else {
      setState(() {});
    }
  }

  void createdDateMethod() {
    final parsedDate =
        DateTime.parse(widget.data.metadata!.healthRecordType!.createdOn!);
    var dateFormatter = DateFormat(CommonUtil.REGION_CODE == 'IN'
        ? variable.strDateFormatDay
        : variable.strUSDateFormatDay);
    createdDate = dateFormatter.format(parsedDate);
  }

  Widget getCarousalImage(List<HealthRecordCollection>? imagesPath) {
    if (imagesPath != null && imagesPath.isNotEmpty) {
      index = _current + 1;
      _current = 0;
      length = imagesPath.length;
    } else if (widget.data.metadata?.sourceName == 'SHEELA') {
      index = _current + 1;
      _current = 0;
      length = 1;
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.data.metadata!.healthRecordType!.name !=
                  AppConstants.voiceNotes
              ? (imagesPath != null && imagesPath.isNotEmpty)
                  ? Expanded(
                      child: CarouselSlider(
                        carouselController: carouselSlider,
                        items: imagesPath.map((imgUrl) {
                          return Builder(
                            builder: (context) {
                              return Container(
                                  height: double.infinity,
                                  child: Image.network(
                                    imgUrl.healthRecordUrl!,
                                    height: 200.0.h,
                                    width: 200.0.h,
                                    headers: {
                                      HttpHeaders.authorizationHeader:
                                          authToken!
                                    },
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
                        options: CarouselOptions(
                          height: 400.0.h,
                          //width: 1.sw,
                          initialPage: 0,
                          enlargeCenterPage: true,
                          reverse: false,
                          enableInfiniteScroll: false,
                          // pauseAutoPlayOnTouch: Duration(seconds: 10),
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, carouselPageChangedReason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                      ),
                    )
                  : ispdfPresent
                      ? pdfFile == null
                          ? Container(child: CommonCircularIndicator())
                          : Expanded(
                              child: Container(
                                child: CommonUtil().showPDFInWidget(pdfFile),
                              ),
                            )
                      : widget.data.metadata?.sourceName == 'SHEELA'
                          ? Container(
                              child: Image.asset(
                                'assets/maya/maya_us_main.png',
                                height: 100.0.h,
                                width: 100.0.h,
                              ),
                            )
                          : Container(
                              child: Icon(
                                Icons.mic,
                                color: mAppThemeProvider.primaryColor,
                                size: 24.0.sp,
                              ),
                            )
              : widget.data.metadata?.sourceName == 'SHEELA'
                  ? Container(
                      child: Image.asset(
                      'assets/maya/maya_us_main.png',
                      height: 100.0.h,
                      width: 100.0.h,
                    ))
                  : Container(
                      child: Icon(
                      Icons.mic,
                      size: 60.0.sp,
                      color: Colors.white,
                    )),
        ],
      ),
    );
  }

  goToPrevious() {
    carouselSlider!.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider!.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  Widget getDocumentImageWidgetClone() {
    if (_healthReportListForUserBlock != null) {
      _healthReportListForUserBlock = null;
      _healthReportListForUserBlock = HealthReportListForUserBlock();
    } else {
      _healthReportListForUserBlock = HealthReportListForUserBlock();
    }

    //_healthReportListForUserBlock.getDocumentImageList(mediMasterId);

    return StreamBuilder<ApiResponse<List<ImageDocumentResponse>>>(
      stream: _healthReportListForUserBlock!.imageListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return Center(
                  child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
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
              imagesPathMain.addAll(snapshot.data!.data!);
              /* }*/
              // return getCarousalImage(snapshot.data.data);
              break;
          }
        }
        // else {
        return Container(
          width: 100.0.h,
          height: 100.0.h,
        );
        // }
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

  showAudioWidgetIfVoiceNotesAvailable(HealthResult data) {
    if (data.metadata!.hasVoiceNotes!) {
      audioMediaId = checkIfMp3IsPresent(data);
      if (audioMediaId != null) {
        getWidgetForPlayingAudioFromServer(audioMediaId);
      } else {
        return getAudioWidget();
      }
    }
  }

  HealthRecordCollection? checkIfMp3IsPresent(HealthResult data) {
    HealthRecordCollection? mediaMetaId;

    if (data.healthRecordCollection != null &&
        data.healthRecordCollection!.isNotEmpty) {
      mediaMetaId = CommonUtil()
          .getMediaMasterIDForAudioFileType(data.healthRecordCollection!);
    }
    return mediaMetaId;
  }

  Widget getWidgetForPlayingAudioFromServer(
      HealthRecordCollection? audioMediaId) {
    return getValuesFromSharedPrefernce();
  }

  Widget getValuesFromSharedPrefernce() {
    return FutureBuilder<bool>(
      future: downloadFile(audioMediaId, '.mp3'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          CommonCircularIndicator();
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          return getAudioIconWithFile();
        }
        return Container();
      },
    );
  }

  downloadMedia(String url, BuildContext context, String fileType) async {
    var path;
    await FHBUtils.createFolderInAppDocDirClone(
            variable.stAudioPath,
            fileType == '.mp3'
                ? '${widget.data.metadata!.fileName}' + fileType
                : widget.data.metadata!.fileName)
        .then((filePath) async {
      var bytes = await _loadFileBytes(url,
          onError: (exception) =>
              debugPrint('audio_provider.load => exception $exception'));
      if (fileType == '.mp3') {
        path = '$filePath${widget.data.metadata!.fileName}' + fileType;
      } else {
        path = '$filePath${widget.data.metadata!.fileName}';
      }
      File(path).writeAsBytes(bytes);
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

  Future<bool> downloadFile(
      HealthRecordCollection? audioMediaId, String fileType) async {
    try {
      /*var fileName = widget.data.metadata!.fileName!.replaceAll(" ", "_") +
          (audioMediaId?.fileType ?? "");*/
      var fileName = widget.data.metadata!.fileName!.replaceAll(" ", "_");
      if (!fileName.endsWith(".pdf")) {
        fileName += (audioMediaId?.fileType ?? "");
      }
      await FHBUtils.createDir(
        variable.stAudioPath,
        fileName,
        isTempDir: true,
      ).then((filePath) async {
        var file = File('$filePath' /*+ fileType*/);
        final request = await ApiServices.get(
          audioMediaId!.healthRecordUrl!,
          headers: {
            HttpHeaders.authorizationHeader: authToken!,
            Constants.KEY_OffSet: CommonUtil().setTimeZone()
          },
          timeout: 60,
        );
        final bytes = request!.bodyBytes; //close();
        await file.writeAsBytes(bytes);

        setState(() {
          if (['.mp3', '.aac'].contains(audioMediaId.fileType)) {
            //await path.writeAsBytes(bytes);

            containsAudio = true;
            audioPath = file.path;
            isAudioDownload = true;
          } else {
            pdfFile = file.path;
            fileNetworkUrl = audioMediaId.healthRecordUrl ?? '';
            fileTypeCommon = audioMediaId.fileType ?? '';
          }
        });
      });
      return isAudioDownload;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e.toString());
      return isAudioDownload;
    }
  }

  Future<bool> downloadImageFile(String? fileType, String fileUrl) async {
    var filePath = await FHBUtils.createFolderInAppDocDirClone(
        variable.stAudioPath, fileUrl.split('/').last);
    var file;
    if (fileType == '.pdf') {
      file = File('$filePath');
    } else {
      file = File('$filePath');
    }
    final request = await ApiServices.get(
      fileUrl,
      headers: {
        HttpHeaders.authorizationHeader: authToken!,
        Constants.KEY_OffSet: CommonUtil().setTimeZone()
      },
    );
    final bytes = request!.bodyBytes; //close();
    await file.writeAsBytes(bytes);

    setState(
      () {
        if (fileType == '.pdf') {
          pdfFile = file.path;
        } else {
          jpefFile = file.path;
        }
      },
    );
    return true;
  }

  Future<Uint8List> _loadFileBytes(String url, {OnError? onError}) async {
    Uint8List bytes;
    try {
      bytes = await readBytes(Uri.parse(url));
    } on ClientException {
      rethrow;
    }
    return bytes;
  }

  showProgressIndicator(HealthResult data) {
    showAudioWidgetIfVoiceNotesAvailable(data);
  }

  void getPdfFileData(HealthRecordCollection pdfFileMediaId) {
    if (_healthReportListForUserBlock != null) {
      _healthReportListForUserBlock = null;
      _healthReportListForUserBlock = HealthReportListForUserBlock();
    } else {
      _healthReportListForUserBlock = HealthReportListForUserBlock();
    }
    downloadFile(pdfFileMediaId, '.pdf');
  }

  getFileNameForPdf(String pdfFileName) {
    if (pdfFileName.contains('.pdf')) {
      pdfFileName = pdfFileName.replaceAll('.pdf', '');
      try {
        var value = '';
        final spilit = pdfFileName.split('_');
        // Check if there are at least two parts after splitting
        if (spilit.length > 1) {
          // If the condition is true, construct the value using the second part capitalized and swapped with the first part
          value = toBeginningOfSentenceCase(spilit[1])! + '_' + spilit[0];
        } else {
          // If there is only one part or none after splitting, construct the value by removing '.pdf' from the original pdfFileName
          value = pdfFileName;
        }
        return value;
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);

        return pdfFileName;
      }
    }
  }

  void setAuthToken() async {
    authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
  }

  void checkTheSpecifiedMetaID(
      HealthRecordList value, PostImageResponse? postImageResponse) {
    // showAudioWidgetIfVoiceNotesAvailable(value);
    for (final healthResult in value.result!) {
      if (widget.data.id == healthResult.id) {
        // widget.data=healthResult
        //widget.data.healthRecordCollection = healthResult.healthRecordCollection;
        PreferenceUtil.saveCompleteData(Constants.KEY_COMPLETE_DATA, value);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(postImageResponse!.message!),
        ));
      }
    }
  }

  moveToPDFViewer() {
    final data = OpenPDF(
        type: PDFLocation.Path,
        path: pdfFile,
        title: widget.data.metadata!.fileName);
    var pdfController = CommonUtil().onInitPDFViewController();
    pdfController.data = data;
    Get.to(() => PDFView());
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../claim/screen/ClaimRecordCreate.dart';
import '../../../common/CommonConstants.dart';
import '../../../common/CommonDialogBox.dart';
import '../../../common/CommonUtil.dart';
import '../../../common/FHBBasicWidget.dart';
import '../../../common/OverLayCategoryDialog.dart';
import '../../../common/OverlayDeviceDialog.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../common/SwitchProfile.dart';
import '../../../common/common_circular_indicator.dart';
import '../../../common/firestore_services.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import '../../../constants/fhb_parameters.dart' as parameters;
import '../../../constants/router_variable.dart' as router;
import '../../../constants/variable_constant.dart' as variable;
import '../../../main.dart';
import '../../../search_providers/models/search_arguments.dart';
import '../../../search_providers/screens/search_specific_list.dart';
import '../../../widgets/GradientAppBar.dart';
import '../../../widgets/RaisedGradientButton.dart';
import '../../blocs/Media/MediaTypeBlock.dart';
import '../../blocs/health/HealthReportListForUserBlock.dart';
import '../../model/Category/catergory_result.dart';
import '../../model/Health/DigitRecogResponse.dart';
import '../../model/Media/media_data_list.dart';
import '../../model/Media/media_result.dart';
import '../../utils/FHBUtils.dart';
import '../../utils/language/language_utils.dart';
import '../../utils/screenutils/size_extensions.dart';

class DisplayPictureScreen extends StatefulWidget {
  final List<String?> imagePath;

  const DisplayPictureScreen({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  TextEditingController doctorsName = TextEditingController();
  TextEditingController hospitalName = TextEditingController();
  TextEditingController labName = TextEditingController();

  late TextEditingController fileName;
  late TextEditingController dateOfVisit;
  late TextEditingController deviceController;
  TextEditingController? memoController;

  late TextEditingController pulse;
  late TextEditingController diaStolicPressure;

  DateTime dateTime = DateTime.now();

  String errForbpSp = '',
      errFForbpDp = '',
      errForbpPulse = '',
      errGluco = '',
      errWeight = '',
      errTemp = '',
      errPoPulse = '',
      errPoOs = '';

  String? categoryName, categoryNameClone;
  String? categoryID;
  bool firstTym = false;

  GlobalKey<State> _keyLoader = GlobalKey<State>();

  late HealthReportListForUserBlock _healthReportListForUserBlock;

  FHBBasicWidget fhbBasicWidget = FHBBasicWidget();

  MediaResult mediaDataObj = MediaResult();

  CategoryResult categoryDataObj = CategoryResult();

  var doctorsData, hospitalData, labData;

  File? imageFile;
  bool isCategoryNameDevices = false;

  bool categoryPressesd = false;
  String? deviceName;

  String? validationMsg;

  List<bool>? isSelected;
  String? selectedID;

  bool containsAudio = false;
  String audioPath = '';

  bool? skipTapped;

  String? tempUnit = "F";
  String? weightUnit = "kg";
  String? heightUnit = "feet";

  List<T?> map<T>(List list, Function handler) {
    List<T?> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  CarouselController? carouselSlider;
  int _current = 0;

  @override
  void initState() {
    _healthReportListForUserBlock = HealthReportListForUserBlock();
    PreferenceUtil.init();
    getAllObjectToPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initialData();
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
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
                Container(
                  child: RaisedGradientButton(
                    borderRadius: 0,
                    child: Text(
                      'Done',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    gradient: LinearGradient(
                      colors: <Color>[
                        mAppThemeProvider.primaryColor,
                        mAppThemeProvider.gradientColor
                      ],
                    ),
                    onPressed: () {
                      saveMediaDialog(
                          context,
                          categoryName,
                          deviceName![0].toUpperCase() +
                              deviceName!.substring(1));
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(OverlayDeviceDialog()).then((value) {
      setFileName();
      setState(() {});
    });
  }

  saveMediaDialog(
      BuildContext context, String? categoryName, String? deviceName) async {
    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);

    tempUnit = await PreferenceUtil.getStringValue(Constants.STR_KEY_TEMP);
    weightUnit = await PreferenceUtil.getStringValue(Constants.STR_KEY_WEIGHT);
    heightUnit = await PreferenceUtil.getStringValue(Constants.STR_KEY_HEIGHT);

    audioPath = '';
    containsAudio = false;
    try {
      deviceName = PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME);
      setFileName();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    if (categoryName != Constants.STR_DEVICES) {
      switch (categoryName) {
        case AppConstants.prescription:
          CommonDialogBox().getDialogBoxForPrescription(
              context,
              hospitalName,
              doctorsName,
              dateOfVisit,
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
          }, widget.imagePath, null, false, fileName);

          break;
        case AppConstants.bills:
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
              widget.imagePath,
              (containsAudio, audioPath) {
                audioPath = audioPath;
                containsAudio = containsAudio;

                setState(() {});
              },
              null,
              false,
              fileName);
          break;
        case Constants.STR_OTHERS:
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
              widget.imagePath,
              (containsAudio, audioPath) {
                audioPath = audioPath;
                containsAudio = containsAudio;

                setState(() {});
              },
              null,
              false,
              fileName);

          break;
        case Constants.STR_MEDICALREPORT:
          CommonDialogBox().getDialogBoxForPrescription(
              context,
              hospitalName,
              doctorsName,
              dateOfVisit,
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
          }, widget.imagePath, null, false, fileName);
          break;
        case Constants.STR_LABREPORT:
          CommonDialogBox().getDialogBoxForLabReport(
              context,
              labName,
              doctorsName,
              dateOfVisit,
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
          }, widget.imagePath, null, false, fileName);
          break;
        case Constants.STR_IDDOCS:
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
              widget.imagePath,
              (containsAudio, audioPath) {
                audioPath = audioPath;
                containsAudio = containsAudio;

                setState(() {});
              },
              null,
              false,
              fileName,
              dateOfVisit,
              '');
          break;
        case Constants.STR_CLAIMSRECORD:
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClaimRecordCreate(
                imagePath: widget.imagePath,
              ),
            ),
          );
          break;
      }
    } else {
      displayDevicesList(deviceName, null);
    }
  }

  readingDeviceDetails(String? device) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
        backgroundColor: mAppThemeProvider.primaryColor,
        content: Container(
            height: 50,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 25, height: 25, child: CommonCircularIndicator()),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(CommonConstants.reading_digits,
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400)),
                  ),
                  _showSkipButton(context, deviceName)
                ]))));
  }

  Widget _showSkipButton(BuildContext context, String? device) {
    final GestureDetector skipButtonWithGesture = GestureDetector(
      onTap: () {
        _skipBtnTapped(device!);
      },
      child: Container(
        width: 100,
        height: 40.0,
        decoration: BoxDecoration(
          color: mAppThemeProvider.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          border: Border.all(color: Colors.white),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            variable.strSkip,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
        child: skipButtonWithGesture);
  }

  _skipBtnTapped(String device) {
    _scaffoldKey.currentState!.hideCurrentSnackBar();
    displayDevicesList(device[0].toUpperCase() + device.substring(1), null);
    skipTapped = true;
  }

  displayDevicesList(String? device, DigitRecogResponse? digitRecogResponse) {
    switch (device) {
      case Constants.STR_GLUCOMETER:
        if (digitRecogResponse != null) {
          if (digitRecogResponse.result!.deviceMeasurementsHead != null) {
            if (digitRecogResponse.result!.deviceMeasurementsHead!
                    .deviceMeasurements![0].values !=
                variable.strImgNtClear) {
              deviceController.text = digitRecogResponse.result!
                  .deviceMeasurementsHead!.deviceMeasurements![0].values!;
            }
          }
        }

        CommonDialogBox().getDialogBoxForGlucometer(
            context,
            Constants.STR_GLUCOMETER,
            containsAudio,
            audioPath,
            (containsAudio, audioPath) {
              setState(() {
                audioPath = audioPath;
                containsAudio = containsAudio;
              });
            },
            widget.imagePath,
            (containsAudio, audioPath) {
              audioPath = audioPath;
              containsAudio = containsAudio;

              setState(() {});
            },
            null,
            false,
            deviceController,
            isSelected,
            fileName);
        break;
      case Constants.STR_THERMOMETER:
        if (digitRecogResponse != null) {
          if (digitRecogResponse.result!.deviceMeasurementsHead != null) {
            if (digitRecogResponse.result!.deviceMeasurementsHead!
                    .deviceMeasurements![0].values !=
                variable.strImgNtClear) {
              deviceController.text = digitRecogResponse.result!
                  .deviceMeasurementsHead!.deviceMeasurements![0].values!;
            }
          }
        }

        CommonDialogBox().getDialogBoxForTemperature(
            context,
            Constants.STR_THERMOMETER,
            containsAudio,
            audioPath,
            (containsAudio, audioPath) {
              setState(() {
                audioPath = audioPath;
                containsAudio = containsAudio;
              });
            },
            widget.imagePath,
            (containsAudio, audioPath) {
              audioPath = audioPath;
              containsAudio = containsAudio;

              setState(() {});
            },
            null,
            false,
            deviceController,
            fileName,
            tempMainUnit: tempUnit,
            updateUnit: (unitValue) async {
              tempUnit = unitValue;
              setState(() {});
            });
        break;
      case Constants.STR_WEIGHING_SCALE:
        if (digitRecogResponse != null) {
          if (digitRecogResponse.result!.deviceMeasurementsHead != null) {
            if (digitRecogResponse.result!.deviceMeasurementsHead!
                    .deviceMeasurements![0].values !=
                variable.strImgNtClear) {
              deviceController.text = digitRecogResponse.result!
                  .deviceMeasurementsHead!.deviceMeasurements![0].values!;
            }
          }
        }

        CommonDialogBox().getDialogBoxForWeightingScale(
            context,
            Constants.STR_WEIGHING_SCALE,
            containsAudio,
            audioPath,
            (containsAudio, audioPath) {
              setState(() {
                audioPath = audioPath;
                containsAudio = containsAudio;
              });
            },
            widget.imagePath,
            (containsAudio, audioPath) {
              audioPath = audioPath;
              containsAudio = containsAudio;

              setState(() {});
            },
            null,
            false,
            deviceController,
            fileName,
            weightUnit: weightUnit,
            updateUnit: (unitValue) async {
              weightUnit = unitValue;

              setState(() {});
            });
        break;
      case Constants.STR_PULSE_OXIMETER:
        if (digitRecogResponse != null) {
          if (digitRecogResponse.result!.deviceMeasurementsHead != null) {
            if (digitRecogResponse.result!.deviceMeasurementsHead!
                    .deviceMeasurements![0].values !=
                variable.strImgNtClear) {
              deviceController.text = digitRecogResponse.result!
                  .deviceMeasurementsHead!.deviceMeasurements![0].values!;
              pulse.text = digitRecogResponse.result!.deviceMeasurementsHead!
                  .deviceMeasurements![0].values!;
            }
          }
        }

        CommonDialogBox().getDialogBoxForPulseOxidometer(
            context,
            Constants.STR_PULSE_OXIMETER,
            containsAudio,
            audioPath,
            (containsAudio, audioPath) {
              setState(() {
                audioPath = audioPath;
                containsAudio = containsAudio;
              });
            },
            widget.imagePath,
            (containsAudio, audioPath) {
              audioPath = audioPath;
              containsAudio = containsAudio;

              setState(() {});
            },
            null,
            false,
            deviceController,
            pulse,
            fileName);
        break;
      case Constants.STR_BP_MONITOR:
        if (digitRecogResponse != null) {
          if (digitRecogResponse.result!.deviceMeasurementsHead != null) {
            if (digitRecogResponse.result!.deviceMeasurementsHead!
                    .deviceMeasurements![0].values !=
                variable.strImgNtClear) {
              deviceController.text = digitRecogResponse.result!
                  .deviceMeasurementsHead!.deviceMeasurements![0].values!;
              diaStolicPressure.text = digitRecogResponse.result!
                  .deviceMeasurementsHead!.deviceMeasurements![1].values!;
              pulse.text = digitRecogResponse.result!.deviceMeasurementsHead!
                  .deviceMeasurements![2].values!;
            }
          }
        }

        CommonDialogBox().getDialogBoxForBPMonitor(
            context,
            Constants.STR_BP_MONITOR,
            containsAudio,
            audioPath,
            (containsAudio, audioPath) {
              setState(() {
                audioPath = audioPath;
                containsAudio = containsAudio;
              });
            },
            widget.imagePath,
            (containsAudio, audioPath) {
              audioPath = audioPath;
              containsAudio = containsAudio;

              setState(() {});
            },
            null,
            false,
            deviceController,
            pulse,
            diaStolicPressure,
            fileName);
        break;
    }
  }

  moveToSearchScreen(BuildContext context, String searchParam) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => SearchSpecificList(
                arguments: SearchArguments(
                  searchWord: searchParam,
                ),
                toPreviousScreen: true,
                isSkipUnknown: true)))
        .then((results) {
      if (results != null) {
        if (results.containsKey(Constants.keyDoctor)) {
          doctorsData = json.decode(results[Constants.keyDoctor]);

          setState(() {
            doctorsName.text = doctorsData[parameters.strName];
          });
        } else if (results.containsKey(Constants.keyHospital)) {
          hospitalData = json.decode(results[Constants.keyHospital]);
          setState(() {
            hospitalName.text =
                hospitalData[parameters.strHealthOrganizationName];
          });
        } else if (results.containsKey(Constants.keyLab)) {
          labData = json.decode(results[Constants.keyLab]);
          setState(() {
            labName.text = labData[parameters.strHealthOrganizationName];
          });
        }
      }
    });
  }

  getAllObjectToPost() {
    initialData();
    setFileName();

    isSelected = [true, false];
    deviceController = TextEditingController(text: '');
    memoController = TextEditingController(text: '');

    pulse = TextEditingController(text: '');
    diaStolicPressure = TextEditingController(text: '');

    List<CategoryResult> catgoryDataList = PreferenceUtil.getCategoryType()!;

    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);

    if (categoryName != Constants.STR_IDDOCS) {
      dateOfVisit = TextEditingController(
          text: FHBUtils().getFormattedDateOnly(dateTime.toString()));
    } else {
      dateOfVisit = TextEditingController(text: '');
    }

    isCategoryNameDevices =
        categoryName == Constants.IS_CATEGORYNAME_DEVICES ? true : false;
    categoryID = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYID);

    categoryDataObj = CommonUtil()
        .getCategoryObjForSelectedLabel(categoryID, catgoryDataList);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());

    if (picked != null) {
      setState(() {
        dateTime = picked;
        dateOfVisit.text = FHBUtils().getFormattedDateOnly(dateTime.toString());
      });
    }
  }

  void initialData() {
    if (!firstTym) {
      categoryNameClone =
          PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
      firstTym = true;
    }

    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
    deviceName =
        (PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME) ?? '') == ''
            ? Constants.IS_CATEGORYNAME_DEVICES
            : PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME);
  }

  Widget getToggleButton() {
    return ToggleButtons(
      borderColor: Colors.black,
      fillColor: Colors.grey[100],
      borderWidth: 2,
      selectedBorderColor: mAppThemeProvider.primaryColor,
      selectedColor: mAppThemeProvider.primaryColor,
      borderRadius: BorderRadius.circular(10),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Before Food',
            style: TextStyle(fontSize: 16.0.sp),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'After Food',
            style: TextStyle(fontSize: 16.0.sp),
          ),
        ),
      ],
      onPressed: (int index) => onToggleBUttonPressed(index),
      isSelected: isSelected!,
    );
  }

  onToggleBUttonPressed(int index) async {
    setState(() {
      for (int i = 0; i < isSelected!.length; i++) {
        isSelected![i] = i == index;
      }
    });
  }

  void setFileName() {
    if (categoryName == variable.strDevices) {
      fileName = TextEditingController(
          text: deviceName! +
              '_${DateTime.now().toUtc().millisecondsSinceEpoch}');
    } else {
      fileName = TextEditingController(
          text: categoryName! +
              '_${DateTime.now().toUtc().millisecondsSinceEpoch}');
    }
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
            child: CarouselSlider(
              carouselController: carouselSlider,
              options: CarouselOptions(
                height: 1.sh,
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
              items: widget.imagePath.map((imgUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: 1.sw,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(),
                        child: Container(
                          height: double.infinity,
                          child: imgUrl!.contains(variable.strpdf)
                              ? CommonUtil().showPDFInWidget(imgUrl)
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
            height: 10.0,
          ),
          Row(
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
              IconButton(
                onPressed: goToNext,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 24.0.sp,
                ),
              ),
            ],
          ),
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

  onPostDeviceImageData(String? deviceName) async {
    Map<String, dynamic> postMediaData = Map();
    List<CategoryResult> catgoryDataList = PreferenceUtil.getCategoryType()!;

    categoryDataObj = CommonUtil()
        .getCategoryObjForSelectedLabel(categoryID, catgoryDataList);
    postMediaData[parameters.strhealthRecordCategory] =
        categoryDataObj.toJson();

    //postMediaData[parameters.strHealthRecordCategory] = categoryDataObj.toJson();
    MediaTypeBlock _mediaTypeBlock = MediaTypeBlock();

    MediaDataList mediaTypesResponse =
        await (_mediaTypeBlock.getMediTypesList() as Future<MediaDataList>);

    List<MediaResult>? metaDataFromSharedPrefernce = mediaTypesResponse.result;
    if (categoryName != Constants.STR_DEVICES) {
      mediaDataObj = CommonUtil().getMediaTypeInfoForParticularLabel(
          categoryID, metaDataFromSharedPrefernce!, categoryName);
    } else {
      mediaDataObj = CommonUtil().getMediaTypeInfoForParticularDevice(
          deviceName, metaDataFromSharedPrefernce!);
    }

    postMediaData[parameters.strhealthRecordType] = mediaDataObj.toJson();

    //    postMediaData["dateOfVisit"] = dateOfVisit.text;
    postMediaData[parameters.strmemoText] = '';
    postMediaData[parameters.strhasVoiceNotes] = false;
    postMediaData[parameters.strdateOfVisit] = dateOfVisit.text;
    postMediaData[parameters.strisDraft] = false;

    postMediaData[parameters.strsourceName] = CommonConstants.strTridentValue;
    postMediaData[parameters.strmemoTextRaw] = parameters.strMemoRawTxtVal;
    postMediaData[parameters.strfileName] = fileName.text;
    //postMainData[parameters.strmetaInfo] = postMediaData;

    var params = json.encode(postMediaData);

    // for (int i = 0; i < widget.imagePath.length; i++) {
    _healthReportListForUserBlock
        .saveDeviceImage(widget.imagePath, params.toString(), '')
        .then((postImageResponse) {
      _scaffoldKey.currentState!.hideCurrentSnackBar();

      if (skipTapped == false) {
        displayDevicesList(deviceName, postImageResponse);
      }
    });
    //}
  }

  getWidgetForTitleAndSwithUser() {
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            child: Text(categoryName!),
            onTap: () {
              _showOverlayCategoryDialog(context);
            },
          ),
        ),
        SwitchProfile()
            .buildActions(context, _keyLoader, callBackToRefresh, false)
      ],
    );
  }

  void callBackToRefresh() {
    FirestoreServices().updateFirestoreListner();
    setState(() {});
  }

  void _showOverlayCategoryDialog(BuildContext context) {
    Navigator.of(context).push(OverlayCategoryDialog()).then((value) {
      initializeData();
    });
  }

  void initializeData() {
    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
    categoryID = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYID);
    if (categoryNameClone == categoryName &&
        categoryName == Constants.STR_DEVICES) {
    } else if (categoryName == Constants.STR_DEVICES) {
      PreferenceUtil.saveString(Constants.stop_detecting, variable.strNo);

      Navigator.pushNamed(context, router.rt_TakePictureForDevices)
          .then((value) {
        Navigator.pop(context);
      });
    } else {
      setState(() {});
    }
  }
}

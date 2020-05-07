import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/AudioWidget.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonDialogBox.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/OverLayCategoryDialog.dart';
import 'package:myfhb/common/OverlayDeviceDialog.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/search_providers/models/search_arguments.dart';
import 'package:myfhb/search_providers/screens/search_specific_list.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/model/Health/DigitRecogResponse.dart';
import 'package:myfhb/src/model/Media/MediaTypeResponse.dart';
import 'package:myfhb/src/ui/audio/audio_record_screen.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/widgets/RaisedGradientButton.dart';

export 'package:myfhb/src/search/Doctors/DoctorsListResponse.dart';

class DisplayPictureScreen extends StatefulWidget {
  final List<String> imagePath;

  const DisplayPictureScreen({
    Key key,
    @required this.imagePath,
  }) : super(key: key);

  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  TextEditingController doctorsName = new TextEditingController();
  TextEditingController hospitalName = new TextEditingController();
  TextEditingController labName = new TextEditingController();

  TextEditingController fileName;
  TextEditingController dateOfVisit;
  TextEditingController deviceController;
  TextEditingController memoController;

  TextEditingController pulse;
  TextEditingController diaStolicPressure;

  DateTime dateTime = DateTime.now();

  String errForbpSp = '',
      errFForbpDp = '',
      errForbpPulse = '',
      errGluco = '',
      errWeight = '',
      errTemp = '',
      errPoPulse = '',
      errPoOs = '';

  String categoryName, categoryNameClone;
  String categoryID;
  bool firstTym = false;

  GlobalKey<State> _keyLoader = new GlobalKey<State>();

  HealthReportListForUserBlock _healthReportListForUserBlock;

  FHBBasicWidget fhbBasicWidget = new FHBBasicWidget();

  MediaData mediaDataObj = new MediaData();

  CategoryData categoryDataObj = new CategoryData();

  var doctorsData, hospitalData, labData;

  File imageFile;
  bool isCategoryNameDevices = false;

  bool categoryPressesd = false;
  String deviceName;

  String validationMsg;

  List<bool> isSelected;
  String selectedID;

  bool containsAudio = false;
  String audioPath = '';
  List<String> documentList = ['Hospital IDS', 'Insurance IDs', 'Other IDs'];

  bool skipTapped;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  CarouselSlider carouselSlider;
  int _current = 0;

  @override
  void initState() {
    _healthReportListForUserBlock = new HealthReportListForUserBlock();

    PreferenceUtil.init();

    getAllObjectToPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initialData();
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
              Container(
                child: RaisedGradientButton(
                  borderRadius: 0,
                  child: Text(
                    'Done',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(new CommonUtil().getMyPrimaryColor()),
                      Color(new CommonUtil().getMyGredientColor())
                    ],
                  ),
                  onPressed: () {
                    saveMediaDialog(context, categoryName, deviceName);
                  },
                ),
              )
            ],
          ),
        ],
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
      BuildContext context, String categoryName, String deviceName) {
    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
    //print('pary categoryName' + categoryName);

    audioPath = '';
    containsAudio = false;
    try {
      deviceName = PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME);
      //print('pary deviceName' + deviceName);
      setFileName();
    } catch (e) {
      print(e);
    }

    if (categoryName != Constants.STR_DEVICES) {
      switch (categoryName) {
        case Constants.STR_PRESCRIPTION:
          new CommonDialogBox().getDialogBoxForPrescription(
              context,
              hospitalName,
              doctorsName,
              dateOfVisit,
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
          }, widget.imagePath, null, false, fileName);

          // getDialogBoxForPrescription(context);
          break;
        case Constants.STR_BILLS:
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
              widget.imagePath,
              (containsAudio, audioPath) {
                print('Audio Path DisplayPicture' + containsAudio.toString());
                print('Audio Path DisplayPicture' + audioPath.toString());

                audioPath = audioPath;
                containsAudio = containsAudio;

                setState(() {});
              },
              null,
              false,
              fileName);
          //getDialogBoxForBillsAndOthers(context);
          break;
        case Constants.STR_OTHERS:
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
              widget.imagePath,
              (containsAudio, audioPath) {
                print('Audio Path DisplayPicture' + containsAudio.toString());
                print('Audio Path DisplayPicture' + audioPath.toString());

                audioPath = audioPath;
                containsAudio = containsAudio;

                setState(() {});
              },
              null,
              false,
              fileName);
          //getDialogBoxForBillsAndOthers(context);

          break;
        case Constants.STR_MEDICALREPORT:
          new CommonDialogBox().getDialogBoxForPrescription(
              context,
              hospitalName,
              doctorsName,
              dateOfVisit,
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
          }, widget.imagePath, null, false, fileName);
          break;
        case Constants.STR_LABREPORT:
          new CommonDialogBox().getDialogBoxForLabReport(
              context,
              labName,
              doctorsName,
              dateOfVisit,
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
          }, widget.imagePath, null, false, fileName);
          break;
        case Constants.STR_IDDOCS:
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
              widget.imagePath,
              (containsAudio, audioPath) {
                print('Audio Path DisplayPicture' + containsAudio.toString());
                print('Audio Path DisplayPicture' + audioPath.toString());

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
      }
    } else {
      //print(deviceName + " Paaaaaaaaaaaaaaaaaaru");

      var digitRecog = true;
      //      displayDevicesList(deviceName);

      digitRecog =
          PreferenceUtil.getStringValue(Constants.allowDigitRecognition) ==
                  'false'
              ? false
              : true;

      if (digitRecog) {
        //      displayDevicesList(deviceName);

        skipTapped = false;

        readingDeviceDetails(deviceName);

        onPostDeviceImageData(deviceName);
      } else {
        displayDevicesList(deviceName, null);
      }
    }
  }

  readingDeviceDetails(String device) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
        content: new Container(
            height: 50,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.white)),
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

  Widget _showSkipButton(BuildContext context, String device) {
    final GestureDetector skipButtonWithGesture = new GestureDetector(
      onTap: () {
        _skipBtnTapped(device);
      },
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
            'Skip',
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
        child: skipButtonWithGesture);
  }

  _skipBtnTapped(String device) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    displayDevicesList(deviceName, null);
    skipTapped = true;

    //    displayDevicesList(device);
  }

  displayDevicesList(String device, DigitRecogResponse digitRecogResponse) {
    switch (device) {
      case Constants.STR_GLUCOMETER:
        if (digitRecogResponse != null) {
          if (digitRecogResponse.response.data.deviceMeasurements != null) {
            if (digitRecogResponse
                    .response.data.deviceMeasurements.data[0].values !=
                'Image not clear') {
              deviceController.text = digitRecogResponse
                  .response.data.deviceMeasurements.data[0].values;
            }
          }
        }

        new CommonDialogBox().getDialogBoxForGlucometer(
            context,
            device,
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
          if (digitRecogResponse.response.data.deviceMeasurements != null) {
            if (digitRecogResponse
                    .response.data.deviceMeasurements.data[0].values !=
                'Image not clear') {
              deviceController.text = digitRecogResponse
                  .response.data.deviceMeasurements.data[0].values;
            }
          }
        }

        new CommonDialogBox().getDialogBoxForTemperature(
            context,
            device,
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
            fileName);
        break;
      case Constants.STR_WEIGHING_SCALE:
        if (digitRecogResponse != null) {
          if (digitRecogResponse.response.data.deviceMeasurements != null) {
            if (digitRecogResponse
                    .response.data.deviceMeasurements.data[0].values !=
                'Image not clear') {
              deviceController.text = digitRecogResponse
                  .response.data.deviceMeasurements.data[0].values;
            }
          }
        }

        new CommonDialogBox().getDialogBoxForWeightingScale(
            context,
            device,
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
            fileName);
        break;
      case Constants.STR_PULSE_OXIMETER:
        if (digitRecogResponse != null) {
          if (digitRecogResponse.response.data.deviceMeasurements != null) {
            if (digitRecogResponse
                    .response.data.deviceMeasurements.data[0].values !=
                'Image not clear') {
              deviceController.text = digitRecogResponse
                  .response.data.deviceMeasurements.data[0].values;
              pulse.text = digitRecogResponse
                  .response.data.deviceMeasurements.data[1].values;
            }
          }
        }

        new CommonDialogBox().getDialogBoxForPulseOxidometer(
            context,
            device,
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
          if (digitRecogResponse.response.data.deviceMeasurements != null) {
            if (digitRecogResponse
                    .response.data.deviceMeasurements.data[0].values !=
                'Image not clear') {
              deviceController.text = digitRecogResponse
                  .response.data.deviceMeasurements.data[0].values;
              diaStolicPressure.text = digitRecogResponse
                  .response.data.deviceMeasurements.data[1].values;
              pulse.text = digitRecogResponse
                  .response.data.deviceMeasurements.data[2].values;
            }
          }
        }

        new CommonDialogBox().getDialogBoxForBPMonitor(
            context,
            device,
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
                )))
        .then((results) {
      if (results != null) {
        if (results.containsKey('doctor')) {
          doctorsData = json.decode(results['doctor']);

          print('doctor data' + doctorsData.toString());
          setState(() {
            print('inside important setState');
            //doctorsName = new TextEditingController(text: doctorsData['name']);
            doctorsName.text = doctorsData['name'];
          });
        } else if (results.containsKey('hospital')) {
          print(' received HospitalValue');

          hospitalData = json.decode(results['hospital']);
          print('hospital data' + hospitalData.toString());
          //hospitalName = new TextEditingController(text: hospitalData['name']);
          hospitalName.text = hospitalData['name'];
        } else if (results.containsKey('laborartory')) {
          labData = json.decode(results['laborartory']);
          print('hospital data' + hospitalData.toString());
          //hospitalName = new TextEditingController(text: hospitalData['name']);
          labName.text = labData['name'];
        }
        setState(() {});
      }
    });
    // Data docotorsData = new Data();
  }

  void onPostDataToServer() async {
    if (doValidationBeforePosting()) {
      Map<String, dynamic> postMainData = new Map();
      Map<String, dynamic> postMediaData = new Map();
      String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

      postMainData["userId"] = userID;

      postMediaData["categoryInfo"] = categoryDataObj.toJson();
      List<MediaData> metaDataFromSharedPrefernce =
          PreferenceUtil.getMediaType();

      if (categoryName != Constants.STR_DEVICES) {
        mediaDataObj = new CommonUtil().getMediaTypeInfoForParticularLabel(
            categoryID, metaDataFromSharedPrefernce, categoryName);
      } else {
        mediaDataObj = new CommonUtil().getMediaTypeInfoForParticularDevice(
            deviceName, metaDataFromSharedPrefernce);
      }

      postMediaData["mediaTypeInfo"] = mediaDataObj.toJson();

      postMediaData["dateOfVisit"] = dateOfVisit.text;
      postMediaData["memoText"] = memoController.text;
      postMediaData["hasVoiceNote"] =
          (audioPath != '' && audioPath != null) ? true : false;
      postMediaData["isDraft"] = false;

      postMediaData["sourceName"] = CommonConstants.strTridentValue;
      postMediaData["memoTextRaw"] = 'memoTextRaw';

      if (categoryName == CommonConstants.strDevice) {
        List<Map<String, dynamic>> postDeviceData = new List();
        Map<String, dynamic> postDeviceValues = new Map();
        Map<String, dynamic> postDeviceValuesExtra = new Map();
        Map<String, dynamic> postDeviceValuesExtraClone = new Map();

        if (deviceName == Constants.STR_GLUCOMETER) {
          postDeviceValues['parameter'] = CommonConstants.strSugarLevel;
          postDeviceValues['value'] = int.parse(deviceController.text);
          postDeviceValues['unit'] = CommonConstants.strGlucometerValue;
          postDeviceData.add(postDeviceValues);
          postDeviceValuesExtra['parameter'] = CommonConstants.strTimeIntake;
          postDeviceValuesExtra['value'] = '';
          postDeviceValuesExtra['unit'] =
              isSelected[0] == true ? 'Before' : 'After';
          postDeviceData.add(postDeviceValuesExtra);
        } else if (deviceName == Constants.STR_THERMOMETER) {
          postDeviceValues['parameter'] = CommonConstants.strTemperature;
          postDeviceValues['value'] = int.parse(deviceController.text);
          postDeviceValues['unit'] = CommonConstants.strTemperatureUnit;
          postDeviceData.add(postDeviceValues);
        } else if (deviceName == Constants.STR_WEIGHING_SCALE) {
          postDeviceValues['parameter'] = CommonConstants.strWeightParam;
          postDeviceValues['value'] = deviceController.text;
          postDeviceValues['unit'] = CommonConstants.strWeightUnit;
          postDeviceData.add(postDeviceValues);
        } else if (deviceName == Constants.STR_PULSE_OXIMETER) {
          postDeviceValues['parameter'] = CommonConstants.strOxygenParams;
          postDeviceValues['value'] = deviceController.text;
          postDeviceValues['unit'] = CommonConstants.strOxygenUnits;
          postDeviceData.add(postDeviceValues);

          postDeviceValuesExtra['parameter'] = CommonConstants.strPulseRate;
          postDeviceValuesExtra['value'] = pulse.text;
          postDeviceValuesExtra['unit'] = CommonConstants.strPulseUnit;

          postDeviceData.add(postDeviceValuesExtra);
        } else if (deviceName == Constants.STR_BP_MONITOR) {
          postDeviceValues['parameter'] = CommonConstants.strBPParams;
          postDeviceValues['value'] = deviceController.text;

          postDeviceValues['unit'] = CommonConstants.strBPUNits;
          postDeviceData.add(postDeviceValues);

          postDeviceValuesExtra['parameter'] =
              CommonConstants.strDiastolicParams;
          postDeviceValuesExtra['value'] = diaStolicPressure.text;
          postDeviceValuesExtra['unit'] = CommonConstants.strBPUNits;

          postDeviceData.add(postDeviceValuesExtra);

          postDeviceValuesExtraClone['parameter'] =
              CommonConstants.strPulseRate;
          postDeviceValuesExtraClone['value'] = pulse.text;
          postDeviceValuesExtraClone['unit'] = CommonConstants.strPulseUnit;

          postDeviceData.add(postDeviceValuesExtraClone);
        }
        print(postDeviceData.toString() + 'Values of readings');
        postMediaData['deviceReadings'] = postDeviceData;
      } else if (categoryName == Constants.STR_PRESCRIPTION ||
          categoryName == Constants.STR_MEDICALREPORT) {
        postMediaData["doctor"] = doctorsData;
        if (hospitalData == null) {
          //postMediaData["hospital"] = {};
        } else {
          postMediaData["hospital"] = hospitalData;
        }
      } else if (categoryName == Constants.STR_IDDOCS) {
        if (selectedID != null) {
          print(selectedID.split(' ')[0]);

          postMediaData['idType'] = selectedID.split(' ')[0];
        }
      } else if (categoryName == Constants.STR_LABREPORT) {
        postMediaData["doctor"] = doctorsData;
        postMediaData["laboratory"] = labData;
      }
      postMediaData["fileName"] = fileName.text;

      postMainData['metaInfo'] = postMediaData;

      print('body' + postMainData.toString());
      print('postDeviceData ' + postMediaData['deviceReadings'].toString());

      var params = json.encode(postMainData);

      print('params' + params.toString());
      print('params' + postMainData['metaInfo'].toString());

      //print('imagePath' + widget.imagePath);

      //imageFile = File(widget.imagePath);

      _healthReportListForUserBlock
          .submit(
        params.toString(),
      )
          .then((savedMetaDataResponse) {
        if (savedMetaDataResponse.success) {
          PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, "");
          postAudioToServer(savedMetaDataResponse.response.data.mediaMetaID);
        }
      });
    } else {
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("MyFHB"),
            content: new Text(validationMsg),
          ));
    }
  }

  getAllObjectToPost() {
    print('inside getAllObjectToPost');
    initialData();
    setFileName();

    isSelected = [true, false];
    deviceController = new TextEditingController(text: '');
    memoController = new TextEditingController(text: '');

    if (doctorsName.text != null) {
      print('doctors Controller' + doctorsName.text);
      print('hospital Controller' + hospitalName.text);
    }

    dateOfVisit = new TextEditingController(
        text: FHBUtils().getFormattedDateOnly(dateTime.toString()));

    pulse = new TextEditingController(text: '');
    diaStolicPressure = new TextEditingController(text: '');

    List<CategoryData> catgoryDataList = PreferenceUtil.getCategoryType();

    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);

    isCategoryNameDevices =
        categoryName == Constants.IS_CATEGORYNAME_DEVICES ? true : false;
    categoryID = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYID);

    print('categoryID' + categoryID);

    categoryDataObj = new CommonUtil()
        .getCategoryObjForSelectedLabel(categoryID, catgoryDataList);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());

    if (picked != null) {
      setState(() {
        dateTime = picked ?? dateTime;
        dateOfVisit.text = FHBUtils().getFormattedDateOnly(dateTime.toString());
      });
    }
  }

  onDateSelected(DateTime dateTimeSelected, String selectedDate) {
    print('inside setState');
    print('inside setState' + dateTimeSelected.toString());
    print('inside setState' + selectedDate);

    setState(() {
      dateTime = dateTimeSelected;
      dateOfVisit.text = selectedDate;
    });
  }

  void postImageToServer(String mediaMetaID) {
    Map<String, dynamic> postImage = new Map();

    postImage['mediaMetaId'] = mediaMetaID;
    print('I am here ' + mediaMetaID);

    /* _healthReportListForUserBlock
                  .saveImage(widget.imagePath, mediaMetaID, '')
                  .then((postImageResponse) {
                print(
                    'output mediaMaster' + postImageResponse.response.data.mediaMasterId);
          
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });*/
  }

  void postAudioToServer(String mediaMetaID) {
    Map<String, dynamic> postImage = new Map();

    postImage['mediaMetaId'] = mediaMetaID;
    print('I am here ' + mediaMetaID);
    print('I am here audioPath' + audioPath);
    int k = 0;
    for (int i = 0; i < widget.imagePath.length; i++) {
      _healthReportListForUserBlock
          .saveImage(widget.imagePath[i], mediaMetaID, '')
          .then((postImageResponse) {
        print('output audio mediaMaster images' +
            postImageResponse.response.data.mediaMasterId);
        k++;
        if (audioPath != '' && k == widget.imagePath.length) {
          _healthReportListForUserBlock
              .saveImage(audioPath, mediaMetaID, '')
              .then((postImageResponse) {
            print('output audio mediaMaster' +
                postImageResponse.response.data.mediaMasterId);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (k == widget.imagePath.length - 1) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {}
        PreferenceUtil.saveMediaData(Constants.KEY_MEDIADATA, null);
      });
    }
  }

  Future<Widget> getDialogBoxForPrescription(BuildContext context) {
    print('inside prescription');
    if (fileName.text == '' || fileName.text == null) {
      setFileName();
    }
    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: fhbBasicWidget.getTextTextTitleWithPurpleColor(categoryName),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strDoctorsName),
                    fhbBasicWidget
                        .getTextFieldForDialogWithControllerAndPressed(context,
                            (context, value) {
                      moveToSearchScreen(context, CommonConstants.keyDoctor);
                    }, doctorsName, CommonConstants.keyDoctor),
                    SizedBox(
                      height: 15,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strFileName),
                    fhbBasicWidget.getTextFieldWithNoCallbacks(
                        context, fileName),
                    SizedBox(
                      height: 15,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strHospitalNameWithoutStar),
                    fhbBasicWidget
                        .getTextFieldForDialogWithControllerAndPressed(context,
                            (context, value) {
                      moveToSearchScreen(context, CommonConstants.keyHospital);
                    }, hospitalName, CommonConstants.keyHospital),
                    SizedBox(
                      height: 15,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strDateOfVisit),
                    Container(
                        width: MediaQuery.of(context).size.width - 60,
                        child: TextField(
                          autofocus: false,
                          onTap: () => _selectDate(context),
                          controller: dateOfVisit,
                          decoration: InputDecoration(
                              suffixIcon: new IconButton(
                            icon: new Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          )),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strMemo),
                    fhbBasicWidget.getTextFiledWithNoHInt(context),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            containsAudio
                ? getAudioIconWithFile()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      getMicIcon(),
                      fhbBasicWidget.getSaveButton(() {
                        onPostDataToServer();
                      })
                    ],
                  ),
          ],
        ),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  Future<Widget> getDialogBoxForGlucometer(
      BuildContext context, String deviceName) {
    print('inside initilzeData');
    if (fileName.text == '' || fileName.text == null) {
      setFileName();
    }
    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: fhbBasicWidget.getTextTextTitleWithPurpleColor(deviceName),
          content: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              fhbBasicWidget.getTextForAlertDialog(
                  context, CommonConstants.strFileName),
              fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
              SizedBox(
                height: 15,
              ),
              fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                  context,
                  CommonConstants.strValue,
                  CommonConstants.strGlucometerValue,
                  deviceController, (errorValue) {
                setState(() {
                  errGluco = errorValue;
                });
              }, errGluco, CommonConstants.strGlucometerValue),
              SizedBox(
                height: 15,
              ),
              fhbBasicWidget.getTextFiledWithHint(
                  context, CommonConstants.strMemo, memoController),
              SizedBox(
                height: 15,
              ),
              fhbBasicWidget.getTextForAlertDialog(
                  context, CommonConstants.strTimeTaken),
              ToggleButtons(
                borderColor: Colors.black,
                fillColor: Colors.grey[100],
                borderWidth: 2,
                selectedBorderColor:
                    Color(new CommonUtil().getMyPrimaryColor()),
                selectedColor: Color(new CommonUtil().getMyPrimaryColor()),
                borderRadius: BorderRadius.circular(10),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Before Food',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'After Food',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
                onPressed: (int index) {
                  setState(() {
                    print('inside setState');
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = i == index;
                    }
                  });
                },
                isSelected: isSelected,
              ),
              SizedBox(
                height: 15,
              ),
              containsAudio
                  ? getAudioIconWithFile()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        getMicIcon(),
                        fhbBasicWidget.getSaveButton(() {
                          onPostDataToServer();
                        })
                      ],
                    ),
            ],
          )));
    });

    return showDialog(context: context, builder: (context) => dialog);
  }

  Future<Widget> getDialogBoxForTemperature(
      BuildContext context, String deviceName) {
    if (fileName.text == '' || fileName.text == null) {
      setFileName();
    }
    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: fhbBasicWidget.getTextTextTitleWithPurpleColor(deviceName),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15,
            ),
            fhbBasicWidget.getTextFiledWithHintAndSuffixText(
              context,
              CommonConstants.strTemperature,
              CommonConstants.strTemperatureValue,
              deviceController,
              (errorValue) {
                setState(() {
                  errTemp = errorValue;
                });
              },
              errTemp,
              CommonConstants.strTemperatureValue,
            ),
            SizedBox(
              height: 15,
            ),
            fhbBasicWidget.getTextFiledWithHint(
                context, CommonConstants.strMemo, memoController),
            SizedBox(
              height: 15,
            ),
            containsAudio
                ? getAudioIconWithFile()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      getMicIcon(),
                      fhbBasicWidget.getSaveButton(() {
                        onPostDataToServer();
                      })
                    ],
                  ),
          ],
        )),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  Future<Widget> getDialogBoxForWeightingScale(
      BuildContext context, String deviceName) {
    if (fileName.text == '' || fileName.text == null) {
      setFileName();
    }
    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: fhbBasicWidget.getTextTextTitleWithPurpleColor(deviceName),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15,
            ),
            fhbBasicWidget.getTextFiledWithHintAndSuffixText(
              context,
              CommonConstants.strWeight,
              CommonConstants.strWeightValue,
              deviceController,
              (errorValue) {
                setState(() {
                  errWeight = errorValue;
                });
              },
              errWeight,
              CommonConstants.strWeightValue,
            ),
            SizedBox(
              height: 15,
            ),
            fhbBasicWidget.getTextFiledWithHint(
                context, CommonConstants.strMemo, memoController),
            SizedBox(
              height: 15,
            ),
            containsAudio
                ? getAudioIconWithFile()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      getMicIcon(),
                      fhbBasicWidget.getSaveButton(() {
                        onPostDataToServer();
                      })
                    ],
                  ),
          ],
        )),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  Future<Widget> getDialogBoxForPulseOxidometer(
      BuildContext context, String deviceName) {
    if (fileName.text == '' || fileName.text == null) {
      setFileName();
    }
    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: fhbBasicWidget.getTextTextTitleWithPurpleColor(deviceName),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15,
            ),
            fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                context,
                CommonConstants.strOxygenSaturation,
                CommonConstants.strOxygenValue,
                deviceController, (errorValue) {
              setState(() {
                errPoOs = errorValue;
              });
            }, errPoOs, '%spo2'),
            SizedBox(
              height: 15,
            ),
            fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                context,
                CommonConstants.strPulse,
                CommonConstants.strPulseValue,
                pulse, (errorValue) {
              setState(() {
                errPoPulse = errorValue;
              });
            }, errPoPulse, 'pulse'),
            SizedBox(
              height: 15,
            ),
            fhbBasicWidget.getTextFiledWithHint(
                context, CommonConstants.strMemo, memoController),
            SizedBox(
              height: 15,
            ),
            containsAudio
                ? getAudioIconWithFile()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      getMicIcon(),
                      fhbBasicWidget.getSaveButton(() {
                        onPostDataToServer();
                      })
                    ],
                  ),
          ],
        )),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  Future<Widget> getDialogBoxForBPMonitor(
      BuildContext context, String deviceName) {
    if (fileName.text == '' || fileName.text == null) {
      setFileName();
    }
    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: fhbBasicWidget.getTextTextTitleWithPurpleColor(deviceName),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15,
            ),
            fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                context,
                CommonConstants.strSystolicPressure,
                CommonConstants.strSysPulseValue,
                deviceController, (errorValue) {
              setState(() {
                errForbpSp = errorValue;
              });
            }, errForbpSp, 'mmHg'),
            SizedBox(
              height: 15,
            ),
            fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                context,
                CommonConstants.strDiastolicPressure,
                CommonConstants.strPressureValue,
                diaStolicPressure, (errorValue) {
              setState(() {
                errFForbpDp = errorValue;
              });
            }, errFForbpDp, 'dp'),
            SizedBox(
              height: 15,
            ),
            fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                context,
                CommonConstants.strPulse,
                CommonConstants.strSysPulseValue,
                pulse, (errorValue) {
              setState(() {
                errForbpPulse = errorValue;
              });
            }, errForbpPulse, 'pulse'),
            SizedBox(
              height: 15,
            ),
            fhbBasicWidget.getTextFiledWithHint(
                context, CommonConstants.strMemo, memoController),
            SizedBox(
              height: 15,
            ),
            containsAudio
                ? getAudioIconWithFile()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      getMicIcon(),
                      fhbBasicWidget.getSaveButton(() {
                        onPostDataToServer();
                      })
                    ],
                  ),
          ],
        )),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  void initialData() {
    print('inside initilzeData');

    if (!firstTym) {
      categoryNameClone =
          PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
      firstTym = true;
    }

    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
    deviceName = PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME) == null
        ? Constants.IS_CATEGORYNAME_DEVICES
        : PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME);

    print('category name : ' + categoryName);
  }

  Widget getToggleButton() {
    return ToggleButtons(
      borderColor: Colors.black,
      fillColor: Colors.grey[100],
      borderWidth: 2,
      selectedBorderColor: Color(new CommonUtil().getMyPrimaryColor()),
      selectedColor: Color(new CommonUtil().getMyPrimaryColor()),
      borderRadius: BorderRadius.circular(10),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Before Food',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'After Food',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
      onPressed: (int index) => onToggleBUttonPressed(index),
      isSelected: isSelected,
    );
  }

  onToggleBUttonPressed(int index) async {
    setState(() {
      print('inside setState');
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = i == index;
      }
    });
  }

  Future<Widget> getDialogBoxForLabReport(BuildContext context) {
    if (fileName.text == '' || fileName.text == null) {
      setFileName();
    }
    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: fhbBasicWidget.getTextTextTitleWithPurpleColor(categoryName),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strLabName),
                    fhbBasicWidget
                        .getTextFieldForDialogWithControllerAndPressed(context,
                            (context, value) {
                      moveToSearchScreen(context, CommonConstants.keyLab);
                    }, labName, CommonConstants.keyLab),
                    SizedBox(
                      height: 15,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strDoctorsName),
                    fhbBasicWidget
                        .getTextFieldForDialogWithControllerAndPressed(context,
                            (context, value) {
                      moveToSearchScreen(context, CommonConstants.keyDoctor);
                    }, doctorsName, CommonConstants.keyDoctor),
                    SizedBox(
                      height: 15,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strFileName),
                    fhbBasicWidget.getTextFieldWithNoCallbacks(
                        context, fileName),
                    SizedBox(
                      height: 15,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strDateOfVisit),
                    Container(
                        width: MediaQuery.of(context).size.width - 60,
                        child: TextField(
                          autofocus: false,
                          onTap: () => _selectDate(context),
                          controller: dateOfVisit,
                          decoration: InputDecoration(
                              suffixIcon: new IconButton(
                            icon: new Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          )),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strMemo),
                    fhbBasicWidget.getTextFiledWithNoHInt(context),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            containsAudio
                ? getAudioIconWithFile()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      getMicIcon(),
                      fhbBasicWidget.getSaveButton(() {
                        onPostDataToServer();
                      })
                    ],
                  ),
          ],
        ),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  Future<Widget> getDialogBoxForBillsAndOthers(BuildContext context) {
    if (fileName.text == '' || fileName.text == null) {
      setFileName();
    }
    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: fhbBasicWidget.getTextTextTitleWithPurpleColor(categoryName),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15,
            ),
            fhbBasicWidget.getTextFiledWithHint(
                context, CommonConstants.strMemo, memoController),
            SizedBox(
              height: 15,
            ),
            containsAudio
                ? getAudioIconWithFile()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      getMicIcon(),
                      fhbBasicWidget.getSaveButton(() {
                        onPostDataToServer();
                      })
                    ],
                  ),
          ],
        )),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  Future<Widget> getDialogForIDDocs(BuildContext context) {
    if (fileName.text == '' || fileName.text == null) {
      setFileName();
    }
    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: fhbBasicWidget.getTextTextTitleWithPurpleColor(categoryName),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15,
            ),
            fhbBasicWidget.getTextFiledWithHint(
                context, CommonConstants.strMemo, memoController),
            SizedBox(
              height: 15,
            ),
            Container(
                width: MediaQuery.of(context).size.width - 60,
                child: TextField(
                  autofocus: false,
                  onTap: () => _selectDate(context),
                  controller: dateOfVisit,
                  decoration: InputDecoration(
                      suffixIcon: new IconButton(
                    icon: new Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  )),
                )),
            SizedBox(
              height: 15,
            ),
            new Center(
              child: new DropdownButton<String>(
                hint: new Text("Select ID Type"),
                value: selectedID,
                onChanged: (String newValue) {
                  setState(() {
                    selectedID = newValue;
                  });
                },
                items: documentList.map((String idType) {
                  return new DropdownMenuItem<String>(
                    value: idType,
                    child: new Text(
                      idType,
                      style: new TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            containsAudio
                ? getAudioIconWithFile()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      getMicIcon(),
                      fhbBasicWidget.getSaveButton(() {
                        onPostDataToServer();
                      })
                    ],
                  ),
          ],
        )),
      );
    });

    return showDialog(context: context, builder: (context) => dialog);
  }

  bool doValidationBeforePosting() {
    bool validationConditon = false;
    print('selectedID $selectedID');
    if (categoryName == Constants.STR_PRESCRIPTION ||
        categoryName == Constants.STR_MEDICALREPORT) {
      if (doctorsName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strDoctorsEmpty;
      } else if (fileName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strFileEmpty;
      } else {
        validationConditon = true;
      }
    } else if (categoryName == Constants.STR_LABREPORT) {
      if (labName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strLabEmpty;
      } else if (doctorsName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strDoctorsEmpty;
      } else if (fileName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strFileEmpty;
      } else {
        validationConditon = true;
      }
    } else if (categoryName == Constants.STR_BILLS ||
        categoryName == Constants.STR_OTHERS) {
      if (fileName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strFileEmpty;
      } else {
        validationConditon = true;
      }
    } else if (categoryName == Constants.STR_IDDOCS) {
      if (fileName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strFileEmpty;
      } else if (PreferenceUtil.getMediaData(Constants.KEY_MEDIADATA) == null) {
        validationConditon = false;
        validationMsg = CommonConstants.strIDEmpty;
      } else {
        validationConditon = true;
      }
    } else if (categoryName == Constants.STR_DEVICES) {
      if (deviceName == Constants.STR_GLUCOMETER) {
        if (fileName.text == '') {
          validationConditon = false;
          validationMsg = CommonConstants.strFileEmpty;
        } else if (deviceController.text == '' ||
            deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strSugarLevelEmpty;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == Constants.STR_BP_MONITOR) {
        if (fileName.text == '') {
          validationConditon = false;
          validationMsg = CommonConstants.strFileEmpty;
        } else if (deviceController.text == '' ||
            deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strSystolicsEmpty;
        } else if (diaStolicPressure.text == '' ||
            diaStolicPressure.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strDiastolicEmpty;
        } else if (pulse.text == '' || pulse.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strPulse;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == Constants.STR_THERMOMETER) {
        if (fileName.text == '') {
          validationConditon = false;
          validationMsg = CommonConstants.strFileEmpty;
        } else if (deviceController.text == '' ||
            deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strtemperatureEmpty;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == Constants.STR_WEIGHING_SCALE) {
        if (fileName.text == '') {
          validationConditon = false;
          validationMsg = CommonConstants.strFileEmpty;
        } else if (deviceController.text == '' ||
            deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strWeightEmpty;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == Constants.STR_PULSE_OXIMETER) {
        if (fileName.text == '') {
          validationConditon = false;
          validationMsg = CommonConstants.strFileEmpty;
        } else if (deviceController.text == '' ||
            deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strOxugenSaturationEmpty;
        } else if (pulse.text == '' || pulse.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strPulse;
        } else {
          validationConditon = true;
        }
      }
    }

    print('category Name' +
        categoryName +
        '  validationConditon' +
        validationConditon.toString());
    return validationConditon;
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

  Widget getMicIcon() {
    return GestureDetector(
      child: Container(
        height: 80,
        width: 80,
        padding: EdgeInsets.all(10),
        child: Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: CircleBorder(),
          child: CircleAvatar(
            //backgroundColor: Colors.transparent,
            backgroundColor: ColorUtils.greycolor,
            child: Icon(
              Icons.mic,
              size: 40,
              color: Colors.black,
            ),
            radius: 30.0,
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (context) => AudioRecordScreen(),
        ))
            .then((results) {
          if (results != null) {
            if (results.containsKey('audioFile')) {
              containsAudio = true;
              audioPath = results['audioFile'];
              print('Audio Path' + audioPath);

              setState(() {});
            }
          }
        });
      },
    );
  }

  Widget getAudioIconWithFile() {
    return Column(
      children: <Widget>[
        new AudioWidget(audioPath, (containsAudio, audioPath) {}),
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        fhbBasicWidget.getSaveButton(() {
          onPostDataToServer();
        })
      ],
    );
  }

  void deleteAudioFile() {
    print('inside delete');
    audioPath = '';
    containsAudio = false;
    setState(() {});
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
              height: MediaQuery.of(context).size.height,
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
              items: widget.imagePath.map((imgUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(),
                        child: Container(
                          height: double.infinity,
                          child: imgUrl.contains('pdf')
                              ? Image.asset('assets/icons/attach.png')
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
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: goToPrevious,
              ),
              Container(
                width: 50.0,
                height: 30.0,
                child: Text('$index /' + widget.imagePath.length.toString(),
                    style: TextStyle(color: Colors.white)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  //color: _current == index ? Colors.redAccent : Colors.green,
                ),
              ),
              IconButton(
                onPressed: goToNext,
                icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
              ),
            ],
          ),
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

  onPostDeviceImageData(String deviceName) {
    Map<String, dynamic> postMainData = new Map();
    Map<String, dynamic> postMediaData = new Map();
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    postMainData["userId"] = userID;

    postMediaData["categoryInfo"] = categoryDataObj.toJson();
    List<MediaData> metaDataFromSharedPrefernce = PreferenceUtil.getMediaType();

    if (categoryName != Constants.STR_DEVICES) {
      mediaDataObj = new CommonUtil().getMediaTypeInfoForParticularLabel(
          categoryID, metaDataFromSharedPrefernce, categoryName);
    } else {
      mediaDataObj = new CommonUtil().getMediaTypeInfoForParticularDevice(
          deviceName, metaDataFromSharedPrefernce);
    }

    postMediaData["mediaTypeInfo"] = mediaDataObj.toJson();

    //    postMediaData["dateOfVisit"] = dateOfVisit.text;
    postMediaData["memoText"] = '';
    postMediaData["hasVoiceNote"] = false;
    postMediaData["isDraft"] = false;

    postMediaData["sourceName"] = CommonConstants.strTridentValue;
    postMediaData["memoTextRaw"] = 'memoTextRaw';
    postMainData['metaInfo'] = postMediaData;

    var params = json.encode(postMainData);

    for (int i = 0; i < widget.imagePath.length; i++) {
      _healthReportListForUserBlock
          .saveDeviceImage(widget.imagePath[i], params.toString(), '')
          .then((postImageResponse) {
        _scaffoldKey.currentState.hideCurrentSnackBar();

        //print('post image response' + postImageResponse.message);
        //displayDevicesList(deviceName, null);

        if (skipTapped == false) {
          displayDevicesList(deviceName, postImageResponse);
        }
      });
    }
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
    setState(() {
      print('setState of home Screen');
    });
  }

  void _showOverlayCategoryDialog(BuildContext context) {
    Navigator.of(context).push(OverlayCategoryDialog()).then((value) {
      initializeData();
    });
  }

  /*  void initialData() {
    print('inside initilzeData');

    if (!firstTym) {
      categoryNameClone =
          PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
      firstTym = true;
    }
  } */

  void initializeData() {
    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
    categoryID = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYID);
    if (categoryNameClone == categoryName &&
        categoryName == Constants.STR_DEVICES) {
    } else if (categoryName == Constants.STR_DEVICES) {
      PreferenceUtil.saveString(Constants.stop_detecting, 'NO');

      Navigator.pushNamed(context, '/take_picture_screen_for_devices')
          .then((value) {
        Navigator.pop(context);
      });
    } else {
      setState(() {});
    }
  }
}

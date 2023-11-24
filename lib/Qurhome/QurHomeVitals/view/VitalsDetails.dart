
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/Qurhome/Common/GradientAppBarQurhome.dart';
import 'package:myfhb/Qurhome/QurHomeVitals/viewModel/VitalDetailController.dart';
import 'package:myfhb/common/CommonCircularQurHome.dart';
import 'package:myfhb/device_integration/model/BPValues.dart';
import 'package:myfhb/device_integration/model/DeleteDeviceHealthRecord.dart';
import 'package:myfhb/device_integration/model/GulcoseValues.dart';
import 'package:myfhb/device_integration/model/OxySaturationValues.dart';
import 'package:myfhb/device_integration/model/TemperatureValues.dart';
import 'package:myfhb/device_integration/model/WeightValues.dart';
import 'package:myfhb/src/model/Category/catergory_data_list.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/sheela_arguments.dart';
import 'package:myfhb/unit/choose_unit.dart';

import '../../../colors/fhb_colors.dart';
import '../../../common/CommonConstants.dart';
import '../../../common/CommonUtil.dart';
import '../../../common/FHBBasicWidget.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../common/customized_checkbox.dart';
import '../../../constants/fhb_constants.dart';
import '../../../constants/fhb_parameters.dart';
import '../../../constants/fhb_parameters.dart' as parameters;
import '../../../constants/router_variable.dart';
import '../../../constants/variable_constant.dart';
import '../../../constants/variable_constant.dart' as variable;
import '../../../src/blocs/Category/CategoryListBlock.dart';
import '../../../src/blocs/Media/MediaTypeBlock.dart';
import '../../../src/blocs/health/HealthReportListForUserBlock.dart';
import '../../../src/model/Category/catergory_result.dart';
import '../../../src/model/Media/media_data_list.dart';
import '../../../src/model/Media/media_result.dart';
import '../../../src/resources/repository/health/HealthReportListForUserRepository.dart';
import '../../../src/utils/FHBUtils.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import 'ButtonGroup.dart';
import '../../../constants/fhb_constants.dart' as Constants;

class VitalsDetails extends StatefulWidget {
  const VitalsDetails(
      {this.device_name,
      this.device_icon,
      this.sheelaRequestString,
      this.deviceNameForAdding});

  final String? device_name;
  final String? device_icon;
  final String? sheelaRequestString;
  final String? deviceNameForAdding;

  @override
  _VitalsDetailsState createState() => _VitalsDetailsState();
}

class _VitalsDetailsState extends State<VitalsDetails>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldMessengerState> scaffold_state = GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  String errorMsg = '', errorMsgDia = '', errorMsgSys = '';
  bool onOkClicked = false;
  String categoryName = STR_DEVICES;

  final CategoryListBlock _categoryListBlock = CategoryListBlock();
  List<CategoryResult> catgoryDataList = [];
  final MediaTypeBlock _mediaTypeBlock = MediaTypeBlock();
  MediaDataList? mediaTypesResponse = MediaDataList();

  CategoryResult categoryDataObj = CategoryResult();
  String categoryID = '14c3f2a1-70d3-49dd-a922-6bee255eed26';
  MediaResult mediaDataObj = MediaResult();

  TextEditingController deviceController = TextEditingController(text: '');
  TextEditingController pulse = TextEditingController(text: '');
  TextEditingController memoController = TextEditingController(text: '');
  TextEditingController diaStolicPressure = TextEditingController(text: '');

  List<bool?> isSelected = List.filled(3, null, growable: false);

  final HealthReportListForUserBlock _healthReportListForUserBlock =
      HealthReportListForUserBlock();

  List<String> imagePathMain = [];

  FlutterToast toast = FlutterToast();

  late String validationMsg;

  FHBBasicWidget fhbBasicWidget = FHBBasicWidget();
  var commonConstants = CommonConstants();
  final controllerGetx = Get.put(VitalDetailController());
  // var qurhomeDashboardController = Get.find<QurhomeDashboardController>();

  late AnimationController animationController;

  int _counter = 0;
  StreamController<int> _events = StreamController<int>();
  Timer? _timer;

  String? tempUnit = 'C';
  String? weightUnit = 'kg';

  //var qurhomeDashboardController = Get.find<QurhomeDashboardController>();

  @override
  void initState() {
    try {
      mInitialTime = DateTime.now();
      super.initState();
      _events.add(180);
      controllerGetx.deviceName = widget.device_name;
      controllerGetx.onTapFilterBtn(0);
      controllerGetx.checkForBleDevices();
      catgoryDataList = PreferenceUtil.getCategoryType()!;
      if (catgoryDataList == null || catgoryDataList == []) {
        _categoryListBlock.getCategoryLists().then((value) {
          catgoryDataList = value.result!;
        } as FutureOr Function(CategoryDataList?));
      }
      _mediaTypeBlock.getMediTypesList().then((value) {
        mediaTypesResponse = value;
      });
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      print(e);
    }

    try {
      weightUnit = PreferenceUtil.getStringValue(Constants.STR_KEY_WEIGHT);
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      weightUnit = "kg";
    }

    try {
      tempUnit = PreferenceUtil.getStringValue(Constants.STR_KEY_TEMP);
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      tempUnit = "F";
    }
  }

  void _startTimer() {
    try {
      _counter = 180;
      if (_timer != null) {
        _timer!.cancel();
      }
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!_events.isClosed) {
          (_counter > 0) ? _counter-- : _timer!.cancel();
          _events.add(_counter);
          notify();
        } else {
          timer.cancel();
        }
      });
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      print(e);
    }
  }

  // void initBleTimer() async {
  //   try {
  //     qurhomeDashboardController.checkForConnectedDevices(true);
  //   } catch (e,stackTrace) {
  //     print(e);
  //   }
  // }

  // void initBpScan() {
  //   qurhomeDashboardController.scanBpSessionStart(isFromVitals: true);
  // }

  void notify() {
    try {
      if (_counter == 0) {
        closeDialog();
        // if (!qurhomeDashboardController.foundBLE.value) {
        //   toast.getToast(NoDeviceFound, Colors.red);
        // }
      }
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      print(e);
    }
  }

  void closeDialog() {
    try {
      Timer(const Duration(milliseconds: 1000), () {
        if (animationController.isAnimating) {
          animationController.stop();
        }
      });
      _events.close();
      Navigator.pop(Get.context!);
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      print(e);
    }
  }

  Widget startProgressIndicator(String strText) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: CircularProgressIndicator(
            backgroundColor: Colors.grey.shade300,
            color: Color(
              CommonUtil().getQurhomeGredientColor(),
            ),
            value: controllerGetx.timerProgress.value,
            strokeWidth: 8,
          ),
        ),
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) => Text(
            "$strText",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  showSearchingBleDialog(BuildContext context) {
    try {
      animationController.reverse(
          from:
              animationController.value == 0 ? 1.0 : animationController.value);
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      print(e);
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return WillPopScope(
            onWillPop: () async => false,
            child: OrientationBuilder(builder: (context, orientation) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: StreamBuilder<int>(
                    stream: _events.stream,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      print(snapshot.data.toString());
                      return Container(
                          width: orientation == Orientation.landscape &&
                                  CommonUtil().isTablet!
                              ? 0.7.sw
                              : 1.sw,
                          height: orientation == Orientation.landscape &&
                                  CommonUtil().isTablet!
                              ? 1.sh / 2
                              : 1.sh / 2.7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        size: 30.0.sp,
                                      ),
                                      onPressed: () {
                                        try {
                                          _events.close();
                                          Navigator.pop(context);
                                        } catch (e,stackTrace) {
                                                CommonUtil().appLogs(message: e,stackTrace:stackTrace);

                                          print(e);
                                        }
                                      })
                                ],
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10.0.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            ScanningForDevices,
                                            style: TextStyle(
                                              color: Color(
                                                CommonUtil()
                                                    .getQurhomeGredientColor(),
                                              ),
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30.0.h,
                                      ),
                                      startProgressIndicator(
                                          snapshot.data.toString()),
                                      SizedBox(
                                        height: 15.0.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ));
                    }),
              );
            }),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    try {
      animationController.dispose();
      _events.close();
      super.dispose();
      fbaLog(eveName: 'qurbook_screen_event', eveParams: {
        'eventTime': '${DateTime.now()}',
        'pageName': 'Device Value Screen',
        'screenSessionTime':
            '${DateTime.now().difference(mInitialTime).inSeconds} secs'
      });
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold_state,
      appBar: AppBar(
        toolbarHeight: CommonUtil().isTablet! ? 110.00 : null,
        title: Text(
          getStringValue(),
          style: TextStyle(fontSize: CommonUtil().isTablet! ? 22.0.sp : 18.0.sp),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: CommonUtil().isTablet! ? 38.0 : 24.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          Image.asset(
            widget.device_icon!,
            height: CommonUtil().isTablet! ? 43.0.h : 45.0.h,
            width: CommonUtil().isTablet! ? 43.0.h : 45.0.h,
          ),
          SizedBoxWidget(
            width: CommonUtil().isTablet! ? 18.0.w : 15.0.w,
          )
        ],
        flexibleSpace: GradientAppBarQurhome(),
      ),
      body: Obx(() => Container(
            color: Colors.grey[200],
            child: Column(
              children: [
                /* SizedBoxWidget(height: 5.0.h),
            Container(child: getAddDeviceReadings()),*/
                SizedBoxWidget(height: 10.0.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ButtonGroup(
                      titles: [
                        filterTitleDay,
                        filterTitleWeek,
                        filterTitleMonth
                      ],
                      current: controllerGetx.filterBtnOnTap.value,
                      color: Colors.white,
                      secondaryColor:
                          Color(CommonUtil().getQurhomePrimaryColor()),
                      onTab: (selected) {
                        controllerGetx.onTapFilterBtn(selected);
                      },
                    ),
                  ],
                ),
                SizedBoxWidget(height: 14.0.h),
                controllerGetx.loadingData.isTrue
                    ? SafeArea(
                        child: SizedBox(
                          height: 1.sh / 1.4,
                          child: Container(
                              child: Center(
                            child: CommonCircularQurHome(),
                          )),
                        ),
                      )
                    : Expanded(
                        child: getValues(context)!,
                      ),
              ],
            ),
          )),
      floatingActionButton: IconButton(
        icon: Image.asset(icon_mayaMain),
        iconSize: CommonUtil().isTablet! ? 90 : 60,
        onPressed: () {
          Get.toNamed(
            rt_Sheela,
            arguments: SheelaArgument(
              sheelaInputs: widget.sheelaRequestString,
              isNeedTranslateText: true
            ),
          )!.then((value) {
            controllerGetx.onTapFilterBtn(0);
          });
          /* Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ChatScreen(
                  sheelaInputs: widget.sheelaRequestString,
                );
              },
            ),
          ).then((value) {
            setState(() {});
          }); */
        },
      ),
    );
  }

  /*Widget getAddDeviceReadings() {
    return Column(
      children: [
        getCardBasedOnDevices(widget.deviceNameForAdding),
        SizedBox(
          height: 20.0.h,
        ),
        Text(
          errorMsg,
          style: TextStyle(fontSize: 14.0.sp),
        ),
        SizedBoxWidget(height: 5.0.h),
        Container(
          child: Padding(
            padding:
            const EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 50,
                ),
                OutlinedButton(
                  onPressed: onOkClicked
                      ? () {}
                      : () async {
                    onOkClicked = true;

                    FHBUtils().check().then((intenet) {
                      if (intenet != null && intenet) {
                        createDeviceRecords(widget.deviceNameForAdding);
                      } else {
                        onOkClicked = false;
                        FHBBasicWidget().showInSnackBar(
                            STR_NO_CONNECTIVITY, scaffold_state);
                      }
                    });
                  } */ /*() {
                      FHBUtils().check().then((intenet) {
                        if (intenet != null && intenet) {
                          createDeviceRecords(deviceName);
                        } else {
                          FHBBasicWidget().showInSnackBar(
                              Constants.STR_NO_CONNECTIVITY, scaffold_state);
                        }
                      });
                    }*/ /*
                  ,
                  textColor: Color(CommonUtil().getMyPrimaryColor()),
                  color: Colors.transparent,
                  borderSide: BorderSide(
                      color: Color(CommonUtil().getMyPrimaryColor())),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text('OK'),
                ),
                //submitButton(_otpVerifyBloc)
                MaterialButton(
                  onPressed: () {
                    //matchOtp();
                  },
                  child: Text('',
                      style: TextStyle(
                          fontSize: 22.0.sp, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }*/

  void deleteDeviceRecord(String deviceId) async {
    var healthReportListForUserRepository = HealthReportListForUserRepository();

    DeleteDeviceHealthRecord deviceHealthRecord;

    final toast = FlutterToast();

    await healthReportListForUserRepository
        .deleteDeviceRecords(deviceId)
        .then((value) {
      deviceHealthRecord = value;
      if (deviceHealthRecord.isSuccess!) {
        toast.getToast('Deleted Successfully', Colors.green);
        // setState(() {});

      } else {
        toast.getToast('Unable to delete the record', Colors.red);
      }
    });
  }

  void createDeviceRecords(String deviceName) async {
    if (doValidation(deviceName)) {
      CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);

      final postMainData = Map<String, dynamic>();
      final postMediaData = Map<String, dynamic>();

      final userID = PreferenceUtil.getStringValue(KEY_USERID);
      try {
        catgoryDataList = PreferenceUtil.getCategoryType()!;
        categoryDataObj = CommonUtil()
            .getCategoryObjForSelectedLabel(categoryID, catgoryDataList);
        postMediaData[strhealthRecordCategory] = categoryDataObj.toJson();
      } catch (e,stackTrace) {
              CommonUtil().appLogs(message: e,stackTrace:stackTrace);

        if (catgoryDataList == null) {
          await _categoryListBlock.getCategoryLists().then((value) {
            catgoryDataList = value.result!;
            categoryDataObj = CommonUtil()
                .getCategoryObjForSelectedLabel(categoryID, catgoryDataList);
            postMediaData[strhealthRecordCategory] = categoryDataObj.toJson();
          } as FutureOr Function(CategoryDataList?));
        }
      }

      List<MediaResult>? metaDataFromSharedPrefernce = <MediaResult>[];
      if (mediaTypesResponse != null &&
          mediaTypesResponse!.result != null &&
          mediaTypesResponse!.result!.isNotEmpty) {
        metaDataFromSharedPrefernce = mediaTypesResponse!.result;
      } else {
        mediaTypesResponse = await _mediaTypeBlock.getMediTypesList();

        metaDataFromSharedPrefernce = mediaTypesResponse!.result;
      }
      mediaDataObj = CommonUtil().getMediaTypeInfoForParticularDevice(
          deviceName, metaDataFromSharedPrefernce!);

      postMediaData[parameters.strhealthRecordType] = mediaDataObj.toJson();

      postMediaData[parameters.strmemoText] = memoController.text;
      postMediaData[parameters.strhasVoiceNotes] = false;
      postMediaData[parameters.strisDraft] = false;

      postMediaData[parameters.strSourceName] = CommonConstants.strTridentValue;
      postMediaData[parameters.strmemoTextRaw] = memoController.text;
      var dateTime = DateTime.now();
      postMediaData[parameters.strStartDate] = dateTime.toUtc().toString();
      postMediaData[parameters.strEndDate] = dateTime.toUtc().toString();
      postMediaData[strlocalTime] = dateTime.toLocal().toString();
      final commonConstants = CommonConstants();

      if (categoryName == variable.strDevices) {
        final List<Map<String, dynamic>> postDeviceData = [];
        final Map<String, dynamic> postDeviceValues = {};
        final Map<String, dynamic> postDeviceValuesExtra = {};
        final Map<String, dynamic> postDeviceValuesExtraClone = {};

        if (deviceName == STR_GLUCOMETER) {
          postDeviceValues[parameters.strParameters] =
              CommonConstants.strSugarLevel;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] =
              CommonConstants.strGlucometerValue;
          postDeviceData.add(postDeviceValues);
          postDeviceValuesExtra[parameters.strParameters] =
              CommonConstants.strTimeIntake;
          postDeviceValuesExtra[parameters.strvalue] = '';
          if (isSelected[0] == true) {
            postDeviceValuesExtra[parameters.strunit] = variable.strBefore;
          } else if (isSelected[1] == true) {
            postDeviceValuesExtra[parameters.strunit] = variable.strAfter;
          } else {
            postDeviceValuesExtra[parameters.strunit] = '';
          }

          postDeviceData.add(postDeviceValuesExtra);
        } else if (deviceName == STR_THERMOMETER) {
          postDeviceValues[parameters.strParameters] =
              CommonConstants.strTemperature;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] = tempUnit;
          postDeviceData.add(postDeviceValues);
        } else if (deviceName == STR_WEIGHING_SCALE) {
          postDeviceValues[parameters.strParameters] =
              CommonConstants.strWeightParam;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] = weightUnit;
          postDeviceData.add(postDeviceValues);
        } else if (deviceName == STR_PULSE_OXIMETER) {
          postDeviceValues[parameters.strParameters] =
              CommonConstants.strOxygenParams;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] = CommonConstants.strOxygenUnits;
          postDeviceData.add(postDeviceValues);

          postDeviceValuesExtra[parameters.strParameters] =
              CommonConstants.strPulseRate;
          postDeviceValuesExtra[parameters.strvalue] = pulse.text;
          postDeviceValuesExtra[parameters.strunit] =
              CommonConstants.strPulseValue;

          postDeviceData.add(postDeviceValuesExtra);
        } else if (deviceName == STR_BP_MONITOR) {
          postDeviceValues[parameters.strParameters] =
              CommonConstants.strBPParams;
          postDeviceValues[parameters.strvalue] = deviceController.text;

          postDeviceValues[parameters.strunit] = CommonConstants.strBPUNits;
          postDeviceData.add(postDeviceValues);

          postDeviceValuesExtra[parameters.strParameters] =
              CommonConstants.strDiastolicParams;
          postDeviceValuesExtra[parameters.strvalue] = diaStolicPressure.text;
          postDeviceValuesExtra[parameters.strunit] =
              CommonConstants.strBPUNits;

          postDeviceData.add(postDeviceValuesExtra);

          postDeviceValuesExtraClone[parameters.strParameters] =
              CommonConstants.strPulseRate;
          postDeviceValuesExtraClone[parameters.strvalue] = pulse.text;
          postDeviceValuesExtraClone[parameters.strunit] =
              CommonConstants.strPulseUnit;

          postDeviceData.add(postDeviceValuesExtraClone);
        }
        postMediaData[parameters.strdeviceReadings] = postDeviceData;
        postMediaData[parameters.strfileName] =
            deviceName + '_${DateTime.now().toUtc().millisecondsSinceEpoch}';
        var dateTime = DateTime.now();

        postMediaData[parameters.strdateOfVisit] =
            FHBUtils().getFormattedDateOnly(dateTime.toString());

        postMainData[parameters.strmetaInfo] = postMediaData;

        final params = json.encode(postMediaData);

        await _healthReportListForUserBlock
            .createHealtRecords(params.toString(), imagePathMain, '')
            .then((value) {
          if (value != null && value.isSuccess!) {
            _healthReportListForUserBlock.getHelthReportLists().then((value) {
              /*Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();*/
              errorMsg = '';
              onOkClicked = false;

              PreferenceUtil.saveCompleteData(KEY_COMPLETE_DATA, value);
              Navigator.of(context).pop(true);

              setState(() {
                deviceController.text = '';
                pulse.text = '';
                diaStolicPressure.text = '';
                isSelected[0] = null;
                isSelected[1] = null;
                isSelected[2] = null;
              });
            });
          } else {
            errorMsg = '';
            onOkClicked = false;
            Navigator.of(context).pop(true);
            //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            toast.getToast(ERR_MSG_RECORD_CREATE, Colors.red);
          }
        });
      }
    } else {
      onOkClicked = false;

      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(variable.strAPP_NAME),
                content: Text(validationMsg),
              ));
    }
  }

  bool doValidation(String deviceName) {
    var validationConditon = false;
    if (categoryName == STR_DEVICES) {
      if (deviceName == STR_GLUCOMETER) {
        if (deviceController.text == '' || deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strSugarLevelEmpty;
        } else if (isSelected[0] == null &&
            isSelected[1] == null &&
            isSelected[2] == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strSugarFasting;
        } else if ((isSelected[0] == null &&
                isSelected[1] == false &&
                isSelected[2] == false) ||
            (isSelected[0] == false &&
                isSelected[1] == null &&
                isSelected[2] == null) ||
            (isSelected[0] == null &&
                isSelected[1] == false &&
                isSelected[2] == null) ||
            (isSelected[0] == false &&
                isSelected[1] == null &&
                isSelected[2] == false) ||
            (isSelected[0] == false &&
                isSelected[1] == false &&
                isSelected[2] == null) ||
            (isSelected[0] == false &&
                isSelected[1] == false &&
                isSelected[2] == false) ||
            (isSelected[0] == null &&
                isSelected[1] == null &&
                isSelected[2] == false)) {
          validationConditon = false;
          validationMsg = CommonConstants.strSugarFasting;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == STR_BP_MONITOR) {
        if (deviceController.text == '' || deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strSystolicsEmpty;
        } else if (diaStolicPressure.text == '' ||
            diaStolicPressure.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strDiastolicEmpty;
        } else if (pulse.text == '' || pulse.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strPulseEmpty;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == STR_THERMOMETER) {
        if (deviceController.text == '' || deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strtemperatureEmpty;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == STR_WEIGHING_SCALE) {
        if (deviceController.text == '' || deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strWeightEmpty;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == STR_PULSE_OXIMETER) {
        if (deviceController.text == '' || deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strOxugenSaturationEmpty;
        } else if (pulse.text == '' || pulse.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strPulseEmpty;
        } else {
          validationConditon = true;
        }
      }
    }

    return validationConditon;
  }

  Widget getCardBasedOnDevices(String deviceName) {
    switch (deviceName) {
      case CommonConstants.STR_BP_MONITOR:
        return getCardForBPMonitor(deviceName);
        break;
      case CommonConstants.STR_THERMOMETER:
        return getCardForThermometer(deviceName);
        break;
      case CommonConstants.STR_PULSE_OXIDOMETER:
        return getCardForPulseOxidometer(deviceName);
        break;
      case CommonConstants.STR_WEIGHING_SCALE:
        return getCardForWeighingScale(deviceName);
        break;
      case CommonConstants.STR_GLUCOMETER:
        return getCardForGlucometer(deviceName);
        break;
      default:
        return getCardForBPMonitor(deviceName);
        break;
    }
  }

  Widget getCardForBPMonitor(String deviceName) {
    return Container(
        //height: 70.0.h,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(cardShadowColor),
              blurRadius: 16, // has the effect of extending the shadow
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Image.asset(
                      Devices_BP,
                      height: 30.0.h,
                      width: 30.0.h,
                      color: Color(CommonConstants.bpDarkColor),
                    ),
                    Text(
                      CommonConstants.STR_BP_MONITOR,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0.sp,
                          color: Color(CommonConstants.bpDarkColor)),
                      softWrap: true,
                    ),
                  ],
                ),
                SizedBox(
                  width: 5.0.w,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 15.0.w,
                      ),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Sys',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0.sp,
                                      color:
                                          Color(CommonConstants.bplightColor)),
                                  softWrap: true,
                                ),
                                /*Container(
                                  child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
                                      textAlign: TextAlign.center,
                                      controller: deviceController,
                                      style: TextStyle(
                                          fontSize: 15.0.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color(
                                              CommonConstants.bpDarkColor)),
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(CommonConstants
                                                    .bpDarkColor),
                                                width: 0.5),
                                          ),
                                          hintText: '0',
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 15.0.sp),
                                          contentPadding: EdgeInsets.zero),
                                      cursorColor:
                                          Color(CommonConstants.bpDarkColor),
                                      keyboardType: TextInputType.number,
                                      cursorWidth: 0.5,
                                      onSaved: (input) => setState(() {})),
                                )*/
                                fhbBasicWidget.getErrorMsgForUnitEntered(
                                    context,
                                    CommonConstants.strSystolicPressure,
                                    commonConstants.bpDPUNIT,
                                    deviceController, (errorValue) {
                                  setState(() {
                                    errorMsgSys = errorValue;
                                    errorMsg = errorMsgSys;
                                  });
                                }, errorMsgSys, variable.strbpunit, deviceName,
                                    range: "Sys")
                              ],
                            ),
                          )),
                      Expanded(
                          child: Column(
                        children: <Widget>[
                          Text(
                            'Dia',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0.sp,
                                color: Color(CommonConstants.bplightColor)),
                            softWrap: true,
                          ),
                          /*Container(
                                constraints: BoxConstraints(maxWidth: 100),
                                child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
                                    controller: diaStolicPressure,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15.0.sp,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Color(CommonConstants.bpDarkColor)),
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 0.5),
                                        ),
                                        hintText: '0',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 15.0.sp),
                                        contentPadding: EdgeInsets.zero),
                                    cursorColor:
                                        Color(CommonConstants.bpDarkColor),
                                    keyboardType: TextInputType.number,
                                    cursorWidth: 0.5,
                                    onSaved: (input) => setState(() {})),
                              ),*/
                          fhbBasicWidget.getErrorMsgForUnitEntered(
                              context,
                              CommonConstants.strDiastolicPressure,
                              commonConstants.bpDPUNIT,
                              diaStolicPressure, (errorValue) {
                            setState(() {
                              errorMsgDia = errorValue;
                              errorMsg = errorMsgDia;
                            });
                          }, errorMsgDia, variable.strbpunit, deviceName,
                              range: "Dia")
                        ],
                      )),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Pul',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0.sp,
                                      color:
                                          Color(CommonConstants.bplightColor)),
                                  softWrap: true,
                                ),
                                /*Container(
                                  constraints: BoxConstraints(maxWidth: 100),
                                  child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
                                      textAlign: TextAlign.center,
                                      controller: pulse,
                                      style: TextStyle(
                                          fontSize: 15.0.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color(
                                              CommonConstants.bpDarkColor)),
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(CommonConstants
                                                    .bpDarkColor),
                                                width: 0.5),
                                          ),
                                          hintText: '0',
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 15.0.sp),
                                          contentPadding: EdgeInsets.zero),
                                      cursorColor:
                                          Color(CommonConstants.bpDarkColor),
                                      keyboardType: TextInputType.number,
                                      cursorWidth: 0.5,
                                      onSaved: (input) => setState(() {})),
                                ),*/
                                fhbBasicWidget.getErrorMsgForUnitEntered(
                                    context,
                                    CommonConstants.strPulse,
                                    commonConstants.bpPulseUNIT,
                                    pulse, (errorValue) {
                                  setState(() {
                                    errorMsg = errorValue;
                                  });
                                }, errorMsg, variable.strpulse, deviceName,
                                    range: ""),
                              ],
                            ),
                          )),
                      SizedBox(
                        width: 15.0.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget getCardForThermometer(String deviceName) {
    try {
      tempUnit = PreferenceUtil.getStringValue(Constants.STR_KEY_TEMP);
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      tempUnit = "F";
    }
    return Container(
        //height: 70.0.h,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(cardShadowColor),
              blurRadius: 16, // has the effect of extending the shadow
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    Devices_THM,
                    height: 40.0.h,
                    width: 40.0.h,
                    color: Color(CommonConstants.ThermoDarkColor),
                  ),
                  Text(
                    CommonConstants.STR_THERMOMETER,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0.sp,
                        color: Color(CommonConstants.ThermoDarkColor)),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5.0.w,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: <Widget>[
                      Text(
                        'Temp',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0.sp,
                            color: Color(CommonConstants.ThermolightColor)),
                        softWrap: true,
                      ),
                      /*Container(
                        width: 50,
                        constraints: BoxConstraints(maxWidth: 100),
                        child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
                            controller: deviceController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15.0.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(CommonConstants.ThermoDarkColor)),
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(
                                          CommonConstants.ThermoDarkColor),
                                      width: 0.5),
                                ),
                                hintText: '0',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 15.0.sp),
                                contentPadding: EdgeInsets.zero),
                            cursorColor: Color(CommonConstants.ThermoDarkColor),
                            keyboardType: TextInputType.number,
                            cursorWidth: 0.5,
                            onSaved: (input) => setState(() {})),
                      )*/
                      fhbBasicWidget.getErrorMsgForUnitEntered(
                          context,
                          CommonConstants.strTemperature,
                          tempUnit,
                          deviceController, (errorValue) {
                        setState(() {
                          errorMsg = errorValue;
                        });
                      }, errorMsg, tempUnit, deviceName,
                          range: "", device: "Temp")
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        '',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0.sp,
                            color:
                                Color(CommonUtil().getQurhomePrimaryColor())),
                        softWrap: true,
                      ),
                      Container(
                        width: 50.0.w,
                        constraints: BoxConstraints(maxWidth: 100.0.w),
                        child: InkWell(
                          child: Text(
                            tempUnit != null ? tempUnit! : 'c',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0.sp,
                                color: Color(CommonConstants.ThermoDarkColor)),
                            softWrap: true,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => ChooseUnit(),
                              ),
                            ).then(
                              (value) {
                                tempUnit = PreferenceUtil.getStringValue(
                                    Constants.STR_KEY_TEMP);
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget getCardForPulseOxidometer(String deviceName) {
    return Container(
        //height: 70.0.h,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(cardShadowColor),
              blurRadius: 16, // has the effect of extending the shadow
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Image.asset(
                    Devices_OxY,
                    height: 30.0.h,
                    width: 30.0.h,
                    color: Color(CommonConstants.pulseDarkColor),
                  ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  Text(
                    deviceName,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0.sp,
                        color: Color(CommonConstants.pulseDarkColor)),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5.0.w,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Text(
                        'SpO2',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0.sp,
                            color: Color(CommonConstants.pulselightColor)),
                        softWrap: true,
                      ),
                      fhbBasicWidget.getErrorMsgForUnitEntered(
                          context,
                          CommonConstants.strOxygenSaturation,
                          commonConstants.poOxySatUNIT,
                          deviceController, (errorValue) {
                        setState(() {
                          errorMsg = errorValue;
                        });
                      }, errorMsg, variable.strpulseUnit, deviceName,
                          range: ""),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Text(
                        'PR bpm',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0.sp,
                            color: Color(CommonConstants.pulselightColor)),
                        softWrap: true,
                      ),
                      /* Container(
                            width: 50,
                            constraints: BoxConstraints(maxWidth: 100),
                            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
                                controller: pulse,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15.0.sp,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Color(CommonConstants.pulseDarkColor)),
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(
                                              CommonConstants.pulseDarkColor),
                                          width: 0.5),
                                    ),
                                    hintText: '0',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 15.0.sp),
                                    contentPadding: EdgeInsets.zero),
                                cursorColor:
                                    Color(CommonConstants.pulseDarkColor),
                                keyboardType: TextInputType.number,
                                cursorWidth: 0.5,
                                onSaved: (input) => setState(() {})),
                          ),*/
                      fhbBasicWidget.getErrorMsgForUnitEntered(
                          context,
                          CommonConstants.strPulse,
                          commonConstants.poPulseUNIT,
                          pulse, (errorValue) {
                        setState(() {
                          errorMsg = errorValue;
                        });
                      }, errorMsg, variable.strpulse, deviceName, range: ""),
                    ],
                  ))
                ],
              ),
            ),
          ],
        ));
  }

  Widget getCardForWeighingScale(String deviceName) {
    try {
      weightUnit = PreferenceUtil.getStringValue(Constants.STR_KEY_WEIGHT);
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      weightUnit = "kg";
    }
    return Container(
        //height: 70.0.h,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(cardShadowColor),
              blurRadius: 16, // has the effect of extending the shadow
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    Devices_WS,
                    height: 30.0.h,
                    width: 30.0.h,
                    color: Color(CommonConstants.weightDarkColor),
                  ),
                  Text(
                    CommonConstants.STR_WEIGHING_SCALE,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0.sp,
                        color: Color(CommonConstants.weightDarkColor)),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5.0.w,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: <Widget>[
                      Text(
                        weightUnit != null ? weightUnit! : 'kg',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0.sp,
                            color: Color(CommonConstants.weightlightColor)),
                        softWrap: true,
                      ),
                      fhbBasicWidget.getErrorMsgForUnitEntered(
                          context,
                          CommonConstants.strWeight,
                          weightUnit,
                          deviceController, (errorValue) {
                        setState(() {
                          errorMsg = errorValue;
                        });
                      }, errorMsg, weightUnit, deviceName),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget getCardForGlucometer(String deviceName) {
    return Container(
        //height: 70.0.h,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(cardShadowColor),
              blurRadius: 16, // has the effect of extending the shadow
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Image.asset(
                    Devices_GL,
                    height: 40.0.h,
                    width: 40.0.h,
                    color: Color(CommonConstants.GlucoDarkColor),
                  ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  Text(
                    deviceName,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0.sp,
                        color: Color(CommonConstants.GlucoDarkColor)),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5.0.w,
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text(
                      'mg/dL',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0.sp,
                          color: Color(CommonConstants.GlucolightColor)),
                      softWrap: true,
                    ),
                    fhbBasicWidget.getErrorMsgForUnitEntered(
                        context,
                        CommonConstants.strValue,
                        commonConstants.glucometerUNIT,
                        deviceController, (errorValue) {
                      setState(() {
                        errorMsg = errorValue;
                      });
                    }, errorMsg, variable.strGlucUnit, deviceName,
                        range: ((isSelected[0] == null &&
                                    isSelected[1] == false) ||
                                (isSelected[0] == false &&
                                    isSelected[1] == null) ||
                                (isSelected[0] == null &&
                                    isSelected[1] == null))
                            ? 'Random'
                            : isSelected[0] == true
                                ? 'Fast'
                                : 'PP')
                  ],
                )),
            SizedBox(
              width: 5.0.w,
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Text(
                        'Fasting',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0.sp,
                            color: Colors.grey),
                        softWrap: true,
                      ),
                      Container(
                          width: 50.0.w,
                          constraints: BoxConstraints(maxWidth: 100.0.w),
                          child: MyCheckbox(
                              value: isSelected[0],
                              onChanged: (value) {
                                setState(() {
                                  isSelected[0] = value;
                                  isSelected[1] = null;
                                  isSelected[2] = null;
                                });
                              })),
                    ],
                  )),
                  SizedBox(
                    width: 5.0.w,
                  ),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Text(
                        'PP',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0.sp,
                            color: Colors.grey),
                        softWrap: true,
                      ),
                      Container(
                          width: 50.0.w,
                          constraints: BoxConstraints(maxWidth: 100.0.w),
                          child: MyCheckbox(
                              value: isSelected[1],
                              onChanged: (value) {
                                setState(() {
                                  isSelected[1] = value;
                                  isSelected[0] = null;
                                  isSelected[2] = null;
                                });
                              })),
                    ],
                  )),
                  SizedBox(
                    width: 5.0.w,
                  ),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Text(
                        'Random',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0.sp,
                            color: Colors.grey),
                        softWrap: true,
                      ),
                      Container(
                          width: 50.0.w,
                          constraints: BoxConstraints(maxWidth: 100.0.w),
                          child: MyCheckbox(
                              value: isSelected[2],
                              onChanged: (value) {
                                setState(() {
                                  isSelected[2] = value;
                                  isSelected[0] = null;
                                  isSelected[1] = null;
                                });
                              })),
                    ],
                  ))
                ],
              ),
            ),
          ],
        ));
  }

  String getFormattedDateTime(String datetime) {
    final dateTimeStamp = DateTime.parse(datetime).toLocal();
    final formattedDate = DateFormat('d MMM yyyy').format(dateTimeStamp);
    return formattedDate;
  }

  String getFormattedTime(String datetime) {
    var dateTimeStamp = DateTime.parse(datetime).toLocal();
    var formattedDate = DateFormat('h:mm a').format(dateTimeStamp);
    return formattedDate;
  }

  Widget? getValues(BuildContext context) {
    final todayDate = getFormattedDateTime(DateTime.now().toString());
    switch (widget.device_name) {
      case strDataTypeBP:
        {
          final translis = controllerGetx.bpList.value;
          //List<WVResult> translist = translis.first;
          final List<BPResult> bpResultNew =
              translis.isNotEmpty ? translis.first : [];
          bpResultNew.sort((translisCopy, translisClone) {
            return translisClone.dateTimeValue!
                .compareTo(translisCopy.dateTimeValue!);
          });
          final bpResult = bpResultNew;
          //final List<DeviceIntervalData> deviceFullList = translis?.last;
          return bpResult.isNotEmpty
              ? GroupedListView<BPResult, String>(
                  groupBy: (element) =>
                      getFormattedDateTime(element.startDateTime!),
                  elements: bpResult,
                  sort: false,
                  groupSeparatorBuilder: (value) => Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      children: [
                        SizedBoxWidget(width: 15.0.w),
                        Text(
                          todayDate != value ? value : 'Today, ' + value,
                          style: TextStyle(
                              fontSize: 14.0.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  indexedItemBuilder: (context, i, index) {
                    return buildRowForBp(
                        bpResult[index].sourceType,
                        getFormattedDateTime(bpResult[index].startDateTime!),
                        '${bpResult[index].systolic}',
                        '${bpResult[index].diastolic}',
                        '',
                        'Systolic',
                        'Diastolic',
                        '',
                        getFormattedTime(bpResult[index].startDateTime!),
                        bpResult[index].bpm != null
                            ? bpResult[index].bpm.toString()
                            : '',
                        bpResult[index].deviceId);
                  },
                )
              : Container(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Text(
                        'No health record details available.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: variable.font_roboto),
                      ),
                    ),
                  ),
                );
        }
        break;
      case strGlusoceLevel:
        {
          var translis = controllerGetx.gulList.value;
          //List<WVResult> translist = translis.first;
          final List<GVResult> translistNew =
              translis.isNotEmpty ? translis.first : [];
          translistNew.sort((translisCopy, translisClone) {
            return translisClone.dateTimeValue!
                .compareTo(translisCopy.dateTimeValue!);
          });
          final translist = translistNew;
          //final List<DeviceIntervalData> deviceFullList = translis?.last;
          return translist.isNotEmpty
              ? GroupedListView<GVResult, String>(
                  groupBy: (element) =>
                      getFormattedDateTime(element.startDateTime!),
                  elements: translist,
                  sort: false,
                  groupSeparatorBuilder: (value) => Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      children: [
                        SizedBoxWidget(width: 15.0.w),
                        Text(
                          todayDate != value ? value : 'Today, ' + value,
                          style: TextStyle(
                              fontSize: 14.0.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  indexedItemBuilder: (context, i, index) {
                    return buildRowForGulcose(
                        translist[index].sourceType,
                        getFormattedDateTime(translist[index].startDateTime!),
                        '${translist[index].bloodGlucoseLevel}',
                        translist[index].mealContext == null ||
                                translist[index].mealContext == ''
                            ? 'Random'
                            : translist[index].mealContext,
                        '',
                        'Blood Glucose',
                        'Meal Type',
                        '',
                        getFormattedTime(translist[index].startDateTime!),
                        translist[index].bgUnit,
                        translist[index].deviceId);
                  },
                )
              : Container(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Text(
                        'No health record details available.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: variable.font_roboto),
                      ),
                    ),
                  ),
                );
        }
        break;
      case strOxgenSaturation:
        {
          var translis = controllerGetx.oxyList.value;
          //List<WVResult> translist = translis.first;
          final List<OxyResult> translistNew =
              translis.isNotEmpty ? translis.first : [];
          translistNew.sort((translisCopy, translisClone) {
            return translisClone.dateTimeValue!
                .compareTo(translisCopy.dateTimeValue!);
          });
          var translist = translistNew;
          // final List<DeviceIntervalData> deviceFullList = translis.last;
          return translist.isNotEmpty
              ? GroupedListView<OxyResult, String>(
                  groupBy: (element) =>
                      getFormattedDateTime(element.startDateTime!),
                  elements: translist,
                  sort: false,
                  groupSeparatorBuilder: (value) => Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      children: [
                        SizedBoxWidget(width: 15.0.w),
                        Text(
                          todayDate != value ? value : 'Today, ' + value,
                          style: TextStyle(
                              fontSize: 14.0.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  indexedItemBuilder: (context, i, index) {
                    return buildRowForOxygen(
                        translist[index].sourceType,
                        getFormattedDateTime(translist[index].startDateTime!),
                        '${translist[index].oxygenSaturation}',
                        '',
                        '',
                        'SpO2',
                        '',
                        '',
                        getFormattedTime(translist[index].startDateTime!),
                        '',
                        translist[index].bpm,
                        translist[index].deviceId);
                  },
                )
              : Container(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Text(
                        'No health record details available.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: variable.font_roboto),
                      ),
                    ),
                  ),
                );
        }
        break;
      case strWeight:
        {
          var translis = controllerGetx.weightList.value;
          //List<WVResult> translist = translis.first;
          final List<WVResult> translistNew =
              translis.isNotEmpty ? translis.first : [];
          translistNew.sort((translisCopy, translisClone) {
            return translisClone.dateTimeValue!
                .compareTo(translisCopy.dateTimeValue!);
          });
          var translist = translistNew;
          //final List<DeviceIntervalData> deviceFullList = translis?.last;
          return translist.isNotEmpty
              ? GroupedListView<WVResult, String>(
                  groupBy: (element) =>
                      getFormattedDateTime(element.startDateTime!),
                  elements: translist,
                  sort: false,
                  groupSeparatorBuilder: (value) => Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      children: [
                        SizedBoxWidget(width: 15.0.w),
                        Text(
                          todayDate != value ? value : 'Today, ' + value,
                          style: TextStyle(
                              fontSize: 14.0.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  indexedItemBuilder: (context, i, index) {
                    return buildRowForTempWeight(
                        translist[index].sourceType,
                        getFormattedDateTime(translist[index].startDateTime!),
                        translist[index].weight,
                        '',
                        '',
                        'Weight',
                        '',
                        '',
                        getFormattedTime(translist[index].startDateTime!),
                        weightUnit,
                        translist[index].deviceId);
                  },
                )
              : Container(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Text(
                        'No health record details available.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: variable.font_roboto),
                      ),
                    ),
                  ),
                );
        }
        break;
      case strTemperature:
        {
          var translis = controllerGetx.tempList.value;
          //List<WVResult> translist = translis.first;
          final List<TMPResult> translistNew = translis.isNotEmpty
              ? translis.isNotEmpty
                  ? translis.first
                  : []
              : [];
          translistNew.sort((translisCopy, translisClone) {
            return translisClone.dateTimeValue!
                .compareTo(translisCopy.dateTimeValue!);
          });
          var translist = translistNew;
          //final List<DeviceIntervalData> deviceFullList = translis?.last;
          return translist.isNotEmpty
              ? GroupedListView<TMPResult, String>(
                  groupBy: (element) =>
                      getFormattedDateTime(element.startDateTime!),
                  elements: translist,
                  sort: false,
                  groupSeparatorBuilder: (value) => Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      children: [
                        SizedBoxWidget(width: 15.0.w),
                        Text(
                          todayDate != value ? value : 'Today, ' + value,
                          style: TextStyle(
                              fontSize: 14.0.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  indexedItemBuilder: (context, i, index) {
                    return buildRowForTempWeight(
                        translist[index].sourceType,
                        getFormattedDateTime(translist[index].startDateTime!),
                        translist[index].temperature,
                        '',
                        '',
                        'Temperature',
                        '',
                        '',
                        getFormattedTime(translist[index].startDateTime!),
                        tempUnit,
                        translist[index].deviceId);
                  },
                )
              : Container(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Text(
                        'No health record details available.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: variable.font_roboto),
                      ),
                    ),
                  ),
                );
        }
        break;
      default:
        {
          //statements;
        }
        break;
    }
  }

  getStringValue() {
    switch (widget.device_name) {
      case strDataTypeBP:
        {
          return strBPTitle;
        }
        break;
      case strGlusoceLevel:
        {
          return strGLTitle;
        }
        break;
      case strOxgenSaturation:
        {
          return strOxyTitle;
        }
        break;
      case strWeight:
        {
          return strWgTitle;
        }
        break;
      case strTemperature:
        {
          return strTmpTitle;
        }
        break;
      default:
        {
          //statements;
        }
        break;
    }
  }

  Widget buildRowForBp(
      String? type,
      String date,
      String value1,
      String value2,
      String value3,
      String valuename1,
      String valuename2,
      String valuename3,
      String time,
      String bpm,
      String? deviceId) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        height: 60.0.h,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0.w,
                ),
                Column(
                  children: [
                    Center(
                      child: Text(time,
                          style:
                              TextStyle(color: Colors.grey, fontSize: 11.0.sp)),
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    if (type == null)
                      Icon(Icons.device_unknown)
                    else
                      TypeIcon(type),
                  ],
                ),
                SizedBox(
                  width: 10.0.w,
                ),
                valuename1 != ''
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 5.0.h),
                            Text(
                              valuename1,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 13.0.sp),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5.0.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  value1 == '' ? '' : value1,
                                  style: TextStyle(
                                      color: Color(CommonUtil()
                                          .getQurhomePrimaryColor()),
                                      fontSize: 15.0.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBoxWidget(
                                  width: 2.0.w,
                                ),
                                Text(
                                  value1 == '' ? '' : 'mmHg',
                                  style: TextStyle(
                                      color: Color(CommonUtil()
                                          .getQurhomePrimaryColor()),
                                      fontSize: 11.0.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                valuename2 != ''
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 5.0.h),
                            Text(
                              valuename2 == '' ? '' : valuename2,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 13.0.sp),
                            ),
                            SizedBox(
                              height: 5.0.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  value2,
                                  style: TextStyle(
                                      color: Color(CommonUtil()
                                          .getQurhomePrimaryColor()),
                                      fontSize: 15.0.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBoxWidget(
                                  width: 2,
                                ),
                                Text(
                                  value1 == '' ? '' : 'mmHg',
                                  style: TextStyle(
                                      color: Color(CommonUtil()
                                          .getQurhomePrimaryColor()),
                                      fontSize: 11.0.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                bpm != ''
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 5.0.h),
                            Text(
                              'Pulse',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 13.0.sp),
                            ),
                            SizedBox(
                              height: 5.0.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  bpm != '' ? bpm : '',
                                  style: TextStyle(
                                      color: Color(CommonUtil()
                                          .getQurhomePrimaryColor()),
                                      fontSize: 15.0.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBoxWidget(
                                  width: 2,
                                ),
                                Text(
                                  bpm == '' ? '' : CommonConstants.strPulseUnit,
                                  style: TextStyle(
                                      color: Color(CommonUtil()
                                          .getQurhomePrimaryColor()),
                                      fontSize: 11.0.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                /*getDeleteIcon(deviceId, type),
                SizedBoxWidget(width: 10)*/
                /*Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                  ],
                ),
              )*/
                /*valuename3 != ''
                  ? Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 5.0.h),
                          Text(
                            valuename3 == '' ? '' : valuename3,
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            height: 5.0.h,
                          ),
                          Text(
                            value3,
                            style: TextStyle(
                                color: Colors.lightBlueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),*/
                /*Expanded(
                  flex: 4,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          date,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )),*/
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getDeleteIcon(String deviceId, String type) {
    if (type == strsourceHK ||
        type == strsourceGoogle ||
        type == strsourceCARGIVER) {
      return SizedBox();
    } else {
      return GestureDetector(
        onTap: () {
          deleteDeviceRecord(deviceId);
        },
        child: Image.asset(
          'assets/icons/delete_icon.png',
          height: 16.0.h,
          width: 16.0.h,
        ),
      );
    }
  }

  Widget buildRowForGulcose(
      String? type,
      String date,
      String value1,
      String? value2,
      String value3,
      String valuename1,
      String valuename2,
      String valuename3,
      String time,
      String? unit,
      String? deviceId) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        height: 60.0.h,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    children: [
                      Center(
                        child: Text(time,
                            style: TextStyle(
                                color: Colors.grey, fontSize: 11.0.sp)),
                      ),
                      SizedBox(
                        height: 2.0.h,
                      ),
                      if (type == null)
                        Icon(Icons.device_unknown)
                      else
                        TypeIcon(type),
                    ],
                  ),
                  SizedBox(
                    width: 110.0.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getMealText(value2),
                        style:
                            TextStyle(color: Colors.black, fontSize: 13.0.sp),
                      ),
                      SizedBox(
                        height: 5.0.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            value1 == '' ? '' : value1,
                            style: TextStyle(
                                color: Color(
                                    CommonUtil().getQurhomePrimaryColor()),
                                fontSize: 15.0.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBoxWidget(
                            width: 2,
                          ),
                          Text(
                            value1 == '' ? '' : unit!,
                            style: TextStyle(
                                color: Color(
                                    CommonUtil().getQurhomePrimaryColor()),
                                fontSize: 11.0.sp),
                          ),
                        ],
                      )
                    ],
                  ),
                  /*SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        getDeleteIcon(deviceId, type),
                        SizedBoxWidget(width: 10)
                      ],
                    ),
                  ),*/
                  /*Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valuename2 == '' ? '' : valuename2,
                      style: TextStyle(color: Colors.black, fontSize: 13.0.sp),
                    ),
                    SizedBox(
                      height: 5.0.h,
                    ),
                    Text(
                      value2,
                      style: TextStyle(
                          color: Color(CommonUtil().getQurhomePrimaryColor()),
                          fontSize: 14.0.sp),
                    ),
                  ],
                ),
                SizedBox(
                  width: 18.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valuename3 == '' ? '' : valuename3,
                      style: TextStyle(color: Colors.black, fontSize: 13.0.sp),
                    ),
                    SizedBox(
                      height: 5.0.h,
                    ),
                    Text(
                      value3,
                      style: TextStyle(
                          color: Color(CommonUtil().getQurhomePrimaryColor()),
                          fontSize: 14.0.sp),
                    ),
                  ],
                ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getMealText(String? mealText) {
    if (mealText != null) {
      if (mealText == 'After Meal') {
        mealText = 'PP';
      } else if (mealText == 'Before Meal') {
        mealText = 'Fasting';
      } else if (mealText == 'Random') {
        mealText = 'Random';
      } else {
        mealText = '';
      }
    } else {
      mealText = '';
    }
    return mealText;
  }

  Widget buildRowForTempWeight(
      String? type,
      String date,
      String? value1,
      String value2,
      String value3,
      String valuename1,
      String valuename2,
      String valuename3,
      String time,
      String? unit,
      String? deviceId) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        height: 60.0.h,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Column(
                  children: [
                    /*Container(
                    width: 42.0.w,
                    height: 14.0.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              Color(CommonUtil().getMyPrimaryColor()),
                              Color(CommonUtil().getMyGredientColor())
                            ],
                            stops: [
                              0.3,
                              1.0
                            ])),
                    child: Center(
                      child: Text(time,
                          style: TextStyle(color: Colors.white, fontSize: 11.0.sp)),
                    ),
                  ),*/
                    Center(
                      child: Text(time,
                          style:
                              TextStyle(color: Colors.grey, fontSize: 11.0.sp)),
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    if (type == null)
                      Icon(Icons.device_unknown)
                    else
                      TypeIcon(type),
                  ],
                ),
                valuename1 != ''
                    ? Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 5.0.h),
                            Column(
                              children: [
                                Text(
                                  valuename1,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13.0.sp),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      value1 == '' ? '' : value1!,
                                      style: TextStyle(
                                          color: Color(CommonUtil()
                                              .getQurhomePrimaryColor()),
                                          fontSize: 15.0.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBoxWidget(
                                      width: 2,
                                    ),
                                    Text(
                                      unit ?? '',
                                      style: TextStyle(
                                          color: Color(CommonUtil()
                                              .getQurhomePrimaryColor()),
                                          fontSize: 14.0.sp),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBoxWidget(),
                /* getDeleteIcon(deviceId, type),
                SizedBoxWidget(width: 10)*/
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRowForOxygen(
      String? type,
      String date,
      String value1,
      String value2,
      String value3,
      String valuename1,
      String valuename2,
      String valuename3,
      String time,
      String unit,
      String? bpm,
      String? deviceId) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        height: 60.0.h,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Column(
                  children: [
                    /*Container(
                    width: 42.0.w,
                    height: 14.0.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              Color(CommonUtil().getMyPrimaryColor()),
                              Color(CommonUtil().getMyGredientColor())
                            ],
                            stops: [
                              0.3,
                              1.0
                            ])),
                    child: Center(
                      child: Text(time,
                          style: TextStyle(color: Colors.white, fontSize: 11.0.sp)),
                    ),
                  ),*/
                    Center(
                      child: Text(time,
                          style:
                              TextStyle(color: Colors.grey, fontSize: 11.0.sp)),
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    if (type == null)
                      Icon(Icons.device_unknown)
                    else
                      TypeIcon(type),
                  ],
                ),
                valuename1 != ''
                    ? Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 5.0.h),
                            Column(
                              children: [
                                Text(
                                  valuename1,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13.0.sp),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      value1 == '' ? '' : value1,
                                      style: TextStyle(
                                          color: Color(CommonUtil()
                                              .getQurhomePrimaryColor()),
                                          fontSize: 15.0.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBoxWidget(
                                      width: 5,
                                    ),
                                    Text(
                                      unit != '' ? unit : '',
                                      style: TextStyle(
                                          color: Color(CommonUtil()
                                              .getQurhomePrimaryColor()),
                                          fontSize: 14.0.sp),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBoxWidget(),
                bpm != ''
                    ? Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 5.0.h),
                            Column(
                              children: [
                                Text(
                                  'PR bpm',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13.0.sp),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      bpm == '' ? '' : bpm!,
                                      style: TextStyle(
                                          color: Color(CommonUtil()
                                              .getQurhomePrimaryColor()),
                                          fontSize: 15.0.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    /* SizedBoxWidget(
                              width: 5,
                            ),
                            Text(
                              unit != '' ? unit : '',
                              style: TextStyle(
                                  color: Color(
                                      CommonUtil().getMyPrimaryColor()),
                                  fontSize: 14.0.sp),
                            ),*/
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBoxWidget(),
                /*getDeleteIcon(deviceId, type),
                SizedBoxWidget(width: 10)*/
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget TypeIcon(String type) {
    if (type == strsourceHK) {
      return Image.asset(
        'assets/devices/fit.png',
        height: 32.0.h,
        width: 32.0.h,
      );
    } else if (type == strsourceGoogle) {
      return Image.asset(
        'assets/settings/googlefit.png',
        height: 32.0.h,
        width: 32.0.h,
      );
    } else if (type == strsourceSheela) {
      return Image.asset(
        'assets/maya/maya_us_main.png',
        height: 32.0.h,
        width: 32.0.h,
      );
    } else if (type == strsourceCARGIVER) {
      return Image.asset(
        'assets/devices/caregiver_source.png',
        height: 32.0.h,
        width: 32.0.h,
        color: Color(CommonUtil().getQurhomePrimaryColor()),
      );
  } else if ((type == strQurPlan && PreferenceUtil.getIfQurhomeisAcive()) || (type == strDevice && PreferenceUtil.getIfQurhomeisAcive())) {
      return Image.asset(
        'assets/Qurhome/Qurhome.png',
        height: 20.0.h,
        width: 20.0.h,
      );
    } else {
      return Image.asset(
        'assets/icons/myfhb_source.png',
        height: 32.0.h,
        width: 32.0.h,
        color: Color(CommonUtil().getQurhomePrimaryColor()),
      );
    }
  }
}

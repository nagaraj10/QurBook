import 'dart:convert';
import 'package:get/get.dart';
import 'package:myfhb/QurHub/Controller/HubListViewController.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/device_integration/model/BPValues.dart';
import 'package:myfhb/device_integration/model/DeviceIntervalData.dart';
import 'package:myfhb/device_integration/model/GulcoseValues.dart';
import 'package:myfhb/device_integration/model/OxySaturationValues.dart';
import 'package:myfhb/device_integration/model/TemperatureValues.dart';
import 'package:myfhb/device_integration/model/WeightValues.dart';
import 'package:myfhb/device_integration/viewModel/getGFDataFromFHBRepo.dart';
import 'package:myfhb/src/ui/SheelaAI/Controller/SheelaAIController.dart';
import 'package:myfhb/src/ui/SheelaAI/Services/SheelaAIBLEServices.dart';

class VitalDetailController extends GetxController {
  final GetGFDataFromFHBRepo _helper = GetGFDataFromFHBRepo();
  var loadingData = false.obs;
  var filterBtnOnTap = 0.obs;
  late SheelaBLEController _sheelaBLEController;
  late HubListViewController _hubController;
  var bpList = [].obs;
  var gulList = [].obs;
  var oxyList = [].obs;
  var tempList = [].obs;
  var weightList = [].obs;
  String? deviceName;

  var timerProgress = 1.0.obs;
  var isShowTimerDialog = true.obs;

  // Initialize the qurhomeDashboardController using CommonUtil class method onInitQurhomeDashboardController()
  var qurhomeDashboardController =
      CommonUtil().onInitQurhomeDashboardController();

  // Initialize the vitalListController using CommonUtil class method onInitVitalListController()
  final vitalListController = CommonUtil().onInitVitalListController();

  String getFilterData(int selectedIndex) {
    String filterData;

    switch (selectedIndex) {
      case 0:
        return filterData = filterApiDay;
        break;
      case 1:
        return filterData = filterApiWeek;
        break;
      case 2:
        return filterData = filterApiMonth;
        break;
      default:
        return filterData = '';
        break;
    }
  }

  void onTapFilterBtn(int index) {
    filterBtnOnTap.value = index;
    getData();
  }

  Future<void> getData() async {
    switch (deviceName) {
      case strDataTypeBP:
        {
          fetchBPDetailsQurHome(
            filter: getFilterData(filterBtnOnTap.value),
            isLoading: true,
          );
        }
        break;
      case strGlusoceLevel:
        {
          fetchGLDetailsQurHome(
            filter: getFilterData(filterBtnOnTap.value),
            isLoading: true,
          );
        }
        break;
      case strOxgenSaturation:
        {
          fetchOXYDetailsQurHome(
            filter: getFilterData(filterBtnOnTap.value),
            isLoading: true,
          );
        }
        break;
      case strWeight:
        {
          fetchWVDetailsQurHome(
            filter: getFilterData(filterBtnOnTap.value),
            isLoading: true,
          );
        }
        break;
      case strTemperature:
        {
          fetchTMPDetailsQurHome(
            filter: getFilterData(filterBtnOnTap.value),
            isLoading: true,
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

  checkForBleDevices() async {
    try {
      var device = "";
      String filterKey = '';
      if (deviceName == strOxgenSaturation) {
        device = strConnectPulseMeter;
        filterKey = 'spo2';
      } else if (deviceName == strDataTypeBP) {
        device = strConnectBpMeter;
        filterKey = 'bp';
      } else if (deviceName == strWeight) {
        device = strConnectWeighingScale;
        filterKey = 'weight';
      } else if (deviceName == 'Blood Glucose') {
        device = strConnectBGL;
        filterKey = 'bgl';
      }
      if (device.isEmpty) {
        return;
      }
      if (!qurhomeDashboardController.forPatientList.value) {
        if (!Get.isRegistered<SheelaAIController>()) {
          Get.put(SheelaAIController());
        }
        if (!Get.isRegistered<SheelaBLEController>()) {
          Get.put(SheelaBLEController());
        }
        if (!Get.isRegistered<HubListViewController>()) {
          Get.put(HubListViewController());
        }
        _hubController = Get.find();
        _sheelaBLEController = Get.find();
        await _hubController.getHubList();
        if ((_hubController.hubListResponse?.result ?? []).length > 0) {
          _sheelaBLEController.isFromVitals = true;
          _sheelaBLEController.filteredDeviceType = filterKey;
          _sheelaBLEController.setupListenerForReadings();
          CommonUtil().dialogForScanDevices(
            Get.context!,
            onPressManual: () {
              Get.back();
              _sheelaBLEController.stopTTS();
              _sheelaBLEController.stopScanning();
            },
            onPressCancel: () async {
              Get.back();
              _sheelaBLEController.stopTTS();
              _sheelaBLEController.stopScanning();
            },
            title: device,
            // Set 'isVitalsManualRecordingRestricted' to true
            isVitalsManualRecordingRestricted: true,
          );
        }
      }
    } catch (e,stackTrace) {
      // This method is used for logging errors or messages along with their stack trace
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Future<List<dynamic>?> fetchBPDetailsQurHome(
      {bool isLoading = false, String filter = ''}) async {
    try {
      if (isLoading) {
        loadingData.value = true;
      }
      var resp = await _helper.getBPData(filter: filter,userId: vitalListController.userId.value);
      if (resp == null) {
        loadingData.value = false;
        return bpList.value = [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        loadingData.value = false;
        return bpList.value = [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult]; //as List;
      var deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<dynamic> finalResult;
      List<BPResult> ret = [];
      //List<HeartRateEntity> heartRate = List();
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bloodPressureCollection!.isEmpty) {
          loadingData.value = false;
          return bpList.value = [];
        }
        dataElement.bloodPressureCollection!.forEach((bpElement) {
          var bpList = BPResult(
              sourceType: dataElement.sourceType!.description,
              startDateTime: bpElement.startDateTime!.toIso8601String(),
              endDateTime: bpElement.endDateTime!.toIso8601String(),
              systolic: bpElement.systolic,
              diastolic: bpElement.diastolic,
              bpm: dataElement.heartRateCollection!.isNotEmpty
                  ? dataElement.heartRateCollection![0].bpm ?? null
                  : null,
              deviceId: dataElement.deviceId,
              dateTimeValue: bpElement.startDateTime);
          ret.add(bpList);
        });

        /*dataElement.heartRateCollection.forEach((element) {
          final heartRateList = HeartRateEntity(bpm: element.bpm);
          heartRate.add(heartRateList);
        });*/
      });

      bpList.value = [];

      if (deviceIntervalData.isEmpty || deviceIntervalData == null) {
        deviceIntervalData = [];
      }

      if (ret.isEmpty || ret == null) {
        ret = [];
      }

      finalResult = [ret, deviceIntervalData];

      bpList.value = finalResult;

      loadingData.value = false;
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      loadingData.value = false;
      bpList.value = [];
    }
  }

  Future<List<dynamic>?> fetchGLDetailsQurHome(
      {bool isLoading = false, String filter = ''}) async {
    try {
      if (isLoading) {
        loadingData.value = true;
      }
      var resp = await _helper.getBloodGlucoseData(filter: filter,userId: vitalListController.userId.value);
      if (resp == null) {
        loadingData.value = false;
        return gulList.value = [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        loadingData.value = false;
        return gulList.value = [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult]; //as List;
      var deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<dynamic> finalResult;
      var ret = <GVResult>[];
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bloodGlucoseCollection!.isEmpty) {
          loadingData.value = false;
          return gulList.value = [];
        }
        dataElement.bloodGlucoseCollection!.forEach((bgValue) {
          var bgList = GVResult(
              sourceType: dataElement.sourceType!.description,
              startDateTime: bgValue.startDateTime!.toIso8601String(),
              endDateTime: bgValue.endDateTime!.toIso8601String(),
              bloodGlucoseLevel: bgValue.bloodGlucoseLevel,
              bgUnit:
                  (bgValue.bgUnit == null) ? null : bgValue.bgUnit!.description,
              mealContext: (bgValue.mealContext == null)
                  ? null
                  : bgValue.mealContext!.description,
              mealType: (bgValue.mealType == null)
                  ? null
                  : bgValue.mealType!.description,
              deviceId: dataElement.deviceId,
              dateTimeValue: bgValue.startDateTime);
          ret.add(bgList);
        });
      });
      gulList.value = [];
      if (deviceIntervalData.isEmpty || deviceIntervalData == null) {
        deviceIntervalData = [];
      }

      if (ret.isEmpty || ret == null) {
        ret = [];
      }

      finalResult = [ret, deviceIntervalData];

      gulList.value = finalResult;

      loadingData.value = false;
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      gulList.value = [];
      loadingData.value = false;
    }
  }

  Future<List<dynamic>?> fetchOXYDetailsQurHome(
      {bool isLoading = false, String filter = ''}) async {
    try {
      if (isLoading) {
        loadingData.value = true;
      }
      var resp = await _helper.getOxygenSaturationData(filter: filter,userId: vitalListController.userId.value);
      if (resp == null) {
        loadingData.value = false;
        return oxyList.value = [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        loadingData.value = false;
        return oxyList.value = [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult]; //as List;
      var deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<dynamic> finalResult;
      var ret = <OxyResult>[];
      //List<HeartRateEntity> heartRate = List();
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.oxygenSaturationCollection!.isEmpty &&
            dataElement.heartRateCollection!.isEmpty) {
          loadingData.value = false;
          return oxyList.value = [];
        }
        dataElement.oxygenSaturationCollection!.forEach((oxyValue) {
          var oxyList = OxyResult(
            sourceType: dataElement.sourceType!.description,
            startDateTime: oxyValue.startDateTime!.toIso8601String(),
            endDateTime: oxyValue.endDateTime!.toIso8601String(),
            oxygenSaturation: oxyValue.oxygenSaturation,
            deviceId: dataElement.deviceId,
            dateTimeValue: oxyValue.startDateTime,
            bpm: dataElement.heartRateCollection!.isEmpty
                ? ''
                : dataElement.heartRateCollection![0].bpm != null
                    ? dataElement.heartRateCollection![0].bpm.toString()
                    : '',
          );
          ret.add(oxyList);
        });
        /* dataElement.heartRateCollection.forEach((element) {
          final heartRateList = HeartRateEntity(bpm: element.bpm);
          heartRate.add(heartRateList);
        });*/
      });

      oxyList.value = [];

      if (deviceIntervalData.isEmpty || deviceIntervalData == null) {
        deviceIntervalData = [];
      }

      if (ret.isEmpty || ret == null) {
        ret = [];
      }

      finalResult = [ret, deviceIntervalData];

      oxyList.value = finalResult;

      loadingData.value = false;
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      oxyList.value = [];
      loadingData.value = false;
    }
  }

  Future<List<dynamic>?> fetchTMPDetailsQurHome(
      {bool isLoading = false, String filter = ''}) async {
    try {
      if (isLoading) {
        loadingData.value = true;
      }
      var resp = await _helper.getBodyTemperatureData(filter: filter,userId: vitalListController.userId.value);
      if (resp == null) {
        loadingData.value = false;
        return tempList.value = [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        loadingData.value = false;
        return tempList.value = [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult]; //as List;
      var deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<TMPResult> ret = [];
      List<dynamic> finalResult;
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bodyTemperatureCollection!.isEmpty) {
          loadingData.value = false;
          return tempList.value = [];
        }
        dataElement.bodyTemperatureCollection!.forEach((tempValue) {
          var tempList = TMPResult(
              sourceType: dataElement.sourceType!.description,
              startDateTime: tempValue.startDateTime!.toIso8601String(),
              endDateTime: tempValue.endDateTime!.toIso8601String(),
              temperature: tempValue.temperature,
              temperatureUnit: tempValue.temperatureUnit!.description,
              deviceId: dataElement.deviceId,
              dateTimeValue: tempValue.startDateTime);
          ret.add(tempList);
        });
      });

      tempList.value = [];

      if (deviceIntervalData.isEmpty || deviceIntervalData == null) {
        deviceIntervalData = [];
      }

      if (ret.isEmpty || ret == null) {
        ret = [];
      }

      finalResult = [ret, deviceIntervalData];

      tempList.value = finalResult;

      loadingData.value = false;
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      tempList.value = [];
      loadingData.value = false;
    }
  }

  Future<List<dynamic>?> fetchWVDetailsQurHome(
      {bool isLoading = false, String filter = ''}) async {
    try {
      if (isLoading) {
        loadingData.value = true;
      }
      var resp = await _helper.getWeightData(filter: filter,userId: vitalListController.userId.value);
      if (resp == null) {
        loadingData.value = false;
        return weightList.value = [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        loadingData.value = false;
        return weightList.value = [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult]; //as List;
      var deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<WVResult> ret = [];
      List<dynamic> finalResult;
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bodyWeightCollection!.isEmpty) {
          loadingData.value = false;
          return weightList.value = [];
        }
        dataElement.bodyWeightCollection!.forEach((weightValue) {
          var weightList = WVResult(
              sourceType: dataElement.sourceType!.description,
              startDateTime: weightValue.startDateTime!.toIso8601String(),
              endDateTime: weightValue.endDateTime!.toIso8601String(),
              weight: weightValue.weight,
              weightUnit: weightValue.weightUnit != null
                  ? weightValue.weightUnit!.description
                  : 'kg',
              deviceId: dataElement.deviceId,
              dateTimeValue: weightValue.startDateTime);
          ret.add(weightList);
        });
      });

      weightList.value = [];

      if (deviceIntervalData.isEmpty || deviceIntervalData == null) {
        deviceIntervalData = [];
      }

      if (ret.isEmpty || ret == null) {
        ret = [];
      }

      finalResult = [ret, deviceIntervalData];

      weightList.value = finalResult;

      loadingData.value = false;
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      weightList.value = [];
      loadingData.value = false;
    }
  }
}

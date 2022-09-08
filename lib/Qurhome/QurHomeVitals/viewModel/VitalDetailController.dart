import 'dart:convert';
import 'package:get/get.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/device_integration/model/BPValues.dart';
import 'package:myfhb/device_integration/model/DeviceIntervalData.dart';
import 'package:myfhb/device_integration/model/GulcoseValues.dart';
import 'package:myfhb/device_integration/model/LastMeasureSync.dart';
import 'package:myfhb/device_integration/model/OxySaturationValues.dart';
import 'package:myfhb/device_integration/model/TemperatureValues.dart';
import 'package:myfhb/device_integration/model/WeightValues.dart';
import 'package:myfhb/device_integration/viewModel/getGFDataFromFHBRepo.dart';
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class VitalDetailController extends GetxController {
  final GetGFDataFromFHBRepo _helper = GetGFDataFromFHBRepo();
  var loadingData = false.obs;
  var filterBtnOnTap = 0.obs;

  var bpList = [].obs;
  var gulList = [].obs;
  var oxyList = [].obs;
  var tempList = [].obs;
  var weightList = [].obs;

  var timerProgress = 1.0.obs;
  var isShowTimerDialog = true.obs;

  void onTapFilterBtn(int index) {
    filterBtnOnTap.value = index;
  }

  Future<List<dynamic>> fetchBPDetailsQurHome(
      {bool isLoading = false, String filter = ''}) async {
    try {
      if (isLoading) {
        loadingData.value = true;
      }
      var resp = await _helper.getBPData(filter: filter);
      if (resp == null) {
        loadingData.value = false;
        return bpList.value = [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        loadingData.value = false;
        return bpList.value = [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult] as List;
      var deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<dynamic> finalResult;
      List<BPResult> ret = [];
      //List<HeartRateEntity> heartRate = new List();
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bloodPressureCollection.isEmpty) {
          loadingData.value = false;
          return bpList.value = [];
        }
        dataElement.bloodPressureCollection.forEach((bpElement) {
          var bpList = BPResult(
              sourceType: dataElement.sourceType.description,
              startDateTime: bpElement.startDateTime.toIso8601String(),
              endDateTime: bpElement.endDateTime.toIso8601String(),
              systolic: bpElement.systolic,
              diastolic: bpElement.diastolic,
              bpm: dataElement.heartRateCollection.isNotEmpty
                  ? dataElement.heartRateCollection[0].bpm ?? null
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
    } catch (e) {
      loadingData.value = false;
      bpList.value = [];
    }
  }

  Future<List<dynamic>> fetchGLDetailsQurHome(
      {bool isLoading = false, String filter = ''}) async {
    try {
      if (isLoading) {
        loadingData.value = true;
      }
      var resp = await _helper.getBloodGlucoseData(filter: filter);
      if (resp == null) {
        loadingData.value = false;
        return gulList.value = [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        loadingData.value = false;
        return gulList.value = [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult] as List;
      var deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<dynamic> finalResult;
      var ret = List<GVResult>();
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bloodGlucoseCollection.isEmpty) {
          loadingData.value = false;
          return gulList.value = [];
        }
        dataElement.bloodGlucoseCollection.forEach((bgValue) {
          var bgList = GVResult(
              sourceType: dataElement.sourceType.description,
              startDateTime: bgValue.startDateTime.toIso8601String(),
              endDateTime: bgValue.endDateTime.toIso8601String(),
              bloodGlucoseLevel: bgValue.bloodGlucoseLevel,
              bgUnit:
                  (bgValue.bgUnit == null) ? null : bgValue.bgUnit.description,
              mealContext: (bgValue.mealContext == null)
                  ? null
                  : bgValue.mealContext.description,
              mealType: (bgValue.mealType == null)
                  ? null
                  : bgValue.mealType.description,
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
    } catch (e) {
      gulList.value = [];
      loadingData.value = false;
    }
  }

  Future<List<dynamic>> fetchOXYDetailsQurHome(
      {bool isLoading = false, String filter = ''}) async {
    try {
      if (isLoading) {
        loadingData.value = true;
      }
      var resp = await _helper.getOxygenSaturationData(filter: filter);
      if (resp == null) {
        loadingData.value = false;
        return oxyList.value = [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        loadingData.value = false;
        return oxyList.value = [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult] as List;
      var deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<dynamic> finalResult;
      var ret = <OxyResult>[];
      //List<HeartRateEntity> heartRate = new List();
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.oxygenSaturationCollection.isEmpty &&
            dataElement.heartRateCollection.isEmpty) {
          loadingData.value = false;
          return oxyList.value = [];
        }
        dataElement.oxygenSaturationCollection.forEach((oxyValue) {
          var oxyList = OxyResult(
            sourceType: dataElement.sourceType.description,
            startDateTime: oxyValue.startDateTime.toIso8601String(),
            endDateTime: oxyValue.endDateTime.toIso8601String(),
            oxygenSaturation: oxyValue.oxygenSaturation,
            deviceId: dataElement.deviceId,
            dateTimeValue: oxyValue.startDateTime,
            bpm: dataElement.heartRateCollection.isEmpty
                ? ''
                : dataElement.heartRateCollection[0].bpm != null
                    ? dataElement.heartRateCollection[0].bpm.toString()
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
    } catch (e) {
      oxyList.value = [];
      loadingData.value = false;
    }
  }

  Future<List<dynamic>> fetchTMPDetailsQurHome(
      {bool isLoading = false, String filter = ''}) async {
    try {
      if (isLoading) {
        loadingData.value = true;
      }
      var resp = await _helper.getBodyTemperatureData(filter: filter);
      if (resp == null) {
        loadingData.value = false;
        return tempList.value = [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        loadingData.value = false;
        return tempList.value = [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult] as List;
      var deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<TMPResult> ret = [];
      List<dynamic> finalResult;
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bodyTemperatureCollection.isEmpty) {
          loadingData.value = false;
          return tempList.value = [];
        }
        dataElement.bodyTemperatureCollection.forEach((tempValue) {
          var tempList = TMPResult(
              sourceType: dataElement.sourceType.description,
              startDateTime: tempValue.startDateTime.toIso8601String(),
              endDateTime: tempValue.endDateTime.toIso8601String(),
              temperature: tempValue.temperature,
              temperatureUnit: tempValue.temperatureUnit.description,
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
    } catch (e) {
      tempList.value = [];
      loadingData.value = false;
    }
  }

  Future<List<dynamic>> fetchWVDetailsQurHome(
      {bool isLoading = false, String filter = ''}) async {
    try {
      if (isLoading) {
        loadingData.value = true;
      }
      var resp = await _helper.getWeightData(filter: filter);
      if (resp == null) {
        loadingData.value = false;
        return weightList.value = [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        loadingData.value = false;
        return weightList.value = [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult] as List;
      var deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<WVResult> ret = [];
      List<dynamic> finalResult;
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bodyWeightCollection.isEmpty) {
          loadingData.value = false;
          return weightList.value = [];
        }
        dataElement.bodyWeightCollection.forEach((weightValue) {
          var weightList = WVResult(
              sourceType: dataElement.sourceType.description,
              startDateTime: weightValue.startDateTime.toIso8601String(),
              endDateTime: weightValue.endDateTime.toIso8601String(),
              weight: weightValue.weight,
              weightUnit: weightValue.weightUnit != null
                  ? weightValue.weightUnit.description
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
    } catch (e) {
      weightList.value = [];
      loadingData.value = false;
    }
  }

  updateTimerValue(double value) async {
    try {
      timerProgress.value = value;
    } catch (e) {
      print(e);
    }
  }

  updateisShowTimerDialog(bool value) async {
    try {
      isShowTimerDialog.value = value;
    } catch (e) {
      print(e);
    }
  }
}

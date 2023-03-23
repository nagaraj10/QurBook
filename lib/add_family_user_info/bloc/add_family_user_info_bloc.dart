
import 'dart:async';
import 'dart:io';

import '../models/update_add_family_info.dart';
import '../models/update_relatiosnship_model.dart';
import '../models/update_self_profile_model.dart';
import '../models/updated_add_family_relation_info.dart';
import '../services/add_family_user_info_repository.dart';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../my_family/models/relationship_response_list.dart';
import '../../src/blocs/Authentication/LoginBloc.dart';
import '../../src/model/CreateDeviceSelectionModel.dart';
import '../../src/model/GetDeviceSelectionModel.dart';
import '../../src/model/UpdatedDeviceModel.dart';
import '../../src/model/user/City.dart';
import '../../src/model/user/MyProfileModel.dart';
import '../../src/model/user/State.dart';
import '../../src/model/user/city_list_model.dart';
import '../../src/model/user/state_list_model.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../models/verify_email_response.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../src/resources/repository/health/HealthReportListForUserRepository.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/model/user/Tags.dart';

class AddFamilyUserInfoBloc extends BaseBloc {
  late AddFamilyUserInfoRepository addFamilyUserInfoRepository;

  // 1
  late StreamController _relationshipListController;

  StreamSink<ApiResponse<RelationShipResponseList>> get relationShipListSink =>
      _relationshipListController.sink as StreamSink<ApiResponse<RelationShipResponseList>>;

  Stream<ApiResponse<RelationShipResponseList>> get relationShipStream =>
      _relationshipListController.stream as Stream<ApiResponse<RelationShipResponseList>>;

  // 2
  late StreamController _myProfileController;

  StreamSink<ApiResponse<MyProfileModel>> get myProfileSink =>
      _myProfileController.sink as StreamSink<ApiResponse<MyProfileModel>>;

  Stream<ApiResponse<MyProfileModel>> get myProfileStream =>
      _myProfileController.stream as Stream<ApiResponse<MyProfileModel>>;

  // 3
  late StreamController _userProfileController;

  StreamSink<ApiResponse<UpdateAddFamilyInfo>> get userProfileSink =>
      _userProfileController.sink as StreamSink<ApiResponse<UpdateAddFamilyInfo>>;

  Stream<ApiResponse<UpdateAddFamilyInfo>> get userProfileStream =>
      _userProfileController.stream as Stream<ApiResponse<UpdateAddFamilyInfo>>;

  // 4
  late StreamController _updatedRelationShipController;

  StreamSink<ApiResponse<UpdateAddFamilyRelationInfo>>
      get updateRelationshipSink => _updatedRelationShipController.sink as StreamSink<ApiResponse<UpdateAddFamilyRelationInfo>>;

  Stream<ApiResponse<UpdateAddFamilyRelationInfo>>
      get updateRelationshipStream => _updatedRelationShipController.stream as Stream<ApiResponse<UpdateAddFamilyRelationInfo>>;

//5
  late StreamController _verifyEmailController;
  StreamSink<ApiResponse<VerifyEmailResponse>> get verifyEmailSink =>
      _verifyEmailController.sink as StreamSink<ApiResponse<VerifyEmailResponse>>;

  Stream<ApiResponse<VerifyEmailResponse>> get verifyEmailStream =>
      _verifyEmailController.stream as Stream<ApiResponse<VerifyEmailResponse>>;

  String? userId;

  MyProfileModel? myprofileObject;

  String? name,
      phoneNo,
      email,
      gender,
      bloodGroup,
      dateOfBirth,
      firstName,
      middleName,
      lastName,
      addressLine1,
      addressLine2,
      cityId,
      stateId,
      zipcode;

  late bool isUpdate;
  UpdateRelationshipModel? relationship;

  String? preferredLanguage = CommonUtil.getCurrentLanCode();

  String? userMappingId = '';
  bool? _isdigitRecognition = true;
  bool? _isdeviceRecognition = true;
  bool? _isGFActive;
  bool? _isHKActive = false;
  bool _firstTym = true;
  bool? _isBPActive = true;
  bool? _isGLActive = true;
  bool? _isOxyActive = true;
  bool? _isTHActive = true;
  bool? _isWSActive = true;
  bool _isHealthFirstTime = false;
  String? preferred_language;
  String? qa_subscription;
  int? preColor = 0xff5e1fe0;
  int? greColor = 0xff753aec;
  var isEndOfConv = false;
  bool canSpeak = true;
  var isLoading = false;
  var isRedirect = false;
  var screenValue;
  bool enableMic = true;
  bool isButtonResponse = false;
  bool stopTTS = false;
  bool isSheelaSpeaking = false;

  late MyProfileModel myProfileModel;

  late String relationshipJsonString;

  File? profilePic, profileBanner;
  CreateDeviceSelectionModel? createDeviceSelectionModel;
  List<Tags>? tagsList = <Tags>[];

  bool? allowAppointmentNotification = true;
  bool? allowVitalNotification = true;
  bool? allowSymptomsNotification = true;

  PreferredMeasurement? preferredMeasurement;

  @override
  void dispose() {
    // TODO: implement dispose

    _relationshipListController.close();
    _myProfileController.close();
    _userProfileController.close();
    _updatedRelationShipController.close();
    _verifyEmailController.close();
  }

  AddFamilyUserInfoBloc() {
    addFamilyUserInfoRepository = AddFamilyUserInfoRepository();

    _relationshipListController =
        StreamController<ApiResponse<RelationShipResponseList>>();

    _myProfileController = StreamController<ApiResponse<MyProfileModel>>();

    _userProfileController =
        StreamController<ApiResponse<UpdateAddFamilyInfo>>();

    _updatedRelationShipController =
        StreamController<ApiResponse<UpdateAddFamilyRelationInfo>>();
    _verifyEmailController =
        StreamController<ApiResponse<VerifyEmailResponse>>();
  }

  getCustomRoles() async {
    relationShipListSink.add(ApiResponse.loading(variable.strFetchRoles));
    try {
      var relationShipResponseList =
          await addFamilyUserInfoRepository.getCustomRoles();
      relationShipListSink.add(ApiResponse.completed(relationShipResponseList));
    } catch (e) {
      relationShipListSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<MyProfileModel?> getMyProfileInfo() async {
    myProfileSink.add(ApiResponse.loading(variable.strFetchRoles));
    MyProfileModel? myProfile;

    try {
      myProfile = await addFamilyUserInfoRepository.getMyProfileInfoNew(userId!);
      myprofileObject = myProfile;
    } catch (e) {
      myProfileSink.add(ApiResponse.error(e.toString()));
    }

    return myProfile;
  }

  Future<UpdateAddFamilyInfo?> updateUserProfile(bool fromFamily) async {
    userProfileSink.add(ApiResponse.loading(variable.strUpdatingProfile));
    UpdateAddFamilyInfo? updateAddFamilyInfo;

    try {
      updateAddFamilyInfo =
          await addFamilyUserInfoRepository.updateUserProfileInfo(
              userId!,
              name,
              phoneNo,
              email,
              gender,
              bloodGroup,
              dateOfBirth,
              profilePic!,
              firstName,
              middleName,
              lastName,
              cityId,
              stateId,
              addressLine1,
              addressLine2,
              zipcode,
              fromFamily);
//      userProfileSink.add(ApiResponse.completed(updateAddFamilyInfo));
    } catch (e) {
      userProfileSink.add(ApiResponse.error(e.toString()));
    }

    return updateAddFamilyInfo;
  }

  Future<UpdateAddFamilyRelationInfo?> updateUserRelationShip() async {
    updateRelationshipSink
        .add(ApiResponse.loading(variable.strUpdateUserRelation));
    UpdateAddFamilyRelationInfo? updateAddFamilyRelationInfo;

    try {
      updateAddFamilyRelationInfo = await addFamilyUserInfoRepository
          .updateRelationShip(relationshipJsonString);
//      userProfileSink.add(ApiResponse.completed(updateAddFamilyInfo));
    } catch (e) {
      updateRelationshipSink.add(ApiResponse.error(e.toString()));
    }

    return updateAddFamilyRelationInfo;
  }

  Future<UpdateSelfProfileModel?> updateSelfProfile(bool fromFamily) async {
    userProfileSink.add(ApiResponse.loading(variable.strUpdatedSelfProfile));
    UpdateSelfProfileModel? updateAddFamilyInfo;
    try {
      preferredLanguage =
          preferredLanguage == null || preferredLanguage == 'undef'
              ? 'en-IN'
              : preferredLanguage;

      var currentLanguage = '';
      if (preferredLanguage != 'undef') {
        currentLanguage = preferredLanguage!.split('-').first;
      } else {
        currentLanguage = 'en';
      }
      await PreferenceUtil.saveString(
          SHEELA_LANG, CommonUtil.langaugeCodes[currentLanguage] ?? 'en-IN');
      preferred_language = currentLanguage;

      updateAddFamilyInfo = await addFamilyUserInfoRepository.updateUserInfoNew(
          userId,
          name,
          phoneNo,
          email,
          gender,
          bloodGroup,
          dateOfBirth,
          profilePic,
          firstName,
          middleName,
          lastName,
          cityId,
          stateId,
          isUpdate,
          addressLine1,
          addressLine2,
          zipcode,
          fromFamily,
          myProfileModel,
          relationship);
      //userProfileSink.add(ApiResponse.completed(updateAddFamilyInfo));

      await updateDeviceSelectionModel(preferredLanguage: preferred_language);
    } catch (e) {
      userProfileSink.add(ApiResponse.error(e.toString()));
    }

    return updateAddFamilyInfo;
  }

  Future<VerifyEmailResponse?> verifyEmail() async {
    verifyEmailSink.add(ApiResponse.loading(variable.strVerifyingMail));
    VerifyEmailResponse? verifyEmailResponse;

    try {
      verifyEmailResponse = await addFamilyUserInfoRepository.verifyEmail();
//      userProfileSink.add(ApiResponse.completed(updateAddFamilyInfo));
    } catch (e) {
      verifyEmailSink.add(ApiResponse.error(e.toString()));
    }

    return verifyEmailResponse;
  }

  Future<List<City>> getCityDataList(String cityname, String apibody) async {
    CityModel cityListModel;

    cityListModel = await addFamilyUserInfoRepository.getValuesBaseOnSearch(
        cityname, apibody);
    return cityListModel.result!;
  }

  Future<List<State>> geStateDataList(String cityname, String apibody) async {
    StateModel stateModel;

    stateModel = await addFamilyUserInfoRepository.getStateValuesBaseOnSearch(
        cityname, apibody);
    return stateModel.result!;
  }

  Future<void> getDeviceSelectionValues() async {
    final healthReportListForUserRepository =
        HealthReportListForUserRepository();
    GetDeviceSelectionModel selectionResult;
    await healthReportListForUserRepository
        .getDeviceSelection(userIdFromBloc: userId)
        .then((value) {
      selectionResult = value;
      if (selectionResult.isSuccess!) {
        if (selectionResult.result != null) {
          setValues(selectionResult);
          userMappingId = selectionResult.result![0].id;
          getMyProfileInfo();
        } else {
          userMappingId = '';
          _isdeviceRecognition = true;
          _isHKActive = false;
          _firstTym = true;
          _isBPActive = true;
          _isGLActive = true;
          _isOxyActive = true;
          _isTHActive = true;
          _isWSActive = true;
          _isHealthFirstTime = false;
          allowAppointmentNotification = true;
          allowSymptomsNotification = true;
          allowVitalNotification = true;
        }
      } else {
        userMappingId = '';
        _isdigitRecognition = true;
        _isdeviceRecognition = true;
        _isHKActive = false;
        _firstTym = true;
        _isBPActive = true;
        _isGLActive = true;
        _isOxyActive = true;
        _isTHActive = true;
        _isWSActive = true;
        _isHealthFirstTime = false;
        allowAppointmentNotification = true;
        allowSymptomsNotification = true;
        allowVitalNotification = true;

        healthReportListForUserRepository
            .createDeviceSelection(
                _isdigitRecognition,
                _isdeviceRecognition,
                _isGFActive,
                _isHKActive,
                _isBPActive,
                _isGLActive,
                _isOxyActive,
                _isTHActive,
                _isWSActive,
                userId,
                preferred_language,
                qa_subscription,
                preColor,
                greColor,
                tagsList,
                allowAppointmentNotification,
                allowVitalNotification,
                allowSymptomsNotification)
            .then((value) {
          createDeviceSelectionModel = value;
          if (createDeviceSelectionModel?.isSuccess ?? false) {
            userMappingId = createDeviceSelectionModel!.result;
            updateDeviceSelectionModel(preferredLanguage: preferredLanguage);
          } else {
            healthReportListForUserRepository
                .createDeviceSelection(
                    _isdigitRecognition,
                    _isdeviceRecognition,
                    _isGFActive,
                    _isHKActive,
                    _isBPActive,
                    _isGLActive,
                    _isOxyActive,
                    _isTHActive,
                    _isWSActive,
                    userId,
                    preferred_language,
                    qa_subscription,
                    preColor,
                    greColor,
                    tagsList,
                    allowAppointmentNotification,
                    allowVitalNotification,
                    allowSymptomsNotification)
                .then((value) {
              createDeviceSelectionModel = value;
              if (createDeviceSelectionModel!.isSuccess!) {
                userMappingId = createDeviceSelectionModel!.result;
                updateDeviceSelectionModel(
                    preferredLanguage: preferredLanguage);
              }
            });
          }
        });
      }
    });
  }

  setValues(GetDeviceSelectionModel getDeviceSelectionModel) {
    preColor = getDeviceSelectionModel.result![0].profileSetting!.preColor;
    greColor = getDeviceSelectionModel.result![0].profileSetting!.greColor;
    _isdeviceRecognition =
        getDeviceSelectionModel.result![0].profileSetting!.allowDevice != null &&
                getDeviceSelectionModel.result![0].profileSetting!.allowDevice !=
                    ''
            ? getDeviceSelectionModel.result![0].profileSetting!.allowDevice
            : true;
    _isdigitRecognition =
        getDeviceSelectionModel.result![0].profileSetting!.allowDigit != null &&
                getDeviceSelectionModel.result![0].profileSetting!.allowDigit !=
                    ''
            ? getDeviceSelectionModel.result![0].profileSetting!.allowDigit
            : true;
    _isHKActive =
        getDeviceSelectionModel.result![0].profileSetting!.healthFit != null &&
                getDeviceSelectionModel.result![0].profileSetting!.healthFit != ''
            ? getDeviceSelectionModel.result![0].profileSetting!.healthFit
            : false;
    _isBPActive =
        getDeviceSelectionModel.result![0].profileSetting!.bpMonitor != null &&
                getDeviceSelectionModel.result![0].profileSetting!.bpMonitor != ''
            ? getDeviceSelectionModel.result![0].profileSetting!.bpMonitor
            : true;
    _isGLActive = getDeviceSelectionModel.result![0].profileSetting!.glucoMeter !=
                null &&
            getDeviceSelectionModel.result![0].profileSetting!.glucoMeter != ''
        ? getDeviceSelectionModel.result![0].profileSetting!.glucoMeter
        : true;
    _isOxyActive = getDeviceSelectionModel
                    .result![0].profileSetting!.pulseOximeter !=
                null &&
            getDeviceSelectionModel.result![0].profileSetting!.pulseOximeter != ''
        ? getDeviceSelectionModel.result![0].profileSetting!.pulseOximeter
        : true;
    _isWSActive = getDeviceSelectionModel.result![0].profileSetting!.weighScale !=
                null &&
            getDeviceSelectionModel.result![0].profileSetting!.weighScale != ''
        ? getDeviceSelectionModel.result![0].profileSetting!.weighScale
        : true;
    _isTHActive =
        getDeviceSelectionModel.result![0].profileSetting!.thermoMeter != null &&
                getDeviceSelectionModel.result![0].profileSetting!.thermoMeter !=
                    ''
            ? getDeviceSelectionModel.result![0].profileSetting!.thermoMeter
            : true;

    preferred_language = getDeviceSelectionModel
                    .result![0].profileSetting!.preferred_language !=
                null &&
            getDeviceSelectionModel
                    .result![0].profileSetting!.preferred_language !=
                ''
        ? getDeviceSelectionModel.result![0].profileSetting!.preferred_language
        : 'undef';

    qa_subscription = getDeviceSelectionModel
                    .result![0].profileSetting!.qa_subscription !=
                null &&
            getDeviceSelectionModel.result![0].profileSetting!.qa_subscription !=
                ''
        ? getDeviceSelectionModel.result![0].profileSetting!.qa_subscription
        : 'Y';

    tagsList = getDeviceSelectionModel.result![0].tags != null &&
            getDeviceSelectionModel.result![0].tags!.length > 0
        ? getDeviceSelectionModel.result![0].tags
        : [];

    if (tagsList!.length > 0) {
      for (Tags tags in tagsList!) {
        tags.isChecked = true;
      }
    }

    allowAppointmentNotification = getDeviceSelectionModel
                    .result![0].profileSetting!.caregiverCommunicationSetting !=
                null &&
            getDeviceSelectionModel
                    .result![0].profileSetting!.caregiverCommunicationSetting !=
                ''
        ? getDeviceSelectionModel.result![0].profileSetting!
            .caregiverCommunicationSetting?.appointments
        : true;

    allowVitalNotification = getDeviceSelectionModel
                    .result![0].profileSetting!.caregiverCommunicationSetting !=
                null &&
            getDeviceSelectionModel
                    .result![0].profileSetting!.caregiverCommunicationSetting !=
                ''
        ? getDeviceSelectionModel
            .result![0].profileSetting!.caregiverCommunicationSetting?.vitals
        : true;

    allowSymptomsNotification = getDeviceSelectionModel
                    .result![0].profileSetting!.caregiverCommunicationSetting !=
                null &&
            getDeviceSelectionModel
                    .result![0].profileSetting!.caregiverCommunicationSetting !=
                ''
        ? getDeviceSelectionModel
            .result![0].profileSetting!.caregiverCommunicationSetting?.symptoms
        : true;

    preferredMeasurement = getDeviceSelectionModel.result![0].profileSetting !=
            null
        ? getDeviceSelectionModel.result![0].profileSetting!.preferredMeasurement
        : null;
  }

  Future<UpdateDeviceModel?> updateDeviceSelectionModel(
      {String? preferredLanguage}) async {
    var healthReportListForUserRepository = HealthReportListForUserRepository();
    await healthReportListForUserRepository
        .updateDeviceModel(
            userMappingId,
            _isdigitRecognition,
            _isdeviceRecognition,
            _isGFActive,
            _isHKActive,
            _isBPActive,
            _isGLActive,
            _isOxyActive,
            _isTHActive,
            _isWSActive,
            preferredLanguage ?? preferred_language,
            qa_subscription,
            preColor,
            greColor,
            tagsList,
            allowAppointmentNotification,
            allowVitalNotification,
            allowSymptomsNotification,
            preferredMeasurement)
        .then(
      (value) {
        if (value.isSuccess ?? false) {
          getDeviceSelectionValues();
        } else {
          //var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
          healthReportListForUserRepository
              .createDeviceSelection(
                  _isdigitRecognition,
                  _isdeviceRecognition,
                  _isGFActive,
                  _isHKActive,
                  _isBPActive,
                  _isGLActive,
                  _isOxyActive,
                  _isTHActive,
                  _isWSActive,
                  userId,
                  preferred_language,
                  qa_subscription,
                  preColor,
                  greColor,
                  tagsList,
                  allowAppointmentNotification,
                  allowVitalNotification,
                  allowSymptomsNotification)
              .then((value) {
            createDeviceSelectionModel = value;
            if (createDeviceSelectionModel!.isSuccess!) {
              updateDeviceSelectionModel(preferredLanguage: preferredLanguage);
            }
          });
        }
      },
    );
  }
}

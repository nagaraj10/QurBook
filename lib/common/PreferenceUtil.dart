
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';
import 'CommonConstants.dart';
import '../constants/fhb_constants.dart' as Constants;
import '../language/model/Language.dart';
import '../my_family/models/FamilyData.dart';
import '../my_family/models/FamilyMembersRes.dart';
import '../my_family/models/RelationShip.dart';
import '../my_family/models/relationship_response_list.dart';
import '../my_family/models/relationships.dart';
import '../src/model/Authentication/UserModel.dart';
import '../src/model/Category/catergory_result.dart';
import '../src/model/Health/asgard/health_record_list.dart';
import '../src/model/Media/media_result.dart';
import '../src/model/user/DoctorIds.dart';
import '../src/model/user/HospitalIds.dart';
import '../src/model/user/LaboratoryIds.dart';
import '../src/model/user/MyProfileModel.dart';
import '../telehealth/features/Notifications/constants/notification_constants.dart';
import '../video_call/model/NotificationModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtil {
  static Future<SharedPreferences>? _prefs = SharedPreferences.getInstance();

  static SharedPreferences? _prefsInstance;
  static bool _initCalled = false;

  static Future<void> init() async {
    _initCalled = true;
    _prefsInstance = await _prefs;
  }

  static void dispose() {
    _prefs = null;
    _prefsInstance = null;
  }

  static bool isKeyValid(String key) {
    return _prefsInstance!.containsKey(key);
  }

  static saveShownIntroScreens() async {
    final instance = await _prefs!;
    await instance.setBool(Constants.KeyShowIntroScreens, true);
  }

  static saveShownQurhomeDefaultUI() async {
    final instance = await _prefs!;
    await instance.setBool(Constants.KeyShowQurhomeDefaultUI, true);
  }

  static Future<bool> saveMediaData(
      String keyProfile, MediaResult? mediaData) async {
    final instance = await _prefs!;
    final profile = json.encode(mediaData);

    return instance.setString(keyProfile, profile);
  }

  static MediaResult getMediaData(String keyProfile) {
    if (_prefsInstance == null) {}
    return MediaResult.fromJson(
        json.decode(_prefsInstance!.getString(keyProfile)!));
  }

  static Future<bool> saveMediaType(
      String membershipKey, List<MediaResult>? mediaDataList) async {
    final instance = await _prefs!;

    return instance.setString(membershipKey, json.encode(mediaDataList));
  }

  static Future<bool> saveString(String key, String value) async {
    final instance = await _prefs!;
    return instance.setString(key, value);
  }

  /* static Future<bool> savePreferredMaya(String key, String value) async {
    var instance = await _prefs;
    return instance.setString(key, value);
  } */

  static List<MediaResult> getMediaType() {
    var mediaData = <MediaResult>[];

    if (_prefsInstance == null) {}
    json
        .decode(_prefsInstance!.getString(Constants.KEY_METADATA)!)
        .forEach((map) {
      mediaData.add(MediaResult.fromJson(map));
    });

    return mediaData;
  }

  static Future<bool> saveNotificationData(NotificationModel data) async {
    _prefsInstance ??= await _prefs;
    var dataInMap = data.toMap();
    var jsonData = json.encode(dataInMap);
    return await _prefsInstance!.setString(Constants.NotificationData, jsonData);
  }

  static Future<NotificationModel> getNotifiationData() async {
    _prefsInstance ??= await _prefs;
    var jsonData = _prefsInstance!.getString(Constants.NotificationData)!;
    var dataInMap = json.decode(jsonData);
    return NotificationModel.fromSharePreferences(dataInMap);
  }

  static Future<bool> removeNotificationData() async {
    _prefsInstance ??= await _prefs;
    return await _prefsInstance!.remove(Constants.NotificationData);
  }

  static String? getStringValue(String key) {
    return _prefsInstance?.getString(key);
  }

  static Future<bool> saveTheme(String key, int value) async {
    final instance = await _prefs!;
    return instance.setInt(key, value);
  }

  static int? getSavedTheme(String key) {
    return _prefsInstance!.getInt(key);
  }

  static Future<bool> saveCategoryList(
      String membershipKey, List<CategoryResult> categoryList) async {
    final instance = await _prefs!;

    for (var categoryData in categoryList) {
      if (categoryData.categoryDescription ==
          CommonConstants.categoryDescriptionVoiceRecord) {
        await saveString(Constants.KEY_VOICE_ID, categoryData.id!);
      }
    }

    return instance.setString(membershipKey, json.encode(categoryList));
  }

  static Future<bool> saveProfileData(
      String keyProfile, MyProfileModel? profileData) async {
    final instance = await _prefs!;
    var profile = json.encode(profileData);
    return instance.setString(keyProfile, profile);
  }

  static MyProfileModel? getProfileData(String keyProfile) { // FUcrash
    // if (_prefsInstance == null) {}
         try{
           if (_prefsInstance == null) {}

    var jsonData = _prefsInstance!.getString(keyProfile) ?? '';
 var data = json.decode(jsonData);
  return MyProfileModel.fromJson(data);
}catch(e){
  print(e);
  return null;
}
     // return MyProfileModel.fromJson(json.decode(_prefsInstance!.getString(keyProfile) ?? ''));
    
   }

  static List<CategoryResult>? getCategoryType() {
    final categoryData = <CategoryResult>[];

    try {
      if (_prefsInstance == null) {}
      json
          .decode(_prefsInstance!.getString(Constants.KEY_CATEGORYLIST)!)
          .forEach((map) {
        categoryData.add(CategoryResult.fromJson(map));
      });

      return categoryData;
    } catch (e) {}
  }

  static Future<bool> clearAllData() async {
    if (_prefsInstance == null) {}
    final instance = await _prefs!;
    return instance.clear();
  }

  static Future<bool> savePrefereDoctors(
      String keyPreferredDoctor, DoctorIds doctorIds) async {
    final instance = await _prefs!;
    var doctorProfile = json.encode(doctorIds);

    return instance.setString(keyPreferredDoctor, doctorProfile);
  }

  static Future<bool> savePrefereHospital(
      String keyPrefrredHospital, HospitalIds hospitalIds) async {
    final instance = await _prefs!;
    final hospitalData = json.encode(hospitalIds);

    return instance.setString(keyPrefrredHospital, hospitalData);
  }

  static Future<bool> savePreferedLab(
      String keyPreferredLab, LaboratoryIds laboratoryIds) async {
    final instance = await _prefs!;
    var labData = json.encode(laboratoryIds);

    return instance.setString(keyPreferredLab, labData);
  }

  static Future<bool> isCorpUserWelcomeMessageDialogShown(
      bool isCorpUserWelcomeMessageDialogShown) async {
    final instance = await _prefs!;
    return instance.setBool(
        Constants.KEY_CORP_USER_MESSAGE, isCorpUserWelcomeMessageDialogShown);
  }

  static Future<bool?> getIsCorpUserWelcomeMessageDialogShown() async {
    final instance = await _prefs!;
    return instance.getBool(Constants.KEY_CORP_USER_MESSAGE);
  }

  static Future<bool> saveActiveMembershipStatus(bool membershipStatus) async {
    final instance = await _prefs!;
    return instance.setBool(
      Constants.KEY_IS_Active_Membership,
      membershipStatus,
    );
  }

  static Future<bool> setAddPlanButton(bool planButtonValue) async {
    final instance = await _prefs!;
    return instance.setBool(
      Constants.KEY_ADD_PLAN_BUTTON,
      planButtonValue,
    );
  }

  static Future<bool> setCartEnable(bool cartEnable) async {
    final instance = await _prefs!;
    return instance.setBool(
      Constants.KEY_CART_PLAN,
      cartEnable,
    );
  }

  static Future<bool> setUnSubscribeValue(bool subscribeValue) async {
    final instance = await _prefs!;
    return instance.setBool(
      Constants.KEY_UN_SUBCRIBE_BTN,
      subscribeValue,
    );
  }

  static Future<bool?> getAddPlanBtn() async {
    final instance = await _prefs!;
    return instance.getBool(Constants.KEY_ADD_PLAN_BUTTON);
  }

  static Future<bool?> getCartEnable() async {
    final instance = await _prefs!;
    return instance.getBool(Constants.KEY_CART_PLAN);
  }

  static Future<bool?> getUnSubscribeValue() async {
    final instance = await _prefs!;
    return instance.getBool(Constants.KEY_UN_SUBCRIBE_BTN);
  }

  static Future<bool?> getActiveMembershipStatus() async {
    final instance = await _prefs!;
    return instance.getBool(
      Constants.KEY_IS_Active_Membership,
    );
  }

  static Future<DoctorIds> getPreferedDoctor(String keyPreferredDoctor) async {
    if (_prefsInstance == null) {}
    return DoctorIds.fromJson(
        json.decode(_prefsInstance!.getString(keyPreferredDoctor)!));
  }

  static Future<HospitalIds> getPreferredHospital(
      String keyPreferredHospital) async {
    if (_prefsInstance == null) {}
    return HospitalIds.fromJson(
        json.decode(_prefsInstance!.getString(keyPreferredHospital)!));
  }

  static Future<LaboratoryIds> getPreferredLab(String keyPreferredLab) async {
    if (_prefsInstance == null) {}
    return LaboratoryIds.fromJson(
        json.decode(_prefsInstance!.getString(keyPreferredLab)!));
  }

  static Future<bool> saveInt(String key, int value) async {
    final instance = await _prefs!;
    return instance.setInt(key, value);
  }

  static int? getIntValue(String key) {
    try {
      return _prefsInstance!.getInt(key);
    } catch (e) {}
  }

  static Future<bool> saveCompleteData(
      String keyCompletedData, HealthRecordList? completeData) async {
    final instance = await _prefs!;
    final completeDataStr = json.encode(completeData);

    return instance.setString(keyCompletedData, completeDataStr);
  }

  static HealthRecordList? getCompleteData(String keyCompletedData) {
    try {
      if (_prefsInstance == null) {}
      return HealthRecordList.fromJson(
          json.decode(_prefsInstance!.getString(keyCompletedData)!));
    } catch (e) {}
  }

  static List<CategoryResult>? getCategoryTypeDisplay(String key) {
    var categoryData = <CategoryResult>[];

    try {
      if (_prefsInstance == null) {}
      json.decode(_prefsInstance!.getString(key)!).forEach((map) {
        categoryData.add(CategoryResult.fromJson(map));
      });

      return categoryData;
    } catch (e) {}
  }

  //save family data to preference

  static Future<bool> saveFamilyData(
      String keyFamily, FamilyMemberResult? familyData) async {
    final instance = await _prefs!;

    try {
      var family = json.encode(familyData);

      return instance.setString(keyFamily, family);
    } catch (e) {
      return instance.setString(keyFamily, ""); // null to ""
    }
  }

  static FamilyData? getFamilyData(String keyFamily) {
    try {
      if (_prefsInstance == null) {}

      return FamilyData.fromJson(
          json.decode(_prefsInstance!.getString(keyFamily)!));
    } catch (e) {}
  }

  static Future<bool> saveFamilyDataNew(
      String keyFamily, FamilyMemberResult familyData) async {
    final instance = await _prefs!;

    try {
      var family = json.encode(familyData);

      return instance.setString(keyFamily, family);
    } catch (e) {
      return instance.setString(keyFamily, "");// null to ""
    }
  }

  static Future<bool> saveLanguageList(
      String membershipKey, List<LanguageResult>? categoryList) async {
    final instance = await _prefs!;

    return instance.setString(membershipKey, json.encode(categoryList));
  }

  static List<LanguageResult>? getLanguagegeList(String keyLanguage) {
    var categoryData = <LanguageResult>[];

    try {
      if (_prefsInstance == null) {}
      json.decode(_prefsInstance!.getString(keyLanguage)!).forEach((map) {
        categoryData.add(LanguageResult.fromJson(map));
      });

      return categoryData;
    } catch (e) {}
  }

  static FamilyMemberResult? getFamilyDataNew(String keyFamily) {
    try {
      if (_prefsInstance == null) {}

      return FamilyMemberResult.fromJson(
          json.decode(_prefsInstance!.getString(keyFamily)!));
    } catch (e) {}
  }

  static Future<bool> saveFamilyRelationShip(
      String keyFamilyrel, RelationShipResponseList? familyData) async {
    final instance = await _prefs!;
              
    try {
      final family = json.encode(familyData);

      return instance.setString(keyFamilyrel, family);
    } catch (e) {
      
      return instance.setString(keyFamilyrel, ""); // null to ""
    }
  }

  static RelationShipResponseList? getFamilyRelaton(String keyFamilyrel) {
    try {
      if (_prefsInstance == null) {}

      return RelationShipResponseList?.fromJson(
          json.decode(_prefsInstance!.getString(keyFamilyrel)!));
    } catch (e) {
      return null;
    }
  }

  static Future<bool> saveRelationshipArray(
      String familyRelation, List<RelationsShipModel>? relationShipAry) async {
    final instance = await _prefs!;

    return instance.setString(familyRelation, json.encode(relationShipAry));
  }

  static List<RelationsShipModel>? getFamilyRelationship(
      String keyFamilyRelation) {
    var categoryData = <RelationsShipModel>[];

    try {
      if (_prefsInstance == null) {}
      json.decode(_prefsInstance!.getString(keyFamilyRelation)!).forEach((map) {
        categoryData.add(RelationsShipModel.fromJson(map));
      });

      return categoryData;
    } catch (e) {}
  }

  static bool? getIfMemberShipIsAcive() {
    return _prefsInstance!.getBool(Constants.KEY_IS_Active_Membership_SELECTED);
  }

  static Future<bool> saveIfMemberShipIsActive(bool membershipStatus) async {
    final instance = await _prefs!;
    return instance.setBool(
      Constants.KEY_IS_Active_Membership_SELECTED,
      membershipStatus,
    );
  }

  static bool getIfQurhomeisAcive() {
    return _prefsInstance!.getBool(
          Constants.KEY_IS_Active_Qurhome,
        ) ??
        false;
  }

  static Future<bool> saveIfQurhomeisAcive({
    bool qurhomeStatus = false,
  }) async {
    final instance = await _prefs!;
    return instance.setBool(
      Constants.KEY_IS_Active_Qurhome,
      qurhomeStatus,
    );
  }

  static Future<bool> saveEnableAppLock({
    bool appLockStatus = false,
  }) async {
    final instance = await _prefs;
    return instance!.setBool(
      Constants.enableAppLock,
      appLockStatus,
    );
  }


  static Future<bool> saveEnableDeleteAccount({
    bool deleteAccountStatus = false,
  }) async {
    final instance = await _prefs;
    return instance!.setBool(
      Constants.enableDeleteAccount,
      deleteAccountStatus,
    );
  }

  static bool getEnableDeleteAccount() {
    return _prefsInstance!.getBool(
          Constants.enableDeleteAccount,
        ) ??
        false;
  }

  static bool getEnableAppLock() {
    return _prefsInstance!.getBool(
          Constants.enableAppLock,
        ) ??
        false;
  }

  static bool getCallNotificationReceived() {
    return _prefsInstance!.getBool(
          Constants.callNotificationReceived,
        ) ??
        false;
  }

  static Future<bool> setCallNotificationRecieved({
    bool isCalled = false,
  }) async {
    final instance = await _prefs;
    return instance!.setBool(
      Constants.callNotificationReceived,
      isCalled,
    );
  }

  // static Future<bool> setNotificationCalled({
  //   bool isCalled = false,
  // }) async {
  //   final instance = await _prefs;
  //   return instance.setBool(
  //     Constants.notificationCalled,
  //     isCalled,
  //   );
  // }

  // static bool getNotificationCalled() {
  //   return _prefsInstance.getBool(
  //         Constants.notificationCalled,
  //       ) ??
  //       false;
  // }

  static bool getIfQurhomeisDefaultUI() {
    return _prefsInstance!.getBool(
          Constants.QurhomeDefaultUI,
        ) ??
        false;
  }

  static Future<bool?> saveQurhomeAsDefaultUI({
    bool qurhomeStatus = false,
  }) async {
    try {
      CommonUtil.updateDefaultUIStatus(qurhomeStatus);
      if (Platform.isIOS) {
        reponseToRemoteNotificationMethodChannel.invokeListMethod(
          QurhomeDefaultUI,
          {'status': (qurhomeStatus)},
        );
      } else {
        if (qurhomeStatus) {
          CommonUtil().enableBackgroundNotification();
        } else {
          CommonUtil().disableBackgroundNotification();
        }
      }
      final instance = await _prefs!;
      return instance.setBool(
        Constants.QurhomeDefaultUI,
        qurhomeStatus,
      );
    } catch (e) {
      //print(e);
    }
  }

  static save(String key, value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(value));
  }

  static UserModel getPatientDetails(String keyProfile) {
    if (_prefsInstance == null) {}
    return UserModel.fromJson(
        json.decode(_prefsInstance!.getString(keyProfile)!));
  }

  static Future<bool> savePreferredMeasurement(String keyCompletedData,
      PreferredMeasurement preferredMeasurementNew) async {
    final instance = await _prefs!;
    final completeDataStr = json.encode(preferredMeasurementNew);

    return instance.setString(keyCompletedData, completeDataStr);
  }

  static PreferredMeasurement? getPreferredMeasurement(String keyCompletedData) {
    try {
      if (_prefsInstance == null) {}
      return PreferredMeasurement.fromJson(
          json.decode(_prefsInstance!.getString(keyCompletedData)!));
    } catch (e) {}
  }
}

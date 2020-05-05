import 'dart:core';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/model/Media/MediaTypeResponse.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/model/user/ProfileCompletedata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class PreferenceUtil {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static SharedPreferences _prefsInstance;
  static bool _initCalled = false;

  static void init() async {
    _initCalled = true;
    _prefsInstance = await _prefs;
  }

  static void dispose() {
    _prefs = null;
    _prefsInstance = null;
  }

  static bool isKeyValid(String key) {
    return _prefsInstance.containsKey(key);
  }

  static Future<bool> saveMediaData(
      String keyProfile, MediaData mediaData) async {
    print('profile data in shared preference : $mediaData');
    var instance = await _prefs;
    String profile = json.encode(mediaData);

    return instance.setString(keyProfile, profile);
  }

  static MediaData getMediaData(String keyProfile) {
    if (_prefsInstance == null) {}
    return MediaData.fromJson(
        json.decode(_prefsInstance.getString(keyProfile)));
  }

  static Future<bool> saveMediaType(
      String membershipKey, List<MediaData> mediaDataList) async {
    var instance = await _prefs;

    return instance.setString(membershipKey, json.encode(mediaDataList));
  }

  static Future<bool> saveString(String key, String value) async {
    var instance = await _prefs;
    return instance.setString(key, value);
  }

  /* static Future<bool> savePreferredMaya(String key, String value) async {
    var instance = await _prefs;
    return instance.setString(key, value);
  } */

  static List<MediaData> getMediaType() {
    List<MediaData> mediaData = new List();

    if (_prefsInstance == null) {}
    json
        .decode(_prefsInstance.getString(Constants.KEY_METADATA))
        .forEach((map) {
      mediaData.add(new MediaData.fromJson(map));
    });

    return mediaData;
  }

  static String getStringValue(String key) {
    return _prefsInstance.getString(key);
  }

  static Future<bool> saveTheme(String key, int value) async {
    var instance = await _prefs;
    return instance.setInt(key, value);
  }

  static int getSavedTheme(String key) {
    return _prefsInstance.getInt(key);
  }

  static Future<bool> saveCategoryList(
      String membershipKey, List<CategoryData> categoryList) async {
    var instance = await _prefs;

    for (CategoryData categoryData in categoryList) {
      if (categoryData.categoryDescription ==
          CommonConstants.categoryDescriptionVoiceRecord) {
        saveString(Constants.KEY_VOICE_ID, categoryData.id);
      }
    }

    return instance.setString(membershipKey, json.encode(categoryList));
  }

  static Future<bool> saveProfileData(
      String keyProfile, MyProfile profileData) async {
    print('profile data in shared preference : $profileData');
    var instance = await _prefs;
    String profile = json.encode(profileData);

    return instance.setString(keyProfile, profile);
  }

  static MyProfile getProfileData(String keyProfile) {
    if (_prefsInstance == null) {}
    return MyProfile.fromJson(
        json.decode(_prefsInstance.getString(keyProfile)));
  }

  static List<CategoryData> getCategoryType() {
    List<CategoryData> categoryData = new List();

    try {
      if (_prefsInstance == null) {}
      json
          .decode(_prefsInstance.getString(Constants.KEY_CATEGORYLIST))
          .forEach((map) {
        categoryData.add(new CategoryData.fromJson(map));
      });

      return categoryData;
    } catch (e) {}
  }

  static Future<bool> clearAllData() async {
    if (_prefsInstance == null) {}
    var instance = await _prefs;
    return instance.clear();
  }

  static Future<bool> savePrefereDoctors(
      String keyPreferredDoctor, DoctorIds doctorIds) async {
    var instance = await _prefs;
    String doctorProfile = json.encode(doctorIds);

    return instance.setString(keyPreferredDoctor, doctorProfile);
  }

  static Future<bool> savePrefereHospital(
      String keyPrefrredHospital, HospitalIds hospitalIds) async {
    var instance = await _prefs;
    String hospitalData = json.encode(hospitalIds);

    return instance.setString(keyPrefrredHospital, hospitalData);
  }

  static Future<bool> savePreferedLab(
      String keyPreferredLab, LaboratoryIds laboratoryIds) async {
    var instance = await _prefs;
    String labData = json.encode(laboratoryIds);

    return instance.setString(keyPreferredLab, labData);
  }

  static Future<DoctorIds> getPreferedDoctor(String keyPreferredDoctor) async {
    if (_prefsInstance == null) {}
    return DoctorIds.fromJson(
        json.decode(_prefsInstance.getString(keyPreferredDoctor)));
  }

  static Future<HospitalIds> getPreferredHospital(
      String keyPreferredHospital) async {
    if (_prefsInstance == null) {}
    return HospitalIds.fromJson(
        json.decode(_prefsInstance.getString(keyPreferredHospital)));
  }

  static Future<LaboratoryIds> getPreferredLab(String keyPreferredLab) async {
    if (_prefsInstance == null) {}
    return LaboratoryIds.fromJson(
        json.decode(_prefsInstance.getString(keyPreferredLab)));
  }

  static Future<bool> saveInt(String key, int value) async {
    var instance = await _prefs;
    return instance.setInt(key, value);
  }

  static int getIntValue(String key) {
    try {
      return _prefsInstance.getInt(key);
    } catch (e) {}
  }

  static Future<bool> saveCompleteData(
      String keyCompletedData, CompleteData completeData) async {
    print('profile data in shared preference : $completeData');
    var instance = await _prefs;
    String completeDataStr = json.encode(completeData);

    return instance.setString(keyCompletedData, completeDataStr);
  }

  static CompleteData getCompleteData(String keyCompletedData) {
    try {
      if (_prefsInstance == null) {}
      return CompleteData.fromJson(
          json.decode(_prefsInstance.getString(keyCompletedData)));
    } catch (e) {}
  }

  static List<CategoryData> getCategoryTypeDisplay(String key) {
    List<CategoryData> categoryData = new List();

    try {
      if (_prefsInstance == null) {}
      json.decode(_prefsInstance.getString(key)).forEach((map) {
        categoryData.add(new CategoryData.fromJson(map));
      });

      return categoryData;
    } catch (e) {}
  }

  //save family data to preference

  static Future<bool> saveFamilyData(
      String keyFamily, FamilyData familyData) async {
    var instance = await _prefs;

    try {
      String family = json.encode(familyData);

      return instance.setString(keyFamily, family);
    } catch (e) {
      return instance.setString(keyFamily, null);
    }
  }

  static FamilyData getFamilyData(String keyFamily) {
    try {
      if (_prefsInstance == null) {}

      return FamilyData.fromJson(
          json.decode(_prefsInstance.getString(keyFamily)));
    } catch (e) {}
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_family/models/FamilyData.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/my_family/models/RelationShip.dart';
import 'package:myfhb/my_family/models/relationship_response_list.dart';
import 'package:myfhb/my_family/models/relationships.dart';
import 'package:myfhb/src/model/Category/catergory_result.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/model/Media/media_result.dart';
import 'package:myfhb/src/model/user/DoctorIds.dart';
import 'package:myfhb/src/model/user/HospitalIds.dart';
import 'package:myfhb/src/model/user/LaboratoryIds.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      String keyProfile, MediaResult mediaData) async {
    var instance = await _prefs;
    String profile = json.encode(mediaData);

    return instance.setString(keyProfile, profile);
  }

  static MediaResult getMediaData(String keyProfile) {
    if (_prefsInstance == null) {}
    return MediaResult.fromJson(
        json.decode(_prefsInstance.getString(keyProfile)));
  }

  static Future<bool> saveMediaType(
      String membershipKey, List<MediaResult> mediaDataList) async {
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

  static List<MediaResult> getMediaType() {
    List<MediaResult> mediaData = new List();

    if (_prefsInstance == null) {}
    json
        .decode(_prefsInstance.getString(Constants.KEY_METADATA))
        .forEach((map) {
      mediaData.add(new MediaResult.fromJson(map));
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
      String membershipKey, List<CategoryResult> categoryList) async {
    var instance = await _prefs;

    for (CategoryResult categoryData in categoryList) {
      if (categoryData.categoryDescription ==
          CommonConstants.categoryDescriptionVoiceRecord) {
        saveString(Constants.KEY_VOICE_ID, categoryData.id);
      }
    }

    return instance.setString(membershipKey, json.encode(categoryList));
  }

  static Future<bool> saveProfileData(
      String keyProfile, MyProfileModel profileData) async {
    var instance = await _prefs;
    String profile = json.encode(profileData);

    return instance.setString(keyProfile, profile);
  }

  static MyProfileModel getProfileData(String keyProfile) {
    if (_prefsInstance == null) {}
    return MyProfileModel.fromJson(
        json.decode(_prefsInstance.getString(keyProfile)));
  }

  static List<CategoryResult> getCategoryType() {
    List<CategoryResult> categoryData = new List();

    try {
      if (_prefsInstance == null) {}
      json
          .decode(_prefsInstance.getString(Constants.KEY_CATEGORYLIST))
          .forEach((map) {
        categoryData.add(new CategoryResult.fromJson(map));
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
      String keyCompletedData, HealthRecordList completeData) async {
    var instance = await _prefs;
    String completeDataStr = json.encode(completeData);

    return instance.setString(keyCompletedData, completeDataStr);
  }

  static HealthRecordList getCompleteData(String keyCompletedData) {
    try {
      if (_prefsInstance == null) {}
      return HealthRecordList.fromJson(
          json.decode(_prefsInstance.getString(keyCompletedData)));
    } catch (e) {}
  }

  static List<CategoryResult> getCategoryTypeDisplay(String key) {
    List<CategoryResult> categoryData = new List();

    try {
      if (_prefsInstance == null) {}
      json.decode(_prefsInstance.getString(key)).forEach((map) {
        categoryData.add(new CategoryResult.fromJson(map));
      });

      return categoryData;
    } catch (e) {}
  }

  //save family data to preference

  static Future<bool> saveFamilyData(
      String keyFamily, FamilyMemberResult familyData) async {
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

  static Future<bool> saveFamilyDataNew(
      String keyFamily, FamilyMemberResult familyData) async {
    var instance = await _prefs;

    try {
      String family = json.encode(familyData);

      return instance.setString(keyFamily, family);
    } catch (e) {
      return instance.setString(keyFamily, null);
    }
  }

  static FamilyMemberResult getFamilyDataNew(String keyFamily) {
    try {
      if (_prefsInstance == null) {}

      return FamilyMemberResult.fromJson(
          json.decode(_prefsInstance.getString(keyFamily)));
    } catch (e) {}
  }

  static Future<bool> saveFamilyRelationShip(
      String keyFamilyrel, RelationShipResponseList familyData) async {
    var instance = await _prefs;

    try {
      String family = json.encode(familyData);

      return instance.setString(keyFamilyrel, family);
    } catch (e) {
      return instance.setString(keyFamilyrel, null);
    }
  }

  static RelationShipResponseList getFamilyRelaton(String keyFamilyrel) {
    try {
      if (_prefsInstance == null) {}

      return RelationShipResponseList.fromJson(
          json.decode(_prefsInstance.getString(keyFamilyrel)));
    } catch (e) {
      return null;
    }
  }

  static Future<bool> saveRelationshipArray(
      String familyRelation, List<RelationsShipCollection> relationShipAry) async {
    var instance = await _prefs;

    return instance.setString(familyRelation, json.encode(relationShipAry));
  }

  static List<RelationsShipCollection> getFamilyRelationship(String keyFamilyRelation) {
    List<RelationsShipCollection> categoryData = new List();

    try {
      if (_prefsInstance == null) {}
      json.decode(_prefsInstance.getString(keyFamilyRelation)).forEach((map) {
        categoryData.add(new RelationsShipCollection.fromJson(map));
      });

      return categoryData;
    } catch (e) {}
  }

  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }
}

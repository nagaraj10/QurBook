import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:http/http.dart' as http;
import 'package:image_downloader/image_downloader.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_family_user_info/models/add_family_user_info_arguments.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/bookmark_record/bloc/bookmarkRecordBloc.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/device_integration/viewModel/deviceDataHelper.dart';
import 'package:myfhb/global_search/model/Data.dart';
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/LinkedData.dart';
import 'package:myfhb/my_family/models/ProfileData.dart';
import 'package:myfhb/my_family/models/Sharedbyme.dart';
import 'package:myfhb/my_providers/models/ProfilePicThumbnail.dart';
import 'package:myfhb/myfhb_weview/myfhb_webview.dart';
import 'package:myfhb/record_detail/model/DoctorImageResponse.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/blocs/Media/MediaTypeBlock.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Authentication/DeviceInfoSucess.dart';
import 'package:myfhb/src/model/Authentication/SignOutResponse.dart';
import 'package:myfhb/src/model/Category/CategoryData.dart';
import 'package:myfhb/src/model/Category/catergory_result.dart';
import 'package:myfhb/src/model/Health/CategoryInfo.dart';
import 'package:myfhb/src/model/Health/CompleteData.dart';

import 'package:myfhb/src/model/Health/MediaMasterIds.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/MediaTypeInfo.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/model/Media/DeviceModel.dart';
import 'package:myfhb/src/model/Media/MediaData.dart';
import 'package:myfhb/src/model/Media/media_result.dart';
import 'package:myfhb/src/model/sceretLoader.dart';
import 'package:myfhb/src/model/secretmodel.dart';
import 'package:myfhb/src/model/user/DoctorIds.dart';
import 'package:myfhb/src/model/user/HospitalIds.dart';
import 'package:myfhb/src/model/user/LaboratoryIds.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/MyProfileResult.dart';
import 'package:myfhb/src/model/user/ProfileCompletedata.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/ui/user/UserAccounts.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';
import 'package:myfhb/telehealth/features/chat/view/BadgeIcon.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcase.dart';
import 'package:myfhb/constants/router_variable.dart' as router;

class CommonUtil {
  static String SHEELA_URL = "";
  static String FAQ_URL = "";
  static String GOOGLE_MAP_URL = "";
  static String GOOGLE_PLACE_API_KEY = "";
  static String GOOGLE_MAP_PLACE_DETAIL_URL = "";
  static String GOOGLE_ADDRESS_FROM__LOCATION_URL = "";
  static String GOOGLE_STATIC_MAP_URL = "";
  static String BASE_URL_FROM_RES = "";
  static String BASEURL_DEVICE_READINGS = '';

  static const secondaryGrey = 0xFF545454;

  CategoryResult categoryDataObjClone = new CategoryResult();

  static List<String> recordIds = new List();
  static List<String> notesId = new List();
  static List<String> voiceIds = new List();

  static Future<dynamic> getResourceLoader() async {
    final Future<Secret> secret =
        SecretLoader(secretPath: "secrets.json").load();
    var valueFromRes = await secret;
    return valueFromRes.myScerets;
  }

  List<HealthResult> getDataForParticularCategoryDescription(
      HealthRecordList completeData, String categoryDescription) {
    List<HealthResult> mediaMetaInfoObj = new List();
    List<HealthResult> bookMarkedData = new List();
    List<HealthResult> unBookMarkedData = new List();
    for (HealthResult mediaMetaInfo in completeData.result) {
      try {
        if (mediaMetaInfo.metadata.healthRecordType.description
            .contains(categoryDescription)) {
          if (categoryDescription ==
              CommonConstants.categoryDescriptionDevice) {
            if (mediaMetaInfo.metadata.deviceReadings != null &&
                mediaMetaInfo.metadata.deviceReadings.length > 0)
            // &&
            // mediaMetaInfo.metadata.fileName != null)
            {
              mediaMetaInfoObj.add(mediaMetaInfo);
            }
          } else {
            mediaMetaInfoObj.add(mediaMetaInfo);
          }
        }
      } catch (e) {}
    }

    if (mediaMetaInfoObj.length > 0) {
      mediaMetaInfoObj.sort((mediaMetaInfoObjCopy, mediaMetaInfoObjClone) {
        return mediaMetaInfoObjCopy.createdOn
            .compareTo(mediaMetaInfoObjClone.createdOn);
      });

      //NOTE show the bookmarked data as first
      for (HealthResult mmi in mediaMetaInfoObj) {
        if (mmi.isBookmarked == true) {
          bookMarkedData.add(mmi);
        } else {
          unBookMarkedData.add(mmi);
        }
      }
      mediaMetaInfoObj.clear();
      mediaMetaInfoObj.addAll(bookMarkedData.reversed);
      mediaMetaInfoObj.addAll(unBookMarkedData.reversed);
    }

    return mediaMetaInfoObj;
  }

  List<HealthResult> getDataForInsurance(HealthRecordList completeData,
      String categoryDescription, String mediaTypeDescription) {
    List<HealthResult> mediaMetaInfoObj = new List();

    for (HealthResult mediaMetaInfo in completeData.result) {
      if (mediaMetaInfo.metadata.healthRecordCategory != null) {
        if (mediaMetaInfo.metadata.healthRecordCategory.categoryDescription ==
                categoryDescription &&
            mediaMetaInfo.metadata.healthRecordType.description ==
                mediaTypeDescription) {
          mediaMetaInfoObj.add(mediaMetaInfo);
        }
      }
    }

    mediaMetaInfoObj.sort((mediaMetaInfoObjCopy, mediaMetaInfoObjClone) {
      return mediaMetaInfoObjCopy.metadata.healthRecordType.createdOn
          .compareTo(mediaMetaInfoObjClone.metadata.healthRecordType.createdOn);
    });
    return mediaMetaInfoObj;
  }

  List<HealthResult> getDataForHospitals(HealthRecordList completeData,
      String categoryDescription, String mediaTypeDescription) {
    List<HealthResult> mediaMetaInfoObj = new List();

    for (HealthResult mediaMetaInfo in completeData.result) {
      if (mediaMetaInfo.metadata.healthRecordCategory != null) {
        if (mediaMetaInfo.metadata.healthRecordCategory.categoryDescription ==
                categoryDescription &&
            mediaMetaInfo.metadata.healthRecordType.description ==
                mediaTypeDescription) {
          mediaMetaInfoObj.add(mediaMetaInfo);
        }
      }
    }

    mediaMetaInfoObj.sort((mediaMetaInfoObjCopy, mediaMetaInfoObjClone) {
      return mediaMetaInfoObjCopy.metadata.healthRecordType.createdOn
          .compareTo(mediaMetaInfoObjClone.metadata.healthRecordType.createdOn);
    });
    return mediaMetaInfoObj;
  }

  MediaResult getMediaTypeInfoForParticularLabel(
      String mediaId, List<MediaResult> mediaDataList, String categoryName) {
    MediaResult mediaDataObj = new MediaResult();
    MediaResult selectedMediaData;
    try {
      selectedMediaData = PreferenceUtil.getMediaData(Constants.KEY_MEDIADATA);
    } catch (e) {}

    for (MediaResult mediaData in mediaDataList) {
      if (categoryName == Constants.STR_IDDOCS) {
        if (mediaData.healthRecordCategory.id == mediaId &&
            mediaData.id == selectedMediaData.id) {
          mediaDataObj = mediaData;
          (mediaDataObj.name + ' for ' + mediaDataObj.toString());

          // break;
        }
      } else {
        if (mediaData.healthRecordCategory.id == mediaId) {
          mediaDataObj = mediaData;
        }
      }
    }

    return mediaDataObj;
  }

  CategoryResult getCategoryObjForSelectedLabel(
      String categoryId, List<CategoryResult> categoryList) {
    CategoryResult categoryObj = new CategoryResult();
    for (CategoryResult categoryData in categoryList) {
      if (categoryData.id == categoryId) {
        categoryObj = categoryData;
      }
    }

    return categoryObj;
  }

  String getMetaMasterId(MediaMetaInfo data) {
    List<MediaMasterIds> mediaMasterIdsList = new List();
    if (data.mediaMasterIds.length > 0) {
      for (MediaMasterIds mediaMasterIds in data.mediaMasterIds) {
        mediaMasterIdsList.add(mediaMasterIds);
      }
    } else {}

    return mediaMasterIdsList.length > 0 ? mediaMasterIdsList[0].id : '0';
  }

  String getCurrentDate() {
    var now = new DateTime.now();
    return new DateFormat(variable.strDateFormatDay).format(now);
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    DateTime date;
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    return date;
  }

  getDocumentImageWidget(HealthResult data) async {
    HealthReportListForUserBlock _healthReportListForUserBlock;
    _healthReportListForUserBlock = new HealthReportListForUserBlock();

    List<dynamic> imageList = new List();
    if (data.healthRecordCollection.isNotEmpty) {
      List<HealthRecordCollection> mediMasterId =
          new CommonUtil().getMetaMasterIdList(data);
      int k = 0;
      for (int i = 0; i < mediMasterId.length; i++) {
        _healthReportListForUserBlock
            .getDocumentImage(mediMasterId[i].id)
            .then((snapshot) {
          if (snapshot != null && k < mediMasterId.length) {
            k++;
            imageList.add(snapshot);
          } else {}
        });
      }
      if (k == mediMasterId.length) {
        return imageList;
      }
    } else {
      return new List();
    }
  }

  List<DeviceModel> getAllDevices(List<MediaResult> mediaList) {
    List<DeviceModel> deviceList = new List();

    for (MediaResult mediaMetaInfo in mediaList) {
      if (mediaMetaInfo.description
          .split("_")
          .contains(CommonConstants.categoryDescriptionDevice)) {
        deviceList.add(new DeviceModel(mediaMetaInfo.name, mediaMetaInfo.logo));
      }
    }
    return deviceList;
  }

  MediaResult getMediaTypeInfoForParticularDevice(
      String deviceName, List<MediaResult> mediaDataList) {
    MediaResult mediaDataObj = new MediaResult();
    for (MediaResult mediaData in mediaDataList) {
      if (mediaData.name == deviceName) {
        mediaDataObj = mediaData;

        // break;
      }
    }
    return mediaDataObj;
  }

  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, String msgToDisplay) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => true,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          msgToDisplay,
                          style: TextStyle(color: Colors.white),
                        )
                      ]),
                    )
                  ]));
        });
  }

  List<HealthRecordCollection> getMetaMasterIdList(HealthResult data) {
    List<HealthRecordCollection> mediaMasterIdsList = new List();
    try {
      if (data.healthRecordCollection != null &&
          data.healthRecordCollection.length > 0) {
        for (HealthRecordCollection mediaMasterIds
            in data.healthRecordCollection) {
          if (mediaMasterIds.fileType == ".jpg" ||
              mediaMasterIds.fileType == ".png" ||
              mediaMasterIds.fileType == ".jpeg")
            mediaMasterIdsList.add(mediaMasterIds);
        }
      }
    } catch (e) {}

    return mediaMasterIdsList.length > 0 ? mediaMasterIdsList : new List();
  }

  MediaMasterIds getMediaMasterIDForPdfType(
      List<MediaMasterIds> mediaMasterIdsList) {
    MediaMasterIds mediaMasterId = new MediaMasterIds();

    for (MediaMasterIds mediaMasterIdsObj in mediaMasterIdsList) {
      if (mediaMasterIdsObj.fileType == 'application/pdf') {
        mediaMasterId = mediaMasterIdsObj;
      }
    }

    return mediaMasterId;
  }

  HealthRecordCollection getMediaMasterIDForPdfTypeStr(
      List<HealthRecordCollection> mediaMasterIdsList) {
    HealthRecordCollection mediaMasterId;

    for (HealthRecordCollection mediaMasterIdsObj in mediaMasterIdsList) {
      if (mediaMasterIdsObj.fileType == '.pdf') {
        mediaMasterId = mediaMasterIdsObj;
      }
    }

    return mediaMasterId;
  }

  bookMarkRecord(HealthResult data, Function _refresh) {
    BookmarkRecordBloc _bookmarkRecordBloc = new BookmarkRecordBloc();

    List<String> mediaIds = [];
    mediaIds.add(data.id);
    bool _isRecordBookmarked = data.isBookmarked;
    if (_isRecordBookmarked) {
      _isRecordBookmarked = false;
    } else {
      _isRecordBookmarked = true;
    }
    HealthReportListForUserBlock _healthReportListForUserBlock =
        new HealthReportListForUserBlock();
    _bookmarkRecordBloc
        .bookMarcRecord(mediaIds, _isRecordBookmarked)
        .then((bookmarkRecordResponse) {
      _healthReportListForUserBlock.getHelthReportLists().then((value) {
        PreferenceUtil.saveCompleteData(Constants.KEY_COMPLETE_DATA, value)
            .then((value) {
          if (bookmarkRecordResponse.success) {
            _refresh();
          }
        });
      });
    });
  }

  void logout(Function(SignOutResponse) moveToLoginPage) async {
    LoginBloc loginBloc = new LoginBloc();

    MyProfileModel myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
    MyProfileResult profileResult = myProfile.result;
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    final token = await _firebaseMessaging.getToken();
    loginBloc.logout().then((signOutResponse) {
      // moveToLoginPage(signOutResponse);
      try {
        CommonUtil()
            .sendDeviceToken(
                PreferenceUtil.getStringValue(Constants.KEY_USERID),
                profileResult.userContactCollection3[0].email,
                profileResult.userContactCollection3[0].phoneNumber,
                token,
                false)
            .then((value) {
          moveToLoginPage(signOutResponse);
        });
      } catch (e) {
        moveToLoginPage(signOutResponse);
      }
    });
  }

  Sharedbyme getProfileDetails() {
    MyProfileModel myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
    MyProfileResult myProfileResult = myProfile.result;

    LinkedData linkedData =
        new LinkedData(roleName: variable.Self, nickName: variable.Self);

    String fullName =
        myProfileResult.firstName + ' ' + myProfileResult.lastName;
    ProfileData profileData = new ProfileData(
        id: PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN),
        userId: PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN),
        name: fullName ?? '',
        email: myProfileResult.userContactCollection3.length > 0
            ? myProfileResult.userContactCollection3[0].email
            : '',
        dateOfBirth: myProfileResult.dateOfBirth,
        gender: myProfileResult.gender,
        bloodGroup: myProfileResult.bloodGroup,
        isVirtualUser: myProfileResult.isVirtualUser,
        phoneNumber: myProfileResult.userContactCollection3.length > 0
            ? myProfileResult.userContactCollection3[0].phoneNumber
            : '',
        //createdOn: myProfileResult.createdOn,
        /*profilePicThumbnail: myProfileResult.profilePicThumbnailUrl,*/
        isEmailVerified: myProfileResult.isEmailVerified,
        isTempUser: myProfileResult.isTempUser,
        profilePicThumbnailURL: myProfileResult.profilePicThumbnailUrl);

    return new Sharedbyme(profileData: profileData, linkedData: linkedData);
  }

  Future<void> getMedicalPreference({Function callBackToRefresh}) async {
    /* MyProfileBloc _myProfileBloc = new MyProfileBloc();
    try {
      _myProfileBloc
          .getCompleteProfileData(Constants.KEY_USERID)
          .then((profileCompleteData) {
        if (profileCompleteData?.response?.data?.medicalPreferences != null) {
          MedicalPreferences medicalPreferences =
              profileCompleteData.response.data.medicalPreferences;

          PreferenceUtil.savePrefereDoctors(
              Constants.KEY_PREFERRED_DOCTOR, null);

          if (medicalPreferences.preferences.doctorIds != null &&
              medicalPreferences.preferences.doctorIds.length > 0) {
            medicalPreferences.preferences.doctorIds.sort(
                (a, b) => (b.isDefault ? 1 : 0).compareTo(a.isDefault ? 1 : 0));

            for (DoctorIds doctorIds
                in medicalPreferences.preferences.doctorIds) {
              if (doctorIds.isDefault) {
                PreferenceUtil.savePrefereDoctors(
                    Constants.KEY_PREFERRED_DOCTOR, doctorIds);
              }
            }
          } else {
            PreferenceUtil.savePrefereDoctors(
                Constants.KEY_PREFERRED_DOCTOR, null);
          }

          if (medicalPreferences.preferences.hospitalIds != null &&
              medicalPreferences.preferences.hospitalIds.length > 0) {
            PreferenceUtil.savePrefereHospital(
                Constants.KEY_PREFERRED_HOSPITAL, null);
            medicalPreferences.preferences.hospitalIds.sort(
                (a, b) => (b.isDefault ? 1 : 0).compareTo(a.isDefault ? 1 : 0));

            for (HospitalIds hospitalIds
                in medicalPreferences.preferences.hospitalIds) {
              if (hospitalIds.isDefault) {
                PreferenceUtil.savePrefereHospital(
                    Constants.KEY_PREFERRED_HOSPITAL, hospitalIds);
              }
            }
          } else {
            PreferenceUtil.savePrefereHospital(
                Constants.KEY_PREFERRED_HOSPITAL, null);
          }

          PreferenceUtil.savePreferedLab(Constants.KEY_PREFERRED_LAB, null);

          if (medicalPreferences.preferences.laboratoryIds != null &&
              medicalPreferences.preferences.laboratoryIds.length > 0) {
            medicalPreferences.preferences.laboratoryIds.sort(
                (a, b) => (b.isDefault ? 1 : 0).compareTo(a.isDefault ? 1 : 0));

            for (LaboratoryIds laboratoryIds
                in medicalPreferences.preferences.laboratoryIds) {
              if (laboratoryIds.isDefault) {
                PreferenceUtil.savePreferedLab(
                    Constants.KEY_PREFERRED_LAB, laboratoryIds);
              }
            }
          } else {
            PreferenceUtil.savePreferedLab(Constants.KEY_PREFERRED_LAB, null);
          }

          // PreferenceUtil.saveCompleteProfileData(Constants.KEY_COMPLETE_PROFILEDATA,profileCompleteData);
          callBackToRefresh();
        } else {
          PreferenceUtil.savePrefereDoctors(
              Constants.KEY_PREFERRED_DOCTOR, null);
          PreferenceUtil.savePrefereHospital(
              Constants.KEY_PREFERRED_HOSPITAL, null);

          PreferenceUtil.savePreferedLab(Constants.KEY_PREFERRED_LAB, null);
        }
      });
    } catch (e) {}*/
    callBackToRefresh();
  }

  int getThemeColor() {
    return PreferenceUtil.getSavedTheme(Constants.keyTheme) != null
        ? PreferenceUtil.getSavedTheme(Constants.keyTheme)
        : 0xff0a72e8;
  }

  int getMyPrimaryColor() {
    return PreferenceUtil.getSavedTheme(Constants.keyPriColor) != null
        ? PreferenceUtil.getSavedTheme(Constants.keyPriColor)
        : 0xff5f0cf9;
  }

  int getMyGredientColor() {
    return PreferenceUtil.getSavedTheme(Constants.keyGreyColor) != null
        ? PreferenceUtil.getSavedTheme(Constants.keyGreyColor)
        : 0xff9929ea;
  }

  List<CategoryData> getAllCategoryList(List<Data> data) {
    List<CategoryData> categoryDataList = new List();

    for (Data dataObj in data) {
      CategoryInfo categoryInfo = dataObj.metaInfo.categoryInfo;

      categoryDataList.add(new CategoryData(
        id: categoryInfo.id,
        categoryDescription: categoryInfo.categoryDescription,
        categoryName: categoryInfo.categoryName,
        isCreate: categoryInfo.isCreate,
        isDelete: categoryInfo.isDelete,
        isDisplay: categoryInfo.isDisplay,
        isEdit: categoryInfo.isEdit,
        isRead: categoryInfo.isRead,
        //lastModifiedOn: categoryInfo.lastModifiedOn,
        logo: categoryInfo.logo,
        isActive: true,
      ));
    }

    return removeDuplicatevalues(categoryDataList);
  }

  HealthRecordList getMediaTypeInfo(List<Data> data) {
    HealthRecordList completeData;
    List<MediaMetaInfo> mediaMetaInfoList = new List();

    for (Data dataObj in data) {
      List<MediaMasterIds> mediaMasterIdsList = new List();
      if (dataObj.mediaMasterIds != null && dataObj.mediaMasterIds.length > 0) {
        for (MediaMasterIds mediaMasterIds in dataObj.mediaMasterIds) {
          mediaMasterIdsList.add(new MediaMasterIds(
              id: mediaMasterIds.id, fileType: mediaMasterIds.fileType));
        }
      }

      CategoryInfo categoryInfo = new CategoryInfo(
          id: dataObj.metaInfo.categoryInfo.id,
          isActive: true,
          categoryDescription:
              dataObj.metaInfo.categoryInfo.categoryDescription,
          categoryName: dataObj.metaInfo.categoryInfo.categoryName,
          isCreate: dataObj.metaInfo.categoryInfo.isCreate,
          isDelete: dataObj.metaInfo.categoryInfo.isDelete,
          isDisplay: dataObj.metaInfo.categoryInfo.isDisplay,
          isEdit: dataObj.metaInfo.categoryInfo.isEdit,
          isRead: dataObj.metaInfo.categoryInfo.isRead,
          logo: dataObj.metaInfo.categoryInfo.logo,
          url: Constants.BASE_URL + dataObj.metaInfo.categoryInfo.logo);

      MediaTypeInfo mediaTypeInfo = new MediaTypeInfo(
          categoryId: dataObj.metaInfo.mediaTypeInfo.categoryId,
          createdOn: dataObj.metaInfo.mediaTypeInfo.createdOn,
          description: dataObj.metaInfo.mediaTypeInfo.description,
          id: dataObj.metaInfo.mediaTypeInfo.id,
          isActive: dataObj.metaInfo.mediaTypeInfo.isActive,
          isAITranscription: dataObj.metaInfo.mediaTypeInfo.isAITranscription,
          isCreate: dataObj.metaInfo.mediaTypeInfo.isCreate,
          isDelete: dataObj.metaInfo.mediaTypeInfo.isDelete,
          isDisplay: dataObj.metaInfo.mediaTypeInfo.isDisplay,
          isEdit: dataObj.metaInfo.mediaTypeInfo.isEdit,
          isManualTranscription:
              dataObj.metaInfo.mediaTypeInfo.isManualTranscription,
          isRead: dataObj.metaInfo.mediaTypeInfo.isRead,
          lastModifiedOn: dataObj.metaInfo.mediaTypeInfo.lastModifiedOn,
          logo: dataObj.metaInfo.mediaTypeInfo.logo,
          name: dataObj.metaInfo.mediaTypeInfo.name,
          url: Constants.BASE_URL + dataObj.metaInfo.mediaTypeInfo.logo);

      Doctor doctor;
      if (dataObj.metaInfo.doctor != null) {
        doctor = new Doctor(
          doctorId: dataObj.metaInfo.doctor.id,
          //city: dataObj.metaInfo.doctor.city,
          //description: dataObj.metaInfo.doctor.description,
          //email: dataObj.metaInfo.doctor.email,
          //isUserDefined: dataObj.metaInfo.doctor.isUserDefined,
          name: dataObj.metaInfo.doctor.name,
          specialization: dataObj.metaInfo.doctor.specialization,
          //state: dataObj.metaInfo.doctor.state
        );
      } else {
        doctor = null;
      }
      /*
      Hospital hospital;

      if (dataObj.metaInfo.hospital != null) {
        hospital = new Hospital(
          addressLine1: dataObj.metaInfo.hospital.addressLine1,
          addressLine2: dataObj.metaInfo.hospital.addressLine2,
          /*  branch: dataObj.metaInfo.hospital.branch,
          description: dataObj.metaInfo.hospital.description,
          email: dataObj.metaInfo.hospital.email,
          isUserDefined: dataObj.metaInfo.hospital.isUserDefined,
          latitude: dataObj.metaInfo.hospital.latitude,
          logoThumbnail: dataObj.metaInfo.hospital.logoThumbnail,
          longitude: dataObj.metaInfo.hospital.longitude,
          website: dataObj.metaInfo.hospital.website,*/

          city: dataObj.metaInfo.hospital.city,
          id: dataObj.metaInfo.hospital.id,

          name: dataObj.metaInfo.hospital.name,
          //zipcode: dataObj.metaInfo.hospital.zipcode,
        );
      } else {
        hospital = null;
      }

      Laboratory laboratory;

      if (dataObj.metaInfo.laboratory != null) {
        laboratory = new Laboratory(
          pincode: dataObj.metaInfo.laboratory.zipcode,
          website: dataObj.metaInfo.laboratory.website,
          name: dataObj.metaInfo.laboratory.name,
          longitude: dataObj.metaInfo.laboratory.longitude,
          logoThumbnail: dataObj.metaInfo.laboratory.logoThumbnail,
          latitude: dataObj.metaInfo.laboratory.latitude,
          isUserDefined: dataObj.metaInfo.laboratory.isUserDefined,
          id: dataObj.metaInfo.laboratory.id,
          email: dataObj.metaInfo.laboratory.email,
          description: dataObj.metaInfo.laboratory.description,
          city: dataObj.metaInfo.laboratory.city,
          branch: dataObj.metaInfo.laboratory.branch,
          addressLine2: dataObj.metaInfo.laboratory.addressLine2,
          addressLine1: dataObj.metaInfo.laboratory.addressLine1,
        );
      } else {
        laboratory = null;
      }

      List<DeviceReadings> deviceReadings = new List();

     if (dataObj.metaInfo.deviceReadings != null &&
          dataObj.metaInfo.deviceReadings.length > 0) {
        for (DeviceReadings deviceReadingsObj
            in dataObj.metaInfo.deviceReadings) {
          deviceReadings.add(new DeviceReadings(
              parameter: deviceReadingsObj.parameter,
              unit: deviceReadingsObj.unit,
              value: deviceReadingsObj.value));
        }
      } else {
        deviceReadings = new List();
      }

      MetaInfo metaInfo = new MetaInfo(
          dateOfVisit: dataObj.metaInfo.dateOfVisit,
          categoryInfo: categoryInfo,
          mediaTypeInfo: mediaTypeInfo,
          fileName: dataObj.metaInfo.fileName,
          hasVoiceNotes: dataObj.metaInfo.hasVoiceNotes,
          isDraft: dataObj.metaInfo.isDraft,
          memoText: dataObj.metaInfo.memoText,
          memoTextRaw: dataObj.metaInfo.memoTextRaw,
          sourceName: dataObj.metaInfo.sourceName,
          // doctor: doctor,
          // hospital: hospital,
          laboratory: laboratory,
          deviceReadings: deviceReadings);

      MediaMetaInfo mediaMetaInfo = new MediaMetaInfo(
          metaInfo: metaInfo,
          createdBy: dataObj.createdBy,
          createdByUser: dataObj.createdBy,
          createdOn: dataObj.createdOn,
          lastModifiedOn: dataObj.lastModifiedOn,
          isActive: dataObj.isActive,
          id: dataObj.id,
          userId: dataObj.userId,
          metaTypeId: dataObj.metaTypeId,
          isBookmarked: dataObj.isBookmarked,
          isDraft: dataObj.isDraft,
          mediaMasterIds: mediaMasterIdsList);

      mediaMetaInfoList.add(mediaMetaInfo);*/
    }

    //completeData = new HealthRecordList(mediaMetaInfo: mediaMetaInfoList);

    return completeData;
  }

  List<CategoryData> removeDuplicatevalues(List<CategoryData> items) {
    List<CategoryData> categoryDataList = new List();
    for (CategoryData categoryDataObj in items) {
      if (categoryDataList.length == 0) {
        categoryDataList.add(categoryDataObj);
      } else {
        bool condition = false;
        for (CategoryData categoryDataObjInner in categoryDataList) {
          if (categoryDataObjInner.categoryName ==
              categoryDataObj.categoryName) {
            condition = true;
          }
        }
        if (!condition) {
          categoryDataList.add(categoryDataObj);
        }
      }
    }

    return categoryDataList;
  }

  HealthRecordCollection getMediaMasterIDForAudioFileType(
      List<HealthRecordCollection> mediaMasterIdsList) {
    HealthRecordCollection mediaMasterId;

    for (HealthRecordCollection mediaMasterIdsObj in mediaMasterIdsList) {
      if (mediaMasterIdsObj.fileType == Constants.audioFileType ||
          mediaMasterIdsObj.fileType == Constants.audioFileAACType ||
          mediaMasterIdsObj.fileType == Constants.audioFileTypeAppStream) {
        mediaMasterId = mediaMasterIdsObj;
      }
    }

    return mediaMasterId;
  }

  static customShowCase(GlobalKey _key, String desc, Widget _child,
      {String title, BuildContext context}) {
    return Showcase.withWidget(
      key: _key,
      disableAnimation: false,
      shapeBorder: CircleBorder(),
      title: variable.strAPP_NAME,
      description: desc,
      child: _child,
      overlayColor: Colors.black,
      overlayOpacity: 0.8,
      height: double.infinity,
      width: double.infinity,
      container: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Image.asset(
              variable.icon_maya,
              height: 80,
              width: 80,
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    desc,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Color(CommonUtil().getMyPrimaryColor()),
                        fontFamily: variable.font_poppins),
                    maxLines: 2,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  desc,
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(CommonUtil().getMyPrimaryColor()),
                      fontFamily: variable.font_poppins),
                  softWrap: true,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  networkUI() {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: 120),
        child: Card(
          elevation: 10.0,
          //margin: EdgeInsets.only(left: 3.0,right: 3.0),
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ImageIcon(
                AssetImage(variable.icon_wifi),
                color: Color(CommonUtil().getMyPrimaryColor()),
                size: 50.0,
              ),
              Text(
                variable.strNoInternet,
                style: TextStyle(
                  color: Color(CommonUtil().getMyPrimaryColor()),
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
    );
  }

  Widget customSnack(bool isOffline) {
    return Container(
      height: 20.0,
      color: isOffline ? Colors.green : Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(isOffline ? Icons.flash_on : Icons.flash_off),
          SizedBox(
            width: 10.0,
          ),
          Text(
            isOffline ? variable.strBackOnline : variable.strNoConnection,
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
        ],
      ),
    );
  }

  String conCatenateBloodGroup(String bloodGroup) {
    String bloodGroupClone = '';
    if (bloodGroup != null && bloodGroup != '') {
      var bloodGroupSplitName = bloodGroup.split('_');
      if (bloodGroupSplitName.length > 1) {
        bloodGroupClone = bloodGroupSplitName[0] + bloodGroupSplitName[1];
      } else {
        var bloodGroupSplitName = bloodGroup.split(' ');
        if (bloodGroupSplitName.length > 1) {
          bloodGroupClone = bloodGroupSplitName[0] + bloodGroupSplitName[1];
        }
      }
    } else {}

    if (bloodGroupClone.contains(variable.strve)) {
    } else {
      bloodGroupClone = bloodGroupClone + variable.strve;
    }
    return bloodGroupClone;
  }

  String getIdForDescription(
      List<CategoryResult> categoryData, String categoryName) {
    String categoryId;
    for (CategoryResult categoryDataObj in categoryData) {
      if (categoryDataObj.categoryName == categoryName) {
        categoryId = categoryDataObj.id;
      }
    }
    return categoryId;
  }

  titleCase(str) {
    var splitStr = str.toLowerCase().split(' ');
    for (var i = 0; i < splitStr.length; i++) {
      // You do not need to check if i is larger than splitStr length, as your for does that for you
      // Assign it back to the array
      if (splitStr[i].length > 0) {
        splitStr[i] = splitStr[i][0].toUpperCase() + splitStr[i].substring(1);
      }
    }
    // Directly return the joined string
    return splitStr.join(' ');
  }

  Future<void> getAllCustomRoles() async {
    FamilyListBloc _familyListBloc = new FamilyListBloc();
    try {
      if (PreferenceUtil.getFamilyRelationship(Constants.keyFamily) != null) {
      } else {
        _familyListBloc.getCustomRoles().then((relationShip) {
          PreferenceUtil.saveRelationshipArray(
              Constants.keyFamily, relationShip.relationShipAry);
        });
      }
    } catch (e) {
      _familyListBloc.getCustomRoles().then((relationShip) {
        PreferenceUtil.saveRelationshipArray(
            Constants.keyFamily, relationShip.relationShipAry);
      });
    }
  }

  Future<void> syncDevices() async {
    DeviceDataHelper _deviceDataHelper = DeviceDataHelper();

    if (PreferenceUtil.getStringValue(Constants.activateGF) ==
            variable.strtrue &&
        PreferenceUtil.getStringValue(Constants.isFirstTym) ==
            variable.strFalse) {
      _deviceDataHelper.syncGoogleFit();
    } else if (PreferenceUtil.getStringValue(Constants.activateHK) ==
        variable.strtrue) {
      _deviceDataHelper.syncHealthKit();
    }
  }

  Future<MyProfileModel> getUserProfileData() async {
    MyProfileBloc _myProfileBloc = new MyProfileBloc();

    MyProfileModel myProfileModel = new MyProfileModel();

    _myProfileBloc.getMyProfileData(Constants.KEY_USERID).then((profileData) {
      if (profileData != null &&
          profileData.isSuccess &&
          profileData.result != null) {
        PreferenceUtil.saveProfileData(Constants.KEY_PROFILE, profileData)
            .then((value) {
          try {
            if (PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN) !=
                PreferenceUtil.getProfileData(Constants.KEY_PROFILE)) {
              PreferenceUtil.saveProfileData(
                  Constants.KEY_PROFILE, profileData);
            } else {
              PreferenceUtil.saveProfileData(
                  Constants.KEY_PROFILE, profileData);
            }
          } catch (e) {
            PreferenceUtil.saveProfileData(Constants.KEY_PROFILE, profileData);
          }

          myProfileModel = profileData;
        });
      }
      //return profileData;
    });

    _myProfileBloc
        .getMyProfileData(Constants.KEY_USERID_MAIN)
        .then((profileData) {
      if (profileData != null &&
          profileData.isSuccess &&
          profileData.result != null) {
        PreferenceUtil.saveProfileData(Constants.KEY_PROFILE_MAIN, profileData)
            .then((value) {
          try {
            if (PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN) !=
                PreferenceUtil.getProfileData(Constants.KEY_PROFILE)) {
              PreferenceUtil.saveProfileData(
                  Constants.KEY_PROFILE_MAIN, profileData);
            } else {
              PreferenceUtil.saveProfileData(
                  Constants.KEY_PROFILE_MAIN, profileData);
            }
          } catch (e) {
            PreferenceUtil.saveProfileData(
                Constants.KEY_PROFILE_MAIN, profileData);
          }

          myProfileModel = profileData;
        });
      }
      return profileData;
    });
  }

  DeviceData getDeviceList() {
    DeviceData devicelist;
    if (PreferenceUtil.getStringValue(Constants.bpMon) != variable.strFalse) {
      devicelist = DeviceData(
          title: Constants.STR_BP_MONITOR,
          icon: Constants.Devices_BP,
          icon_new: Constants.Devices_BP_Tool,
          status: 0,
          isSelected: false,
          value_name: parameters.strDataTypeBP,
          value1: 'SYS',
          value2: 'DIS',
          color: [Colors.teal, Colors.tealAccent]);
    }
    if (PreferenceUtil.getStringValue(Constants.glMon) != variable.strFalse) {
      devicelist = DeviceData(
          title: Constants.STR_GLUCOMETER,
          icon: Constants.Devices_GL,
          icon_new: Constants.Devices_GL_Tool,
          status: 0,
          isSelected: false,
          value_name: parameters.strGlusoceLevel,
          value1: 'GL',
          value2: '',
          color: [Colors.deepOrange, Colors.deepOrangeAccent]);
    }

    if (PreferenceUtil.getStringValue(Constants.oxyMon) != variable.strFalse) {
      devicelist = DeviceData(
          title: Constants.STR_PULSE_OXIMETER,
          icon: Constants.Devices_OxY,
          icon_new: Constants.Devices_OxY_Tool,
          status: 0,
          isSelected: false,
          value_name: parameters.strOxgenSaturation,
          value1: 'OS',
          value2: '',
          color: [
            Color(new CommonUtil().getMyPrimaryColor()),
            Color(new CommonUtil().getMyGredientColor())
          ]);
    }

    if (PreferenceUtil.getStringValue(Constants.wsMon) != variable.strFalse) {
      devicelist = DeviceData(
          title: Constants.STR_WEIGHING_SCALE,
          icon: Constants.Devices_WS,
          icon_new: Constants.Devices_WS_Tool,
          status: 0,
          isSelected: false,
          value_name: parameters.strWeight,
          value1: 'WT',
          value2: '',
          color: [Colors.amber[700], Colors.amber[300]]);
    }
    if (PreferenceUtil.getStringValue(Constants.thMon) != variable.strFalse) {
      devicelist = DeviceData(
          title: Constants.STR_THERMOMETER,
          icon: Constants.Devices_THM,
          icon_new: Constants.Devices_THM_Tool,
          status: 0,
          isSelected: false,
          value_name: parameters.strTemperature,
          value1: 'TEMP',
          value2: '',
          color: [Colors.indigo, Colors.indigoAccent]);
    }

    return devicelist;
  }

  Future<MyProfileModel> getMyProfile() async {
    if (PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN) != null) {
      return PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
    } else {
      return await getUserProfileData();
    }
  }

  Future<void> getMediaTypes() async {
    MediaTypeBlock _mediaTypeBlock = new MediaTypeBlock();
    try {
      if (PreferenceUtil.getMediaType() != null) {
      } else {
        _mediaTypeBlock.getMediTypesList().then((value) {});
      }
    } catch (e) {
      _mediaTypeBlock.getMediTypesList().then((value) {});
    }
  }

  String checkIfStringIsEmpty(String value) {
    return value != null ? value : '';
  }

  bool checkIfStringisNull(String value) {
    return value != null && value != 'null';
  }

  dateConversion(DateTime dateTime) {
    var newFormat = DateFormat("EEE ,MMMM d,yyyy");
    String updatedDate = newFormat.format(dateTime);

    return updatedDate;
  }

  dateConversionToDayMonthYear(DateTime dateTime) {
    var newFormat = DateFormat('d MMM, ' 'yyyy');
    String updatedDate = newFormat.format(dateTime);

    return updatedDate;
  }

  dateConversionToTime(DateTime dateTime) {
    var newFormat = DateFormat('h:mm a');
    String updatedDate = newFormat.format(dateTime);

    return updatedDate;
  }

  stringToDateTime(String string) {
    DateTime dateTime = DateTime.parse(string);

    return dateTime;
  }

  removeLastThreeDigits(String string) {
    String removedString = '';
    removedString = string.substring(0, string.length - 3);

    return removedString;
  }

  dateConversionToApiFormat(DateTime dateTime) {
    var newFormat = DateFormat('yyyy-MM-dd');
    String updatedDate = newFormat.format(dateTime);
    return updatedDate;
  }

  List<CategoryResult> fliterCategories(List<CategoryResult> data) {
    List<CategoryResult> filteredCategoryData = new List();
    for (CategoryResult dataObj in data) {
      if (dataObj.isDisplay &&
          dataObj.categoryName != Constants.STR_FEEDBACK &&
          dataObj.categoryName != Constants.STR_CLAIMSRECORD &&
          dataObj.categoryName != Constants.STR_WEARABLES) {
        if (!filteredCategoryData.contains(dataObj)) {
          filteredCategoryData.add(dataObj);
        }
      }
    }

    int i = 0;
    for (CategoryResult categoryDataObj in filteredCategoryData) {
      if (categoryDataObj.categoryDescription ==
          CommonConstants.categoryDescriptionOthers) {
        categoryDataObjClone = categoryDataObj;
        // filteredCategoryData.removeAt(i);
        break;
      }
      i++;
    }

    filteredCategoryData.sort((a, b) {
      return a.categoryDescription
          .toLowerCase()
          .compareTo(b.categoryDescription.toLowerCase());
    });

    return filteredCategoryData;
  }

  CategoryResult getCatgeoryLabel(List<CategoryResult> filteredCategoryData) {
    for (CategoryResult categoryDataObj in filteredCategoryData) {
      if (categoryDataObj.categoryDescription ==
          CommonConstants.categoryDescriptionOthers) {
        categoryDataObjClone = categoryDataObj;
      }
    }
    return categoryDataObjClone;
  }

  static Future<void> askPermissionForCameraAndMic() async {
//    await PermissionHandler().requestPermissions(
//      [PermissionGroup.camera, PermissionGroup.microphone],
//    );

    PermissionStatus status = await Permission.microphone.request();
    PermissionStatus cameraStatus = await Permission.camera.request();

    if (status == PermissionStatus.granted &&
        cameraStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(cameraStatus, status);
      return false;
    }
  }

  static void _handleInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus microphonePermissionStatus,
  ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to camera and microphone denied",
          details: null);
    } else if (cameraPermissionStatus == PermissionStatus.permanentlyDenied &&
        microphonePermissionStatus == PermissionStatus.permanentlyDenied) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  getDoctorProfileImageWidget(String doctorUrl) {
    if (doctorUrl != null && doctorUrl != '') {
      return Image.network(
        doctorUrl,
        height: 50,
        width: 50,
        fit: BoxFit.cover,
      );
    } else {
      return new SizedBox(
        width: 50.0,
        height: 50.0,
        child: Container(width: 50, height: 50, color: Colors.grey[200]),
      );
    }

    ///load until snapshot.hasData resolves to true
  }

  Future<DeviceInfoSucess> sendDeviceToken(String userId, String email,
      String user_mobile_no, String deviceId, bool isActive) async {
    var jsonParam;
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    ApiBaseHelper apiBaseHelper = new ApiBaseHelper();

    final token = await _firebaseMessaging.getToken();
    Map<String, dynamic> deviceInfo = new Map();
    Map<String, dynamic> user = new Map();
    Map<String, dynamic> jsonData = new Map();

    user['id'] = userId;
    deviceInfo['user'] = user;
    deviceInfo['phoneNumber'] = user_mobile_no;
    deviceInfo['email'] = email;
    deviceInfo['isActive'] = isActive;
    deviceInfo['deviceTokenId'] = token;

    jsonData['deviceInfo'] = deviceInfo;
    if (Platform.isIOS) {
      jsonData['platformCode'] = 'IOSPLT';
      jsonData['deviceTypeCode'] = 'IPHONE';
    } else {
      jsonData['platformCode'] = 'ANDPLT';
      jsonData["deviceTypeCode"] = 'ANDROID';
    }

    var params = json.encode(jsonData);

    final response =
        await apiBaseHelper.postDeviceId('device-info', params, isActive);
    if (isActive) {
      PreferenceUtil.saveString(Constants.KEY_DEVICEINFO, variable.strtrue);
    } else {
      PreferenceUtil.saveString(Constants.KEY_DEVICEINFO, variable.strFalse);
    }
    return DeviceInfoSucess.fromJson(response);
  }

  static Future<File> downloadFile(String url, String extension) async {
    try {
      http.Client _client = new http.Client();
      var req = await _client.get(Uri.parse(url));
      var bytes = req.bodyBytes;
      String dir = Platform.isIOS
          ? await FHBUtils.createFolderInAppDocDirForIOS("images")
          : await FHBUtils.createFolderInAppDocDir('images');
      File file = new File('$dir/${basename(url)}$extension');
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      print('$e exception thrown');
    }
  }

  static void downloadMultipleFile(List images, BuildContext context) async {
    for (var currentImage in images) {
      try {
        var _currentImage =
            '${currentImage.response.data.fileContent}${currentImage.response.data.fileType}';
        var dir = await FHBUtils.createFolderInAppDocDir('images');
        var response = await Dio().get(currentImage.response.data.fileContent,
            options: Options(responseType: ResponseType.bytes));
        File file = File('$dir/${basename(_currentImage)}');
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();

        //var img = await ImageDownloader.downloadImage(file.path);
        //var img_path = await ImageDownloader.findPath(img);
        // currentImage =
        //     '${basename(currentImage.response.data.fileContent)}${currentImage.response.data.fileType}';
        // var req =
        //     await http.get(Uri.parse(currentImage.response.data.fileContent));
        // var bytes = req.bodyBytes;
        // String dir = (await getTemporaryDirectory()).path;
        // File file = new File(
        //     '$dir/${basename(currentImage.response.data.fileContent)}${currentImage.response.data.fileType}');
        // await file.writeAsBytes(bytes);
        /* var file_status =
            await GallerySaver.saveImage(file.path, albumName: 'myfhb');
        print('image file save status $file_status');
*/
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: const Text(variable.strFilesDownloaded),
        //   backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        // ));
      } catch (error) {
        print('$error exception thrown');
      }
    }
    Get.snackbar('status', variable.strFilesDownloaded);
  }

  List<HealthRecordCollection> getMetaMasterIdListNew(HealthResult data) {
    List<HealthRecordCollection> mediaMasterIdsList = new List();
    try {
      if (data.healthRecordCollection != null &&
          data.healthRecordCollection.length > 0) {
        for (HealthRecordCollection mediaMasterIds
            in data.healthRecordCollection) {
          if (mediaMasterIds.fileType == ".jpg" ||
              mediaMasterIds.fileType == ".png" ||
              mediaMasterIds.fileType == ".pdf" ||
              mediaMasterIds.fileType == ".jpeg")
            mediaMasterIdsList.add(mediaMasterIds);
        }
      }
    } catch (e) {}

    return mediaMasterIdsList.length > 0 ? mediaMasterIdsList : new List();
  }

  void openWebViewNew(String title, String url, bool isLocal) {
    Get.to(MyFhbWebView(title: title, selectedUrl: url, isLocalAsset: isLocal));
  }

  void mSnackbar(BuildContext context, String message, String actionName) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        elevation: 5.0,
        action: SnackBarAction(
            label: actionName,
            onPressed: () async {
              MyProfileModel myProfile = await fetchUserProfileInfo();
              if (myProfile?.result != null) {
                Navigator.pushNamed(context, router.rt_AddFamilyUserInfo,
                    arguments: AddFamilyUserInfoArguments(
                        myProfileResult: myProfile?.result,
                        fromClass: CommonConstants.user_update));
              } else {
                FlutterToast()
                    .getToast('Unable to Fetch User Profile data', Colors.red);
              }
            }),
        duration: const Duration(seconds: 10),
      ),
    );
  }

  Future<MyProfileModel> fetchUserProfileInfo() async {
    var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    MyProfileModel myProfile =
        await AddFamilyUserInfoRepository().getMyProfileInfoNew(userid);
    return myProfile;
  }

  Widget getNotificationIcon(BuildContext context) {
    try {
      int count = 0;
      String targetID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      return StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('unreadNotifications')
              .document(targetID)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              count = 0;
              if (snapshot.data.data != null) {
                if (snapshot.data['count'] != null &&
                    snapshot.data['count'] != '') {
                  count = snapshot.data['count'];
                } else {
                  count = 0;
                }
              } else {
                count = 0;
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationMain()),
                  );
                },
                child: BadgeIcon(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 30,
                    ),
                    badgeColor: ColorUtils.countColor,
                    badgeCount: count),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationMain()),
                  );
                },
                child: BadgeIcon(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 30,
                    ),
                    badgeColor: ColorUtils.countColor,
                    badgeCount: 0),
              );
            }
          });
    } catch (e) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationMain()),
          );
        },
        child: BadgeIcon(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
              size: 30,
            ),
            badgeColor: ColorUtils.countColor,
            badgeCount: 0),
      );
    }
  }
}

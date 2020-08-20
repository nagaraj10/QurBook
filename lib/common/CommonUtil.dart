import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/bookmark_record/bloc/bookmarkRecordBloc.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/global_search/model/Data.dart';
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/LinkedData.dart';
import 'package:myfhb/my_family/models/ProfileData.dart';
import 'package:myfhb/my_family/models/Sharedbyme.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/blocs/Media/MediaTypeBlock.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Authentication/SignOutResponse.dart';
import 'package:myfhb/src/model/Category/CategoryData.dart';
import 'package:myfhb/src/model/Health/CategoryInfo.dart';
import 'package:myfhb/src/model/Health/CompleteData.dart';
import 'package:myfhb/src/model/Health/DeviceReadings.dart';
import 'package:myfhb/src/model/Health/Doctor.dart';
import 'package:myfhb/src/model/Health/Hospital.dart';
import 'package:myfhb/src/model/Health/Laboratory.dart';
import 'package:myfhb/src/model/Health/MediaMasterIds.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/MediaTypeInfo.dart';
import 'package:myfhb/src/model/Health/MetaInfo.dart';
import 'package:myfhb/src/model/Media/DeviceModel.dart';
import 'package:myfhb/src/model/Media/MediaData.dart';
import 'package:myfhb/src/model/sceretLoader.dart';
import 'package:myfhb/src/model/secretmodel.dart';
import 'package:myfhb/src/model/user/DoctorIds.dart';
import 'package:myfhb/src/model/user/GeneralInfo.dart';
import 'package:myfhb/src/model/user/HospitalIds.dart';
import 'package:myfhb/src/model/user/LaboratoryIds.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/model/user/ProfileCompletedata.dart';
import 'package:myfhb/src/model/user/ProfilePicThumbnail.dart';
import 'package:myfhb/src/model/user/QualifiedFullName.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:showcaseview/showcase.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/device_integration/viewModel/deviceDataHelper.dart';

class CommonUtil {
  static String MAYA_URL = "";
  static String FAQ_URL = "";
  static String GOOGLE_MAP_URL = "";
  static String GOOGLE_PLACE_API_KEY = "";
  static String GOOGLE_MAP_PLACE_DETAIL_URL = "";
  static String GOOGLE_ADDRESS_FROM__LOCATION_URL = "";
  static String GOOGLE_STATIC_MAP_URL = "";
  static String BASE_URL_FROM_RES = "";
  static String BASE_COVER_IMAGE = "";
  static String BASE_URL_V2 = '';
  static String COGNITO_AUTH_TOKEN = '';
  static String COGNITO_AUTH_CODE = '';
  static String COGNITO_URL = '';

  CategoryData categoryDataObjClone = new CategoryData();

  static Future<dynamic> getResourceLoader() async {
    final Future<Secret> secret =
        SecretLoader(secretPath: "secrets.json").load();
    var valueFromRes = await secret;
    return valueFromRes.myScerets;
  }

  List<MediaMetaInfo> getDataForParticularCategoryDescription(
      CompleteData completeData, String categoryDescription) {
    List<MediaMetaInfo> mediaMetaInfoObj = new List();
    List<MediaMetaInfo> bookMarkedData = new List();
    List<MediaMetaInfo> unBookMarkedData = new List();
    for (MediaMetaInfo mediaMetaInfo in completeData.mediaMetaInfo) {
      if (mediaMetaInfo.metaInfo.categoryInfo.categoryDescription ==
          categoryDescription) {
        if (categoryDescription == CommonConstants.categoryDescriptionDevice) {
          if (mediaMetaInfo.metaInfo.deviceReadings != null &&
              mediaMetaInfo.metaInfo.deviceReadings.length > 0 &&
              mediaMetaInfo.metaInfo.fileName != null) {
            mediaMetaInfoObj.add(mediaMetaInfo);
          }
        } else {
          mediaMetaInfoObj.add(mediaMetaInfo);
        }
      }
    }

    mediaMetaInfoObj.sort((mediaMetaInfoObjCopy, mediaMetaInfoObjClone) {
      return mediaMetaInfoObjCopy.createdOn
          .compareTo(mediaMetaInfoObjClone.createdOn);
    });

    //NOTE show the bookmarked data as first
    for (MediaMetaInfo mmi in mediaMetaInfoObj) {
      if (mmi.isBookmarked == true) {
        bookMarkedData.add(mmi);
      } else {
        unBookMarkedData.add(mmi);
      }
    }
    mediaMetaInfoObj.clear();
    mediaMetaInfoObj.addAll(bookMarkedData.reversed);
    mediaMetaInfoObj.addAll(unBookMarkedData.reversed);

    return mediaMetaInfoObj;
  }

  List<MediaMetaInfo> getDataForInsurance(CompleteData completeData,
      String categoryDescription, String mediaTypeDescription) {
    List<MediaMetaInfo> mediaMetaInfoObj = new List();

    for (MediaMetaInfo mediaMetaInfo in completeData.mediaMetaInfo) {
      if (mediaMetaInfo.metaInfo.categoryInfo != null) {
        if (mediaMetaInfo.metaInfo.categoryInfo.categoryDescription ==
                categoryDescription &&
            mediaMetaInfo.metaInfo.mediaTypeInfo.description ==
                mediaTypeDescription) {
          mediaMetaInfoObj.add(mediaMetaInfo);
        }
      }
    }

    mediaMetaInfoObj.sort((mediaMetaInfoObjCopy, mediaMetaInfoObjClone) {
      return mediaMetaInfoObjCopy.createdOn
          .compareTo(mediaMetaInfoObjClone.createdOn);
    });
    return mediaMetaInfoObj;
  }

  List<MediaMetaInfo> getDataForHospitals(CompleteData completeData,
      String categoryDescription, String mediaTypeDescription) {
    List<MediaMetaInfo> mediaMetaInfoObj = new List();

    for (MediaMetaInfo mediaMetaInfo in completeData.mediaMetaInfo) {
      if (mediaMetaInfo.metaInfo.categoryInfo != null) {
        if (mediaMetaInfo.metaInfo.categoryInfo.categoryDescription ==
                categoryDescription &&
            mediaMetaInfo.metaInfo.mediaTypeInfo.description ==
                mediaTypeDescription) {
          mediaMetaInfoObj.add(mediaMetaInfo);
        }
      }
    }

    mediaMetaInfoObj.sort((mediaMetaInfoObjCopy, mediaMetaInfoObjClone) {
      return mediaMetaInfoObjCopy.createdOn
          .compareTo(mediaMetaInfoObjClone.createdOn);
    });
    return mediaMetaInfoObj;
  }

  MediaData getMediaTypeInfoForParticularLabel(
      String mediaId, List<MediaData> mediaDataList, String categoryName) {
    MediaData mediaDataObj = new MediaData();
    MediaData selectedMediaData;
    try {
      selectedMediaData = PreferenceUtil.getMediaData(Constants.KEY_MEDIADATA);
    } catch (e) {}

    for (MediaData mediaData in mediaDataList) {
      if (categoryName == Constants.STR_IDDOCS) {
        if (mediaData.categoryId == mediaId &&
            mediaData.description == selectedMediaData.description) {
          mediaDataObj = mediaData;
          (mediaDataObj.name + ' for ' + mediaDataObj.toString());

          // break;
        }
      } else {
        if (mediaData.categoryId == mediaId) {
          mediaDataObj = mediaData;
        }
      }
    }

    return mediaDataObj;
  }

  CategoryData getCategoryObjForSelectedLabel(
      String categoryId, List<CategoryData> categoryList) {
    CategoryData categoryObj = new CategoryData();
    for (CategoryData categoryData in categoryList) {
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

  getDocumentImageWidget(MediaMetaInfo data) async {
    HealthReportListForUserBlock _healthReportListForUserBlock;
    _healthReportListForUserBlock = new HealthReportListForUserBlock();

    List<dynamic> imageList = new List();
    if (data.mediaMasterIds.isNotEmpty) {
      List<MediaMasterIds> mediMasterId =
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

  List<DeviceModel> getAllDevices(List<MediaData> mediaList) {
    List<DeviceModel> deviceList = new List();

    for (MediaData mediaMetaInfo in mediaList) {
      if (mediaMetaInfo.description
          .split("_")
          .contains(CommonConstants.categoryDescriptionDevice)) {
        deviceList.add(new DeviceModel(mediaMetaInfo.name, mediaMetaInfo.logo));
      }
    }
    return deviceList;
  }

  MediaData getMediaTypeInfoForParticularDevice(
      String deviceName, List<MediaData> mediaDataList) {
    MediaData mediaDataObj = new MediaData();
    for (MediaData mediaData in mediaDataList) {
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

  List<MediaMasterIds> getMetaMasterIdList(MediaMetaInfo data) {
    List<MediaMasterIds> mediaMasterIdsList = new List();
    if (data.mediaMasterIds.length > 0) {
      for (MediaMasterIds mediaMasterIds in data.mediaMasterIds) {
        if (mediaMasterIds.fileType == "image/jpg" ||
            mediaMasterIds.fileType == "image/png")
          mediaMasterIdsList.add(mediaMasterIds);
      }
    } 

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

  String getMediaMasterIDForPdfTypeStr(
      List<MediaMasterIds> mediaMasterIdsList) {
    String mediaMasterId;

    for (MediaMasterIds mediaMasterIdsObj in mediaMasterIdsList) {
      if (mediaMasterIdsObj.fileType == 'application/pdf') {
        mediaMasterId = mediaMasterIdsObj.id;
      }
    }

    return mediaMasterId;
  }

  bookMarkRecord(MediaMetaInfo data, Function _refresh) {
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
      _healthReportListForUserBlock.getHelthReportList().then((value) {
        PreferenceUtil.saveCompleteData(
                Constants.KEY_COMPLETE_DATA, value.response.data)
            .then((value) {
          if (bookmarkRecordResponse.success) {
            _refresh();
          }
        });
      });
    });
  }

  void logout(Function(SignOutResponse) moveToLoginPage) {
    LoginBloc loginBloc = new LoginBloc();

    loginBloc.logout().then((signOutResponse) {
      moveToLoginPage(signOutResponse);
    });
  }

  Sharedbyme getProfileDetails() {
    MyProfile myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
    GeneralInfo generalInfo = myProfile.response.data.generalInfo;
    
    LinkedData linkedData =
        new LinkedData(roleName: variable.Self, nickName: variable.Self);
    ProfilePicThumbnailMain profilePicThumbnail =
        generalInfo.profilePicThumbnail != null
            ? new ProfilePicThumbnailMain(
                type: generalInfo.profilePicThumbnail.type,
                data: generalInfo.profilePicThumbnail.data)
            : null;

    QualifiedFullName qualifiedFullName = generalInfo.qualifiedFullName != null
        ? new QualifiedFullName(
            firstName: generalInfo.qualifiedFullName.firstName,
            middleName: generalInfo.qualifiedFullName.middleName,
            lastName: generalInfo.qualifiedFullName.lastName)
        : null;

    ProfileData profileData = new ProfileData(
        id: PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN),
        userId: PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN),
        name: generalInfo.name,
        email: generalInfo.email,
        dateOfBirth: generalInfo.dateOfBirth,
        gender: generalInfo.gender,
        bloodGroup: generalInfo.bloodGroup,
        isVirtualUser: generalInfo.isVirtualUser,
        phoneNumber: generalInfo.phoneNumber,
        createdOn: generalInfo.createdOn,
        profilePicThumbnail: profilePicThumbnail,
        qualifiedFullName: qualifiedFullName,
        isEmailVerified: generalInfo.isEmailVerified,
        isTempUser: generalInfo.isTempUser);

    return new Sharedbyme(profileData: profileData, linkedData: linkedData);
  }

  Future<void> getMedicalPreference({Function callBackToRefresh}) async {
    MyProfileBloc _myProfileBloc = new MyProfileBloc();
    try {
      _myProfileBloc
          .getCompleteProfileData(Constants.KEY_USERID)
          .then((profileCompleteData) {
        if (profileCompleteData.response.data.medicalPreferences != null) {
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
          callBackToRefresh();
        }
      });
    } catch (e) {}
  }

  int getThemeColor() {
    return PreferenceUtil.getSavedTheme(Constants.keyTheme) != null
        ? PreferenceUtil.getSavedTheme(Constants.keyTheme)
        : 0xff0a72e8;
  }

  int getMyPrimaryColor() {
    return PreferenceUtil.getSavedTheme(Constants.keyPriColor) != null
        ? PreferenceUtil.getSavedTheme(Constants.keyPriColor)
        : 0xff015eea;
  }

  int getMyGredientColor() {
    return PreferenceUtil.getSavedTheme(Constants.keyGreyColor) != null
        ? PreferenceUtil.getSavedTheme(Constants.keyGreyColor)
        : 0xff00c0fa;
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

  CompleteData getMediaTypeInfo(List<Data> data) {
    CompleteData completeData;
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
            id: dataObj.metaInfo.doctor.id,
            city: dataObj.metaInfo.doctor.city,
            description: dataObj.metaInfo.doctor.description,
            email: dataObj.metaInfo.doctor.email,
            isUserDefined: dataObj.metaInfo.doctor.isUserDefined,
            name: dataObj.metaInfo.doctor.name,
            specialization: dataObj.metaInfo.doctor.specialization,
            state: dataObj.metaInfo.doctor.state);
      } else {
        doctor = null;
      }

      Hospital hospital;

      if (dataObj.metaInfo.hospital != null) {
        hospital = new Hospital(
          addressLine1: dataObj.metaInfo.hospital.addressLine1,
          addressLine2: dataObj.metaInfo.hospital.addressLine2,
          branch: dataObj.metaInfo.hospital.branch,
          city: dataObj.metaInfo.hospital.city,
          description: dataObj.metaInfo.hospital.description,
          email: dataObj.metaInfo.hospital.email,
          id: dataObj.metaInfo.hospital.id,
          isUserDefined: dataObj.metaInfo.hospital.isUserDefined,
          latitude: dataObj.metaInfo.hospital.latitude,
          logoThumbnail: dataObj.metaInfo.hospital.logoThumbnail,
          longitude: dataObj.metaInfo.hospital.longitude,
          name: dataObj.metaInfo.hospital.name,
          website: dataObj.metaInfo.hospital.website,
          zipcode: dataObj.metaInfo.hospital.zipcode,
        );
      } else {
        hospital = null;
      }

      Laboratory laboratory;

      if (dataObj.metaInfo.laboratory != null) {
        laboratory = new Laboratory(
          zipcode: dataObj.metaInfo.laboratory.zipcode,
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
          doctor: doctor,
          hospital: hospital,
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

      mediaMetaInfoList.add(mediaMetaInfo);
    }

    completeData = new CompleteData(mediaMetaInfo: mediaMetaInfoList);

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

  String getMediaMasterIDForAudioFileType(
      List<MediaMasterIds> mediaMasterIdsList) {
    String mediaMasterId = '';

    for (MediaMasterIds mediaMasterIdsObj in mediaMasterIdsList) {
      if (mediaMasterIdsObj.fileType == Constants.audioFileType) {
        mediaMasterId = mediaMasterIdsObj.id;
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
      List<CategoryData> categoryData, String categoryName) {
    String categoryId;
    for (CategoryData categoryDataObj in categoryData) {
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
        variable.strtrue) {
      _deviceDataHelper.syncGF();
    } else if (PreferenceUtil.getStringValue(Constants.activateHK) ==
        variable.strtrue) {
      _deviceDataHelper.syncHKT();
    }
  }

  Future<MyProfile> getUserProfileData() async {
    MyProfileBloc _myProfileBloc = new MyProfileBloc();

    MyProfile myProfile = new MyProfile();

    _myProfileBloc
        .getMyProfileData(Constants.KEY_USERID_MAIN)
        .then((profileData) {
      if (profileData != null &&
          profileData.status == 200 &&
          profileData.success) {
        PreferenceUtil.saveProfileData(Constants.KEY_PROFILE_MAIN, profileData)
            .then((value) {
          try {
            if (PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN) !=
                PreferenceUtil.getProfileData(Constants.KEY_PROFILE)) {
            } else {
              PreferenceUtil.saveProfileData(
                  Constants.KEY_PROFILE, profileData);
            }
          } catch (e) {
            PreferenceUtil.saveProfileData(Constants.KEY_PROFILE, profileData);
          }

          myProfile = profileData;
        });
      }
      return profileData;
    });
  }

  List<DeviceData> getDeviceList() {
    List<DeviceData> devicelist = new List<DeviceData>();
    if (PreferenceUtil.getStringValue(Constants.bpMon) != variable.strFalse) {
      devicelist.add(DeviceData(
          title: 'BP Monitor',
          icon: 'assets/devices/bp_m.png',
          status: 0,
          isSelected: false,
          value_name: 'bloodPressure',
          value1: 'SYS',
          value2: 'DIS',
          color: Colors.redAccent));
    }
    if (PreferenceUtil.getStringValue(Constants.glMon) != variable.strFalse) {
      devicelist.add(DeviceData(
          title: 'Glucometer',
          icon: 'assets/devices/gulco.png',
          status: 0,
          isSelected: false,
          value_name: 'bloodGlucose',
          value1: 'GL',
          value2: '',
          color: Colors.orange));
    }

    if (PreferenceUtil.getStringValue(Constants.oxyMon) != variable.strFalse) {
      devicelist.add(DeviceData(
          title: 'Pulse Oximeter',
          icon: 'assets/devices/pulse_oxim.png',
          status: 0,
          isSelected: false,
          value_name: 'oxygenSaturation',
          value1: 'OS',
          value2: '',
          color: Colors.black26));
    }

    if (PreferenceUtil.getStringValue(Constants.wsMon) != variable.strFalse) {
      devicelist.add(DeviceData(
          title: 'Weighing Scale',
          icon: 'assets/devices/weight.png',
          status: 0,
          isSelected: false,
          value_name: 'bodyWeight',
          value1: 'WT',
          value2: '',
          color: Colors.lightGreen));
    }
    if (PreferenceUtil.getStringValue(Constants.thMon) != variable.strFalse) {
      devicelist.add(DeviceData(
          title: 'Thermometer',
          icon: 'assets/devices/fever.png',
          status: 0,
          isSelected: false,
          value_name: 'bodyTemperature',
          value1: 'TEMP',
          value2: '',
          color: Colors.deepOrangeAccent));
    }

    return devicelist;
  }

  Future<MyProfile> getMyProfile() async {
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
        _mediaTypeBlock.getMediTypes().then(() {});
      }
    } catch (e) {
      _mediaTypeBlock.getMediTypes().then(() {});
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
    var newFormat = DateFormat('yyyy-MM-d');
    String updatedDate = newFormat.format(dateTime);

    return updatedDate;
  }

  List<CategoryData> fliterCategories(List<CategoryData> data) {
    List<CategoryData> filteredCategoryData = new List();

    for (CategoryData dataObj in data) {
      if (/*dataObj.isDisplay &&*/
          dataObj.categoryName != Constants.STR_FEEDBACK &&
              dataObj.categoryName != Constants.STR_CLAIMSRECORD &&
              dataObj.categoryName != Constants.STR_WEARABLES) {
        filteredCategoryData.add(dataObj);
      }
    }

    int i = 0;
    for (CategoryData categoryDataObj in filteredCategoryData) {
      if (categoryDataObj.categoryDescription ==
          CommonConstants.categoryDescriptionOthers) {
        categoryDataObjClone = categoryDataObj;
        filteredCategoryData.removeAt(i);
        break;
      }
      i++;
    }
    filteredCategoryData.add(categoryDataObjClone);

    filteredCategoryData.sort((a, b) {
      if (a.categoryDescription != null) {
        return a.categoryDescription
            .toLowerCase()
            .compareTo(b.categoryDescription.toLowerCase());
      }
    });

    return filteredCategoryData;
  }

  static Future<void> askPermissionForCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}

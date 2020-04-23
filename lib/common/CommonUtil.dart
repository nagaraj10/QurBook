import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/bookmark_record/bloc/bookmarkRecordBloc.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart'
    as familyMember;
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Authentication/SignOutResponse.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/model/Media/MediaTypeResponse.dart';
import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/model/Media/DeviceModel.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/model/user/ProfileCompletedata.dart';
import 'package:myfhb/global_search/model/GlobalSearch.dart' as globalSearch;
import 'package:get/get.dart';
import 'package:showcaseview/showcase.dart';

class CommonUtil {
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

  /* MediaData getMediaTypeInfoForParticularLabel(
      String mediaId, List<MediaData> mediaDataList) {
    MediaData mediaDataObj = new MediaData();
    for (MediaData mediaData in mediaDataList) {
      if (mediaData.categoryId == mediaId) {
        mediaDataObj = mediaData;
        print(mediaDataObj.name + ' for ' + mediaDataObj.toString());

        // break;
      }
    }

    return mediaDataObj;
  } */

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
          print(mediaDataObj.name + ' for ' + mediaDataObj.toString());

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
    return new DateFormat("dd/MM/yyyy").format(now);
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
          if (snapshot.isNotEmpty && k < mediMasterId.length) {
            k++;
            imageList.add(snapshot);
          } else {}
        });
      }
      if (k == mediMasterId.length) {
        return imageList;
      }

      /* return FutureBuilder(
        future: _healthReportListForUserBlock
            .getDocumentImage(new CommonUtil().getMetaMasterId(data)),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data,
            );
          } else {
            return Container();
          }
        },
      );*/
    } else {
      /* return Container(
        width: 0,
        height: 0,
      );*/

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
    print('deviceList' + deviceList.length.toString());
    return deviceList;
  }

  MediaData getMediaTypeInfoForParticularDevice(
      String deviceName, List<MediaData> mediaDataList) {
    MediaData mediaDataObj = new MediaData();
    for (MediaData mediaData in mediaDataList) {
      if (mediaData.name == deviceName) {
        mediaDataObj = mediaData;
        print(mediaDataObj.name + ' for ' + mediaDataObj.toString());

        // break;
      }
    }
    return mediaDataObj;
  }

  /*  Future<void> writeToFile(List<MediaMasterIds> mediaMasterIds) async {
    HealthReportListForUserBlock _healthReportsMedia =
        HealthReportListForUserBlock();

    mediaMasterIds.forEach((item) {
      writeFileToLocal(_healthReportsMedia.getDocumentImage(item.id));
    });

    //final buffer = data.buffer;

    /* return new File(path).writeAsBytes(
              buffer.asUint8List(data.offsetInBytes, data.lengthInBytes)); */
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> writeFileToLocal(Future documentImage) async {
    final String path = await _localPath;
    return new File(path).writeAsBytes(documentImage as);
  } */

  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, String msgToDisplay) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
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
      print('Getting into media masters');
      for (MediaMasterIds mediaMasterIds in data.mediaMasterIds) {
        if (mediaMasterIds.fileType == "image/jpg" ||
            mediaMasterIds.fileType == "image/png") {
          mediaMasterIdsList.add(mediaMasterIds);
        }
      }
    } else {}

    print('mediaMasterID' + mediaMasterIdsList[0].id);
    return mediaMasterIdsList.length > 0 ? mediaMasterIdsList : new List();
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
    _bookmarkRecordBloc
        .bookMarcRecord(mediaIds, _isRecordBookmarked)
        .then((bookmarkRecordResponse) {
      if (bookmarkRecordResponse.success) {
        _refresh();
      }
    });
  }

  void logout(Function(SignOutResponse) moveToLoginPage) {
    LoginBloc loginBloc = new LoginBloc();

    loginBloc.logout().then((signOutResponse) {
      moveToLoginPage(signOutResponse);
    });
  }

  familyMember.Sharedbyme getProfileDetails() {
    MyProfile myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
    GeneralInfo generalInfo = myProfile.response.data.generalInfo;
    familyMember.LinkedData linkedData =
        new familyMember.LinkedData(roleName: 'Self', nickName: 'Self');
    familyMember.ProfilePicThumbnail profilePicThumbnail =
        generalInfo.profilePicThumbnail != null
            ? new familyMember.ProfilePicThumbnail(
                type: generalInfo.profilePicThumbnail.type,
                data: generalInfo.profilePicThumbnail.data)
            : null;

    familyMember.QualifiedFullName qualifiedFullName =
        generalInfo.qualifiedFullName != null
            ? new familyMember.QualifiedFullName(
                firstName: generalInfo.qualifiedFullName.firstName,
                middleName: generalInfo.qualifiedFullName.middleName,
                lastName: generalInfo.qualifiedFullName.lastName)
            : null;

    familyMember.ProfileData profileData = new familyMember.ProfileData(
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

    return new familyMember.Sharedbyme(
        profileData: profileData, linkedData: linkedData);
  }

  void getMedicalPreference({Function callBackToRefresh}) {
    MyProfileBloc _myProfileBloc = new MyProfileBloc();
    _myProfileBloc
        .getCompleteProfileData(Constants.KEY_USERID)
        .then((profileCompleteData) {
      if (profileCompleteData.response.data.medicalPreferences != null) {
        MedicalPreferences medicalPreferences =
            profileCompleteData.response.data.medicalPreferences;

        if (medicalPreferences.preferences.doctorIds != null &&
            medicalPreferences.preferences.doctorIds.length > 0) {
          medicalPreferences.preferences.doctorIds.sort(
              (a, b) => (b.isDefault ? 1 : 0).compareTo(a.isDefault ? 1 : 0));
          DoctorIds doctorIds = medicalPreferences.preferences.doctorIds[0];

          PreferenceUtil.savePrefereDoctors(
              Constants.KEY_PREFERRED_DOCTOR, doctorIds);
        } else {
          PreferenceUtil.savePrefereDoctors(
              Constants.KEY_PREFERRED_DOCTOR, null);
        }

        if (medicalPreferences.preferences.hospitalIds != null &&
            medicalPreferences.preferences.hospitalIds.length > 0) {
          medicalPreferences.preferences.hospitalIds.sort(
              (a, b) => (b.isDefault ? 1 : 0).compareTo(a.isDefault ? 1 : 0));
          HospitalIds hospitalIds =
              medicalPreferences.preferences.hospitalIds[0];
          PreferenceUtil.savePrefereHospital(
              Constants.KEY_PREFERRED_HOSPITAL, hospitalIds);
        } else {
          PreferenceUtil.savePrefereHospital(
              Constants.KEY_PREFERRED_HOSPITAL, null);
        }

        if (medicalPreferences.preferences.laboratoryIds != null &&
            medicalPreferences.preferences.laboratoryIds.length > 0) {
          medicalPreferences.preferences.laboratoryIds.sort(
              (a, b) => (b.isDefault ? 1 : 0).compareTo(a.isDefault ? 1 : 0));
          LaboratoryIds laboratoryIds =
              medicalPreferences.preferences.laboratoryIds[0];
          PreferenceUtil.savePreferedLab(
              Constants.KEY_PREFERRED_LAB, laboratoryIds);
        } else {
          PreferenceUtil.savePreferedLab(Constants.KEY_PREFERRED_LAB, null);
        }
        callBackToRefresh();
      } else {
        PreferenceUtil.savePrefereDoctors(Constants.KEY_PREFERRED_DOCTOR, null);
        PreferenceUtil.savePrefereHospital(
            Constants.KEY_PREFERRED_HOSPITAL, null);

        PreferenceUtil.savePreferedLab(Constants.KEY_PREFERRED_LAB, null);
        callBackToRefresh();
      }
    });
  }

  int getThemeColor() {
    return PreferenceUtil.getSavedTheme('my_theme') != null
        ? PreferenceUtil.getSavedTheme('my_theme')
        : 0xff0a72e8;
  }

  int getMyPrimaryColor() {
    return PreferenceUtil.getSavedTheme('pri_color') != null
        ? PreferenceUtil.getSavedTheme('pri_color')
        : 0xff3da0a6;
  }

  int getMyGredientColor() {
    return PreferenceUtil.getSavedTheme('gre_color') != null
        ? PreferenceUtil.getSavedTheme('gre_color')
        : 0xff66dca0;
  }

  List<CategoryData> getAllCategoryList(List<globalSearch.Data> data) {
    List<CategoryData> categoryDataList = new List();

    for (globalSearch.Data dataObj in data) {
      globalSearch.CategoryInfo categoryInfo = dataObj.metaInfo.categoryInfo;

      categoryDataList.add(new CategoryData(
        id: categoryInfo.id,
        categoryDescription: categoryInfo.categoryDescription,
        categoryName: categoryInfo.categoryName,
        isCreate: categoryInfo.isCreate,
        isDelete: categoryInfo.isDelete,
        isDisplay: categoryInfo.isDisplay,
        isEdit: categoryInfo.isEdit,
        isRead: categoryInfo.isRead,
        lastModifiedOn: categoryInfo.lastModifiedOn,
        logo: categoryInfo.logo,
        isActive: true,
      ));
    }

    return removeDuplicatevalues(categoryDataList);
  }

  CompleteData getMediaTypeInfo(List<globalSearch.Data> data) {
    CompleteData completeData;
    List<MediaMetaInfo> mediaMetaInfoList = new List();

    for (globalSearch.Data dataObj in data) {
      List<MediaMasterIds> mediaMasterIdsList = new List();
      for (globalSearch.MediaMasterIds mediaMasterIds
          in dataObj.mediaMasterIds) {
        mediaMasterIdsList.add(new MediaMasterIds(
            id: mediaMasterIds.id, fileType: mediaMasterIds.fileType));
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
          url: Constants.BASERURL + dataObj.metaInfo.categoryInfo.logo);

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
          url: Constants.BASERURL + dataObj.metaInfo.mediaTypeInfo.logo);

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
          zipcode: dataObj.metaInfo.hospital.zipCode.toString(),
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
        for (globalSearch.DeviceReadings deviceReadingsObj
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
          hasVoiceNotes: dataObj.metaInfo.hasVoiceNote,
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
          isBookmarked: dataObj.isBookmarked,
          isDraft: dataObj.isDraft,
          mediaMasterIds: mediaMasterIdsList);

      mediaMetaInfoList.add(mediaMetaInfo);
    }

    completeData = new CompleteData(mediaMetaInfo: mediaMetaInfoList);

    print('value inside completeData');

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

    print('value inside removeDuplicatevalues' +
        categoryDataList.length.toString());
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

  /*  static customShowCase(
    GlobalKey _key,
    String desc,
    Widget _child, {
    String title,
  }) {
    return Showcase(
      key: _key,
      disableAnimation: true,
      shapeBorder: CircleBorder(),
      //showcaseBackgroundColor: Colors.transparent,
      title: title != null ? title : '',
      description: desc,
      descTextStyle: TextStyle(color: Colors.black),
      child: _child,
    );
  } */

  static customShowCase(GlobalKey _key, String desc, Widget _child,
      {String title, BuildContext context}) {
    return Showcase.withWidget(
      key: _key,
      disableAnimation: false,
      shapeBorder: CircleBorder(),
      title: 'MyFHB',
      description: desc,
      child: _child,
      overlayColor: Colors.black,
      overlayOpacity: 0.8,
      height: 800.0,
      width: 300.0,
      container: Center(
        //color: Colors.transparent,
        child: Column(
          children: <Widget>[
            Text(
              desc,
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 2,
              softWrap: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              desc,
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  networkUI() {
    Get.bottomSheet(
      builder: (_) {
        return Container(
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
                  AssetImage('assets/icons/wifi.png'),
                  color: Color(CommonUtil().getMyPrimaryColor()),
                  size: 50.0,
                ),
                Text(
                  'No internet connection',
                  style: TextStyle(
                    color: Color(CommonUtil().getMyPrimaryColor()),
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
            isOffline ? 'back to online' : 'no connection',
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

    if (bloodGroupClone.contains('ve')) {
    } else {
      bloodGroupClone = bloodGroupClone + 've';
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
}

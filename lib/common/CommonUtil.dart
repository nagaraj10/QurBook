import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:badges/badges.dart' as Badge;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_geocoder/model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/FlatButton.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:myfhb/QurHub/Controller/HubListViewController.dart';
import 'package:myfhb/QurHub/View/HubListView.dart';
import 'package:myfhb/Qurhome/QurHomeVitals/viewModel/VitalListController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/View/QurhomeDashboard.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/CareGiverPatientList.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/SheelaRemainderConfig.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/errorAppLogDataModel.dart';
import 'package:myfhb/chat_socket/model/SheelaReminderResponse.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/landing/controller/landing_screen_controller.dart';
import 'package:myfhb/main.dart';
import 'package:myfhb/more_menu/trouble_shoot_controller.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/sheela_arguments.dart';
import 'package:myfhb/src/ui/loader_class.dart';
import 'package:myfhb/telehealth/features/appointments/services/fetch_appointments_service.dart';
import 'package:myfhb/ticket_support/controller/create_ticket_controller.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info/package_info.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../authentication/constants/constants.dart';
import '../../constants/fhb_constants.dart' as constants;
import '../Qurhome/QurhomeDashboard/Api/QurHomeApiProvider.dart';
import '../Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import '../Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import '../Qurhome/QurhomeDashboard/model/calldata.dart';
import '../Qurhome/QurhomeDashboard/model/calllogmodel.dart';
import '../Qurhome/QurhomeDashboard/model/callpushmodel.dart';
//import 'package:open_file/open_file.dart'; FU2.5
import '../add_family_user_info/models/add_family_user_info_arguments.dart';
import '../add_family_user_info/services/add_family_user_info_repository.dart';
import '../add_providers/bloc/update_providers_bloc.dart';
import '../authentication/model/device_version.dart';
import '../authentication/model/logged_in_success.dart';
import '../authentication/view/authentication_validator.dart';
import '../authentication/view/login_screen.dart';
import '../bookmark_record/bloc/bookmarkRecordBloc.dart';
import '../chat_socket/constants/const_socket.dart';
import '../chat_socket/model/TotalCountModel.dart';
import '../chat_socket/viewModel/chat_socket_view_model.dart';
import '../chat_socket/viewModel/getx_chat_view_model.dart';
import '../constants/fhb_constants.dart';
import '../constants/fhb_constants.dart' as Constants;
import '../constants/fhb_parameters.dart';
import '../constants/fhb_parameters.dart' as parameters;
import '../constants/fhb_query.dart';
import '../constants/responseModel.dart';
import '../constants/router_variable.dart' as router;
import '../constants/variable_constant.dart';
import '../constants/variable_constant.dart' as variable;
import '../device_integration/view/screens/Device_Data.dart';
import '../device_integration/viewModel/deviceDataHelper.dart';
import '../global_search/model/Data.dart';
import '../my_family/bloc/FamilyListBloc.dart';
import '../my_family/models/LinkedData.dart';
import '../my_family/models/ProfileData.dart';
import '../my_family/models/Sharedbyme.dart';
import '../my_providers/models/User.dart';
import '../myfhb_weview/myfhb_webview.dart';
import '../plan_dashboard/viewModel/subscribeViewModel.dart';
import '../plan_wizard/view_model/plan_wizard_view_model.dart';
import '../record_detail/screens/record_detail_screen.dart';
import '../refer_friend/view/invite_contacts_screen.dart';
import '../refer_friend/viewmodel/referafriend_vm.dart';
import '../regiment/models/field_response_model.dart';
import '../regiment/models/regiment_data_model.dart';
import '../regiment/models/regiment_response_model.dart';
import '../regiment/service/regiment_service.dart';
import '../regiment/view_model/regiment_view_model.dart';
import '../reminders/QurPlanReminders.dart';
import '../src/blocs/Authentication/LoginBloc.dart';
import '../src/blocs/Media/MediaTypeBlock.dart';
import '../src/blocs/User/MyProfileBloc.dart';
import '../src/blocs/health/HealthReportListForUserBlock.dart';
import '../src/model/Authentication/DeviceInfoSucess.dart';
import '../src/model/Category/CategoryData.dart';
import '../src/model/Category/catergory_result.dart';
import '../src/model/GetDeviceSelectionModel.dart';
import '../src/model/Health/CategoryInfo.dart';
import '../src/model/Health/MediaMasterIds.dart';
import '../src/model/Health/MediaMetaInfo.dart';
import '../src/model/Health/MediaTypeInfo.dart';
import '../src/model/Health/asgard/health_record_collection.dart';
import '../src/model/Health/asgard/health_record_list.dart';
import '../src/model/Media/DeviceModel.dart';
import '../src/model/Media/media_data_list.dart';
import '../src/model/Media/media_result.dart';
import '../src/model/sceretLoader.dart';
import '../src/model/user/MyProfileModel.dart';
import '../src/model/user/UserAddressCollection.dart';
import '../src/resources/network/ApiBaseHelper.dart';
import '../src/resources/network/api_services.dart';
import '../src/resources/repository/CategoryRepository/CategoryResponseListRepository.dart';
import '../src/resources/repository/health/HealthReportListForUserRepository.dart';
import '../src/ui/MyRecord.dart';
import '../src/ui/MyRecordsArguments.dart';
import '../src/ui/SheelaAI/Controller/SheelaAIController.dart';
import '../src/ui/SheelaAI/Services/SheelaAIBLEServices.dart';
import '../src/ui/SheelaAI/Services/SheelaQueueServices.dart';
import '../src/ui/SheelaAI/Widgets/BadgeIconBig.dart';
import '../src/utils/FHBUtils.dart';
import '../src/utils/PageNavigator.dart';
import '../src/utils/colors_utils.dart';
import '../src/utils/language/language_utils.dart';
import '../src/utils/screenutils/size_extensions.dart';
import '../telehealth/features/Notifications/services/notification_services.dart';
import '../telehealth/features/Notifications/view/notification_main.dart';
import '../telehealth/features/Payment/PaymentPage.dart';
import '../telehealth/features/appointments/controller/AppointmentDetailsController.dart';
import '../telehealth/features/appointments/model/fetchAppointments/healthRecord.dart';
import '../telehealth/features/appointments/view/AppointmentDetailScreen.dart';
import '../telehealth/features/chat/view/BadgeIcon.dart';
import '../telehealth/features/chat/view/PDFViewerController.dart';
import '../video_call/model/UpdatedInfo.dart';
import '../video_call/model/messagedetails.dart';
import '../video_call/model/msgcontent.dart';
import '../video_call/model/payload.dart' as vsPayLoad;
import '../video_call/pages/calling_page.dart';
import '../video_call/pages/callmain.dart';
import '../video_call/pages/callmain_makecall.dart';
import '../video_call/services/iOS_Notification_Handler.dart';
import '../video_call/utils/audiocall_provider.dart';
import '../video_call/utils/hideprovider.dart';
import '../video_call/utils/rtc_engine.dart';
import '../video_call/utils/settings.dart';
import '../video_call/utils/videoicon_provider.dart';
import '../widgets/checkout_page.dart';
import '../widgets/device_type.dart';
import 'CommonConstants.dart';
import 'PreferenceUtil.dart';
import 'ShowPDFFromFile.dart';
import 'common_circular_indicator.dart';
import 'firestore_services.dart';
import 'keysofmodel.dart' as keysConstant;
import 'widgets/CommonWidgets.dart';

class CommonUtil {
  static String SHEELA_URL = '';
  static String FAQ_URL = '';
  static String GOOGLE_MAP_URL = '';
  static String GOOGLE_PLACE_API_KEY = '';
  static String GOOGLE_MAP_PLACE_DETAIL_URL = '';
  static String GOOGLE_ADDRESS_FROM__LOCATION_URL = '';
  static String GOOGLE_STATIC_MAP_URL = '';
  static String BASE_URL_FROM_RES = '';
  static String BASEURL_DEVICE_READINGS = '';
  static String FIREBASE_CHAT_NOTIFY_TOKEN = '';
  static String REGION_CODE = 'IN';
  static String CURRENCY = INR;
  static String POWER_BI_URL = 'IN';
  static String BASE_URL_QURHUB = '';
  static String TRUE_DESK_URL = '';
  static String WEB_URL = '';
  static String PORTAL_URL = '';

  static String AppName = '';

  static String UNIT_CONFIGURATION_URL =
      'system-configuration/unit-configuration';
  static String PUSH_KIT_TOKEN = '';
  static String SHEELA_CONFIGURATION_URL =
      'system-configuration/sheela-reminder-config';

  static const bgColor = 0xFFe3e2e2;
  static bool isRenewDialogOpened = false;
  static const secondaryGrey = 0xFF545454;

  CategoryResult categoryDataObjClone = CategoryResult();
  late CategoryResponseListRepository _categoryResponseListRepository;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  static bool audioPage = false;
  static bool isRemoteUserOnPause = false;
  static bool isVideoRequestSent = false;
  static bool isLocalUserOnPause = false;

  static List<String>? recordIds = [];
  static List<String>? notesId = [];
  static List<String>? voiceIds = [];
  MyProfileModel? myProfile;
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();
  UpdateProvidersBloc updateProvidersBloc = UpdateProvidersBloc();
  SubscribeViewModel subscribeViewModel = SubscribeViewModel();
  final String CONTENT_DISCALIMER =
      'Your selection and use of care plans is voluntary and you acknowledge that care plan(s) offered in Qurbook is based on the best practices of care coordination management specific to a health condition. Plan activities along with any coordinated care suggestions provided by care team is limited to care coordination to a plan and do not provide conclusion or any sort of clinical assessment or shall not be used to make clinical decisions or to change of medical therapies / treatments as prescribed by your physician. please contact your physician for further directions  for activities in a plan that do not apply to your health needs or not listed. Care coordination services from caregivers, Doctors, Hospitals or other healthcare providers from QurBook (collectively referred as “Care Team”) is limited to the information shared by you with care team and/or scope of your subscription. You agree to protect and indemnify Care provider(s)/Care Team/QurHealth Solutions India Pvt Ltd or our partners, on all claims of whatsoever (including but not limited to side effects, illness or sickness) against products, services, suggestions  or received from QurBook.  For emergency please contact your nearest Healthcare facility. Our care givers are available from 9 AM to 7 PM IST.';
  final String CONTENT_PROFILE_CHECK =
      'Oops! Your profile is incomplete. Please complete the profile to subscribe to a care plan.';
  final String CONTENT_UNSUBSCRIBE_PACKAGE =
      'Are you sure you want to unsubscribe?';
  final String CONTENT_RENEW_PACKAGE = 'Are you sure you want to renew?';
  final String CHOOSE_DATE = 'Choose Date';

  final String CONTENT_NO_REFUND =
      'Please note that no refund will be provided. Are you sure you want to Unsubscribe?';

  final String sheelaDialogTitle = 'Activity is not completed.';

  final String sheelaDialogBody = 'Do you wish to exit the conversation?';

  static getProviderType(String type) {
    return 'health-organization/search/efhb?healthOrganizationType=%5B%22${type}%22%5D&limit=100&sortBy=asc';
  }

  static bool dialogboxOpen = false;

  static String? bookedForId = null;
  static bool isCallStarted = false;
  static bool isVersionLatest = true;

  var commonConstants = CommonConstants();

  String tempUnit = 'C';
  String weightUnit = 'kg';

  bool isTouched = true;

  bool isPounds = false;
  bool isKg = false;

  bool isCele = false;
  bool isFaren = false;

  bool isInchFeet = false;
  bool isCenti = false;

  GetDeviceSelectionModel? selectionResult;
  PreferredMeasurement? preferredMeasurement;
  ProfileSetting? profileSetting;

  HealthReportListForUserRepository healthReportListForUserRepository =
      HealthReportListForUserRepository();

  Height? heightObj, weightObj, tempObj;
  String? userMappingId = '';
  SheelaQueueServices queueServices = SheelaQueueServices();

  Future<GetDeviceSelectionModel?> getProfileSetings() async {
    var userId = await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    await healthReportListForUserRepository
        .getDeviceSelection(userIdFromBloc: userId)
        .then((value) async {
      if (value.isSuccess!) {
        selectionResult = value;
        if (value.result != null && value.result!.length > 0) {
          if (value.result![0] != null) {
            profileSetting = value.result![0].profileSetting;
            userMappingId = value.result![0].id;

            if (profileSetting != null) {
              if (profileSetting!.preferredMeasurement != null) {
                preferredMeasurement = profileSetting!.preferredMeasurement;
                weightObj = preferredMeasurement!.weight;

                if (weightObj != null) {
                  await PreferenceUtil.saveString(Constants.STR_KEY_WEIGHT,
                      preferredMeasurement!.weight!.unitCode!);
                  if (preferredMeasurement!.weight!.unitCode!.toLowerCase() ==
                      Constants.STR_VAL_WEIGHT_IND.toLowerCase()) {
                    isKg = true;
                    isPounds = false;
                  } else {
                    isKg = false;
                    isPounds = true;
                  }
                } else {
                  commonMethodToSetPreference();
                }

                heightObj = preferredMeasurement!.height;

                if (heightObj != null) {
                  await PreferenceUtil.saveString(Constants.STR_KEY_HEIGHT,
                      preferredMeasurement!.height!.unitCode!);
                  if (preferredMeasurement!.height!.unitCode ==
                      Constants.STR_VAL_HEIGHT_IND) {
                    isInchFeet = true;
                    isCenti = false;
                  } else {
                    isInchFeet = false;
                    isCenti = true;
                  }
                } else {
                  commonMethodToSetPreference();
                }

                tempObj = preferredMeasurement!.temperature;
                if (tempObj != null) {
                  await PreferenceUtil.saveString(Constants.STR_KEY_TEMP,
                      preferredMeasurement!.temperature!.unitCode!);
                  if (preferredMeasurement!.temperature!.unitCode!
                          .toLowerCase() ==
                      Constants.STR_VAL_TEMP_IND.toLowerCase()) {
                    isFaren = true;
                    isCele = false;
                  } else {
                    isFaren = false;
                    isCele = true;
                  }
                } else {
                  commonMethodToSetPreference();
                }

                return selectionResult;
              } else {
                commonMethodToSetPreference();
                return selectionResult;
              }
            }
          }
        }
      }
    });
  }

  // Function to replace a separator in a string with an empty string
  String? replaceSeparator(
      {required String? value, required String separator}) {
    // Check if the value is not null and contains the separator
    if (value != null && value.contains(separator)) {
      // If it does, replace all occurrences of the separator with an empty string
      return value.replaceAll(separator, '');
    }
    // If the value is null or doesn't contain the separator, return the original value
    return value;
  }

  void commonMethodToSetPreference() async {
    var apiBaseHelper = ApiBaseHelper();

    var unitConfiguration = await apiBaseHelper
        .getUnitConfiguration(CommonUtil.UNIT_CONFIGURATION_URL);

    if (unitConfiguration.isSuccess!) {
      if (unitConfiguration.result != null) {
        var configurationData = unitConfiguration.result![0].configurationData;
        if (configurationData != null) {
          if (CommonUtil.REGION_CODE != "IN") {
            await PreferenceUtil.saveString(Constants.STR_KEY_HEIGHT,
                    configurationData.unitSystemList!.us!.height![0].unitCode!)
                .then((value) {
              PreferenceUtil.saveString(
                      Constants.STR_KEY_WEIGHT,
                      configurationData
                          .unitSystemList!.us!.weight![0].unitCode!)
                  .then((value) {
                PreferenceUtil.saveString(
                        Constants.STR_KEY_TEMP,
                        configurationData
                            .unitSystemList!.us!.temperature![0].unitCode!)
                    .then((value) {});
              });
            });
          } else {
            await PreferenceUtil.saveString(
                    Constants.STR_KEY_HEIGHT,
                    configurationData
                        .unitSystemList!.india!.height![0].unitCode!)
                .then((value) {
              PreferenceUtil.saveString(
                      Constants.STR_KEY_WEIGHT,
                      configurationData
                          .unitSystemList!.india!.weight![0].unitCode!)
                  .then((value) {
                PreferenceUtil.saveString(
                        Constants.STR_KEY_TEMP,
                        configurationData
                            .unitSystemList!.india!.temperature![0].unitCode!)
                    .then((value) {});
              });
            });
          }
        }
      }
    }
  }

  void commonMethodToSetPreferenceNew() async {
    if (CommonUtil.REGION_CODE != "IN") {
      await PreferenceUtil.saveString(
          Constants.STR_KEY_HEIGHT, Constants.STR_VAL_HEIGHT_US);
      await PreferenceUtil.saveString(
          Constants.STR_KEY_WEIGHT, Constants.STR_VAL_WEIGHT_US);
      await PreferenceUtil.saveString(
          Constants.STR_KEY_TEMP, Constants.STR_VAL_TEMP_US);

      heightObj = Height(
          unitCode: Constants.STR_VAL_HEIGHT_US, unitName: 'feet/Inches');
      weightObj =
          Height(unitCode: Constants.STR_VAL_WEIGHT_US, unitName: 'pounds');
      tempObj =
          Height(unitCode: Constants.STR_VAL_TEMP_US, unitName: 'celsius');
      isKg = true;
      isPounds = false;

      isInchFeet = true;
      isCenti = false;

      isFaren = true;
      isCele = false;
    } else {
      await PreferenceUtil.saveString(
          Constants.STR_KEY_HEIGHT, Constants.STR_VAL_HEIGHT_IND);
      await PreferenceUtil.saveString(
          Constants.STR_KEY_WEIGHT, Constants.STR_VAL_WEIGHT_IND);
      await PreferenceUtil.saveString(
          Constants.STR_KEY_TEMP, Constants.STR_VAL_TEMP_IND);

      heightObj = Height(
          unitCode: Constants.STR_VAL_HEIGHT_IND,
          unitName: variable.str_centi.toLowerCase());
      weightObj = Height(
          unitCode: Constants.STR_VAL_WEIGHT_IND,
          unitName: variable.str_Kilogram.toLowerCase());
      tempObj = Height(
          unitCode: Constants.STR_VAL_TEMP_IND,
          unitName: variable.str_far.toLowerCase());
      isKg = false;
      isPounds = true;

      isInchFeet = false;
      isCenti = true;

      isFaren = false;
      isCele = true;
    }
  }

  static Future<dynamic> getResourceLoader() async {
    final secret = SecretLoader(secretPath: 'secrets.json').load();
    final valueFromRes = await secret;
    return valueFromRes.myScerets;
  }

  List<HealthResult> getDataForParticularCategoryDescription(
      HealthRecordList completeData, String categoryDescription) {
    final List<HealthResult> mediaMetaInfoObj = [];
    final List<HealthResult> bookMarkedData = [];
    final List<HealthResult> unBookMarkedData = [];
    for (final mediaMetaInfo in completeData.result!) {
      try {
        if (mediaMetaInfo.metadata!.healthRecordType!.description!
            .contains(categoryDescription)) {
          if (categoryDescription ==
              CommonConstants.categoryDescriptionDevice) {
            if (mediaMetaInfo.metadata!.deviceReadings != null &&
                mediaMetaInfo.metadata!.deviceReadings!.isNotEmpty)
            // &&
            // mediaMetaInfo.metadata.fileName != null)
            {
              mediaMetaInfoObj.add(mediaMetaInfo);
            }
          } else {
            mediaMetaInfoObj.add(mediaMetaInfo);
          }
        }
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    }

    if (mediaMetaInfoObj.isNotEmpty) {
      mediaMetaInfoObj.sort((mediaMetaInfoObjCopy, mediaMetaInfoObjClone) {
        return mediaMetaInfoObjCopy.dateTimeValue!
            .compareTo(mediaMetaInfoObjClone.dateTimeValue!);
      });

      //NOTE show the bookmarked data as first
      for (var mmi in mediaMetaInfoObj) {
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
    final List<HealthResult> mediaMetaInfoObj = [];

    for (final mediaMetaInfo in completeData.result!) {
      if (mediaMetaInfo.metadata!.healthRecordCategory != null) {
        if (mediaMetaInfo.metadata!.healthRecordCategory!.categoryDescription ==
                categoryDescription &&
            mediaMetaInfo.metadata!.healthRecordType!.description ==
                mediaTypeDescription) {
          mediaMetaInfoObj.add(mediaMetaInfo);
        }
      }
    }

    mediaMetaInfoObj.sort((mediaMetaInfoObjCopy, mediaMetaInfoObjClone) {
      return mediaMetaInfoObjCopy.metadata!.healthRecordType!.createdOn!
          .compareTo(
              mediaMetaInfoObjClone.metadata!.healthRecordType!.createdOn!);
    });
    return mediaMetaInfoObj;
  }

  List<HealthResult> getDataForHospitals(HealthRecordList completeData,
      String categoryDescription, String mediaTypeDescription) {
    var mediaMetaInfoObj = <HealthResult>[];

    for (var mediaMetaInfo in completeData.result!) {
      if (mediaMetaInfo.metadata!.healthRecordCategory != null) {
        if (mediaMetaInfo.metadata!.healthRecordCategory!.categoryDescription ==
                categoryDescription &&
            mediaMetaInfo.metadata!.healthRecordType!.description ==
                mediaTypeDescription) {
          mediaMetaInfoObj.add(mediaMetaInfo);
        }
      }
    }

    mediaMetaInfoObj.sort((mediaMetaInfoObjCopy, mediaMetaInfoObjClone) {
      return mediaMetaInfoObjCopy.metadata!.healthRecordType!.createdOn!
          .compareTo(
              mediaMetaInfoObjClone.metadata!.healthRecordType!.createdOn!);
    });
    return mediaMetaInfoObj;
  }

  MediaResult getMediaTypeInfoForParticularLabel(
      String? mediaId, List<MediaResult> mediaDataList, String? categoryName) {
    var mediaDataObj = MediaResult();
    late MediaResult selectedMediaData;
    try {
      selectedMediaData = PreferenceUtil.getMediaData(Constants.KEY_MEDIADATA);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    for (var mediaData in mediaDataList) {
      if (categoryName == Constants.STR_IDDOCS) {
        if (mediaData.healthRecordCategory!.id == mediaId &&
            mediaData.id == selectedMediaData.id) {
          mediaDataObj = mediaData;
          mediaDataObj.name! + ' for ' + mediaDataObj.toString();

          // break;
        }
      } else {
        if (mediaData.healthRecordCategory!.id == mediaId) {
          mediaDataObj = mediaData;
        }
      }
    }

    return mediaDataObj;
  }

  CategoryResult getCategoryObjForSelectedLabel(
      String? categoryId, List<CategoryResult> categoryList) {
    var categoryObj = CategoryResult();
    for (final categoryData in categoryList) {
      if (categoryData.id == categoryId) {
        categoryObj = categoryData;
      }
    }

    return categoryObj;
  }

  String? getMetaMasterId(MediaMetaInfo data) {
    var mediaMasterIdsList = <MediaMasterIds>[];
    if (data.mediaMasterIds!.isNotEmpty) {
      for (var mediaMasterIds in data.mediaMasterIds!) {
        mediaMasterIdsList.add(mediaMasterIds);
      }
    } else {}

    return mediaMasterIdsList.isNotEmpty ? mediaMasterIdsList[0].id : '0';
  }

  String getCurrentDate() {
    final now = DateTime.now();
    return DateFormat(CommonUtil.REGION_CODE == 'IN'
            ? variable.strDateFormatDay
            : variable.strUSDateFormatDay)
        .format(now);
  }

  String getCurrentDateForStatusActivity() {
    final now = DateTime.now();
    return DateFormat(CommonUtil.REGION_CODE == 'IN'
            ? variable.strDateYear
            : variable.strDateYear)
        .format(now);
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    DateTime? date;
    final picked = await showDatePicker(
        context: context,
        initialDate: date!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    return date;
  }

  getDocumentImageWidget(HealthResult data) async {
    HealthReportListForUserBlock _healthReportListForUserBlock;
    _healthReportListForUserBlock = HealthReportListForUserBlock();

    var imageList = <dynamic>[];
    if (data.healthRecordCollection!.isNotEmpty) {
      var mediMasterId = CommonUtil().getMetaMasterIdList(data);
      var k = 0;
      for (var i = 0; i < mediMasterId.length; i++) {
        await _healthReportListForUserBlock
            .getDocumentImage(mediMasterId[i].id!)
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
      return [];
    }
  }

  List<DeviceModel> getAllDevices(List<MediaResult> mediaList) {
    final deviceList = <DeviceModel>[];

    for (var mediaMetaInfo in mediaList) {
      if (mediaMetaInfo.description!
          .split('_')
          .contains(CommonConstants.categoryDescriptionDevice)) {
        deviceList.add(DeviceModel(mediaMetaInfo.name!, mediaMetaInfo.logo!));
      }
    }
    return deviceList;
  }

  MediaResult getMediaTypeInfoForParticularDevice(
      String? deviceName, List<MediaResult> mediaDataList) {
    var mediaDataObj = MediaResult();
    for (final mediaData in mediaDataList) {
      if (mediaData.name == deviceName) {
        mediaDataObj = mediaData;

        // break;
      }
    }
    return mediaDataObj;
  }

  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, String msgToDisplay,
      {bool isAutoDismiss = false}) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          if (isAutoDismiss) {
            Future.delayed(Duration(seconds: 6), () {
              Navigator.of(context).pop(true);
            });
          }
          return WillPopScope(
              onWillPop: () async => true,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Text(
                          msgToDisplay,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0.sp,
                          ),
                        )
                      ]),
                    )
                  ]));
        });
  }

  /// Common Message Dialog
  static showCommonMsgDialog({required String msg}) {
    showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              clipBehavior: Clip.antiAlias,
              insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      strAlert,
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0.sp, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 100.w,
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: Offset(2, 4),
                                  blurRadius: 5,
                                  spreadRadius: 2)
                            ],
                            gradient: LinearGradient(
                                end: Alignment.centerRight,
                                colors: [
                                  mAppThemeProvider.primaryColor,
                                  mAppThemeProvider.gradientColor
                                ])),
                        child: Text(
                          strOK,
                          style:
                              TextStyle(fontSize: 14.0.sp, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  List<HealthRecordCollection> getMetaMasterIdList(HealthResult data) {
    final List<HealthRecordCollection> mediaMasterIdsList = [];
    try {
      if (data.healthRecordCollection != null &&
          data.healthRecordCollection!.isNotEmpty) {
        for (final mediaMasterIds in data.healthRecordCollection!) {
          if (mediaMasterIds.fileType == '.jpg' ||
              mediaMasterIds.fileType == '.png' ||
              mediaMasterIds.fileType == '.jpeg' ||
              mediaMasterIds.fileType == '.aac') {
            mediaMasterIdsList.add(mediaMasterIds);
          }
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    return mediaMasterIdsList.isNotEmpty ? mediaMasterIdsList : [];
  }

  MediaMasterIds getMediaMasterIDForPdfType(
      List<MediaMasterIds> mediaMasterIdsList) {
    var mediaMasterId = MediaMasterIds();

    for (final mediaMasterIdsObj in mediaMasterIdsList) {
      if (mediaMasterIdsObj.fileType == 'application/pdf') {
        mediaMasterId = mediaMasterIdsObj;
      }
    }

    return mediaMasterId;
  }

  HealthRecordCollection? getMediaMasterIDForPdfTypeStr(
      List<HealthRecordCollection> mediaMasterIdsList) {
    HealthRecordCollection? mediaMasterId;

    for (final mediaMasterIdsObj in mediaMasterIdsList) {
      if (mediaMasterIdsObj.fileType == '.pdf') {
        mediaMasterId = mediaMasterIdsObj;
      }
    }

    return mediaMasterId;
  }

  bookMarkRecord(HealthResult data, Function _refresh) {
    var _bookmarkRecordBloc = BookmarkRecordBloc();

    var mediaIds = <String?>[];
    mediaIds.add(data.id);
    var _isRecordBookmarked = data.isBookmarked!;
    if (_isRecordBookmarked) {
      _isRecordBookmarked = false;
    } else {
      _isRecordBookmarked = true;
    }
    final _healthReportListForUserBlock = HealthReportListForUserBlock();
    _bookmarkRecordBloc
        .bookMarcRecord(mediaIds, _isRecordBookmarked)
        .then((bookmarkRecordResponse) {
      _healthReportListForUserBlock.getHelthReportLists().then((value) {
        PreferenceUtil.saveCompleteData(Constants.KEY_COMPLETE_DATA, value)
            .then((value) {
          if (bookmarkRecordResponse!.success!) {
            _refresh();
          }
        });
      });
    });
  }

  void logout(Function() moveToLoginPage) async {
    final loginBloc = LoginBloc();

    //loginBloc.logout().then((signOutResponse) {
    // moveToLoginPage(signOutResponse);
    // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    // final token = await _firebaseMessaging.getToken();
    try {
      var myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
      final profileResult = myProfile!.result!;

      List<Future<dynamic>> apiCalls = [
        CommonUtil().sendDeviceToken(
            PreferenceUtil.getStringValue(Constants.KEY_USERID),
            profileResult.userContactCollection3![0]!.email,
            profileResult.userContactCollection3![0]!.phoneNumber,
            token,
            false),
        // Record the user's last access time
        CommonUtil().saveUserLastAccessTime()
      ];

      await Future.wait(apiCalls);

      await QurPlanReminders.deleteAllLocalReminders();
      moveToLoginPage();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      // if (Platform.isIOS) {
      //   _firebaseMessaging.deleteInstanceID();
      // }
      moveToLoginPage();
    }
    //}
    //);
  }

  Sharedbyme getProfileDetails() {
    var myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
    var myProfileResult = myProfile!.result!;

    var linkedData =
        LinkedData(roleName: variable.Self, nickName: variable.Self);

    final fullName =
        myProfileResult.firstName! + ' ' + myProfileResult.lastName!;
    final profileData = ProfileData(
        id: PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN),
        userId: PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN),
        name: fullName,
        email: myProfileResult.userContactCollection3!.isNotEmpty
            ? myProfileResult.userContactCollection3![0]!.email
            : '',
        dateOfBirth: myProfileResult.dateOfBirth,
        gender: myProfileResult.gender,
        bloodGroup: myProfileResult.bloodGroup,
        isVirtualUser: myProfileResult.isVirtualUser,
        phoneNumber: myProfileResult.userContactCollection3!.isNotEmpty
            ? myProfileResult.userContactCollection3![0]!.phoneNumber
            : '',
        //createdOn: myProfileResult.createdOn,
        /*profilePicThumbnail: myProfileResult.profilePicThumbnailUrl,*/
        isEmailVerified: myProfileResult.isEmailVerified,
        isTempUser: myProfileResult.isTempUser,
        profilePicThumbnailURL: myProfileResult.profilePicThumbnailUrl);

    return Sharedbyme(profileData: profileData, linkedData: linkedData);
  }

  int getThemeColor() {
    return PreferenceUtil.getSavedTheme(Constants.keyTheme) ?? 0xff0a72e8;
  }


  List<CategoryData> getAllCategoryList(List<Data> data) {
    final List<CategoryData> categoryDataList = [];

    for (final dataObj in data) {
      var categoryInfo = dataObj.metaInfo!.categoryInfo!;

      categoryDataList.add(CategoryData(
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

  HealthRecordList? getMediaTypeInfo(List<Data> data) {
    HealthRecordList? completeData;
    final List<MediaMetaInfo> mediaMetaInfoList = [];

    for (var dataObj in data) {
      final List<MediaMasterIds> mediaMasterIdsList = [];
      if (dataObj.mediaMasterIds != null &&
          dataObj.mediaMasterIds!.isNotEmpty) {
        for (final mediaMasterIds in dataObj.mediaMasterIds!) {
          mediaMasterIdsList.add(MediaMasterIds(
              id: mediaMasterIds.id, fileType: mediaMasterIds.fileType));
        }
      }

      var categoryInfo = CategoryInfo(
          id: dataObj.metaInfo!.categoryInfo!.id,
          isActive: true,
          categoryDescription:
              dataObj.metaInfo!.categoryInfo!.categoryDescription,
          categoryName: dataObj.metaInfo!.categoryInfo!.categoryName,
          isCreate: dataObj.metaInfo!.categoryInfo!.isCreate,
          isDelete: dataObj.metaInfo!.categoryInfo!.isDelete,
          isDisplay: dataObj.metaInfo!.categoryInfo!.isDisplay,
          isEdit: dataObj.metaInfo!.categoryInfo!.isEdit,
          isRead: dataObj.metaInfo!.categoryInfo!.isRead,
          logo: dataObj.metaInfo!.categoryInfo!.logo,
          url: Constants.BASE_URL + dataObj.metaInfo!.categoryInfo!.logo!);

      final mediaTypeInfo = MediaTypeInfo(
          categoryId: dataObj.metaInfo!.mediaTypeInfo!.categoryId,
          createdOn: dataObj.metaInfo!.mediaTypeInfo!.createdOn,
          description: dataObj.metaInfo!.mediaTypeInfo!.description,
          id: dataObj.metaInfo!.mediaTypeInfo!.id,
          isActive: dataObj.metaInfo!.mediaTypeInfo!.isActive,
          isAITranscription: dataObj.metaInfo!.mediaTypeInfo!.isAITranscription,
          isCreate: dataObj.metaInfo!.mediaTypeInfo!.isCreate,
          isDelete: dataObj.metaInfo!.mediaTypeInfo!.isDelete,
          isDisplay: dataObj.metaInfo!.mediaTypeInfo!.isDisplay,
          isEdit: dataObj.metaInfo!.mediaTypeInfo!.isEdit,
          isManualTranscription:
              dataObj.metaInfo!.mediaTypeInfo!.isManualTranscription,
          isRead: dataObj.metaInfo!.mediaTypeInfo!.isRead,
          lastModifiedOn: dataObj.metaInfo!.mediaTypeInfo!.lastModifiedOn,
          logo: dataObj.metaInfo!.mediaTypeInfo!.logo,
          name: dataObj.metaInfo!.mediaTypeInfo!.name,
          url: Constants.BASE_URL + dataObj.metaInfo!.mediaTypeInfo!.logo!);

      Doctor? doctor;
      if (dataObj.metaInfo!.doctor != null) {
        doctor = Doctor(
          doctorId: dataObj.metaInfo!.doctor!.id,
          //city: dataObj.metaInfo.doctor.city,
          //description: dataObj.metaInfo.doctor.description,
          //email: dataObj.metaInfo.doctor.email,
          //isUserDefined: dataObj.metaInfo.doctor.isUserDefined,
          name: dataObj.metaInfo!.doctor!.name,
          specialization: dataObj.metaInfo!.doctor!.specialization,
          //state: dataObj.metaInfo.doctor.state
        );
      } else {
        doctor = null;
      }
      /*
      Hospital hospital;

      if (dataObj.metaInfo.hospital != null) {
        hospital =Hospital(
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
        laboratory =Laboratory(
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

      List<DeviceReadings> deviceReadings =List();

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
        deviceReadings =List();
      }

      MetaInfo metaInfo =MetaInfo(
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

      MediaMetaInfo mediaMetaInfo =MediaMetaInfo(
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

    //completeData =HealthRecordList(mediaMetaInfo: mediaMetaInfoList);

    return completeData;
  }

  List<CategoryData> removeDuplicatevalues(List<CategoryData> items) {
    final categoryDataList = <CategoryData>[];
    for (final categoryDataObj in items) {
      if (categoryDataList.isEmpty) {
        categoryDataList.add(categoryDataObj);
      } else {
        var condition = false;
        for (var categoryDataObjInner in categoryDataList) {
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

  HealthRecordCollection? getMediaMasterIDForAudioFileType(
      List<HealthRecordCollection> mediaMasterIdsList) {
    HealthRecordCollection? mediaMasterId;

    for (final mediaMasterIdsObj in mediaMasterIdsList) {
      if (mediaMasterIdsObj.fileType == Constants.audioFileType ||
          mediaMasterIdsObj.fileType == Constants.audioFileAACType ||
          mediaMasterIdsObj.fileType == Constants.audioFileTypeAppStream) {
        mediaMasterId = mediaMasterIdsObj;
      }
    }

    return mediaMasterId;
  }

  static customShowCase(GlobalKey _key, String desc, Widget _child,
      {String? title, BuildContext? context}) {
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
              height: 80.0.h,
              width: 80.0.h,
            ),
            SizedBox(width: 20.0.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    desc,
                    style: TextStyle(
                        fontSize: 20.0.sp,
                        color: mAppThemeProvider.primaryColor,
                        fontFamily: variable.font_poppins),
                    maxLines: 2,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 10.0.h,
                ),
                Text(
                  desc,
                  style: TextStyle(
                      fontSize: 14.0.sp,
                      color: mAppThemeProvider.primaryColor,
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
        constraints: BoxConstraints(maxHeight: 120.0.h),
        child: Card(
          elevation: 10,
          //margin: EdgeInsets.only(left: 3.0,right: 3.0),
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ImageIcon(
                AssetImage(variable.icon_wifi),
                color: mAppThemeProvider.primaryColor,
                size: 50,
              ),
              Text(
                variable.strNoInternet,
                style: TextStyle(
                  color: mAppThemeProvider.primaryColor,
                  fontSize: 16.0.sp,
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
      height: 20.0.h,
      color: isOffline ? Colors.green : Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(isOffline ? Icons.flash_on : Icons.flash_off),
          SizedBox(
            width: 10.0.w,
          ),
          Text(
            isOffline ? variable.strBackOnline : variable.strNoConnection,
            style: TextStyle(color: Colors.white, fontSize: 15.0.sp),
          ),
        ],
      ),
    );
  }

  String conCatenateBloodGroup(String bloodGroup) {
    var bloodGroupClone = '';
    if (bloodGroup != null && bloodGroup != '') {
      final bloodGroupSplitName = bloodGroup.split('_');
      if (bloodGroupSplitName.length > 1) {
        bloodGroupClone = bloodGroupSplitName[0] + bloodGroupSplitName[1];
      } else {
        final bloodGroupSplitName = bloodGroup.split(' ');
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

  String? getIdForDescription(
      List<CategoryResult> categoryData, String categoryName) {
    String? categoryId;
    for (var categoryDataObj in categoryData) {
      if (categoryDataObj.categoryName == categoryName) {
        categoryId = categoryDataObj.id;
      }
    }
    return categoryId;
  }

  titleCase(str) {
    final splitStr = str.toLowerCase().split(' ');
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
    final _familyListBloc = FamilyListBloc();
    try {
      if (PreferenceUtil.getFamilyRelationship(Constants.keyFamily) != null) {
      } else {
        _familyListBloc.getCustomRoles().then((relationShip) {
          if (relationShip != null) {
            PreferenceUtil.saveRelationshipArray(
                Constants.keyFamily, relationShip?.relationShipAry);
          }
        });
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      _familyListBloc.getCustomRoles().then((relationShip) {
        if (relationShip != null) {
          PreferenceUtil.saveRelationshipArray(
              Constants.keyFamily, relationShip?.relationShipAry);
        }
      });
    }
  }

  Future<void> syncDevices() async {
    final _deviceDataHelper = DeviceDataHelper();

    if (PreferenceUtil.getStringValue(Constants.activateGF) ==
            variable.strtrue &&
        PreferenceUtil.getStringValue(Constants.isFirstTym) ==
            variable.strFalse &&
        Platform.isAndroid) {
      await _deviceDataHelper.syncGoogleFit();
    }
  }

  moveToLoginPage() {
    PreferenceUtil.clearAllData().then((value) {
      // PageNavigator.goToPermanent(context,router.rt_SignIn);
      Navigator.pushAndRemoveUntil(
          Get.context!,
          MaterialPageRoute(builder: (context) => PatientSignInScreen()),
          (route) => false);
    });
  }

  Future<MyProfileModel?> getUserProfileData() async {
    final _myProfileBloc = MyProfileBloc();

    var myProfileModel = MyProfileModel();

    await _myProfileBloc
        .getMyProfileData(Constants.KEY_USERID)
        .then((profileData) {
      if (profileData != null &&
          (profileData.isSuccess ?? false) &&
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
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
            PreferenceUtil.saveProfileData(Constants.KEY_PROFILE, profileData);
          }

          myProfileModel = profileData;
        });
      } else {
        //logout(moveToLoginPage);
      }
      //return profileData;
    });

    await _myProfileBloc
        .getMyProfileData(Constants.KEY_USERID_MAIN)
        .then((profileData) {
      if (profileData != null &&
          (profileData.isSuccess ?? false) &&
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
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
            PreferenceUtil.saveProfileData(
                Constants.KEY_PROFILE_MAIN, profileData);
          }

          myProfileModel = profileData;
        });
      } else {
        logout(moveToLoginPage);
      }
      return profileData;
    });
  }

  DeviceData? getDeviceList() {
    DeviceData? devicelist;
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
            mAppThemeProvider.primaryColor,
            mAppThemeProvider.gradientColor
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

  Future<MyProfileModel?> getMyProfile() async {
    if (PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN) != null) {
      return PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
    } else {
      return await getUserProfileData();
    }
  }

  Future<void> getMediaTypes() async {
    var _mediaTypeBlock = MediaTypeBlock();
    try {
      if (PreferenceUtil.getMediaType() != null) {
      } else {
        await _mediaTypeBlock
            .getMediTypesList()
            .then((value) {} as FutureOr Function(MediaDataList?));
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      await _mediaTypeBlock.getMediTypesList().then((value) {});
    }
  }

  String checkIfStringIsEmpty(String? value) {
    return value ?? '';
  }

  bool checkIfStringisNull(String? value) {
    return value != null && value != 'null';
  }

  // dateConversion(DateTime dateTime) {
  //   final newFormat = DateFormat('EEE ,MMMM d,yyyy');
  //   var updatedDate = newFormat.format(dateTime);

  //   return updatedDate;
  // }
  String setTimeZone() {
    var date = DateTime.now().timeZoneOffset.isNegative ? "-" : "+";
    final timeZoneSplit = DateTime.now().timeZoneOffset.toString().split(":");
    var hour = int.parse(timeZoneSplit[0]);
    hour = (hour).abs();
    date += hour < 10 ? "0${hour}" : "$hour";
    date += timeZoneSplit[1];
    return date;
  }

  regimentDateFormat(DateTime newDateTime,
      {bool isAck = false, bool isLanding = false, bool ackDate = false}) {
    DateFormat newFormat;
    var updatedDate = '';
    final currentTime = DateTime.now();
    if (newDateTime.day == currentTime.day &&
        newDateTime.month == currentTime.month &&
        newDateTime.year == currentTime.year) {
      if (isAck) {
        newFormat = DateFormat('hh:mm a');
      } else if (isLanding) {
        newFormat = DateFormat('HH:mm');
      } else {
        newFormat = DateFormat('MMM d, yyyy');
      }
      if (isAck) {
        updatedDate = 'Today at ';
      } else {
        updatedDate = 'Today, ';
      }
    } else {
      if (isAck) {
        if (ackDate)
          newFormat = DateFormat('MMM d, hh:mm a');
        else
          newFormat = DateFormat("MMM d, yyyy hh:mm a");
      } else if (isLanding) {
        newFormat = DateFormat('MMM d, HH:mm');
      } else {
        newFormat = DateFormat('EEE, MMM d, yyyy');
      }
    }
    updatedDate = updatedDate + newFormat.format(newDateTime);
    return updatedDate;
  }

  snoozeDataFormat(DateTime newDateTime) {
    DateFormat newFormat;
    var updatedDate = '';
    newFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    updatedDate = updatedDate + newFormat.format(newDateTime);
    return updatedDate;
  }

  regimentDateFormatV2(
    DateTime newDateTime, {
    bool isAck = false,
    bool isLanding = false,
  }) {
    DateFormat newFormat;
    var updatedDate = '';
    final currentTime = DateTime.now();
    if (newDateTime.day == currentTime.day &&
        newDateTime.month == currentTime.month &&
        newDateTime.year == currentTime.year) {
      if (isAck) {
        newFormat = DateFormat('hh:mm a');
      } else if (isLanding) {
        newFormat = DateFormat('HH:mm');
      } else {
        newFormat = DateFormat('MMM d, yyyy');
      }
    } else {
      if (isAck) {
        newFormat = DateFormat("MMM d, yyyy hh:mm a");
      } else if (isLanding) {
        newFormat = DateFormat('MMM d, HH:mm');
      } else {
        newFormat = DateFormat('EEE, MMM d, yyyy');
      }
    }
    updatedDate = updatedDate + newFormat.format(newDateTime);
    return updatedDate;
  }

  dateTimeString(DateTime dateTime) {
    if (dateTime != null && (dateTime.toString().isNotEmpty)) {
      final newFormat = DateFormat('MMM d, yyyy hh:mm a');
      final updatedDate = newFormat.format(dateTime);
      return updatedDate;
    } else {
      return '';
    }
  }

  dateConversionToDayMonthDate(DateTime dateTime) {
    final newFormat = DateFormat('EEEE, MMMM d');
    var updatedDate = newFormat.format(dateTime);
    return updatedDate;
  }

  dateConversionToDayMonthYear(DateTime dateTime) {
    final newFormat = DateFormat('d MMM, ' 'yyyy');
    final updatedDate = newFormat.format(dateTime);
    return updatedDate;
  }

  dateConversionToTime(DateTime dateTime) {
    final newFormat = DateFormat('h:mm a');
    var updatedDate = newFormat.format(dateTime);
    return updatedDate;
  }

  stringToDateTime(String string) {
    var dateTime = DateTime.parse(string);
    return dateTime;
  }

  removeLastThreeDigits(String string) {
    var removedString = '';
    removedString = string.substring(0, string.length - 3);
    return removedString;
  }

  static String getDateStringFromDateTime(String string,
      {bool forNotification = false}) {
    try {
      if (string != "" && string != null) {
        //check if date is empty or not
        var dateTime = DateTime.tryParse(string);
        if (dateTime != null) {
          return dateConversionToApiFormat(dateTime,
              MMM: true, forAppointmentNotification: forNotification);
        } else {
          DateFormat format = DateFormat(
              CommonUtil.REGION_CODE == 'IN' ? "dd-MM-yyyy" : "MM-dd-yyyy");

          var now = format.parse(string);
          final df = new DateFormat(
              CommonUtil.REGION_CODE == 'IN' ? 'dd-MMM-yyyy' : 'MMM-dd-yyyy');

          return df.format(now);
        }
      } else {
        DateFormat format = DateFormat(
            CommonUtil.REGION_CODE == 'IN' ? "dd-MM-yyyy" : "MM-dd-yyyy");

        var now =
            DateTime.now(); //when date is empty use the current date to fomat
        final df = DateFormat(
            CommonUtil.REGION_CODE == 'IN' ? 'dd-MMM-yyyy' : 'MMM-dd-yyyy');

        return format.format(now);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      DateFormat format = DateFormat(
          CommonUtil.REGION_CODE == 'IN' ? "dd-MM-yyyy" : "MM-dd-yyyy");

      var now = format.parse(string);
      final df = DateFormat(
          CommonUtil.REGION_CODE == 'IN' ? 'dd-MMM-yyyy' : 'MMM-dd-yyyy');

      return df.format(now);
    }
  }

  static String dateFormatterWithdatetimeseconds(DateTime dateTime,
      {bool isIndianTime = false}) {
    final newFormat = REGION_CODE == 'IN' || isIndianTime
        ? DateFormat('yyyy-MM-dd HH:mm:ss')
        : DateFormat('MM-dd-yyyy HH:mm:ss');
    final updatedDate = newFormat.format(dateTime);
    return updatedDate;
  }

  static String dateFormatterWithdatetimesecondsApiFormatAI(DateTime dateTime) {
    final newFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final updatedDate = newFormat.format(dateTime);
    return updatedDate;
  }

  List<CategoryResult> fliterCategories(List<CategoryResult> data) {
    final filteredCategoryData = <CategoryResult>[];
    for (final dataObj in data) {
      if (dataObj.isDisplay! &&
          dataObj.categoryName != Constants.STR_FEEDBACK &&
          dataObj.categoryName != Constants.STR_CLAIMSRECORD &&
          dataObj.categoryName != Constants.STR_WEARABLES) {
        if (!filteredCategoryData.contains(dataObj)) {
          filteredCategoryData.add(dataObj);
        }
      }
    }

    var i = 0;
    for (final categoryDataObj in filteredCategoryData) {
      if (categoryDataObj.categoryDescription ==
          CommonConstants.categoryDescriptionOthers) {
        categoryDataObjClone = categoryDataObj;
        // filteredCategoryData.removeAt(i);
        break;
      }
      i++;
    }

    filteredCategoryData.sort((a, b) {
      return a.categoryDescription!
          .toLowerCase()
          .compareTo(b.categoryDescription!.toLowerCase());
    });

    return filteredCategoryData;
  }

  CategoryResult getCatgeoryLabel(List<CategoryResult> filteredCategoryData) {
    for (final categoryDataObj in filteredCategoryData) {
      if (categoryDataObj.categoryDescription ==
          CommonConstants.categoryDescriptionOthers) {
        categoryDataObjClone = categoryDataObj;
      }
    }
    return categoryDataObjClone;
  }

  static Future<bool> askPermissionForCameraAndMic(
      {bool isAudioCall = false}) async {
//    await PermissionHandler().requestPermissions(
//      [PermissionGroup.camera, PermissionGroup.microphone],
//    );

    if (isAudioCall) {
      PermissionStatus micStatus = await Permission.microphone.request();
      if (micStatus == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {
      final status = await Permission.microphone.request();
      final cameraStatus = await Permission.camera.request();

      if (status == PermissionStatus.granted &&
          cameraStatus == PermissionStatus.granted) {
        return true;
      } else {
        _handleInvalidPermissions(cameraStatus, status);
        return false;
      }
    }
  }

  static void _handleInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus microphonePermissionStatus,
  ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      // throw PlatformException(
      //     code: 'PERMISSION_DENIED',
      //     message: 'Access to camera and microphone denied');
      print("Access to camera and microphone denied");
    } else if (cameraPermissionStatus == PermissionStatus.permanentlyDenied &&
        microphonePermissionStatus == PermissionStatus.permanentlyDenied) {
      // throw PlatformException(
      //     code: 'PERMISSION_DISABLED',
      //     message: 'Location data is not available on device');
      print("Access to camera and microphone denied permanently");
    }
  }

  static Future<bool> askPermissionForLocation(
      {bool isLocation = false}) async {
//    await PermissionHandler().requestPermissions(
//      [PermissionGroup.camera, PermissionGroup.microphone],
//    );

    if (isLocation) {
      LocationPermission locationStatus = await Geolocator.requestPermission();
      if (locationStatus != LocationPermission.denied &&
          locationStatus != LocationPermission.deniedForever) {
        return true;
      } else {
        return false;
      }
    } else {
      final status = await Geolocator.requestPermission();
      if (status != LocationPermission.denied &&
          status != LocationPermission.deniedForever) {
        return true;
      } else {
        _handleInvalidPermissionsLocations(status);
        return false;
      }
    }
  }

  static void _handleInvalidPermissionsLocations(
      LocationPermission locationPermissionStatus) {
    if (locationPermissionStatus == LocationPermission.denied) {
      print("Access to location denied");
    } else if (locationPermissionStatus == LocationPermission.deniedForever) {
      print("Access to location denied permanently");
    }
  }

  getDoctorProfileImageWidget(String? doctorUrl, Doctor? doctor) {
    String name = doctor!.firstName!.capitalizeFirstofEach;
    if (doctorUrl != null && doctorUrl != '') {
      return Image.network(
        doctorUrl,
        height: 50.0.h,
        width: 50.0.h,
        fit: BoxFit.cover,
        errorBuilder: (context, exception, stackTrace) {
          return Container(
            height: 50.0.h,
            width: 50.0.h,
            color: mAppThemeProvider.primaryColor,
            child: Center(
              child: getFirstLastNameText(doctor),
            ),
          );
        },
      );
    } else {
      return SizedBox(
        width: 50.0.h,
        height: 50.0.h,
        child:
            Container(width: 50.0.h, height: 50.0.h, color: Colors.grey[200]),
      );
    }

    ///load until snapshot.hasData resolves to true
  }

  Widget getFirstLastNameText(Doctor? doctor) {
    if (doctor != null && doctor.firstName != null && doctor.lastName != null) {
      return Text(
        doctor.firstName![0].toUpperCase() + doctor.lastName![0].toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    } else if (doctor != null && doctor.firstName != null) {
      return Text(
        doctor.firstName![0].toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    } else {
      return Text(
        '',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0.sp,
          fontWeight: FontWeight.w200,
        ),
      );
    }
  }

  Future<void> validateToken() async {
    final localToken = PreferenceUtil.getStringValue(Constants.STR_PUSH_TOKEN);
    var currentToken = await FirebaseMessaging.instance.getToken();
    if (localToken != currentToken) {
      await saveTokenToDatabase(currentToken);
    }
  }

  Future<bool> checkAppLock(
      {bool useErrorDialogs = true,
      Function(String)? authErrorCallback}) async {
    try {
      var value = await LocalAuthentication().authenticate(
        localizedReason: strAuthToUseApp,
        stickyAuth: true,
        biometricOnly: false,
        //useErrorDialogs: useErrorDialogs,
        useErrorDialogs: useErrorDialogs,
        // androidAuthStrings: AndroidAuthMessages(
        //   signInTitle: 'Oops! Biometric authentication required!',
        //   cancelButton: 'No thanks',
        // ),
        // iOSAuthStrings: IOSAuthMessages(
        //   cancelButton: 'No thanks',
        // ),
      );
      authErrorCallback?.call('');
      print("value:${value}");
      return value;
    } on PlatformException catch (e, stackTrace) {
      authErrorCallback?.call(e.code);
      if (e.code == auth_error.notAvailable) {
        print(e.message);
        return false;

        // Add handling of no hardware here.
      } else if (e.code == auth_error.notEnrolled) {
      } else if (e.code == auth_error.passcodeNotSet) {
        /// Indicates that the user has not yet configured a passcode (iOS) or
        /// PIN/pattern/password (Android) on the device.
        // return false; // Nothing sets but app lock code called
      } else {}
      return false;
    }
  }

  ListenForTokenUpdate() {
    FirebaseMessaging.instance.onTokenRefresh.listen((currentToken) {
      final localToken =
          PreferenceUtil.getStringValue(Constants.STR_PUSH_TOKEN);
      if (localToken != currentToken) {
        saveTokenToDatabase(currentToken);
      }
    });
  }

  Future<void> saveTokenToDatabase(String? token) async {
    try {
      final myProfile =
          PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
      final profileResult = myProfile!.result!;

      await CommonUtil().sendDeviceToken(
        PreferenceUtil.getStringValue(Constants.KEY_USERID),
        profileResult.userContactCollection3![0]!.email,
        profileResult.userContactCollection3![0]!.phoneNumber,
        token,
        true,
      );
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  escalateNonAdherance(
      String? careCoordinatorUserId,
      String? patientName,
      String? careGiverName,
      String? activityTime,
      String? activityName,
      String? userId,
      String? uid,
      String? patientPhoneNumber) async {
    final apiBaseHelper = ApiBaseHelper();
    var params = {
      "careCoordinatorUserId": careCoordinatorUserId,
      "patientName": patientName,
      "careGiverName": careGiverName,
      "activityTime": activityTime,
      "activityName": activityName,
      "uid": uid,
      "patientPhoneNumber": patientPhoneNumber,
      "userId": userId,
    };
    var response = await apiBaseHelper.escalateNonAdherance(
        'qurplan-node-mysql/escalate-nonadherence', params);
  }

  Future<DeviceInfoSucess> sendDeviceToken(String? userId, String? email,
      String? userMobileNo, String? deviceId, bool isActive) async {
    var jsonParam;
    final _firebaseMessaging = FirebaseMessaging.instance;
    final apiBaseHelper = ApiBaseHelper();
    String? token = '';
    try {
      token = await _firebaseMessaging.getToken();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    await PreferenceUtil.saveString(
        Constants.STR_PUSH_TOKEN, token ?? 'not available');

    String? pushkitToken =
        await PreferenceUtil.getStringValue(Constants.KEY_PUSH_KIT_TOKEN);
    var deviceInfo = Map<String, dynamic>();
    var user = Map<String, dynamic>();
    var jsonData = Map<String, dynamic>();

    user['id'] = userId;
    deviceInfo['user'] = user;
    deviceInfo['phoneNumber'] = userMobileNo;
    deviceInfo['email'] = email;
    deviceInfo['isActive'] = isActive;
    deviceInfo['deviceTokenId'] = token ?? 'NOT AVAILABLE';

    jsonData['deviceInfo'] = deviceInfo;

    if (Platform.isIOS) {
      deviceInfo['iosDeviceToken'] = pushkitToken;
    }
    if (Platform.isIOS) {
      jsonData['platformCode'] = 'IOSPLT';
      jsonData['deviceTypeCode'] = 'IPHONE';
    } else {
      jsonData['platformCode'] = 'ANDPLT';
      jsonData['deviceTypeCode'] = 'ANDROID';
    }

    var additionalInfo = Map<String, dynamic>();
    final packageInfo = await PackageInfo.fromPlatform();
    additionalInfo[stringAppVersion] =
        packageInfo.version + " + " + packageInfo.buildNumber;
    if (packageInfo.packageName == appQurbookBundleId) {
      additionalInfo[strAppType] = strAppTypeQurbook;
    } else if (packageInfo.packageName == appQurhomeBundleId) {
      additionalInfo[strAppType] = strAppTypeQurhome;
    } else if (packageInfo.packageName == appQurdayBundleId) {
      additionalInfo[strAppType] = strAppTypeQurday;
    }
    additionalInfo[strDeviceType] =
        (isTablet ?? false) ? strDeviceTypeTablet : strDeviceTypeMobile;
    jsonData[strAdditionalInfo] = additionalInfo;

    final params = json.encode(jsonData);

    print('DEVICE TOKEN INPUT: $params');

    var response =
        await apiBaseHelper.postDeviceId('device-info', params, isActive);
    if (isActive) {
      await PreferenceUtil.saveString(
          Constants.KEY_DEVICEINFO, variable.strtrue);
    } else {
      await PreferenceUtil.saveString(
          Constants.KEY_DEVICEINFO, variable.strFalse);
    }

    getLoggedIDetails();
    return DeviceInfoSucess.fromJson(response);
  }

  static Future<File?> downloadFile(String url, String? extension) async {
    try {
      final req = await ApiServices.get(url);
      final bytes = req!.bodyBytes;
      final dir = Platform.isIOS
          ? await FHBUtils.createFolderInAppDocDirForIOS('images')
          : await FHBUtils.createFolderInAppDocDir();

      String? imageName;
      if (url.contains('/')) {
        imageName = url.split('/').last;
      }
      String fileName = '$imageName$extension';
      var file = File('$dir${imageName}$extension');
      int fileNumber = 1;
      // Check if the file already exists
      while (await file.exists()) {
        fileName = '$imageName($fileNumber)$extension';
        file = File('$dir$fileName');
        fileNumber++;
      }

      await file.writeAsBytes(bytes);
      return file;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print('$e exception thrown');
    }
  }

  static void downloadMultipleFile(List images, BuildContext context) async {
    for (final currentImage in images) {
      try {
        final _currentImage =
            '${currentImage.response.data.fileContent}${currentImage.response.data.fileType}';
        final dir = await FHBUtils.createFolderInAppDocDir();
        final response = await Dio().get(currentImage.response.data.fileContent,
            options: Options(responseType: ResponseType.bytes));
        var file = File('$dir/${basename(_currentImage)}');
        final raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();

        //var img = await ImageDownloader.downloadImage(file.path);
        //var img_path = await ImageDownloader.findPath(img);
        // currentImage =
        //     '${basename(currentImage.response.data.fileContent)}${currentImage.response.data.fileType}';
        // var req =
        //     await ApiServices.get(Uri.parse(currentImage.response.data.fileContent));
        // var bytes = req.bodyBytes;
        // String dir = (await getTemporaryDirectory()).path;
        // File file =File(
        //     '$dir/${basename(currentImage.response.data.fileContent)}${currentImage.response.data.fileType}');
        // await file.writeAsBytes(bytes);
        /* var file_status =
            await GallerySaver.saveImage(file.path, albumName: 'myfhb');
        print('image file save status $file_status');
*/
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: const Text(variable.strFilesDownloaded),
        //   backgroundColor: mAppThemeProvider.primaryColor,
        // ));
      } catch (error) {
        print('$error exception thrown');
      }
    }
    Get.snackbar('status', variable.strFilesDownloaded);
  }

  List<HealthRecordCollection> getMetaMasterIdListNew(HealthResult data) {
    final List<HealthRecordCollection> mediaMasterIdsList = [];
    try {
      if (data.healthRecordCollection != null &&
          data.healthRecordCollection!.isNotEmpty) {
        for (var mediaMasterIds in data.healthRecordCollection!) {
          if (mediaMasterIds.fileType == '.jpg' ||
              mediaMasterIds.fileType == '.png' ||
              mediaMasterIds.fileType == '.pdf' ||
              mediaMasterIds.fileType == '.jpeg') {
            mediaMasterIdsList.add(mediaMasterIds);
          }
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    return mediaMasterIdsList.isNotEmpty ? mediaMasterIdsList : [];
  }

  void openWebViewNew(String? title, String? url, bool isLocal) {
    Get.to(MyFhbWebView(title: title, selectedUrl: url, isLocalAsset: isLocal));
  }

  void mSnackbar(BuildContext context, String message, String actionName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: mAppThemeProvider.primaryColor,
        elevation: 5,
        action: SnackBarAction(
            label: actionName,
            onPressed: () async {
              final myProfile = await fetchUserProfileInfo();
              if (myProfile.result != null) {
                await Navigator.pushNamed(context, router.rt_AddFamilyUserInfo,
                    arguments: AddFamilyUserInfoArguments(
                      myProfileResult: myProfile.result,
                      fromClass: CommonConstants.user_update,
                      isFromAppointmentOrSlotPage: true,
                      isForFamilyAddition: false,
                      isForFamily: false,
                    ));
              } else {
                FlutterToast()
                    .getToast('Unable to Fetch User Profile data', Colors.red);
              }
            }),
        duration: const Duration(seconds: 10),
      ),
    );
  }

  static String? toCheckEmailValidiation(
      String? value, String patternEmail, String strEmailValidText) {
    if (CommonUtil.REGION_CODE != "IN") {
      if (value!.length > 0 && value != null) {
        return AuthenticationValidator()
            .emailValidation(value, patternEmail, strEmailValidText);
      }
    } else {
      return AuthenticationValidator()
          .emailValidation(value!, patternEmail, strEmailValidText);
    }
  }

  Future<MyProfileModel> fetchUserProfileInfo() async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;
    var myProfile =
        await AddFamilyUserInfoRepository().getMyProfileInfoNew(userid);
    return myProfile;
  }

  Future<Widget?> showErrorAlert(String text, BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Info'),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                    fontSize: 18,
                    color: mAppThemeProvider.qurHomePrimaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showSingleLoadingDialog(BuildContext context) {
    LoaderClass.showLoadingDialog(
      context,
      canDismiss: true,
    );
  }

  void hideLoadingDialog(BuildContext context) {
    LoaderClass.hideLoadingDialog(context);
  }

  getCategoryFromTypeName(String typeName) {
    String category = '';
    switch (typeName.toUpperCase()) {
      case 'MANDACTIVITY':
        category = 'Missed Mandatory Activities';
        break;
      case 'VITALS':
        category = 'Vital Alerts';
        break;
      case 'MEDICATION':
        category = 'Missed Medication';
        break;
      case 'RULEALERT':
        category = 'Rule Based Alerts';
        break;
      case 'SYMPTOM':
        category = 'Symptom Alerts';
        break;
    }

    return category;
  }

  Future<bool> checkIfUserIdSame() async {
    bool isUserMainId = false;
    final userId = await PreferenceUtil.getStringValue(constants.KEY_USERID);
    final userIdMain =
        await PreferenceUtil.getStringValue(constants.KEY_USERID_MAIN);

    if (userId != userIdMain) {
      isUserMainId = false;
    } else {
      isUserMainId = true;
    }

    return isUserMainId;
  }

  showPatientListOfCaregiver(
      BuildContext context,
      Function(String? user, CareGiverPatientListResult? result)
          selectedUser) async {
    try {
      showSingleLoadingDialog(context);
      CareGiverPatientList? response;
      MyProfileModel? myProfile =
          await PreferenceUtil.getProfileData(KEY_PROFILE);
      response = await addFamilyUserInfoRepository.getCareGiverPatientList();
      hideLoadingDialog(context);

      showDialogPatientList(response?.result, myProfile, context, selectedUser);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      hideLoadingDialog(context);

      return showErrorAlert(unassignedMember, context);
    }
  }

  Future<Widget?> showDialogPatientList(
      List<CareGiverPatientListResult?>? result,
      MyProfileModel? myProfile,
      BuildContext context,
      Function(String? user, CareGiverPatientListResult? result) selectedUser) {
    if (result!.length > 0 && result != null) {
      CareGiverPatientListResult selfResult = CareGiverPatientListResult(
          childId: userID,
          firstName: myProfile?.result?.firstName,
          lastName: myProfile?.result?.lastName,
          middleName: myProfile?.result?.middleName,
          relationship: "You");
      result.insert(0, selfResult);
    }
    if (result!.length > 0 && result != null) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              width: MediaQuery.of(context)
                  .size
                  .width, //  <------- Use SizedBox to limit width
              child: ListView.separated(
                  shrinkWrap: true, //            <------  USE SHRINK WRAP
                  itemCount: result.length,
                  separatorBuilder: (BuildContext context, index) {
                    return Divider(
                      height: 1.0.h,
                      color: Colors.grey,
                    );
                  },
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        selectedUser(
                            result[index]?.relationship, result[index]);
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: result[index]?.firstName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: CommonUtil().isTablet!
                                      ? 20.0.sp
                                      : 18.0.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                children: [
                                  TextSpan(text: " "),
                                  TextSpan(
                                    text: result[index]?.lastName,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: CommonUtil().isTablet!
                                          ? 20.0.sp
                                          : 18.0.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(result[index]?.relationship ?? ''),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          );
        },
      );
    } else {
      return CommonUtil().showErrorAlert(unassignedMember, context);
    }
  }

  void navigateToQurhomeDasboard() {
    Get.back();
    Get.to(
      () => QurhomeDashboard(
        forPatientList: false,
        careGiverPatientListResult: null,
      ),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(
            () => QurhomeDashboardController(),
          );
        },
      ),
    );
  }

  void navigateToQurhomePatientDasboard(CareGiverPatientListResult? result) {
    Get.back();
    Get.to(
      () => QurhomeDashboard(
        forPatientList: true,
        careGiverPatientListResult: result,
      ),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(
            () => QurhomeDashboardController(),
          );
        },
      ),
    );
  }

  void getLoggedIDetails() async {
    var apiBaseHelper = ApiBaseHelper();

    var response = await apiBaseHelper.getLoginDetails();
    final loginDetails = LoginDetails.fromJson(response);

    await PreferenceUtil.save(
        Constants.KEY_LASTLOGGEDTIME, loginDetails.result!.lastLoggedIn);
  }

  Widget getNotificationIcon(BuildContext context,
      {Color? color, bool isFromQurday = false}) {
    try {
      int? count = 0;
      var targetID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('unreadNotifications')
              .doc(targetID)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              count = 0;

              if (snapshot.data!.data() != null) {
                if (snapshot.data!.data()!['count'] != null &&
                    snapshot.data!.data()!['count'] != '') {
                  count = snapshot.data!.data()!['count'];
                } else {
                  count = 0;
                }
              } else {
                count = 0;
              }

              return GestureDetector(
                onTap: () {
                  try {
                    var qurhomeDashboardController =
                        CommonUtil().onInitQurhomeDashboardController();
                    qurhomeDashboardController.updateBLETimer(Enable: false);

                    navigateToNotificationScreen(isFromQurday);
                  } catch (e, stackTrace) {
                    CommonUtil().appLogs(message: e, stackTrace: stackTrace);

                    print(e);
                  }
                },
                child: count! > 0
                    ? Badge.Badge(
                        position: Badge.BadgePosition.topEnd(
                          top: -8,
                          end: -5,
                        ),
                        toAnimate: false,
                        badgeColor: ColorUtils.countColor,
                        badgeContent: Container(
                          constraints:
                              BoxConstraints(minWidth: 6.w, minHeight: 6.h),
                          alignment: Alignment.center,
                          child: Center(
                            child: Text(
                              (count! > 99) ? '99+' : count.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: CommonUtil().isTablet! ? 14 : 9,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        child: IconWidget(
                          icon: Icons.notifications,
                          colors: isFromQurday
                              ? mAppThemeProvider.qurHomePrimaryColor
                              : Colors.white,
                          size: CommonUtil().isTablet! ? 33.0.sp : 27.0.sp,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              rt_notification_main,
                            );
                          },
                        ),
                      )
                    : BadgeIcon(
                        icon: Icon(
                          Icons.notifications,
                          color: isFromQurday
                              ? mAppThemeProvider.qurHomePrimaryColor
                              : Colors.white,
                          size: 30.0.sp,
                        ),
                        badgeColor: ColorUtils.countColor),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  try {
                    navigateToNotificationScreen(isFromQurday);
                  } catch (e, stackTrace) {
                    CommonUtil().appLogs(message: e, stackTrace: stackTrace);

                    print(e);
                  }
                },
                child: BadgeIcon(
                    icon: Icon(
                      Icons.notifications,
                      color: isFromQurday
                          ? mAppThemeProvider.qurHomePrimaryColor
                          : Colors.white,
                      size: 30.0.sp,
                    ),
                    badgeColor: ColorUtils.countColor),
              );
            }
          });
    } catch (e, stackTrace) {
      return GestureDetector(
        onTap: () {
          try {
            navigateToNotificationScreen(isFromQurday);
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);

            CommonUtil().appLogs(message: e, stackTrace: stackTrace);

            print(e);
          }
        },
        child: BadgeIcon(
            icon: Icon(
              Icons.notifications,
              color: isFromQurday
                  ? mAppThemeProvider.qurHomePrimaryColor
                  : Colors.white,
              size: 30.0.sp,
            ),
            badgeColor: ColorUtils.countColor),
      );
    }
  }

  navigateToNotificationScreen(bool isFromQurday) async {
    try {
      Get.to(
        NotificationMain(isFromQurday: isFromQurday),
      );
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  versionCheck(context, {bool showDialog = true}) async {
    //Get Current installed version of app
    final info = await PackageInfo.fromPlatform();
    var currentVersion = double.parse(info.version.trim().replaceAll('.', ''));
    var controller = Get.put(TroubleShootController());
    try {
      // Using default duration to force fetching from remote server.
      var apiBaseHelper = ApiBaseHelper();
      var endPoint = Platform.isIOS ? QURBOOK_iOS : QURBOOK_ANDROID;
      var response = await apiBaseHelper.getAppVersion(endPoint);
      // Check if the response is not null
      if (response != null) {
        final deviceVersionModel = DeviceVersion.fromJson(response);
        var newVersion;
        var isForceUpdate = false;
        if (deviceVersionModel.isSuccess!) {
          if (deviceVersionModel?.result != null) {
            newVersion = double.parse(deviceVersionModel.result!.versionName!
                .trim()
                .replaceAll('.', ''));
            if (deviceVersionModel.result!.additionalInfo! != null) {
              isForceUpdate = deviceVersionModel
                  .result!.additionalInfo!.qurbook!.isForceUpdate!;
            }
          }
        }

        if (newVersion > currentVersion) {
          isVersionLatest = false;

          if (showDialog) _showVersionDialog(context, isForceUpdate);
        }

        if (newVersion > currentVersion) {
          controller.isLatestVersion = false;
        } else if (newVersion <= currentVersion) {
          controller.isLatestVersion = true;
        }
      }
    } on FirebaseException catch (exception, stackTrace) {
      // Fetch throttled.
      isVersionLatest = false;
      controller.isLatestVersion = false;

      CommonUtil().appLogs(message: exception, stackTrace: stackTrace);
    } catch (exception, stackTrace) {
      isVersionLatest = false;
      controller.isLatestVersion = false;

      CommonUtil().appLogs(message: exception, stackTrace: stackTrace);
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  static updateDefaultUIStatus(bool status) {
    HealthReportListForUserRepository().getDeviceSelection().then((result) {
      if (result.isSuccess! && (result.result!.first.profileSetting != null)) {
        result.result!.first.profileSetting!.qurhomeDefaultUI = status;
        var body = jsonEncode(result.result!.first.toProfileSettingJson());
        ApiBaseHelper().updateDeviceSelection(qr_user_profile_no_slash, body);
      }
    });
  }

  static showFamilyMemberPlanExpiryDialog(String? pateintName,
      {String? redirect = myCartDetails}) async {
    await Get.defaultDialog(
      content: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Text(
          redirect == myCartDetails
              ? "Switch to $pateintName profile in Home screen and Tap on the Renew button again from the Notifications list"
              : "Switch to $pateintName profile in Home screen and Tap on the notification from the Notifications list",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      confirm: OutlinedButton(
        onPressed: () {
          Get.back();
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: mAppThemeProvider.primaryColor),
        ),
        child: Text(
          variable.strOK,
          style: TextStyle(
            color: mAppThemeProvider.primaryColor,
          ),
        ),
      ),
      onConfirm: () {
        Get.back();
      },
      // AlertDialog(
      //   title: Text(
      //     "Switch Profile",
      //     style: TextStyle(fontSize: 16),
      //   ),
      //   content: Text(
      //     "Switch to $pateintName profile in Home screen and Tap on the Renew button again from the Notifications list",
      //     style: TextStyle(fontSize: 14),
      //   ),
      //   actions: <Widget>[
      //     FlatButton(
      //       onPressed: () {
      //         Get.back();
      //       },
      //       child: Text(
      //         "ok",
      //         // style: TextStyle(
      //         //   color: mAppThemeProvider.primaryColor,
      //         // ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  _showVersionDialog(context, bool isForceUpdate) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        var title = STR_UPDATE_AVAIL;
        var message = STR_UPDATE_CONTENT;
        final btnLabel = STR_UPDATE_NOW;
        final btnLabelCancel = STR_LATER;
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(
                  title,
                  style: const TextStyle(fontSize: 16),
                ),
                content: Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
                actions: <Widget>[
                  FlatButtonWidget(
                    bgColor: Colors.transparent,
                    isSelected: true,
                    onPress: () => launchURL(APP_STORE_URL),
                    title: btnLabel,
                    titleColor: mAppThemeProvider.primaryColor,
                  ),
                  if (!isForceUpdate)
                    FlatButtonWidget(
                      bgColor: Colors.transparent,
                      isSelected: true,
                      title: btnLabelCancel,
                      titleColor: mAppThemeProvider.primaryColor,
                      onPress: () => Navigator.pop(context),
                    ),
                  /*else
                    SizedBox.shrink(),*/
                ],
              )
            : WillPopScope(
                onWillPop: () async => isForceUpdate ? false : true,
                child: AlertDialog(
                  title: Text(
                    title,
                    style: TextStyle(fontSize: 16),
                  ),
                  content: Text(
                    message,
                    style: TextStyle(fontSize: 14),
                  ),
                  actions: <Widget>[
                    FlatButtonWidget(
                      width: 115,
                      bgColor: Colors.transparent,
                      isSelected: true,
                      onPress: () => launchURL(PLAY_STORE_URL),
                      title: btnLabel,
                      titleColor: mAppThemeProvider.primaryColor,
                    ),
                    if (!isForceUpdate)
                      FlatButtonWidget(
                        bgColor: Colors.transparent,
                        isSelected: true,
                        title: btnLabelCancel,
                        titleColor: mAppThemeProvider.primaryColor,
                        onPress: () => Navigator.pop(context),
                      )
                    /*else
                      SizedBox.shrink(),*/
                  ],
                ),
              );
      },
    );
  }

  requestQurhomeDialog() async {
    if (!PreferenceUtil.isKeyValid(KeyShowQurhomeDefaultUI)) {
      if (!PreferenceUtil.getIfQurhomeisDefaultUI()) {
        await Future.delayed(const Duration(seconds: 0));
        _showDefaultUIDialog();
      }
      PreferenceUtil.saveShownQurhomeDefaultUI();
    }
  }

  _showDefaultUIDialog() async {
    await showDialog<String>(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) {
        var message = strQurhomeDefaultUI;
        final btnLabel = strCamelYes;
        final btnLabelCancel = strCamelNo;
        return Platform.isIOS
            ? CupertinoAlertDialog(
                content: Text(
                  message,
                  style: TextStyle(fontSize: 14),
                ),
                actions: <Widget>[
                  FlatButtonWidget(
                    bgColor: Colors.transparent,
                    isSelected: true,
                    onPress: () {
                      Get.back();
                      if (!PreferenceUtil.getIfQurhomeisDefaultUI()) {
                        PreferenceUtil.saveQurhomeAsDefaultUI(
                          qurhomeStatus: true,
                        );
                      }
                    },
                    title: btnLabel,
                    titleColor: mAppThemeProvider.primaryColor,
                  ),
                  FlatButtonWidget(
                    bgColor: Colors.transparent,
                    isSelected: true,
                    title: btnLabelCancel,
                    titleColor: mAppThemeProvider.primaryColor,
                    onPress: () => Get.back(),
                  ),
                  /*else
                    SizedBox.shrink(),*/
                ],
              )
            : AlertDialog(
                content: Text(
                  message,
                  style: TextStyle(fontSize: 14),
                ),
                actions: <Widget>[
                  FlatButtonWidget(
                    bgColor: Colors.transparent,
                    isSelected: true,
                    onPress: () {
                      Get.back();
                      if (!PreferenceUtil.getIfQurhomeisDefaultUI()) {
                        PreferenceUtil.saveQurhomeAsDefaultUI(
                          qurhomeStatus: true,
                        );
                      }
                    },
                    title: btnLabel,
                    titleColor: mAppThemeProvider.primaryColor,
                  ),
                  FlatButtonWidget(
                    bgColor: Colors.transparent,
                    isSelected: true,
                    title: btnLabelCancel,
                    titleColor: mAppThemeProvider.primaryColor,
                    onPress: () => Get.back(),
                  ),
                ],
              );
      },
    );
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  navigateToRecordDetailsScreen(String? id) async {
    final helper = ApiBaseHelper();
    String? userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var requestParam = {};
    requestParam[qr_userid] = userID;
    requestParam[qr_healthRecordMetaIds] = [id];
    var jsonString = jsonEncode(requestParam);
    String queryVal = qr_health_record + qr_filter;
    try {
      final response = await helper.getHealthRecordLists(
        jsonString,
        queryVal,
      );
      var record = HealthRecordList.fromJson(response);
      if (record.isSuccess! && (record.result ?? []).length > 0) {
        Get.to(
          () => RecordDetailScreen(
            data: record.result!.first,
          ),
        );
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e.toString());
    }
  }

  Future<int?> getCategoryListPos(String? categoryName) async {
    var position = 0;
    _categoryResponseListRepository = CategoryResponseListRepository();
    var filteredCategoryData = <CategoryResult>[];
    if (filteredCategoryData == null || filteredCategoryData.isEmpty) {
      try {
        var categoryResponseList =
            await _categoryResponseListRepository.getCategoryLists();
        filteredCategoryData = fliterCategories(categoryResponseList.result!);
        for (var i = 0;
            i <
                (filteredCategoryData == null
                    ? 0
                    : filteredCategoryData.length);
            i++) {
          if (categoryName == filteredCategoryData[i].categoryName) {
            print(categoryName! +
                ' ****' +
                filteredCategoryData[i].categoryName!);
            position = i;
          }
        }
        if (categoryName == AppConstants.prescription) {
          return position;
        } else if (categoryName == Constants.STR_IDDOCS ||
            categoryName == Constants.STR_HOS_ID ||
            categoryName == Constants.STR_OTHER_ID ||
            categoryName == Constants.STR_INSURE_ID) {
          final pos = filteredCategoryData
              .indexWhere((data) => data.categoryName == Constants.STR_IDDOCS);
          return pos > 0 ? pos : 0;
        } else {
          return position;
        }
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);

        print(e.toString());
      }
    } else {
      return position;
    }
  }

  void navigateToMyRecordsCategory(
      categoryType, List<String?>? hrmId, bool isTerminate) async {
    var value = await getCategoryListPos(categoryType);
    if (value != null) {
      goToMyRecordsScreen(value, hrmId, isTerminate);
    }
  }

  void goToMyRecordsScreen(position, List<String?>? hrmId, bool isTerminate) {
    if (isTerminate) {
      Get.toNamed(router.rt_MyRecords,
              arguments: MyRecordsArgument(
                  categoryPosition: position,
                  allowSelect: false,
                  isAudioSelect: false,
                  isNotesSelect: false,
                  selectedMedias: hrmId,
                  isFromChat: false,
                  showDetails: true,
                  isAssociateOrChat: false,
                  fromAppointments: false,
                  fromClass: 'notification'))!
          .then((value) =>
              Get.offNamedUntil(router.rt_Landing, (route) => false));
    } else {
      Get.to(
        MyRecords(
          argument: MyRecordsArgument(
              categoryPosition: position,
              allowSelect: false,
              isAudioSelect: false,
              isNotesSelect: false,
              selectedMedias: hrmId,
              isFromChat: false,
              showDetails: true,
              isAssociateOrChat: false,
              fromAppointments: false,
              fromClass: 'notification'),
        ),
      );
    }
  }

  static Map<String, String> supportedLanguages = {
    'english': 'en',
    'french': 'fr',
    'german': 'de',
    'spanish': 'es',
    'bengali': 'bn',
    'gujarati': 'gu',
    'hindi': 'hi',
    'kannada': 'kn',
    'malayalam': 'ml',
    'tamil': 'ta',
    'telugu': 'te',
  };

  static Map<String, String> langaugeCodes = {
    'en': strDefaultLanguage,
    'ta': 'ta-IN',
    'te': 'te-IN',
    'hi': 'hi-IN',
    'undef': 'undef',
    'bn': 'bn-IN',
    'gu': 'gu-IN',
    'kn': 'kn-IN',
    'ml': 'ml-IN',
    'es': 'es-ES',
    'fr': 'fr-FR',
    'de': 'de-DE'
  };

  static String? getCurrentLanCode() {
    if (PreferenceUtil.getStringValue(SHEELA_LANG) != null &&
        PreferenceUtil.getStringValue(SHEELA_LANG) != '') {
      return PreferenceUtil.getStringValue(SHEELA_LANG);
    } else {
      return 'undef';
    }
  }

  String dateFormatConversion(String? datetime) {
    var formattedDate = '';
    if (datetime != null && datetime != '') {
      final dateTimeStamp = DateTime.parse(datetime);
      formattedDate = DateFormat('MMM dd yyyy').format(dateTimeStamp);
    } else {
      formattedDate = '';
    }
    return formattedDate;
  }

  profileValidationCheck(BuildContext context,
      {String? packageId,
      String? isSubscribed,
      String? providerId,
      String? isFrom,
      bool? feeZero,
      Function()? refresh}) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;
    await showLoadingDialog(context, _keyLoader, variable.Please_Wait);
    await addFamilyUserInfoRepository.getMyProfileInfoNew(userId).then((value) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      myProfile = value;
    });

    if (myProfile != null) {
      addressValidation(context,
          packageId: packageId,
          isSubscribed: isSubscribed,
          providerId: providerId,
          isFrom: isFrom,
          feeZero: feeZero,
          refresh: refresh);
    } else {
      FlutterToast().getToast(noGender, Colors.red);
    }
  }

  addressValidation(BuildContext context,
      {String? packageId,
      String? isSubscribed,
      String? providerId,
      String? isFrom,
      bool? feeZero,
      Function()? refresh}) {
    if (myProfile != null) {
      if (myProfile!.isSuccess!) {
        if (myProfile!.result != null) {
          if (myProfile!.result!.gender != null &&
              myProfile!.result!.gender!.isNotEmpty) {
            if (myProfile!.result!.dateOfBirth != null &&
                myProfile!.result!.dateOfBirth!.isNotEmpty) {
              if (myProfile!.result!.additionalInfo != null) {
                if (isFrom == strIsFromSubscibe) {
                  if (myProfile!.result!.userAddressCollection3 != null) {
                    if (myProfile!.result!.userAddressCollection3!.isNotEmpty) {
                      patientAddressCheck(
                          myProfile!.result!.userAddressCollection3![0],
                          context,
                          packageId: packageId,
                          isSubscribed: isSubscribed,
                          providerId: providerId,
                          feeZero: feeZero,
                          refresh: refresh);
                    } else {
                      mCustomAlertDialog(context,
                          content: CONTENT_PROFILE_CHECK,
                          packageId: packageId,
                          isSubscribed: isSubscribed,
                          providerId: providerId,
                          feeZero: feeZero,
                          refresh: refresh);
                    }
                  } else {
                    mCustomAlertDialog(context,
                        content: CONTENT_PROFILE_CHECK,
                        packageId: packageId,
                        isSubscribed: isSubscribed,
                        providerId: providerId,
                        feeZero: feeZero,
                        refresh: refresh);
                  }
                }
                //// for appointment book we need to check height weight
                else {
                  if (myProfile!.result!.additionalInfo!.height != null &&
                      myProfile!.result!.additionalInfo!.height!.isNotEmpty) {
                    if (myProfile!.result!.additionalInfo!.weight != null &&
                        myProfile!.result!.additionalInfo!.weight!.isNotEmpty) {
                      if (myProfile!.result!.userAddressCollection3 != null) {
                        if (myProfile!
                            .result!.userAddressCollection3!.isNotEmpty) {
                          patientAddressCheck(
                              myProfile!.result!.userAddressCollection3![0],
                              context,
                              packageId: packageId,
                              isSubscribed: isSubscribed,
                              providerId: providerId,
                              feeZero: feeZero,
                              refresh: refresh);
                        } else {
                          mCustomAlertDialog(context,
                              content: CONTENT_PROFILE_CHECK,
                              packageId: packageId,
                              providerId: providerId,
                              isSubscribed: isSubscribed,
                              feeZero: feeZero,
                              refresh: refresh);
                        }
                      } else {
                        mCustomAlertDialog(context,
                            content: CONTENT_PROFILE_CHECK,
                            packageId: packageId,
                            providerId: providerId,
                            isSubscribed: isSubscribed,
                            feeZero: feeZero,
                            refresh: refresh);
                      }
                    } else {
                      mCustomAlertDialog(context,
                          content: CONTENT_PROFILE_CHECK,
                          packageId: packageId,
                          providerId: providerId,
                          isSubscribed: isSubscribed,
                          feeZero: feeZero,
                          refresh: refresh);
                    }
                  } else {
                    mCustomAlertDialog(context,
                        content: CONTENT_PROFILE_CHECK,
                        packageId: packageId,
                        providerId: providerId,
                        isSubscribed: isSubscribed,
                        feeZero: feeZero,
                        refresh: refresh);
                  }
                }
              } else {
                mCustomAlertDialog(context,
                    content: CONTENT_PROFILE_CHECK,
                    packageId: packageId,
                    providerId: providerId,
                    isSubscribed: isSubscribed,
                    feeZero: feeZero,
                    refresh: refresh);
              }
            } else {
              mCustomAlertDialog(context,
                  content: CONTENT_PROFILE_CHECK,
                  packageId: packageId,
                  providerId: providerId,
                  isSubscribed: isSubscribed,
                  feeZero: feeZero,
                  refresh: refresh);
            }
          } else {
            mCustomAlertDialog(context,
                content: CONTENT_PROFILE_CHECK,
                packageId: packageId,
                providerId: providerId,
                isSubscribed: isSubscribed,
                feeZero: feeZero,
                refresh: refresh);
          }
        } else {
          mCustomAlertDialog(context,
              content: CONTENT_PROFILE_CHECK,
              packageId: packageId,
              providerId: providerId,
              isSubscribed: isSubscribed,
              feeZero: feeZero,
              refresh: refresh);
        }
      } else {
        mCustomAlertDialog(context,
            content: CONTENT_PROFILE_CHECK,
            packageId: packageId,
            providerId: providerId,
            isSubscribed: isSubscribed,
            feeZero: feeZero,
            refresh: refresh);
      }
    } else {
      mCustomAlertDialog(context,
          content: CONTENT_PROFILE_CHECK,
          packageId: packageId,
          providerId: providerId,
          isSubscribed: isSubscribed,
          feeZero: feeZero,
          refresh: refresh);
    }
  }

  patientAddressCheck(
      UserAddressCollection3 userAddressCollection, BuildContext context,
      {String? packageId,
      String? isSubscribed,
      String? providerId,
      bool? feeZero,
      Function()? refresh}) {
    var address1 = userAddressCollection.addressLine1 ?? '';
    if (userAddressCollection.city != null) {
      var city = userAddressCollection.city!.name ?? '';
      final state = userAddressCollection.state!.name ?? '';

      if (address1 != '' && city != '' && state != '') {
        //check if its subcribed we need not to show disclimer alert
        if (isSubscribed == '1') {
          if (isSubscribed == '0') {
            var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;
            updateProvidersBloc
                .mappingHealthOrg(providerId, userId)
                .then((value) {
              if (value != null) {
                if (value.success!) {
                  subscribeViewModel.subScribePlan(packageId!).then((value) {
                    if (value != null) {
                      if (value.isSuccess!) {
                        if (value.result != null) {
                          if (value.result!.result == 'Done') {
                            Get.back(result: 'refreshUI');
                          } else {
                            FlutterToast().getToast(
                                value.result!.message ?? 'Subscribe Failed',
                                Colors.red);
                          }
                        }
                      } else {
                        FlutterToast().getToast('Subscribe Failed', Colors.red);
                      }
                    }
                  });
                } else {
                  FlutterToast().getToast('Subscribe Map Failed', Colors.red);
                }
              } else {
                FlutterToast().getToast('Subscribe Map Failed', Colors.red);
              }
            });
          } else {
            unSubcribeAlertDialog(context,
                packageId: packageId, refresh: refresh);
          }
        } else {
          // if its unsubscibed need to invoke discalimer dialog
          mDisclaimerAlertDialog(
              packageId: packageId,
              isSubscribed: isSubscribed,
              providerId: providerId,
              refresh: refresh,
              feeZero: feeZero,
              context: context);
        }
      } else {
        mCustomAlertDialog(context,
            content: CONTENT_PROFILE_CHECK,
            packageId: packageId,
            isSubscribed: isSubscribed,
            providerId: providerId,
            feeZero: feeZero,
            refresh: refresh);
      }
    } else {
      mCustomAlertDialog(context,
          content: CONTENT_PROFILE_CHECK,
          packageId: packageId,
          isSubscribed: isSubscribed,
          providerId: providerId,
          feeZero: feeZero,
          refresh: refresh);
    }
  }

  Future<dynamic> mCustomAlertDialog(BuildContext context,
      {String? title,
      String? content,
      String? packageId,
      String? isSubscribed,
      bool? feeZero,
      Function()? refresh,
      String? providerId}) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Column(children: [
                    //CircularProgressIndicator(),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Text(
                      content!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0.sp,
                      ),
                    ),
                    SizedBox(
                      height: 5.0.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            // open profile page
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: mAppThemeProvider.primaryColor,
                            ),
                          ),
                          child: Text(
                            'cancel'.toUpperCase(),
                            style: TextStyle(
                              color: mAppThemeProvider.primaryColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0.h,
                        ),
                        OutlinedButton(
                          //hoverColor: mAppThemeProvider.primaryColor,
                          onPressed: () async {
                            // open profile page
                            Navigator.of(context).pop();
                            var myProfile = await fetchUserProfileInfo();
                            await Get.toNamed(router.rt_AddFamilyUserInfo,
                                arguments: AddFamilyUserInfoArguments(
                                  myProfileResult: myProfile.result,
                                  fromClass: CommonConstants.user_update,
                                  isFromCSIR: true,
                                  packageId: packageId,
                                  providerId: providerId,
                                  isSubscribed: isSubscribed,
                                  feeZero: feeZero,
                                  refresh: refresh,
                                  isForFamilyAddition: false,
                                  isFromAppointmentOrSlotPage: false,
                                  isForFamily: false,
                                ));
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: mAppThemeProvider.primaryColor,
                            ),
                          ),
                          //hoverColor: mAppThemeProvider.primaryColor,
                          child: Text(
                            'complete profile'.toUpperCase(),
                            style: TextStyle(
                              color: mAppThemeProvider.primaryColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ]),
          );
        });
  }

  Future<dynamic> unSubcribeAlertDialog(
    BuildContext context, {
    String? title,
    String? content,
    String? packageId,
    String? isSubscribed,
    Function()? refresh,
    bool fromDetail = false,
  }) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Column(children: [
                    //CircularProgressIndicator(),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Text(
                      CONTENT_UNSUBSCRIBE_PACKAGE,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0.sp,
                      ),
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            // open profile page
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: mAppThemeProvider.primaryColor,
                            ),
                          ),
                          child: Text(
                            'no'.toUpperCase(),
                            style: TextStyle(
                              color: mAppThemeProvider.primaryColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0.h,
                        ),
                        OutlinedButton(
                          //hoverColor: mAppThemeProvider.primaryColor,
                          onPressed: () async {
                            CommonUtil.showLoadingDialog(
                                context, _keyLoader, variable.Please_Wait);
                            await subscribeViewModel.UnsubScribePlan(packageId!)
                                .then((value) {
                              if (value != null) {
                                if (value.isSuccess!) {
                                  if (value.result != null) {
                                    if (value.result!.result == 'Done') {
                                      //setState(() {});
                                      Navigator.of(_keyLoader.currentContext!,
                                              rootNavigator: true)
                                          .pop();
                                      if (fromDetail) {
                                        Get.back();
                                      }
                                      Get.back(result: 'refreshUI');
                                      refresh!();
                                    } else {
                                      Navigator.of(_keyLoader.currentContext!,
                                              rootNavigator: true)
                                          .pop();
                                      Get.back();
                                      FlutterToast().getToast(
                                          value.result!.message ??
                                              'UnSubscribe Failed',
                                          Colors.red);
                                    }
                                  }
                                } else {
                                  Navigator.of(_keyLoader.currentContext!,
                                          rootNavigator: true)
                                      .pop();
                                  Get.back();
                                  FlutterToast().getToast(
                                      'UnSubscribe Failed', Colors.red);
                                }
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: mAppThemeProvider.primaryColor,
                            ),
                          ),
                          //hoverColor: mAppThemeProvider.primaryColor,
                          child: Text(
                            'yes'.toUpperCase(),
                            style: TextStyle(
                              color: mAppThemeProvider.primaryColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ]),
          );
        });
  }

  Future<dynamic> mDisclaimerAlertDialog(
      {required BuildContext context,
      String? title,
      String? content,
      String? packageId,
      String? isSubscribed,
      String? providerId,
      bool? feeZero,
      Function()? refresh}) async {
    await Get.dialog(
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Disclaimer',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0.sp,
              ),
            ),
            Expanded(
              child: IconButton(
                  icon: Icon(Icons.close_rounded),
                  onPressed: () {
                    Get.back();
                  }),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  //color: Colors.blue,
                  margin: EdgeInsets.symmetric(horizontal: 1),
                  width: double.infinity,
                  child: Column(children: [
                    Text(
                      CONTENT_DISCALIMER,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w300),
                    ),
                  ]),
                ),
              ]),
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  //hoverColor: mAppThemeProvider.primaryColor,
                  onPressed: () async {
                    // open profile page
                    if (feeZero!) {
                      Navigator.pop(context);
                      CommonUtil.showLoadingDialog(
                          context, _keyLoader, variable.Please_Wait);
                      final userId =
                          PreferenceUtil.getStringValue(Constants.KEY_USERID)!;
                      await updateProvidersBloc
                          .mappingHealthOrg(providerId, userId)
                          .then((value) {
                        if (value != null) {
                          if (value.success!) {
                            subscribeViewModel
                                .subScribePlan(packageId!)
                                .then((value) {
                              if (value != null) {
                                if (value.isSuccess!) {
                                  if (value.result != null) {
                                    if (value.result!.result == 'Done') {
                                      Navigator.of(_keyLoader.currentContext!,
                                              rootNavigator: true)
                                          .pop();
                                      refresh!();

                                      //TODO: to confirm
                                      /*
                                      Provider.of<RegimentViewModel>(
                                        context,
                                        listen: false,
                                      ).updateTabIndex(currentIndex: 3);
                                      Get.offNamedUntil(
                                          router.rt_MyPlans, (route) => false);
                                          */
                                    } else {
                                      Navigator.of(_keyLoader.currentContext!,
                                              rootNavigator: true)
                                          .pop();
                                      FlutterToast().getToast(
                                          value.result!.message ??
                                              'Subscribe Failed',
                                          Colors.red);
                                    }
                                  }
                                } else {
                                  Navigator.of(_keyLoader.currentContext!,
                                          rootNavigator: true)
                                      .pop();
                                  FlutterToast()
                                      .getToast('Subscribe Failed', Colors.red);
                                }
                              }
                            });
                          } else {
                            Navigator.of(_keyLoader.currentContext!,
                                    rootNavigator: true)
                                .pop();
                            FlutterToast()
                                .getToast('Subscribe Map Failed', Colors.red);
                          }
                        } else {
                          Navigator.of(_keyLoader.currentContext!,
                                  rootNavigator: true)
                              .pop();
                          FlutterToast()
                              .getToast('Subscribe Map Failed', Colors.red);
                        }
                      });
                    } else {
                      if (isSubscribed == '0') {
                        Navigator.pop(context);
                        _dialogForSubscribePayment(
                            context, providerId, packageId, false, () {
                          refresh!();
                        });
                      } else {
                        await subscribeViewModel.UnsubScribePlan(packageId!)
                            .then((value) {
                          if (value != null) {
                            if (value.isSuccess!) {
                              if (value.result != null) {
                                if (value.result!.result == 'Done') {
                                  Navigator.of(_keyLoader.currentContext!,
                                          rootNavigator: true)
                                      .pop();
                                  Get.back(result: 'refreshUI');
                                  refresh!();
                                } else {
                                  Navigator.of(_keyLoader.currentContext!,
                                          rootNavigator: true)
                                      .pop();
                                  Get.back(result: 'refreshUI');
                                  FlutterToast().getToast(
                                      value.result!.message ??
                                          'UnSubscribe Failed',
                                      Colors.red);
                                }
                              }
                            } else {
                              Navigator.of(_keyLoader.currentContext!,
                                      rootNavigator: true)
                                  .pop();
                              FlutterToast()
                                  .getToast('UnSubscribe Failed', Colors.red);
                            }
                          }
                        });
                      }
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: mAppThemeProvider.primaryColor,
                    ),
                  ),
                  //hoverColor: mAppThemeProvider.primaryColor,
                  child: Text(
                    'accept'.toUpperCase(),
                    style: TextStyle(
                      color: mAppThemeProvider.primaryColor,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                  onPressed: () async {
                    // open profile page
                    Get.back();
                    Get.back(result: 'refreshUI');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: mAppThemeProvider.primaryColor,
                    ),
                  ),
                  child: Text(
                    'Reject'.toUpperCase(),
                    style: TextStyle(
                      color: mAppThemeProvider.primaryColor,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<DateTime> selectDate(BuildContext context, DateTime _date,
      DateTime startDate, DateTime endDate, bool isExpired) async {
    DateTime firstDate;

    if (isExpired) {
      print('endDate: expired');
      firstDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
    } else {
      print('endDate:' + endDate.toString());
      firstDate = endDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: firstDate,
      lastDate: DateTime(2040),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light().copyWith(
            primary: mAppThemeProvider.primaryColor,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      _date = picked;
    }
    return _date;
  }

  Future<dynamic> renewAlertDialog(BuildContext context,
      {String? title,
      String? content,
      String? packageId,
      String? isSubscribed,
      bool? IsExtendable,
      String? price,
      String? startDate,
      String? endDate,
      required bool isExpired,
      Function()? refresh,
      bool moveToCart = false,
      dynamic nsBody,
      String? packageDuration}) async {
    DateTime initDate;
    var formatter = DateFormat('yyyy-MM-dd');

    DateTime startDateFinal = startDate != null
        ? DateFormat("yyyy-MM-dd").parse(startDate)
        : DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime endDateFinal = endDate != null
        ? DateFormat("yyyy-MM-dd").parse(endDate)
        : DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (isExpired) {
      initDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
    } else {
      initDate = endDateFinal;
    }

    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(children: <Widget>[
              StatefulBuilder(builder: (context, setState) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Column(children: [
                      //CircularProgressIndicator(),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      Text(
                        CONTENT_RENEW_PACKAGE,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0.sp,
                        ),
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      FittedBox(
                          child: Row(
                        children: <Widget>[
                          Text(
                            'Effective Renewal Date: ',
                          ),
                          SizedBox(width: 5.w),
                          IconButton(
                            icon: Icon(Icons.calendar_today, size: 18.sp),
                            onPressed: () async {
                              initDate = await selectDate(
                                  context,
                                  isExpired ? initDate : endDateFinal,
                                  startDateFinal,
                                  endDateFinal,
                                  isExpired);
                              setState(() {});
                            },
                          ),
                          Text('${formatter.format(initDate)}'),
                        ],
                      )),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      FittedBox(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              // open profile page
                              isRenewDialogOpened = false;
                              Navigator.of(context).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: mAppThemeProvider.primaryColor,
                              ),
                            ),
                            child: Text(
                              'no'.toUpperCase(),
                              style: TextStyle(
                                color: mAppThemeProvider.primaryColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0.h,
                          ),
                          OutlinedButton(
                            //hoverColor: mAppThemeProvider.primaryColor,
                            onPressed: () async {
                              Navigator.pop(context);
                              /*_dialogForSubscribePayment(
                                  context, '', packageId, true, () {
                                refresh();
                              });*/
                              isRenewDialogOpened = false;
                              if (moveToCart && nsBody != null) {
                                try {
                                  FetchNotificationService()
                                      .updateNsActionStatus(nsBody)
                                      .then((data) {
                                    FetchNotificationService()
                                        .updateNsOnTapAction(nsBody);
                                  });
                                } catch (e, stackTrace) {
                                  CommonUtil().appLogs(
                                      message: e, stackTrace: stackTrace);
                                }
                              }

                              if (IsExtendable!) {
                                var response =
                                    await Provider.of<PlanWizardViewModel>(
                                            context,
                                            listen: false)
                                        .addToCartItem(
                                            packageId: packageId,
                                            price: price,
                                            isRenew: true,
                                            isFromAdd: strMyPlan,
                                            packageDuration: packageDuration);

                                refresh!();
                                if (moveToCart) {
                                  if ((response!.message!.toLowerCase() ==
                                          'Product already exists in cart'
                                              .toLowerCase()) ||
                                      response.isSuccess!) {
                                    Get.to(CheckoutPage());
                                  }
                                }
                              } else {
                                FlutterToast().getToast(
                                    'Renewal limit reached for this plan. Please try after few days',
                                    Colors.black);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: mAppThemeProvider.primaryColor,
                              ),
                            ),
                            //hoverColor: mAppThemeProvider.primaryColor,
                            child: Text(
                              'yes'.toUpperCase(),
                              style: TextStyle(
                                color: mAppThemeProvider.primaryColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      )),
                    ]),
                  ),
                );
              }),
            ]),
          );
        });
  }

  Future<dynamic> alertDialogForNoReFund(
    BuildContext context, {
    String? title,
    String? content,
    String? packageId,
    String? isSubscribed,
    Function()? refresh,
    bool fromDetail = false,
  }) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Column(children: [
                    //CircularProgressIndicator(),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Text(
                      CONTENT_NO_REFUND,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0.sp,
                      ),
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            // open profile page
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: mAppThemeProvider.primaryColor,
                            ),
                          ),
                          child: Text(
                            'cancel'.toUpperCase(),
                            style: TextStyle(
                              color: mAppThemeProvider.primaryColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0.h,
                        ),
                        OutlinedButton(
                          //hoverColor: mAppThemeProvider.primaryColor,
                          onPressed: () async {
                            CommonUtil.showLoadingDialog(
                                context, _keyLoader, variable.Please_Wait);
                            await subscribeViewModel.UnsubScribePlan(packageId!)
                                .then((value) {
                              if (value != null) {
                                if (value.isSuccess!) {
                                  if (value.result != null) {
                                    if (value.result!.result == 'Done') {
                                      //setState(() {});

                                      Navigator.of(_keyLoader.currentContext!,
                                              rootNavigator: true)
                                          .pop();
                                      if (fromDetail) {
                                        Get.back();
                                      }
                                      Get.back(result: 'refreshUI');
                                      refresh!();
                                    } else {
                                      Navigator.of(_keyLoader.currentContext!,
                                              rootNavigator: true)
                                          .pop();
                                      Get.back();
                                      FlutterToast().getToast(
                                          value.result!.message ??
                                              'UnSubscribe Failed',
                                          Colors.red);
                                    }
                                  }
                                } else {
                                  Navigator.of(_keyLoader.currentContext!,
                                          rootNavigator: true)
                                      .pop();
                                  Get.back();
                                  FlutterToast().getToast(
                                      'UnSubscribe Failed', Colors.red);
                                }
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: mAppThemeProvider.primaryColor,
                            ),
                          ),
                          //hoverColor: mAppThemeProvider.primaryColor,
                          child: Text(
                            'confirm'.toUpperCase(),
                            style: TextStyle(
                              color: mAppThemeProvider.primaryColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ]),
          );
        });
  }

  Widget customImage(
    String? iconApi, {
    Widget? defaultWidget,
    String? planInitial,
  }) {
    var defaultInitial = '';
    if ((planInitial ?? '').isNotEmpty) {
      var planWords = planInitial?.split(' ') ?? [];
      if (planWords.length > 1) {
        defaultInitial =
            planWords[0].substring(0, 1) + planWords[1].substring(0, 1);
      } else {
        defaultInitial = planWords[0].substring(0, 1);
      }
    }

    if ((defaultInitial).isNotEmpty) {
      defaultWidget = ClipOval(
        child: CircleAvatar(
          radius: 32.h,
          backgroundColor: Colors.grey[200],
          child: Center(
            child: Text(
              defaultInitial.toUpperCase(),
              style: TextStyle(
                fontSize: 25.0.sp,
                color: mAppThemeProvider.primaryColor,
              ),
            ),
          ),
        ),
      );
    }

    return ClipOval(
      child: Container(
        alignment: Alignment.center,
        height: 70.h,
        width: 70.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: iconApi != null && iconApi != ''
            ? iconApi.toString().toLowerCase().contains('.svg')
                ? Center(
                    child: SizedBox(
                      height: 50.h,
                      width: 50.h,
                      child: SvgPicture.network(
                        iconApi,
                        placeholderBuilder: (context) =>
                            CommonCircularIndicator(),
                      ),
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: iconApi,
                    placeholder: (context, url) => CommonCircularIndicator(),
                    errorWidget: (context, url, error) =>
                        defaultWidget ??
                        ClipOval(
                            child: CircleAvatar(
                          backgroundImage: AssetImage(qurHealthLogo),
                          radius: 32.h,
                          backgroundColor: Colors.transparent,
                        )),
                    imageBuilder: (context, imageProvider) => Container(
                      width: 80.h,
                      height: 80.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fill),
                      ),
                    ),
                  )
            : iconApi != null && iconApi != ''
                ? iconApi.toString().toLowerCase().contains('.svg')
                    ? SvgPicture.network(
                        iconApi,
                        placeholderBuilder: (context) =>
                            CommonCircularIndicator(),
                      )
                    : CachedNetworkImage(
                        imageUrl: iconApi,
                        placeholder: (context, url) =>
                            CommonCircularIndicator(),
                        errorWidget: (context, url, error) =>
                            defaultWidget ??
                            ClipOval(
                                child: CircleAvatar(
                              backgroundImage: AssetImage(qurHealthLogo),
                              radius: 32.h,
                              backgroundColor: Colors.transparent,
                            )),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 80.h,
                          height: 80.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fill),
                          ),
                        ),
                      )
                : defaultWidget ??
                    ClipOval(
                        child: CircleAvatar(
                      backgroundImage: AssetImage(qurHealthLogo),
                      radius: 32.h,
                      backgroundColor: Colors.transparent,
                    )),
      ),
    );
  }

  Future<void> CallbackAPIFromChat(
    String? patId,
    String? careProviderId,
    String? careProviderName,
  ) async {
    var res = await ApiBaseHelper().callBackFromChat(
      careProviderId,
      patId,
    );

    if (res) {
      Get.rawSnackbar(
          messageText: Center(
            child: Text(
              "Your callback request is placed. " +
                  (careProviderName!.isNotEmpty
                      ? "$careProviderName, "
                      : careProviderName) +
                  " will reach you shortly.",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.GROUNDED,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green.shade500);
    } else {
      Get.rawSnackbar(
          messageText: Center(
            child: Text(
              "Failed to notify the caregiver",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.GROUNDED,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red.shade500);
    }
  }

  Future<void> CallbackAPI(
    String? patientName,
    String? planId,
    String? userId,
  ) async {
    // LoaderClass.showLoadingDialog(
    //   Get.context,
    //   canDismiss: false,
    // );
    var res = await ApiBaseHelper().callBackForPlanExpiry(
      userId,
      planId,
    );
    // LoaderClass.hideLoadingDialog(
    //   Get.context,
    // );

    if (res) {
      Get.rawSnackbar(
          messageText: Center(
            child: Text(
              (patientName!.isNotEmpty ? "$patientName, " : patientName) +
                  "Thank you for reaching out.  Your caregiver will call you as soon as possible.",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.GROUNDED,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green.shade500);
    } else {
      Get.rawSnackbar(
          messageText: Center(
            child: Text(
              "Failed to notify the caregiver",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.GROUNDED,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red.shade500);
    }
  }

  static Future<Directory?> getDir() async {
    return Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();
  }

  Future<bool> isFirstTime() async {
    var prefs = await SharedPreferences.getInstance();
    var firstTime = prefs.getBool('first_time');
    if (firstTime != null && !firstTime) {
      // Not first time
      return false;
    } else {
      // First time
      await prefs.setBool('first_time', false);
      await _deleteAppDir();
      await _deleteCacheDir();
      return true;
    }
  }

  Future<void> _deleteCacheDir() async {
    try {
      var cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print("Failed to delete the Temp dir : ${e.toString()}");
    }
  }

  Future<void> _deleteAppDir() async {
    try {
      var appDir = await getApplicationSupportDirectory();
      if (appDir.existsSync()) {
        appDir.deleteSync(recursive: true);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print("Failed to delete the support dir : ${e.toString()}");
    }
  }

  Future<String?> downloader(String url) async {
    return await FlutterDownloader.enqueue(
      url: url,
      savedDir: '/storage/emulated/0/Qurbook/',
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

  List<String> getFileNameAndUrl(String url) {
    String? updatedUrl;
    String? fileName;
    final response = <String>[];
    final file = File(url);
    var fileExention = extension(file.path);
    if (fileExention == '.htm') {
      updatedUrl = url.replaceAll('.htm', '.pdf');
    } else if (fileExention == '.html') {
      updatedUrl = url.replaceAll('.html', '.pdf');
    } else if (fileExention == '.pdf') updatedUrl = url;
    if (updatedUrl != null) {
      final fileupdated = File(updatedUrl);
      fileName = basename(fileupdated.path);
    }
    if (updatedUrl != null && fileName != null) {
      response.addAll([updatedUrl, fileName]);
    }
    return response;
  }

  Future<ResultFromResponse> loadPdf(
      {required String url, String? fileName}) async {
    try {
      FlutterToast().getToast('Download Started', Colors.green);
      var response = await ApiServices.get(url);
      if (response?.statusCode == 200) {
        var responseJson = response!.bodyBytes;

        final dir = Platform.isIOS
            ? await FHBUtils.createFolderInAppDocDirForIOS('images')
            : await FHBUtils.createFolderInAppDocDir();
        String? imageName = fileName;
        if (imageName == null) {
          if (url.contains('/')) {
            imageName = url.split('/').last;
          }
        }
        var file = File('$dir/${imageName}.pdf');
        await file.writeAsBytes(responseJson);
        return ResultFromResponse(true, file.path);
      } else {
        return ResultFromResponse(false, 'Requested file not found');
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e.toString());
      return ResultFromResponse(false, 'Failed to download the file');
    }
  }

  showStatusToUser(ResultFromResponse response,
      GlobalKey<ScaffoldMessengerState>? scaffoldKey) {
    if (response.status) {
      scaffoldKey!.currentState!.showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Downloaded'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () async {
              await OpenFilex.open(
                response.result,
              );
            },
          ),
        ),
      );
    } else {
      scaffoldKey!.currentState!.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(response.result),
        ),
      );
    }
  }

  String? getDoctorName(User user) {
    String? doctorName = '';

    if (user.name != null && user.name != '') {
      doctorName = user.name;
    } else if (user.firstName != null && user.firstName != '') {
      doctorName = user.firstName! + ' ' + user.lastName!;
    } else if (user.userName != null && user.userName != '') {
      doctorName = user.userName;
    }
    return doctorName?.capitalizeFirstofEach;
  }

  accessContactsDialog() async {
    final permissionStatus = await Permission.contacts.status;
    if (permissionStatus == PermissionStatus.granted) {
      navigateInviteContact();
    } else {
      await getPermission().then((value) {
        if (value == PermissionStatus.granted) {
          navigateInviteContact();
        } else {
          FlutterToast().getToast(
              'Please allow access to invite people from your contacts',
              Colors.red);
        }
      });
    }
  }

  Future<PermissionStatus> getPermission() async {
    final permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      final permissionStatus = await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  navigateInviteContact() {
    //Navigator.pop(Get.context);
    Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<ReferAFriendViewModel>(
              create: (_) => ReferAFriendViewModel(),
            ),
          ],
          child: InviteContactsScreen(),
        ),
      ),
    );
  }

  _dialogForSubscribePayment(BuildContext context, String? providerId,
      String? packageId, bool isFromRenew, Function() refresh) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 8),
            backgroundColor: Colors.transparent,
            content: Container(
              width: double.maxFinite,
              height: 250,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Container(
                          height: 160,
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Center(
                                child: TextWidget(
                                    text: redirectedToPaymentMessage,
                                    fontsize: 16.0.sp,
                                    fontWeight: FontWeight.w500,
                                    colors: Colors.grey[600]),
                              ),
                              SizedBoxWidget(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SizedBoxWithChild(
                                    width: 90,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(
                                                color: mAppThemeProvider.primaryColor)),
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: mAppThemeProvider.primaryColor,
                                        padding: EdgeInsets.all(8),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: TextWidget(
                                        text: 'Cancel',
                                        fontsize: 14.0.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBoxWithChild(
                                    width: 90,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(
                                                color: mAppThemeProvider.primaryColor)),
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: mAppThemeProvider.primaryColor,
                                        padding: EdgeInsets.all(8),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        CommonUtil.showLoadingDialog(context,
                                            _keyLoader, variable.Please_Wait);
                                        var userId =
                                            PreferenceUtil.getStringValue(
                                                Constants.KEY_USERID);
                                        if (isFromRenew) {
                                          subscribeViewModel
                                              .createSubscribePayment(
                                                  packageId!)
                                              .then((value) {
                                            if (value != null) {
                                              if (value.isSuccess!) {
                                                if (value.result != null) {
                                                  if (value.result?.payment !=
                                                      null) {
                                                    if (value.result?.payment
                                                            ?.status ==
                                                        'PAYITA') {
                                                      if (value.result
                                                              ?.paymentGatewayDetail !=
                                                          null) {
                                                        if (value
                                                                .result
                                                                ?.paymentGatewayDetail
                                                                ?.metadata !=
                                                            null) {
                                                          if (value
                                                                  .result
                                                                  ?.paymentGatewayDetail
                                                                  ?.metadata!
                                                                  .paymentGateWay ==
                                                              STR_RAZOPAY) {
                                                            if (value
                                                                    .result
                                                                    ?.paymentGatewayDetail
                                                                    ?.metadata!
                                                                    .shorturl !=
                                                                null) {
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => PaymentPage(
                                                                            redirectUrl:
                                                                                value.result!.paymentGatewayDetail!.metadata!.shorturl,
                                                                            paymentId:
                                                                                value.result!.payment!.id.toString(),
                                                                            isFromSubscribe:
                                                                                true,
                                                                            isFromRazor:
                                                                                true,
                                                                            closePage:
                                                                                (value) {
                                                                              if (value == STR_SUCCESS) {
                                                                                refresh();
                                                                                /*Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                                                                                  Provider.of<RegimentViewModel>(
                                                                                    context,
                                                                                    listen: false,
                                                                                  ).updateTabIndex(currentIndex: 3);
                                                                                  Get.offNamedUntil(router.rt_MyPlans, (Route<dynamic> route) => false);*/
                                                                              } else {
                                                                                Navigator.pop(context);
                                                                              }
                                                                            },
                                                                          )));
                                                            } else {
                                                              Navigator.of(
                                                                      _keyLoader
                                                                          .currentContext!,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                              FlutterToast()
                                                                  .getToast(
                                                                      'Renew Failed',
                                                                      Colors
                                                                          .red);
                                                            }
                                                          } else {
                                                            if (value
                                                                        .result
                                                                        ?.paymentGatewayDetail
                                                                        ?.metadata
                                                                        ?.longurl !=
                                                                    null &&
                                                                value
                                                                        .result
                                                                        ?.paymentGatewayDetail
                                                                        ?.metadata
                                                                        ?.longurl !=
                                                                    '') {
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => PaymentPage(
                                                                            redirectUrl:
                                                                                value.result?.paymentGatewayDetail?.metadata?.longurl,
                                                                            paymentId:
                                                                                value.result?.payment?.id.toString(),
                                                                            isFromSubscribe:
                                                                                true,
                                                                            isFromRazor:
                                                                                false,
                                                                            closePage:
                                                                                (value) {
                                                                              if (value == STR_SUCCESS) {
                                                                                refresh();
                                                                                /*Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                                                                                  Provider.of<RegimentViewModel>(
                                                                                    context,
                                                                                    listen: false,
                                                                                  ).updateTabIndex(currentIndex: 3);
                                                                                  Get.offNamedUntil(router.rt_MyPlans, (Route<dynamic> route) => false);*/
                                                                              } else {
                                                                                Navigator.pop(context);
                                                                              }
                                                                            },
                                                                          )));
                                                            }
                                                          }
                                                        }
                                                      }
                                                    } else {
                                                      Navigator.of(
                                                              _keyLoader
                                                                  .currentContext!,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                      FlutterToast().getToast(
                                                          'Renew Failed',
                                                          Colors.red);
                                                    }
                                                  } else {
                                                    Navigator.of(
                                                            _keyLoader
                                                                .currentContext!,
                                                            rootNavigator: true)
                                                        .pop();
                                                    FlutterToast().getToast(
                                                        'Renew Failed',
                                                        Colors.red);
                                                  }
                                                }
                                              } else {
                                                Navigator.of(
                                                        _keyLoader
                                                            .currentContext!,
                                                        rootNavigator: true)
                                                    .pop();
                                                FlutterToast().getToast(
                                                    'Renew Failed', Colors.red);
                                              }
                                            }
                                          });
                                        } else {
                                          updateProvidersBloc
                                              .mappingHealthOrg(
                                                  providerId, userId!)
                                              .then((value) {
                                            if (value != null) {
                                              if (value.success!) {
                                                subscribeViewModel
                                                    .createSubscribePayment(
                                                        packageId!)
                                                    .then((value) {
                                                  if (value != null) {
                                                    if (value.isSuccess!) {
                                                      if (value.result !=
                                                          null) {
                                                        if (value.result
                                                                ?.payment !=
                                                            null) {
                                                          if (value
                                                                  .result
                                                                  ?.payment
                                                                  ?.status ==
                                                              'PAYITA') {
                                                            if (value.result
                                                                    ?.paymentGatewayDetail !=
                                                                null) {
                                                              if (value
                                                                      .result
                                                                      ?.paymentGatewayDetail
                                                                      ?.metadata !=
                                                                  null) {
                                                                if (value
                                                                        .result
                                                                        ?.paymentGatewayDetail
                                                                        ?.metadata!
                                                                        .paymentGateWay ==
                                                                    STR_RAZOPAY) {
                                                                  if (value
                                                                          .result
                                                                          ?.paymentGatewayDetail
                                                                          ?.metadata
                                                                          ?.shorturl !=
                                                                      null) {
                                                                    Navigator.pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => PaymentPage(
                                                                                  redirectUrl: value.result?.paymentGatewayDetail?.metadata?.shorturl,
                                                                                  paymentId: value.result?.payment?.id.toString(),
                                                                                  isFromSubscribe: true,
                                                                                  isFromRazor: true,
                                                                                  closePage: (value) {
                                                                                    if (value == STR_SUCCESS) {
                                                                                      refresh();
                                                                                      /*Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                                                                                  Provider.of<RegimentViewModel>(
                                                                                    context,
                                                                                    listen: false,
                                                                                  ).updateTabIndex(currentIndex: 3);
                                                                                  Get.offNamedUntil(router.rt_MyPlans, (Route<dynamic> route) => false);*/
                                                                                    } else {
                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  },
                                                                                )));
                                                                  } else {
                                                                    Navigator.of(
                                                                            _keyLoader
                                                                                .currentContext!,
                                                                            rootNavigator:
                                                                                true)
                                                                        .pop();
                                                                    FlutterToast().getToast(
                                                                        'Renew Failed',
                                                                        Colors
                                                                            .red);
                                                                  }
                                                                } else {
                                                                  if (value
                                                                              .result
                                                                              ?.paymentGatewayDetail
                                                                              ?.metadata
                                                                              ?.longurl !=
                                                                          null &&
                                                                      value
                                                                              .result
                                                                              ?.paymentGatewayDetail
                                                                              ?.metadata
                                                                              ?.longurl !=
                                                                          '') {
                                                                    Navigator.pushReplacement(
                                                                        Get.context!,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => PaymentPage(
                                                                                  redirectUrl: value.result?.paymentGatewayDetail?.metadata?.longurl,
                                                                                  paymentId: value.result?.payment?.id?.toString(),
                                                                                  isFromSubscribe: true,
                                                                                  isFromRazor: false,
                                                                                  closePage: (value) {
                                                                                    if (value == 'success') {
                                                                                      refresh();
                                                                                    } else {
                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  },
                                                                                )));
                                                                  }
                                                                }
                                                              } else {
                                                                Navigator.of(
                                                                        _keyLoader
                                                                            .currentContext!,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop();
                                                                FlutterToast()
                                                                    .getToast(
                                                                        'Subscribe Failed',
                                                                        Colors
                                                                            .red);
                                                              }
                                                            }
                                                          } else {
                                                            Navigator.of(
                                                                    _keyLoader
                                                                        .currentContext!,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop();
                                                            FlutterToast().getToast(
                                                                'Subscribe Failed',
                                                                Colors.red);
                                                          }
                                                        } else {
                                                          Navigator.of(
                                                                  _keyLoader
                                                                      .currentContext!,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                          FlutterToast().getToast(
                                                              'Subscribe Failed',
                                                              Colors.red);
                                                        }
                                                      }
                                                    } else {
                                                      Navigator.of(
                                                              _keyLoader
                                                                  .currentContext!,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                      FlutterToast().getToast(
                                                          'Subscribe Failed',
                                                          Colors.red);
                                                    }
                                                  }
                                                });
                                              } else {
                                                Navigator.of(
                                                        _keyLoader
                                                            .currentContext!,
                                                        rootNavigator: true)
                                                    .pop();
                                                FlutterToast().getToast(
                                                    'Subscribe Map Failed',
                                                    Colors.red);
                                              }
                                            } else {
                                              Navigator.of(
                                                      _keyLoader
                                                          .currentContext!,
                                                      rootNavigator: true)
                                                  .pop();
                                              FlutterToast().getToast(
                                                  'Subscribe Map Failed',
                                                  Colors.red);
                                            }
                                          });
                                        }
                                      },
                                      child: TextWidget(
                                        text: ok,
                                        fontsize: 14.0.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  String getMemberShipID() {
    return PreferenceUtil.getStringValue(Constants.keyMembeShipID) ?? "";
  }

  String getClaimAmount() {
    return PreferenceUtil.getStringValue(Constants.keyClaimAmount) ?? "";
  }

  String getHealthOrganizationID() {
    return PreferenceUtil.getStringValue(Constants.keyHealthOrganizationId) ??
        "";
  }

  String getMemberSipStartDate() {
    return PreferenceUtil.getStringValue(Constants.keyMembershipStartDate) ??
        "";
  }

  String getMemberSipEndDate() {
    return PreferenceUtil.getStringValue(Constants.keyMembershipEndDate) ?? "";
  }

  num doubleWithoutDecimalToInt(double val) {
    return val % 1 == 0 ? val.toInt() : val;
  }

  bool checkIfFileIsPdf(String filePath) {
    bool condition = false;
    ;
    final fileName = File(filePath);
    final fileNoun = fileName.path.split('/').last;
    if (fileNoun.contains(".pdf")) {
      condition = true;
    }
    return condition;
  }

  static String convertMinuteToHour(int min) {
    if (min >= 60) {
      var value = min / 60;
      if (value >= 1) {
        final int hour = min ~/ 60;
        final int minutes = min % 60;
        return '${hour.toString().padLeft(2, hour < 10 ? "" : "0")} hour${minutes > 0 ? (minutes > 0 ? ' ' + minutes.toString().padLeft(2, "0") + " mins" : '') : ""}';
      }
    }

    return min.toString() + ' mins';
  }

  String getTimeString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }

  static String dateConversionToApiFormat(DateTime dateTime,
      {bool isIndianTime = false,
      bool MMM = false,
      bool forAppointmentNotification = false}) {
    final newFormat = REGION_CODE == 'IN' || isIndianTime
        ? DateFormat(MMM
            ? forAppointmentNotification
                ? 'dd MMMM,yyyy HH:mm'
                : 'yyyy-MMM-dd'
            : 'yyyy-MM-dd')
        : DateFormat(MMM ? 'MMM-dd-yyyy' : 'MM-dd-yyyy');

    var updatedDate = newFormat.format(dateTime);
    return updatedDate;
  }

  listenToCallStatus(Map message) {
    if ((message['meeting_id'] ?? '').isNotEmpty) {
      FirebaseFirestore.instance
          .collection("call_log")
          .doc("${message['meeting_id']}")
          .snapshots()
          .listen(
        (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
          Map<String, dynamic> firestoreInfo = documentSnapshot.data() ?? {};
          var status = (firestoreInfo['call_status'] ?? '');
          if ((status == 'accept') ||
              (status == 'missed') ||
              (status == 'decline')) {
            variable.reminderMethodChannel.invokeMethod(
              variable.removeReminderMethod,
              {'deliveredNotificationId': message['id']},
            );
          }
        },
      );
    }
  }

  Widget showPDFInWidget(String filePath) {
    try {
      return FutureBuilder<PDFDocument>(
        future: PDFDocument.fromFile(File(filePath)), // async work
        builder: (BuildContext context, AsyncSnapshot<PDFDocument> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading....');
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return ShowPDFFromFile(document: snapshot.data);
          }
        },
      );
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e.toString());
      return Text('Failed to load');
    }
  }

  updateSocketFamily() {
    try {
      String? userId = PreferenceUtil.getStringValue(KEY_USERID);

      Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
          .socket!
          .disconnect();
      Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
          .initSocket()
          .then((value) {
        //update common count
        Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
            .socket!
            .emitWithAck(getChatTotalCountEmit, {
          'userId': userId,
        }, ack: (countResponseEmit) {
          if (countResponseEmit != null) {
            TotalCountModel totalCountModel =
                TotalCountModel.fromJson(countResponseEmit);
            if (totalCountModel != null) {
              Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
                  .updateChatTotalCount(totalCountModel);
            }
          }
        });
      });
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  static commonDialogBox(String msg) async {
    await Get.defaultDialog(
      content: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      confirm: OutlinedButton(
        onPressed: () {
          Get.back();
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: mAppThemeProvider.primaryColor),
        ),
        child: Text(
          variable.strOK,
          style: TextStyle(
            color: mAppThemeProvider.primaryColor,
          ),
        ),
      ),
      onConfirm: () {
        Get.back();
      },
      // AlertDialog(
      //   title: Text(
      //     "Switch Profile",
      //     style: TextStyle(fontSize: 16),
      //   ),
      //   content: Text(
      //     "Switch to $pateintName profile in Home screen and Tap on the Renew button again from the Notifications list",
      //     style: TextStyle(fontSize: 14),
      //   ),
      //   actions: <Widget>[
      //     FlatButton(
      //       onPressed: () {
      //         Get.back();
      //       },
      //       child: Text(
      //         "ok",
      //         // style: TextStyle(
      //         //   color: mAppThemeProvider.primaryColor,
      //         // ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  void showCommonDialogBox(String msg, BuildContext context) {
    dialogboxOpen = true;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(variable.strAlert),
            content: Text(msg),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.check,
                    size: 24.0.sp,
                  ),
                  onPressed: () {
                    dialogboxOpen = false;
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  void showDialogForActivityConfirmation(BuildContext context, String name,
      Function() onPressedYes, bool isQurhome) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              variable.strConfirm,
              style: TextStyle(
                  fontSize: CommonUtil().isTablet! ? 22.0.sp : null,
                  color: isQurhome
                      ? mAppThemeProvider.qurHomePrimaryColor
                      : mAppThemeProvider.primaryColor),
            ),
            // To display the title it is optional
            content: CommonUtil().isTablet!
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: Text(
                      'Record ' + name.trim() + '?',
                      style: TextStyle(fontSize: 20.0.sp),
                    ))
                : Text('Record ' + name.trim() + '?'),
            // Message which will be pop up on the screen
            // Action widget which will provide the user to acknowledge the choice
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: isQurhome
                        ? mAppThemeProvider.qurHomePrimaryColor
                        : mAppThemeProvider.primaryColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    variable.strNo,
                    style: TextStyle(
                        fontSize: CommonUtil().isTablet! ? 22.0.sp : null),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // FlatButton widget is used to make a text to work like a button
                    foregroundColor: isQurhome
                        ? mAppThemeProvider.qurHomePrimaryColor
                        : mAppThemeProvider.primaryColor,
                  ),
                  onPressed: onPressedYes,
                  // function used to perform after pressing the button
                  child: Text(
                    variable.strYes,
                    style: TextStyle(
                        fontSize: CommonUtil().isTablet! ? 22.0.sp : null),
                  )),
            ],
          );
        });
  }

  void showDialogForActivityStatus(String msg, BuildContext context,
      {Function()? pressOk}) {
    // set up the buttons
    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Get.back();
      },
    );
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        pressOk!();
      },
    );
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(variable.strConfirm),
            content: Text(msg),
            actions: [
              noButton,
              yesButton,
            ],
          );
        });
  }

  Widget qurHomeMainIcon() {
    //Qurhome icon width and height size updated and used common method
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (CommonUtil().isTablet ?? false) ? 0 : 8.h,
        vertical: (CommonUtil().isTablet ?? false) ? 0 : 4.h,
      ),
      child: AssetImageWidget(
        icon: icon_qurhome,
        height: (CommonUtil().isTablet ?? false) ? 48.h : 32.h,
        width: (CommonUtil().isTablet ?? false) ? 48.h : 32.h,
      ),
    );
  }

  void callQueueNotificationPostApi(var json, {bool isNeedDialog = true}) {
    //if (avoidExtraNotification) {
    //avoidExtraNotification = false;
    queueServices
        .postNotificationQueue(PreferenceUtil.getStringValue(KEY_USERID)!, json)
        .then((value) {
      if (value != null && value.isSuccess!) {
        if (value.result != null) {
          if (value.result!.queueCount != null &&
              value.result!.queueCount! > 0) {
            var sheelaAIController = CommonUtil().onInitSheelaAIController();
            sheelaAIController.sheelaIconBadgeCount.value =
                (value.result?.queueCount ?? 0);
            // isNeedDialog condition for showing the dialog or not
            if (isNeedDialog) {
              CommonUtil().dialogForSheelaQueue(Get.context!);
            }

            if (sheelaAIController.isSheelaScreenActive) {
              // Check if Sheela screen is active
              var kioskTask =
                  json[KIOSK_task]; // Retrieve kiosk task from JSON object
              var kioskEid =
                  json[KIOSK_eid]; // Retrieve kiosk EID from JSON object

              if (kioskTask != KIOSK_appointment_avail) {
                // Check if kiosk task is not appointment availability
                sheelaAIController.latestRemindEid =
                    kioskEid; // Update latest reminder EID in Sheela AI Controller
              }
            }
          }
        }
      }
    });
    //}
  }

  String capitalizeFirstofEach(String data) {
    return data
        .trim()
        .toLowerCase()
        .split(' ')
        .map((str) =>
            str.length > 0 ? '${str[0].toUpperCase()}${str.substring(1)}' : '')
        .join(' ');
  }

  String showDescriptionTextForm(FieldModel fieldModel) {
    // Initialize desc with an empty string
    String? desc = '';

    // Check if the current language is English
    if (CommonUtil().isLanguageEnglish() ?? false) {
      // Check if it's a survey and title description is not empty
      if ((fieldModel?.isSurvey ?? false) &&
          (fieldModel.strTitleDesc ?? "").trim().isNotEmpty) {
        // Set desc to title description
        desc = fieldModel.strTitleDesc;
      }
      // Check if description is not null and not empty
      else if (fieldModel.description != null && fieldModel.description != '') {
        // Set desc to description
        desc = fieldModel.description;
      }
      // Check if title is not null and not empty
      else if (fieldModel.title != null && fieldModel.title != '') {
        // Set desc to title
        desc = fieldModel.title;
      } else {
        // Set desc to empty string
        desc = '';
      }
    } else {
      // For other languages
      // Check if it's a survey and title description is not empty
      if ((fieldModel?.isSurvey ?? false) &&
          (fieldModel.strTitleDesc ?? "").trim().isNotEmpty) {
        // Set desc to title description
        desc = fieldModel.strTitleDesc;
      }
      // Check if translated description is not null and not empty
      else if (fieldModel.translatedDescription != null &&
          fieldModel.translatedDescription != '') {
        // Set desc to translated description
        desc = fieldModel.translatedDescription;
      }
      // Check if translated title is not null and not empty
      else if (fieldModel.translatedTitle != null &&
          fieldModel.translatedTitle != '') {
        // Set desc to translated title
        desc = fieldModel.translatedTitle;
      } else {
        // Set desc to empty string
        desc = '';
      }
    }

    // Return the parsed HTML string
    return parseHtmlString(desc);
  }

  String showDescTextRegimenList(VitalsData vitalsData) {
    String? desc = '';

    if (vitalsData != null) {
      if (vitalsData.description != null && vitalsData.description != '') {
        desc = vitalsData.description;
      } else if (vitalsData.vitalName != null && vitalsData.vitalName != '') {
        desc = vitalsData.vitalName;
      } else {
        desc = '';
      }
    } else {
      desc = '';
    }
    desc = checkIfStringContiansUnderscore(desc ?? "");
    return parseHtmlString(desc);
  }

  String checkIfStringContiansUnderscore(String value) {
    String result = "";
    if (value.contains("_")) {
      result = value.replaceAll("_", " ");
    } else {
      result = value;
    }

    return result;
  }

  String parseHtmlString(String? htmlString) {
    var text = "";
    if (validString(htmlString).trim().isNotEmpty) {
      var unescape = HtmlUnescape();
      text = unescape.convert(htmlString!);
    }
    return text;
  }

  String validString(String? strText) {
    try {
      if (strText == null)
        return "";
      else if (strText.trim().isEmpty)
        return "";
      else
        return strText.trim();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    return "";
  }

  enableBackgroundNotification() {
    try {
      const platform = MethodChannel(ENABLE_BACKGROUND_NOTIFICATION);
      platform.invokeMethod(ENABLE_BACKGROUND_NOTIFICATION);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  disableBackgroundNotification() {
    try {
      const platform = MethodChannel(DISABLE_BACKGROUND_NOTIFICATION);
      platform.invokeMethod(DISABLE_BACKGROUND_NOTIFICATION);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // This method is responsible for closing the Sheela dialog and performing related actions
  closeSheelaDialog() async {
    try {
      // Initializing SheelaAIController for additional actions
      SheelaAIController? sheelaAIController =
          CommonUtil().onInitSheelaAIController();

      // Checking and closing Sheela input dialog if it is showing
      if (sheelaAIController.isSheelaInputDialogShowing.value) {
        await sheelaAIController.closeSheelaInputDialogAndStopListening();
      }

      // Checking and closing countdown timer dialog, and stopping speech listening if it is showing
      if (sheelaAIController.isCountDownDialogShowing.value) {
        await sheelaAIController.closeCountdownTimerDialogAndCleanup();
        await sheelaAIController.stopSpeechListening();
      }
    } catch (e, stackTrace) {
      // Handling exceptions and logging errors
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  String? realNumber(int? number) {
    if (number == 0) {
      return zero;
    }
    return generate(number!)!.trim();
  }

  String? generate(int number) {
    if (number >= 1000000000) {
      return generate(number ~/ 1000000000)! +
          " billion " +
          generate(number % 1000000000)!;
    } else if (number >= 1000000) {
      return generate(number ~/ 1000000)! +
          " million " +
          generate(number % 1000000)!;
    } else if (number >= 1000) {
      return generate(number ~/ 1000)! +
          " thousand " +
          generate(number % 1000)!;
    } else if (number >= 100) {
      return generate(number ~/ 100)! + " hundred " + generate(number % 100)!;
    }
    return generate1To99(number);
  }

  String generate1To99(int number) {
    if (number == 0) {
      return "";
    } else if (number <= 9) {
      return oneToNine[number - 1];
    } else if (number <= 19) {
      return tenToNinteen[number % 10];
    } else {
      return dozens[number ~/ 10 - 1] + " " + generate1To99(number % 10);
    }
  }

  commonWidgetForTitleValue(String title, String value) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.w100,
                  ),
                  textAlign: TextAlign.start,
                )),
            Expanded(
              flex: 1,
              child: Text(
                value,
                style: TextStyle(
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String? getFieldName(String? field) {
    String? strName = "";
    try {
      strName = field;
      if (strName!.contains("_")) {
        strName = strName.replaceAll('_', '');
        strName = CommonUtil().titleCase(strName.toLowerCase());
      } else {
        strName = CommonUtil().titleCase(strName.toLowerCase());
      }
      return strName;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    return strName;
  }

  String getFormattedDateTime(String datetime) {
    DateTime dateTimeStamp = DateTime.parse(datetime);
    String formattedDate =
        DateFormat('MMM d, hh:mm a').format(dateTimeStamp.toLocal());
    return formattedDate;
  }

  void dialogForScanDevices(BuildContext context,
      {Function()? onPressManual,
      Function()? onPressCancel,
      String? title,
      // Display "Enter Manually" button only if manual recording is not restricted
      bool? isVitalsManualRecordingRestricted}) async {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black38,
      barrierLabel: 'Label',
      barrierDismissible: false,
      pageBuilder: (_, __, ___) => Center(
        child: Container(
          width: double.infinity,
          child: Material(
            color: Colors.transparent.withOpacity(0.8),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AssetImageWidget(
                    icon: icon_device_scan_measure,
                    height: 70.h,
                    width: 70.w,
                  ),
                  SizedBox(height: 40.h),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 80, 0, 120),
                    child: SizedBox(
                        width: 220.w,
                        child: Text(title!,
                            style:
                                TextStyle(fontSize: 18.sp, color: Colors.white),
                            textAlign: TextAlign.center)),
                  ),
                  // Display "Enter Manually" button only if manual recording is not restricted
                  if (!isVitalsManualRecordingRestricted!)
                    SizedBox(
                      width: 180.w,
                      child: TextButton(
                        child: Text(
                          'Enter Manually',
                          style: TextStyle(
                              color:
                                  mAppThemeProvider.qurHomePrimaryColor,
                              fontSize: 16.sp),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          onPressManual!();
                        },
                      ),
                    ),
                  SizedBox(height: 5.h),
                  SizedBox(
                    width: 180.w,
                    child: TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            mAppThemeProvider.qurHomePrimaryColor),
                      ),
                      onPressed: () {
                        onPressCancel!();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void dialogForSheelaQueue(BuildContext context) async {
    var sheelaAIController = Get.find<SheelaAIController>();
    bool isFirstTime = true;
    showGeneralDialog(
        context: context,
        barrierColor: Colors.black38,
        barrierLabel: 'Label',
        barrierDismissible: false,
        pageBuilder: (_, __, ___) {
          if (isFirstTime) {
            isFirstTime = false;
            Future.delayed(Duration(seconds: 2), () {
              Get.back();
            });
          }
          return Center(
            child: Container(
              width: double.infinity,
              child: Material(
                color: Colors.transparent.withOpacity(0.8),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BadgeIconBig(
                        badgeCount:
                            sheelaAIController.sheelaIconBadgeCount.value,
                        badgeColor: ColorUtils.badgeQueue,
                        icon: AssetImageWidget(
                          icon: icon_sheela_queue,
                          height: 250.h,
                          width: 250.w,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void dialogForSheelaQueueStable(BuildContext context,
      {int? unReadMsgCount,
      Function(bool)? onTapSheelaRemainders,
      Function(bool)? onTapHideSheelaDialog,
        String? sheelaIdealDialogNote,
        bool isScreenIdealDialog = false,
      /// Checks if the user came from the Qurhome regimen flow and returns
      /// the fromQurhomeRegimen value if it exists.
      bool? fromQurhomeRegimen}) async {
    bool isFirstTime = true;
    var sheelaAIController = Get.find<SheelaAIController>();
    showGeneralDialog(
        context: context,
        barrierColor: Colors.black38,
        barrierLabel: 'Label',
        barrierDismissible: true,
        pageBuilder: (_, __, ___) {
          if (isFirstTime && sheelaAIController.isSheelaScreenActive) {
            isFirstTime = false;
            Future.delayed(Duration(seconds: 2), () {
              Get.back();
            });
          }
          return WillPopScope(
            onWillPop: () async {
              sheelaDialogVisibleFalse();
              onTapHideSheelaDialog?.call(true);
              return true;
            },
            child: Center(
              child: Container(
                width: double.infinity,
                child: Material(
                  color: Colors.transparent.withOpacity(0.8),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      sheelaDialogVisibleFalse();
                      onTapHideSheelaDialog?.call(true);
                      Get.back();
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isScreenIdealDialog  ?
                          Padding(
                            padding:  EdgeInsets.only(left: 50.sp, right: 50.sp,bottom: 20.sp),
                            child: Text(
                              strQurhomeIdealDialogTitle,
                              style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          )
                            : Text(
                             strRemainders,
                             style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          BadgeIconBig(
                            badgeCount:
                                sheelaAIController.sheelaIconBadgeCount.value,
                            badgeColor: ColorUtils.badgeQueue,
                            icon: GestureDetector(
                              onTap: () {
                                onTapSheelaRemainders?.call(true);
                              },
                              child: (isTablet ?? true)
                                  ? SheelaQueueIcon(
                                      size: 150,
                                    )
                                  : SheelaQueueIcon(
                                      size: 250,
                                    ),
                            ),
                          ),
                          Visibility(
                            visible: (unReadMsgCount ?? 0) > 0 && !isScreenIdealDialog,
                            child: Column(
                              children: [
                                Container(
                                  height: 2.h,
                                  width: 0.2.sw,
                                  margin: EdgeInsets.only(top: 20.h),
                                  decoration: BoxDecoration(
                                      color: mAppThemeProvider.primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text(
                                  variable.strUnReadMessage,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                BadgeIconBig(
                                  badgeCount: unReadMsgCount ?? 0,
                                  badgeColor: ColorUtils.badgeQueue,
                                  right: 5,
                                  top: 5,
                                  boxConstraints: BoxConstraints(
                                      minHeight: 35.h, minWidth: 35.h),
                                  badgeTextSize: 18.sp,
                                  icon: InkWell(
                                    onTap: () {
                                      onTapSheelaRemainders?.call(false);
                                    },
                                    child: (isTablet ?? true)
                                        ? UnreadMessagesIcon(
                                            size: 80,
                                          )
                                        : UnreadMessagesIcon(
                                            size: 100,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                           //Quick Tips:
                          Visibility(
                            visible: isScreenIdealDialog &&
                                sheelaAIController.sheelaIconBadgeCount.value==0,
                            child: Padding(
                              padding: const EdgeInsets.only(top:30),
                              child: Text(
                                'Quick Tips:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          /// Conditionally renders a Text widget if 'fromQurhomeRegimen' is true, otherwise renders an empty SizedBox.
                          /// This allows showing a note text only when relevant.
                          (fromQurhomeRegimen == true &&
                                  sheelaAIController.isSheelaScreenActive ==
                                      false)
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      isScreenIdealDialog?
                                      sheelaAIController.sheelaIconBadgeCount.value>0?
                                      strQurhomeIdealDialogDescription:
                                      sheelaIdealDialogNote??"":strSheelaDialogNote,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            (CommonUtil().isTablet ?? false)
                                                ? 22
                                                : 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void sheelaDialogVisibleFalse() {
    var sheelaAIController = Get.find<SheelaAIController>();
    sheelaAIController.isQueueDialogShowing.value = false;
  }

  void initPortraitMode() async {
    try {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
    }
  }

  void initQurHomePortraitLandScapeMode() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
    }
  }

  void initLandScapeMode() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
    }
  }

  getUserName() {
    String userName = '';
    try {
      MyProfileModel myProfile;

      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE)!;
      userName = myProfile.result != null &&
              myProfile.result!.firstName != null &&
              myProfile.result!.firstName != ''
          ? 'Hey ${toBeginningOfSentenceCase(myProfile.result?.firstName ?? "")}'
          : myProfile != null
              ? 'Hey User'
              : '';

      return userName;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      //debugPrint(e.toString());
      return userName;
    }
  }

  Future<bool> checkGPSIsOn() async {
    try {
      bool? serviceEnabled = false;
      if (Platform.isAndroid) {
        const platform = MethodChannel(IS_LOCATION_SERVICE_CHECK);
        serviceEnabled =
            await (platform.invokeMethod(IS_LOCATION_SERVICE_CHECK));
      } else {
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      }
      return serviceEnabled!;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return false;
    }
  }

  Future<bool?> checkBluetoothIsOn() async {
    try {
      const platform = MethodChannel(IS_BP_ENABLE_CHECK);
      bool? isBluetoothEnable = await platform.invokeMethod(IS_BP_ENABLE_CHECK);
      return isBluetoothEnable;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return false;
    }
  }

  Future<String> checkForBluetoothIsOnForIOS() async {
    onInitHubListViewController().hubListResponse = null;
    final bleController = onInitSheelaBLEController();
    bleController.troubleShootTheBluetooth();
    await Future.delayed(const Duration(seconds: 4));
    if (bleController.troubleShootTimerSubscription != null) {
      bleController.troubleShootTimerSubscription!.cancel();
    }
    bleController.troubleShootTimerSubscription = null;
    print(bleController.troubleShootStatus);
    //unknown
//unsupported
//unauthorized
//poweredOff
//scanstarted
    bleController.stopScanning();
    onInitHubListViewController().getHubList();
    return bleController.troubleShootStatus;
  }

  String get _getDeviceType {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    return data.size.shortestSide < 550 ? 'phone' : 'tablet';
  }

  bool? get isTablet {
    return Device.get().isTablet;
  }

  Future<MyProfileModel?> getDetailsOfAddedFamilyMember(
      BuildContext context, String userID) async {
    final GlobalKey<State> _keyLoader = GlobalKey<State>();

    MyProfileModel myProfile;
    AddFamilyUserInfoRepository addFamilyUserInfoRepository =
        AddFamilyUserInfoRepository();
    CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);

    await addFamilyUserInfoRepository
        .checkIfChildISMember(userID)
        .then((mainValue) async {
      if (mainValue.isSuccess!) {
        await addFamilyUserInfoRepository
            .getMyProfileInfoNew(userID)
            .then((value) {
          myProfile = value;

          if (myProfile.result != null) {
            Navigator.of(context).pop();

            Get.toNamed(router.rt_AddFamilyUserInfo,
                    arguments: AddFamilyUserInfoArguments(
                        myProfileResult: myProfile.result,
                        fromClass: CommonConstants.user_update,
                        isFromAppointmentOrSlotPage: false,
                        isForFamily: false,
                        isForFamilyAddition: true))!
                .then((value) =>
                    PageNavigator.goToPermanent(context, router.rt_Landing));
          } else {
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

            FlutterToast()
                .getToast('Unable to Fetch User Profile data', Colors.red);
          }
        });
      } else {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

        FlutterToast().getToast(mainValue.message!, Colors.red);
        return mainValue;
      }
    });
  }

  Future<MyProfileModel?> acceptCareGiverTransportRequestReminder(
      BuildContext context,
      String appointmentId,
      String patientId,
      bool isAccept) async {
    final GlobalKey<State> _keyLoader = GlobalKey<State>();

    MyProfileModel myProfile = MyProfileModel();
    FetchAppointmentsService fetchAppointmentsService =
        FetchAppointmentsService();
    // var dialog=CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);
    var result = await fetchAppointmentsService.acceptOrDeclineAppointment(
        appointmentId, patientId, isAccept);
    //Navigator.pop(context);

    if ((appointmentId ?? '').isNotEmpty) {
      AppointmentDetailsController appointmentDetailsController =
          CommonUtil().onInitAppointmentDetailsController();
      appointmentDetailsController.getAppointmentDetail(appointmentId ?? '');
      Get.to(() => AppointmentDetailScreen());
    }

    return myProfile;
    // return result;
    // await addFamilyUserInfoRepository
    //     .checkIfChildISMember(userID)
    //     .then((mainValue) async {
    //   if (mainValue.isSuccess!) {
    //     await addFamilyUserInfoRepository
    //         .getMyProfileInfoNew(userID)
    //         .then((value) {
    //       myProfile = value;
    //
    //       if (myProfile.result != null) {
    //         Navigator.of(context).pop();
    //
    //         Get.toNamed(router.rt_AddFamilyUserInfo,
    //             arguments: AddFamilyUserInfoArguments(
    //                 myProfileResult: myProfile.result,
    //                 fromClass: CommonConstants.user_update,
    //                 isFromAppointmentOrSlotPage: false,
    //                 isForFamily: false,
    //                 isForFamilyAddition: true))!
    //             .then((value) =>
    //             PageNavigator.goToPermanent(context, router.rt_Landing));
    //       } else {
    //         Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    //
    //         FlutterToast()
    //             .getToast('Unable to Fetch User Profile data', Colors.red);
    //       }
    //     });
    //   } else {
    //     Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    //
    //     FlutterToast().getToast(mainValue.message!, Colors.red);
    //     return mainValue;
    //   }
    // });
  }

  Future<List<RegimentDataModel>> getMasterData(
      BuildContext context, String searchText) async {
    RegimentResponseModel regimentsData;
    Provider.of<RegimentViewModel>(context, listen: false).regimentFilter =
        RegimentFilter.Missed;

    Provider.of<RegimentViewModel>(context, listen: false)
        .changeFilter(RegimentFilter.Missed);

    regimentsData = await RegimentService.getRegimentData(
      dateSelected: CommonUtil.dateConversionToApiFormat(
        Provider.of<RegimentViewModel>(context, listen: false)
            .selectedRegimenDate,
        isIndianTime: true,
      ),
      isSymptoms:
          Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
                  RegimentMode.Symptoms
              ? 1
              : 0,
      isForMasterData: true,
      searchText: searchText,
    );
    List<RegimentDataModel> missedActvities = [];
    regimentsData.regimentsList!.forEach((regimenData) {
      if (!(regimenData.asNeeded) &&
          (regimenData.estart
                  ?.difference(DateTime.now())
                  .inMinutes
                  .isNegative ??
              false) &&
          regimenData.ack == null) {
        missedActvities.add(regimenData);
      }
    });

    return missedActvities;
  }

  OnInitAction() async {
    try {
      dbInitialize();

      //initSocket();
      Future.delayed(const Duration(seconds: 1)).then((_) {
        if (Platform.isIOS) {
          if (PreferenceUtil.isKeyValid(NotificationData)) {
            // changeTabToAppointments();
          }
        }
      });
      if (!Get.isRegistered<SheelaAIController>()) {
        Get.put(SheelaAIController());
      }
      if (!Get.isRegistered<ChatUserListController>()) {
        Get.put(ChatUserListController());
      }

      Get.find<SheelaAIController>().getSheelaBadgeCount(
        makeApiRequest: true,
      );
      await getMyProfilesetting();
      var regController = CommonUtil().onInitQurhomeRegimenController();
      regController.getRegimenList();
      FirestoreServices().setupListenerForFirestoreChanges();
      FirestoreServices().updateDataFor('all');
      if (!Get.isRegistered<PDFViewController>()) {
        Get.lazyPut(
          () => PDFViewController(),
        );
      }
      // Record the user's last access time
      saveUserLastAccessTime();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) print(e.toString());
    }
  }

  Future<MyProfileModel> getMyProfilesetting() async {
    final userId = await PreferenceUtil.getStringValue(constants.KEY_USERID);
    final userIdMain =
        await PreferenceUtil.getStringValue(constants.KEY_USERID_MAIN);

    if (userId != null && userId.isNotEmpty) {
      try {
        MyProfileModel value =
            await addFamilyUserInfoRepository.getMyProfileInfoNew(userId);
        myProfile = value;

        if (value != null) {
          if (value.result!.userProfileSettingCollection3!.isNotEmpty) {
            var profileSetting =
                value.result?.userProfileSettingCollection3![0].profileSetting;
            if (profileSetting != null) {
              CommonUtil.langaugeCodes.forEach((language, languageCode) {
                if (language == profileSetting.preferred_language) {
                  final langCode = language.split("-").first;
                  String currentLanguage = langCode;
                  if (currentLanguage.isNotEmpty) {
                    CommonUtil.supportedLanguages
                        .forEach((language, languageCode) {
                      if (currentLanguage == languageCode) {
                        PreferenceUtil.saveString(
                            SHEELA_LANG,
                            CommonUtil.langaugeCodes[languageCode] ??
                                strDefaultLanguage);
                      }
                    });
                  }
                }
              });
            } else {
              PreferenceUtil.saveString(SHEELA_LANG, strDefaultLanguage);
            }
            if (profileSetting?.preferredMeasurement != null) {
              PreferredMeasurement preferredMeasurement =
                  profileSetting!.preferredMeasurement!;
              await PreferenceUtil.saveString(Constants.STR_KEY_HEIGHT,
                      preferredMeasurement.height!.unitCode!)
                  .then((value) {
                PreferenceUtil.saveString(Constants.STR_KEY_WEIGHT,
                        preferredMeasurement.weight!.unitCode!)
                    .then((value) {
                  PreferenceUtil.saveString(
                          Constants.STR_KEY_TEMP,
                          preferredMeasurement.temperature!.unitCode!
                              .toUpperCase())
                      .then((value) {});
                });
              });
            } else {
              CommonUtil().commonMethodToSetPreference();
            }
          } else {
            CommonUtil().commonMethodToSetPreference();
          }
        } else {
          CommonUtil().commonMethodToSetPreference();
        }
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);

        CommonUtil().commonMethodToSetPreference();
      }
    } else {
      CommonUtil().logout(moveToLoginPage);
    }
    return myProfile!;
  }

  // 1
  void dbInitialize() {
    final commonConstants = CommonConstants();
    commonConstants.getCountryMetrics();
  }

  // 2
  void initSocket() {
    var userId = PreferenceUtil.getStringValue(KEY_USERID);

    if (userId == null)
      return Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
          .socket!
          .off(getChatTotalCountOn);

    Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
        .socket!
        .off(getReminderSheelaRedirect);

    Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
        .socket!
        .emitWithAck(getChatTotalCountEmit, {
      'userId': userId,
    }, ack: (countResponseEmit) {
      if (countResponseEmit != null) {
        TotalCountModel totalCountModel =
            TotalCountModel.fromJson(countResponseEmit);
        if (totalCountModel != null) {
          Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
              .updateChatTotalCount(totalCountModel);
        }
      }
    });

    Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
        .socket!
        .on(getChatTotalCountOn, (countResponseOn) {
      if (countResponseOn != null) {
        TotalCountModel totalCountModelOn =
            TotalCountModel.fromJson(countResponseOn);
        if (totalCountModelOn != null) {
          Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
              .updateChatTotalCount(totalCountModelOn);
        }
      }
    });

    Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
        .socket!
        .on(getReminderSheelaRedirect, (chatListresponse) {
      if (PreferenceUtil.getIfQurhomeDashboardActiveChat() &&
          isAllowSheelaLiveReminders()) {
        if (chatListresponse != null) {
          //Check whether the sheela inactive dialog is there
          var qurhomeDashboardController =
              CommonUtil().onInitQurhomeDashboardController();
          //close sheela inactive dialog if already exist
          if (qurhomeDashboardController.isShowScreenIdleDialog.value) {
            Get.back();
            qurhomeDashboardController.isScreenNotIdle.value = true;
            qurhomeDashboardController.isShowScreenIdleDialog.value = false;
          }
          SheelaReminderResponse chatList =
              SheelaReminderResponse.fromJson(chatListresponse);
          if (chatList != null) {
            var chatMessageId = chatList.chatMessageId ?? '';
            if (chatMessageId != null && chatMessageId != '') {
              Get.toNamed(
                rt_Sheela,
                arguments: SheelaArgument(
                    sheelReminder: true, chatMessageIdSocket: chatMessageId),
              )?.then((value) {
                //Start the timer if qurhome is true
                final isQurhomeActive = PreferenceUtil.getIfQurhomeisAcive();
                if (isQurhomeActive) {
                  qurhomeDashboardController.resetScreenIdleTimer();
                }
              });
            }
          }
        }
      }
    });
  }

  static bool isUSRegion() {
    try {
      bool value = false;
      if (CommonUtil.REGION_CODE != IND_REG) {
        value = true;
      } else {
        value = false;
      }
      return value;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return false;
    }
  }

  String getFirstAndLastName(String strText) {
    String strName = strText;
    String strName1 = "";
    String strName2 = "";
    try {
      if (strName.contains(" ")) {
        strName1 = strName.split(" ").first;
        strName2 = strName.split(" ").last;
      } else {
        strName1 = strName;
      }
      return strName2.trim().isNotEmpty
          ? strName1[0].toUpperCase() + strName2[0].toUpperCase()
          : strName1.trim().isNotEmpty
              ? strName1[0].toUpperCase()
              : "";
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
    return strName.trim().isNotEmpty ? strName[0].toUpperCase() : "";
  }

  AppointmentDetailsController onInitAppointmentDetailsController() {
    AppointmentDetailsController appointmentDetailsController;
    if (!Get.isRegistered<AppointmentDetailsController>()) {
      Get.put(AppointmentDetailsController());
    }
    appointmentDetailsController = Get.find();
    return appointmentDetailsController;
  }

  QurhomeRegimenController onInitQurhomeRegimenController() {
    QurhomeRegimenController qurhomeRegimenController;
    if (!Get.isRegistered<QurhomeRegimenController>()) {
      Get.put(QurhomeRegimenController());
    }
    qurhomeRegimenController = Get.find();
    return qurhomeRegimenController;
  }

  SheelaBLEController onInitSheelaBLEController() {
    SheelaBLEController sheelaBLEController;
    if (!Get.isRegistered<SheelaBLEController>()) {
      Get.put(SheelaBLEController());
    }
    sheelaBLEController = Get.find();
    return sheelaBLEController;
  }

  QurhomeDashboardController onInitQurhomeDashboardController() {
    QurhomeDashboardController qurhomeDashboardController;
    if (!Get.isRegistered<QurhomeDashboardController>()) {
      Get.put(QurhomeDashboardController());
    }
    qurhomeDashboardController = Get.find();
    return qurhomeDashboardController;
  }

  PDFViewController onInitPDFViewController() {
    PDFViewController pdfViewController;
    if (!Get.isRegistered<PDFViewController>()) {
      Get.put(PDFViewController());
    }
    pdfViewController = Get.find();
    return pdfViewController;
  }

  ChatUserListController onInitChatUserListController() {
    ChatUserListController chatUserListController;
    if (!Get.isRegistered<ChatUserListController>()) {
      Get.put(ChatUserListController());
    }
    chatUserListController = Get.find();
    return chatUserListController;
  }

  SheelaAIController onInitSheelaAIController() {
    SheelaAIController sheelaAIController;
    if (!Get.isRegistered<SheelaAIController>()) {
      Get.put(SheelaAIController());
    }
    sheelaAIController = Get.find();
    return sheelaAIController;
  }

  void goToAppointmentDetailScreen(
    String appointmentId, {
    Function(bool)? backFromAppointmentScreen,
  }) {
    if (!Get.isRegistered<AppointmentDetailsController>())
      Get.lazyPut(() => AppointmentDetailsController());
    AppointmentDetailsController appointmentDetailsController =
        Get.find<AppointmentDetailsController>();
    appointmentDetailsController.getAppointmentDetail(appointmentId);
    Get.to(() => AppointmentDetailScreen())?.then((value) {
      //Add appointment callback for pop the screen
      backFromAppointmentScreen?.call(true);
    });
  }

  Widget? startTheCall(String navRoute) {
    try {
      var docPic = navRoute.split('&')[3];
      var patPic = navRoute.split('&')[7];
      var callType = navRoute.split('&')[8];
      var isWeb = navRoute.split('&')[9] == null
          ? false
          : navRoute.split('&')[9] == 'true'
              ? true
              : false;
      try {
        if (docPic.isNotEmpty) {
          try {
            docPic = json.decode(navRoute.split('&')[3]);
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
          }
        } else {
          docPic = '';
        }
        if (patPic.isNotEmpty) {
          try {
            patPic = json.decode(navRoute.split('&')[7]);
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
          }
        } else {
          patPic = '';
        }
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }

      if (callType.toLowerCase() == 'audio') {
        Provider.of<AudioCallProvider>(Get.context!, listen: false)
            .enableAudioCall();
      } else if (callType.toLowerCase() == 'video') {
        Provider.of<AudioCallProvider>(Get.context!, listen: false)
            .disableAudioCall();
      }
      Get.to(CallMain(
        isAppExists: false,
        role: ClientRole.Broadcaster,
        channelName: navRoute.split('&')[0],
        doctorName: navRoute.split('&')[1],
        doctorId: navRoute.split('&')[2],
        doctorPic: docPic,
        patientId: navRoute.split('&')[5],
        patientName: navRoute.split('&')[6],
        patientPicUrl: patPic,
        isWeb: isWeb,
      ));
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) print(e.toString());
    }
  }

  Widget primaryProviderIndication() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(primary_provider,
              style: TextStyle(
                  color: mAppThemeProvider.primaryColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  String getFormattedDate(String strDate, String format) {
    try {
      String formattedDate;
      formattedDate =
          DateFormat(format).format(DateTime.parse(strDate).toLocal());
      return formattedDate;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return '';
    }
  }

  Future<void> handleCameraAndMic({bool onlyMic = false}) async {
    final status = await askPermissionForCameraAndMic(isAudioCall: onlyMic);
    if (!status) {
      if (onlyMic) {
        FlutterToast toastToShow = FlutterToast();
        toastToShow.getToast(
          strMicPermission,
          Colors.red,
        );
      } else {
        FlutterToast toastToShow = FlutterToast();
        toastToShow.getToast(
          strCameraPermission,
          Colors.red,
        );
      }
    }
  }

  String getFormattedString(
      String title, String type, String name, double fontSize,
      {bool forDetails = false}) {
    List<TextSpan> widget = [];
    if (type == 'Vitals') {
      try {
        return name;
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);

        return name;
      }
    } else {
      String first = '';
      String second = '';
      try {
        first = title.substring(title.indexOf("{") + 1, title.indexOf("}"));
        try {
          second = title.substring(title.indexOf("[") + 1, title.indexOf("]"));
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);

          return first;
        }
        return first + ' ' + second;
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);

        return title;
      }
    }
  }

  String getFormatedDate({String? date = null}) {
    DateTime now = date == null ? DateTime.now() : DateTime.parse(date);
    String prefix = '';
    if (calculateDifference(now) == 0) {
      //today
      prefix = 'Today, ';
    } else if (calculateDifference(now) < 0) {
      //past
      String formattedDate = DateFormat('EEEE').format(now);
      prefix = formattedDate + ', ';
    } else if (calculateDifference(now) > 0) {
      //future
      String formattedDate = DateFormat('EEEE').format(now);
      prefix = formattedDate + ', ';
    } else {
      String formattedDate = DateFormat('EEEE').format(now);
      prefix = formattedDate + ', ';
    }
    String formattedDate = DateFormat('dd MMM').format(now);
    return prefix + formattedDate;
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  bool canEditRegimen(
      DateTime selectedDate, RegimentDataModel regimen, BuildContext context) {
    var canEdit = false;
    int duration = 15;
    duration = CommonUtil.isUSRegion() ? regimen?.activityThreshold ?? 15 : 15;
    try {
      if (regimen?.ack != null) {
        canEdit = true;
      } else if (regimen?.doseMealString == Constants.doseValueless ||
          regimen?.doseMealString == Constants.doseValueHigh) {
        if (regimen?.otherinfo?.isAllDayActivity == true) {
          DateTime selectedDateTime =
              CommonUtil.getDateBasedOnOnceInAPlan(selectedDate, regimen!);

          if (calculateDifference(selectedDateTime ?? DateTime.now()) <= 0) {
            canEdit = true;
          } else {
            canEdit =
                (selectedDateTime?.difference(DateTime.now()).inMinutes ?? 0) <=
                        duration &&
                    Provider.of<RegimentViewModel>(context!, listen: false)
                            .regimentMode ==
                        RegimentMode.Schedule;
          }
        } else {
          DateTime selectedDateTime =
              CommonUtil.getDateBasedOnOnceInAPlan(selectedDate, regimen!);

          canEdit =
              (selectedDateTime?.difference(DateTime.now()).inMinutes ?? 0) <=
                      duration &&
                  Provider.of<RegimentViewModel>(context!, listen: false)
                          .regimentMode ==
                      RegimentMode.Schedule;
        }
      } else {
        if (regimen?.otherinfo?.isAllDayActivity == true) {
          if (calculateDifference(regimen?.estart ?? DateTime.now()) <= 0) {
            canEdit = true;
          } else {
            canEdit =
                (regimen?.estart?.difference(DateTime.now()).inMinutes ?? 0) <=
                        duration &&
                    Provider.of<RegimentViewModel>(context!, listen: false)
                            .regimentMode ==
                        RegimentMode.Schedule;
          }
        } else {
          canEdit =
              (regimen?.estart?.difference(DateTime.now()).inMinutes ?? 0) <=
                      duration &&
                  Provider.of<RegimentViewModel>(context!, listen: false)
                          .regimentMode ==
                      RegimentMode.Schedule;
        }
      }
    } catch (e) {
      canEdit = false;
    }
    return canEdit;
  }

  bool checkIfSkipAcknowledgemnt(RegimentDataModel regimen) {
    return (CommonUtil.isUSRegion() &&
        regimen?.otherinfo?.isSkipAcknowledgement == "1");
  }

  static DateTime getDateBasedOnOnceInAPlan(
      DateTime selectedDate, RegimentDataModel regimen) {
    try {
      String startDate = CommonUtil.dateConversionToApiFormat(
        selectedDate,
        isIndianTime: true,
      );
      if (regimen?.estartNew != null && regimen?.estartNew != "") {
        if ((regimen?.estartNew ?? "").contains(" ")) {
          String dateTime = regimen.estartNew?.split(" ")[1] ?? "";
          String completDate = ((startDate ?? " ") + " " + (dateTime ?? " "));
          DateTime selectedDateTime =
              DateTime.tryParse(completDate) ?? DateTime.now();

          return selectedDateTime;
        } else {
          return DateTime.now();
        }
      } else {
        return DateTime.now();
      }
    } catch (e, stackTrace) {
      return DateTime.now();
    }
  }

  Future<void> alertForSheelaDiscardOnConversation(
      BuildContext context, bool isQurhome,
      {Function()? pressYes, Function()? pressNo}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(sheelaDialogBody, style: TextStyle(fontSize: 18.sp)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(strCamelNo,
                  style: TextStyle(
                      color: isQurhome
                          ? mAppThemeProvider.qurHomePrimaryColor
                          : mAppThemeProvider.primaryColor)),
              onPressed: () {
                pressNo!();
              },
            ),
            TextButton(
              child: Text(strCamelYes,
                  style: TextStyle(
                      color: isQurhome
                          ? mAppThemeProvider.qurHomePrimaryColor
                          : mAppThemeProvider.primaryColor)),
              onPressed: () {
                pressYes!();
              },
            ),
          ],
        );
      },
    );
  }

  getTitleStyle() {
    return TextStyle(
      fontSize: CommonUtil().isTablet! ? tabHeader2 : mobileHeader2,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle getDefaultStyle() {
    return TextStyle(
        fontSize: CommonUtil().isTablet! ? tabHeader2 : mobileHeader2);
  }

  appLogs({var message, var stackTrace, String userName = ""}) async {
    try {
      String userId = '';
      String messageTemp = '';
      userId = CommonUtil().validString(userName ?? "");
      if (userId.trim().isEmpty) {
        userId = PreferenceUtil.getStringValue(KEY_USERID) ?? "";
      }
      if ((validString(userId ?? "").trim().isNotEmpty)) {
        var regController = CommonUtil().onInitQurhomeRegimenController();
        String version = '';
        String oSVersion = '';
        if (stackTrace != null) {
          messageTemp = (message != null
              ? (message.toString() + "\n" + stackTrace.toString())
              : (stackTrace.toString()));
        } else {
          messageTemp = (message != null ? message.toString() : "");
        }
        bool isProd = false;
        if ((BASE_URL == prodINURL) ||
            (BASE_URL == prodUSURL) ||
            (BASE_URL == demoINURL) ||
            (BASE_URL == demoUSURL)) {
          isProd = true;
        }

        await PackageInfo.fromPlatform().then((packageInfo) {
          version = (packageInfo.version + " + " + packageInfo.buildNumber);
        });

        if (Platform.isIOS) {
          oSVersion = "IOS ${Platform.operatingSystemVersion}";
        } else {
          oSVersion = "ANDROID ${Platform.operatingSystemVersion}";
        }

        if (isProd) {
          final apiResponse = QurHomeApiProvider();
          await apiResponse.saveAppLogs(
              userId: userId,
              message: messageTemp,
              userName: userName,
              version: version,
              oSVersion: oSVersion);
        } else {
          String strRandomId = getMyMeetingID().toString();
          ErrorAppLogDataModel errorAppLogDataModel = ErrorAppLogDataModel(
              itemId: strRandomId,
              message: messageTemp,
              appVersion: version,
              osVersion: oSVersion);
          regController.errorAppLogList?.add(errorAppLogDataModel);
          showErrorAppLogDialog(0);
        }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  showErrorLogPopUp(ErrorAppLogDataModel errorAppLogDataModel) {
    final scrollController = ScrollController();
    final dialog = StatefulBuilder(builder: (context, setState) {
      return WillPopScope(
        onWillPop: () => Future<bool>.value(false),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          titlePadding: EdgeInsets.zero,
          title: Container(
            color: (PreferenceUtil.getIfQurhomeisDefaultUI())
                ? mAppThemeProvider.qurHomePrimaryColor
                : mAppThemeProvider.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text(
                      parameters.strErrorLog,
                      style: TextStyle(
                          fontSize: 22.0.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    try {
                      var regController =
                          CommonUtil().onInitQurhomeRegimenController();
                      regController.isErrorAppLogDialogShowing.value = false;
                      regController.errorAppLogList?.clear();
                      regController.errorAppLogList = [];
                      Get.back();
                    } catch (e, stackTrace) {
                      if (kDebugMode) {
                        printError(info: e.toString());
                      }
                    }
                  },
                  child: Icon(
                    Icons.clear_all,
                    color: Colors.white,
                    //size: 20.0.sp,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    //size: 20.0.sp,
                  ),
                  onPressed: () {
                    try {
                      var regController =
                          CommonUtil().onInitQurhomeRegimenController();
                      regController.isErrorAppLogDialogShowing.value = false;
                      regController.errorAppLogList?.removeWhere(
                          (item) => item.itemId == errorAppLogDataModel.itemId);
                      Get.back();
                      if ((regController.errorAppLogList != null) &&
                          ((regController.errorAppLogList?.length ?? 0) > 0)) {
                        showErrorAppLogDialog(1);
                      }
                    } catch (e, stackTrace) {
                      if (kDebugMode) {
                        printError(info: e.toString());
                      }
                    }
                  },
                )
              ],
            ),
          ),
          contentPadding:
              EdgeInsets.only(left: 0.0, bottom: 10.0, right: 0.0, top: 5),
          content: Container(
            width: double.infinity,
            child: Scrollbar(
              controller: scrollController, // <---- Here, the controller
              thumbVisibility: false, // <---- Required
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.only(
                            top: 5.0, bottom: 5, right: 15, left: 15),
                        child: Text(
                          '${(errorAppLogDataModel.message)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0.sp,
                            fontWeight: FontWeight.normal,
                          ),
                        )),
                    Container(
                        padding: EdgeInsets.only(
                            top: 5.0, bottom: 5, right: 15, left: 15),
                        child: RichText(
                          text: TextSpan(
                            text: parameters.strAppVersion,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0.sp,
                            ),
                            children: [
                              TextSpan(
                                text: ' : ${errorAppLogDataModel.appVersion}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        )),
                    Container(
                        padding: EdgeInsets.only(
                            top: 5.0, bottom: 5, right: 15, left: 15),
                        child: RichText(
                          text: TextSpan(
                            text: parameters.strOSVersion,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0.sp,
                            ),
                            children: [
                              TextSpan(
                                text: ' : ${errorAppLogDataModel.osVersion}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
    return showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) => dialog);
  }

  showErrorAppLogDialog(int flag) async {
    try {
      var regController = CommonUtil().onInitQurhomeRegimenController();
      if (!(regController.isErrorAppLogDialogShowing.value)) {
        regController.isErrorAppLogDialogShowing.value = true;

        if (flag == 0) {
          await Future.delayed(const Duration(seconds: 10));
        } else {
          await Future.delayed(const Duration(milliseconds: 5));
        }

        showErrorLogPopUp(regController.errorAppLogList![0]);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  static getTitleName(String? firstName) {
    MyProfileModel myProfile;
    String? name = "";
    var phoneNumber = "";

    try {
      myProfile = PreferenceUtil.getProfileData(KEY_PROFILE)!;
      if (myProfile.result?.firstName != null &&
          myProfile.result?.firstName != "") {
        name = '${myProfile.result?.firstName?.capitalizeFirstofEach} ';
      }
    } catch (e, stackTraceError) {
      name = firstName ?? "";
    }

    return name;
  }

  askPermissionForNotification() async {
    try {
      if (Platform.isAndroid) {
        const platform = MethodChannel(IS_NOTIFICATION_PERMISSION_CHECK);
        await (platform.invokeMethod(IS_NOTIFICATION_PERMISSION_CHECK));
      } else {
        await Permission.notification.request();
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  showAlertDialogWithTextAndButton(
      String title, String msg, String buttonText, Function() onPressed) {
    showDialog(
      context: Get.context!,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              onPressed();
            },
            child: Container(
              color: mAppThemeProvider.primaryColor,
              padding: const EdgeInsets.all(14),
              child: Text(buttonText, style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  HubListViewController onInitHubListViewController() {
    HubListViewController hubListViewController;
    if (!Get.isRegistered<HubListViewController>()) {
      Get.put(HubListViewController());
    }
    hubListViewController = Get.find();
    return hubListViewController;
  }

  navigateToHubList(BuildContext context, {bool fromNotification = false}) {
    try {
      //Get.back();
      Get.to(
        () => HubListView(),
        binding: BindingsBuilder(
          () {
            if (!Get.isRegistered<HubListViewController>()) {
              Get.lazyPut(
                () => HubListViewController(),
              );
            }
          },
        ),
      )?.then((value) {
        if (!fromNotification) {
          PageNavigator.goToPermanent(context, router.rt_Landing);
        }
      });
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  LandingScreenController onInitLandingScreenController() {
    LandingScreenController landingScreenController;
    if (!Get.isRegistered<LandingScreenController>()) {
      Get.put(LandingScreenController());
    }
    landingScreenController = Get.find();
    return landingScreenController;
  }

  bool validYouTubeUrl(String content) {
    RegExp regExp = RegExp(
        r'((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?');
    String? matches = regExp.stringMatch(content);
    if (matches == null) {
      return false; // Always returns here while the video URL is in the content paramter
    }
    final String youTubeUrl = matches;
    return youTubeUrl.trim().isNotEmpty ? true : false;
  }

  String durationFormatter(int milliSeconds) {
    var seconds = milliSeconds ~/ 1000;
    final hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    var minutes = seconds ~/ 60;
    seconds = seconds % 60;
    final hoursString = hours >= 10
        ? '$hours'
        : hours == 0
            ? '00'
            : '0$hours';
    final minutesString = minutes >= 10
        ? '$minutes'
        : minutes == 0
            ? '00'
            : '0$minutes';
    final secondsString = seconds >= 10
        ? '$seconds'
        : seconds == 0
            ? '00'
            : '0$seconds';
    final formattedTime =
        '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';
    return formattedTime;
  }

  onBackVideoPlayerScreen() {
    try {
      if (CommonUtil().isTablet == true) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  static Future<bool> askPermissionForLocationBleScan() async {
    final location = await Permission.location.request();
    final bluetoothScan = await Permission.bluetoothScan.request();
    if (location == PermissionStatus.granted &&
        bluetoothScan == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissionsLocationBleScan(location, bluetoothScan);
      return false;
    }
  }

  static void _handleInvalidPermissionsLocationBleScan(
    PermissionStatus locationStatus,
    PermissionStatus bluetoothScanStatus,
  ) {
    if (locationStatus == PermissionStatus.denied &&
        bluetoothScanStatus == PermissionStatus.denied) {
      print("Access to location and ble scan denied");
    } else if (locationStatus == PermissionStatus.permanentlyDenied &&
        bluetoothScanStatus == PermissionStatus.permanentlyDenied) {
      print("Access to location and ble scan denied permanently");
    }
  }

  static Future<bool> askForStoragePermission() async {
    PermissionStatus storage = await Permission.storage.request();
    if (storage == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> handleLocationBleScanConnect() async {
    final status = await CommonUtil.askPermissionForLocationBleScan();
    if (!status) {
      FlutterToast toastToShow = FlutterToast();
      toastToShow.getToast(
        strLocationBlePermission,
        Colors.red,
      );
    }
  }

  Future<void> askPermssionLocationBleScan() async {
    try {
      var location = await Permission.location.status;
      var bluetoothScan = await Permission.bluetoothScan.status;
      if (location.isDenied || bluetoothScan.isDenied) {
        await CommonUtil().handleLocationBleScanConnect();
      } else {}
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Future<void> askAllPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
      Permission.microphone,
      Permission.camera,
      Permission.storage,
      Permission.photos,
      Permission.videos,
      //Permission.notification, // integrated native permission for push notificaion
    ].request();
    /*if (statuses[Permission.bluetoothConnect]!.isGranted &&
          statuses[Permission.bluetoothScan]!.isGranted &&
          statuses[Permission.location]!.isGranted &&
          statuses[Permission.microphone]!.isGranted &&
          statuses[Permission.camera]!.isGranted &&
          statuses[Permission.storage]!.isGranted &&
          statuses[Permission.notification]!.isGranted) {}*/
  }

  String getExtensionSheelaPreview(int type) {
    switch (type) {
      case 0:
        return "";
      case 1:
        return ".jpg";
      case 2:
        return ".pdf";
      case 3:
        return ".mp3";
      default:
        return "";
    }
  }

/**
 * This method is used to get value from api ,
 * based on which the remainders are shown in intervals.
 * Default value of the interval time would be 30 mins
 */
  getSheelaConfig() async {
    var apiBaseHelper = ApiBaseHelper();

    final response =
        await apiBaseHelper.getSheelaConfig(SHEELA_CONFIGURATION_URL);
    SheelaRemainderConfig sheelaRemainderConfig =
        SheelaRemainderConfig.fromJson(response);
    if (sheelaRemainderConfig != null &&
        sheelaRemainderConfig.isSuccess == true) {
      if (sheelaRemainderConfig.result != null &&
          (sheelaRemainderConfig.result?.length ?? 0) > 0) {
        if (sheelaRemainderConfig.result?[0].configurationData != null &&
            (sheelaRemainderConfig.result?[0].configurationData?.length ?? 0) >
                0) {
          if (sheelaRemainderConfig.result?[0].configurationData?[0].name ==
              "sheelaReminderTime") {
            int time = getTime(
                sheelaRemainderConfig?.result?[0].configurationData?[0].value ??
                    '');

            PreferenceUtil.saveInt(SHEELA_REMAINDER_TIME, (time));
          } else {
            PreferenceUtil.saveInt(SHEELA_REMAINDER_TIME, (30));
          }
        } else {
          PreferenceUtil.saveInt(SHEELA_REMAINDER_TIME, (30));
        }
      } else {
        PreferenceUtil.saveInt(SHEELA_REMAINDER_TIME, (30));
      }
    }
    return sheelaRemainderConfig;
  }

  int getTime(String value) {
    switch (value) {
      case "15m":
        return 15;
        break;
      case "30m":
        return 30;
        break;

      case "45m":
        return 45;
        break;
      case "1h":
        return 60;
        break;
      case "2h":
        return 120;
        break;

      default:
        return 30;
    }
  }

  getErrorMessage(RegimentDataModel? regimen, BuildContext context) {
    if (isUSRegion()) {
      String duration, dynamicActivityError;

      if (regimen?.activityThreshold != null &&
          regimen?.activityThreshold > 0) {
        duration = convertMinuteToHour(regimen?.activityThreshold);
        dynamicActivityError =
            "Future activities can be logged only ${duration} before the occurrence";
        return (Provider.of<RegimentViewModel>(context, listen: false)
                    .regimentMode ==
                RegimentMode.Symptoms)
            ? symptomsError
            : dynamicActivityError;
      } else {
        return (Provider.of<RegimentViewModel>(context, listen: false)
                    .regimentMode ==
                RegimentMode.Symptoms)
            ? symptomsError
            : activitiesError;
      }
    } else {
      return (Provider.of<RegimentViewModel>(context, listen: false)
                  .regimentMode ==
              RegimentMode.Symptoms)
          ? symptomsError
          : activitiesError;
    }
  }

  String getLocalityName(List<Address> addresses) {
    try {
      if ((addresses != null) && (addresses?.length ?? 0) > 0) {
        for (final adr in addresses) {
          if (adr.locality != null && (adr.locality?.length ?? 0) > 0) {
            return (adr.locality ?? '');
          }
        }
      }
      return "";
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    return "";
  }

  bool isAllowSheelaLiveReminders() {
    SheelaAIController? sheelaAIController = onInitSheelaAIController();
    return sheelaAIController.isAllowSheelaLiveReminders;
  }

  String getTimeMillsSnooze(String snoozeSelectTime) {
    String timeMills = '';
    try {
      if (snoozeSelectTime != '') {
        switch (snoozeSelectTime) {
          case '5':
            timeMills = Platform.isAndroid ? '300000' : '300';
            break;
          case '15':
            timeMills = Platform.isAndroid ? '900000' : '900';
            break;
          case '30':
            timeMills = Platform.isAndroid ? '1800000' : '1800';
            break;
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    return timeMills;
  }

  // Saves the user's last access time on the server.
  saveUserLastAccessTime() async {
    try {
      // Retrieve the user's ID from preferences
      String userId = PreferenceUtil.getStringValue(KEY_USERID) ?? '';

      // Check if the user ID is not empty
      if ((validString(userId ?? '').trim().isNotEmpty)) {
        // Initialize the version string
        String version = '';
        // Initialize an empty string variable to store the app name
        String appName = '';
        // Fetch the app version and build number
        await PackageInfo.fromPlatform().then((packageInfo) {
          version = (packageInfo.version + ' + ' + packageInfo.buildNumber);
          // Check the package name and set the corresponding app name
          if (packageInfo.packageName == appQurbookBundleId) {
            appName = strAppTypeQurbook;
          } else if (packageInfo.packageName == appQurhomeBundleId) {
            appName = strAppTypeQurhome;
          } else if (packageInfo.packageName == appQurdayBundleId) {
            appName = strAppTypeQurday;
          }
        });

        // Create an instance of QurHomeApiProvider
        final apiResponse = QurHomeApiProvider();
        // Call saveUserLastAccessTime method on QurHomeApiProvider
        await apiResponse.saveUserLastAccessTime(
            version: version, appNameTemp: appName);
      }
    } catch (e, stackTrace) {
      // Log any errors using appLogs
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // Define a method to save the voice clone patient assignment status
  saveVoiceClonePatientAssignmentStatus(
      String voiceCloneId, bool isAcceptTemp) async {
    try {
      // Create an instance of QurHomeApiProvider
      final apiResponse = QurHomeApiProvider();
      // Call the saveVoiceClonePatientAssignmentStatus method on QurHomeApiProvider
      await apiResponse.saveVoiceClonePatientAssignmentStatus(
          strVoiceCloneId: voiceCloneId, isAccept: isAcceptTemp);
    } catch (e, stackTrace) {
      // Log any errors using appLogs
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // Asynchronous function to retrieve and handle the route based on notification
  getMyRoute() async {
    try {
      // Get details if the app was launched from a notification
      NotificationAppLaunchDetails? didLaunchFromNotification =
          await localNotificationsPlugin.getNotificationAppLaunchDetails();

      // Get the notification response if available
      NotificationResponse? notificationResponse =
          didLaunchFromNotification?.notificationResponse;

      // Check if there is a notification response
      if (notificationResponse != null) {
        // Check if the app was launched by tapping on the notification
        if (didLaunchFromNotification?.didNotificationLaunchApp == true) {
          // Decode the payload and handle the notification response
          var mapResponse = jsonDecode(notificationResponse.payload ?? '');

          // If there is an action id, add it to the map
          if (notificationResponse.actionId != null) {
            mapResponse['action'] = notificationResponse.actionId;
          }

          // Handle the notification response for iOS
          IosNotificationHandler().handleNotificationResponse(mapResponse);
        }
      }
    } catch (e, stackTrace) {
      // Log any errors using appLogs
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // This function is responsible for handling the Sheela activity remainder invocation.
  getActivityRemainderInvokeSheela(
      var passedValArr, SheelaAIController sheelaAIController) async {
    var reqJson = {
      KIOSK_task: KIOSK_remind,
      KIOSK_eid: passedValArr[1].toString(),
    };
    // Check if auto redirect to Sheela screen is allowed
    if (CommonUtil().isAllowSheelaLiveReminders()) {
      // Live reminder on default existing flow
      if (sheelaAIController.isSheelaScreenActive) {
        // If Sheela screen is active, send a reminder notification
        CommonUtil().callQueueNotificationPostApi(reqJson);
      } else {
        // If Sheela screen is not active and queue dialog is showing, dismiss it
        var qurhomeDashboardController =
            CommonUtil().onInitQurhomeDashboardController();

        if (sheelaAIController.isQueueDialogShowing.value) {
          Get.back();
          sheelaAIController.isQueueDialogShowing.value = false;
        } else if (qurhomeDashboardController.isShowScreenIdleDialog.value) {
          qurhomeDashboardController.isScreenNotIdle.value = true;
          Get.back();
          qurhomeDashboardController.isShowScreenIdleDialog.value = false;
        }
        // Delayed navigation to Sheela screen
        await Future.delayed(Duration(milliseconds: 500), () async {
          // call queue insert api for adding the queue before navigate
          CommonUtil()
              .callQueueNotificationPostApi(reqJson, isNeedDialog: false);
          CommonUtil().getToSheelaNavigate(passedValArr, sheelaAIController,
              isFromActivityRemainderInvokeSheela: true);
        });
      }
    } else {
      // Live reminder off, only queue flow is working
      var reqJson = {
        KIOSK_task: KIOSK_remind,
        KIOSK_eid: passedValArr[1].toString(),
      };
      CommonUtil().callQueueNotificationPostApi(reqJson);
    }
  }

// This function is responsible for navigating to the Sheela screen based on various conditions.
  getToSheelaNavigate(var passedValArr, SheelaAIController sheelaAIController,
      {bool isFromAudio = false,
      bool isFromActivityRemainderInvokeSheela = false}) {
    if (isFromActivityRemainderInvokeSheela) {
      // If invoked from activity remainder, navigate to Sheela screen with arguments
      Get.toNamed(
        rt_Sheela,
        arguments: SheelaArgument(eId: passedValArr[1].toString()),
      )!
          .then((value) {
        try {
          var qurhomeDashboardController =
              CommonUtil().onInitQurhomeDashboardController();
          //Sheela badge count 0 means restart the timer for ideal
          if (sheelaAIController.sheelaIconBadgeCount.value == 0 &&
              qurhomeDashboardController.isRegimenScreen.value) {
            qurhomeDashboardController.resetScreenIdleTimer();
          } else {
            //Update the Sheela badge count
            sheelaAIController.getSheelaBadgeCount(
                isNeedSheelaDialog: true,
                isFromQurHomeRegimen:
                    qurhomeDashboardController.isRegimenScreen.value);
          }
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        }
      });
      return;
    }

    if (isFromAudio) {
      // If invoked from audio, navigate to Sheela screen with audio-related arguments
      Get.toNamed(
        router.rt_Sheela,
        arguments: SheelaArgument(
          allowBackBtnPress: true,
          audioMessage: passedValArr[3].toString(),
          eventIdViaSheela: passedValArr[4].toString(),
        ),
      )!
          .then((value) {
        try {
          sheelaAIController.getSheelaBadgeCount(isNeedSheelaDialog: true);
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
          if (kDebugMode) {
            print(e);
          }
        }
      });
    } else {
      // Delayed navigation to Sheela screen with default arguments
      Future.delayed(Duration(milliseconds: 500), () async {
        Get.toNamed(
          rt_Sheela,
          arguments: SheelaArgument(
              allowBackBtnPress: true,
              isSheelaFollowup: true,
              textSpeechSheela: (passedValArr[2] != null &&
                      passedValArr[2] != 'null' &&
                      passedValArr[2] != '')
                  ? passedValArr[2]
                  : passedValArr[1],
              audioMessage: '',
              isNeedPreferredLangauge: true,
              eventIdViaSheela: passedValArr[4]),
        )!
            .then((value) {
          try {
            sheelaAIController.getSheelaBadgeCount(isNeedSheelaDialog: true);
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
            if (kDebugMode) {
              print(e);
            }
          }
        });
      });
    }
  }

  /// Checks if the preferred language is English based on certain conditions.
  ///
  /// @param preferredLanguage The preferred language to be checked (nullable).
  /// @return True if the language is English, false otherwise.
  bool? checkIsLanguageEnglish(String? preferredLanguage) {
    // Check if the preferredLanguage is not null and matches one of the English language codes
    try {
      if (preferredLanguage != null &&
          (preferredLanguage == strDefaultLanguage || // English - India
              preferredLanguage == 'en' || // English
              preferredLanguage == 'undef')) {
        // Undefined language (assuming 'undef' represents a special case)
        return true; // If any of the conditions are met, return true
      } else {
        return false; // If none of the conditions are met, return false
      }
    } catch (e, stackTrace) {
      appLogs(message: e, stackTrace: stackTrace);
    }
  }

  bool? isLanguageEnglish() {
    bool isCheckEnglishLang = true;
    // Attempt to check if the current language is English using the checkIsLanguageEnglish method
    isCheckEnglishLang = (checkIsLanguageEnglish(getCurrentLanCode()) ?? true);
    return isCheckEnglishLang;
  }

  // Function to initialize and get the CreateTicketController instance
  CreateTicketController onInitCreateTicketController() {
    CreateTicketController createTicketController;

    // Check if CreateTicketController is not registered with GetX
    if (!Get.isRegistered<CreateTicketController>()) {
      // If not registered, put the CreateTicketController into the GetX dependency injection system
      Get.put(CreateTicketController());
    }

    // Find and get the CreateTicketController instance
    createTicketController = Get.find();

    // Return the obtained CreateTicketController instance
    return createTicketController;
  }

  /// Formats the given [amount] number to a string with 2 decimal places,
  /// unless the amount is an integer, in which case no decimal places are used.
  ///
  /// @param amount The number to format as a string.
  /// @return The formatted string representing the amount.
  static String formatAmount(num amount) =>
      '${amount % 1 == 0 ? amount : amount.toStringAsFixed(2)}';
  /**
    Gets the source name for the app based on the package name.
    Checks the package name from PackageInfo against known bundle IDs
    to determine the source name for the current app.
    Returns a string containing the determined source name.
   */

  getSourceName() async {
    var source = '';
    final packageInfo = await PackageInfo.fromPlatform();
    if (packageInfo.packageName == appQurbookBundleId) {
      source = strAppTypeQurbook;
    } else if (packageInfo.packageName == appQurhomeBundleId) {
      source = strAppTypeQurhome;
    } else if (packageInfo.packageName == appQurdayBundleId) {
      source = strAppTypeQurday;
    }

    return source;
  }

  VitalListController onInitVitalListController() {
    // Check if the controller is already registered
    if (!Get.isRegistered<VitalListController>()) {
      // If not registered, create and register a new instance
      Get.put<VitalListController>(VitalListController());
    }

    // Retrieve the instance of VitalListController
    return Get.find<VitalListController>();
  }

  Future<bool?> checkDevicePaired() async {
    // Initialize a variable to track device pairing status
    bool isDevicePaired = false;

    // Initialize the hub controller
    var _hubController = onInitHubListViewController();

    try {
      // Get the list of hubs
      await _hubController.getHubList();

      // Check if there are hubs available
      if ((_hubController.hubListResponse?.result ?? []).length > 0) {
        // If there are hubs, set device pairing status to true
        isDevicePaired = true;
      }
    } catch (e, stackTrace) {
      // Handle any errors and log them
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    // Return the device pairing status
    return isDevicePaired;
  }

  Future<bool?> checkRestrictManualRecord() async {
    // Initialize a variable to track manual record restriction status
    bool isRestrictManualRecord = false;

    try {
      // Get device selection for vitals
      await onInitVitalListController().getDeviceSelection();

      // Check if manual recording is restricted
      if (PreferenceUtil.getBool(KEY_IS_Vitals_ManualRecording_Restricted)) {
        // If manual recording is restricted, set the status to true
        isRestrictManualRecord = true;
      }
    } catch (e, stackTrace) {
      // Handle any errors and log them
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    // Return the manual record restriction status
    return isRestrictManualRecord;
  }

}

extension CapExtension on String {
  String get inCaps =>
      this.isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  String get allInCaps => toUpperCase();

  String get capitalizeFirstofEach => this != null && isNotEmpty
      ? trim().toLowerCase().split(' ').map((str) => str.inCaps).join(' ')
      : '';
}

enum CallActions { CALLING, DECLINED }

class VideoCallCommonUtils {
  final myDB = FirebaseFirestore.instance;
  static bool isMissedCallNsSent = false;

  RtcEngineEventHandler rtcEngineEventHandler = RtcEngineEventHandler();
  int videoPauseResumeState = 0;
  String? doctor_id, mtTitle, specialityName = null;

  String? userIdForNotify = '';
  static const platform = const MethodChannel('ongoing_ns.channel');
  static ValueNotifier callActions = ValueNotifier(CallActions.CALLING);

  //static String callStartTime = '';
  Future<bool?> makeCallToPatient(
      {BuildContext? context,
      required String bookId,
      String? appointmentId,
      String? patName,
      String? patId,
      String? patChatId,
      String? patientDOB,
      String? patientPicUrl,
      String? gender,
      bool? isFromAppointment,
      String? healthOrganizationId,
      dynamic slotDuration,
      dynamic isCallActualTime,
      HealthRecord? healthRecord,
      User? patienInfo,
      String? patientPrescriptionId,
      required String callType,
      required String isFrom}) async {
    try {
      //bool isCallSent = false;
      final apiResponse = QurHomeApiProvider();
      await PreferenceUtil.init();
      //var regController = Get.put<QurhomeRegimenController>();
      var regController = CommonUtil().onInitQurhomeRegimenController();
      var authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
      var docName = regController.userName.value;
      var randomMID = getMyMeetingID();
      var mID = (bookId.isNotEmpty || bookId != null) ? bookId : randomMID;
      vsPayLoad.Payload payLoad = vsPayLoad.Payload(
          type: regController.isFromSOS.value
              ? "sos"
              : keysConstant.c_ns_type_call,
          //type: keysConstant.c_ns_type_call,
          priority: regController.isFromSOS.value ? "high" : "",
          userId: regController.careCoordinatorId.value,
          meetingId: mID as String?,
          patientId: patChatId != null ? patChatId : '',
          patientName: patName != null ? patName : '',
          patientPicture: patientPicUrl != null ? patientPicUrl : '',
          userName: regController.userName.value,
          callType: callType,
          isWeb: 'false',
          // this will be always false when sent from mobile
          patientPhoneNumber: regController.userMobNo.value);

      Content _content = Content(
        messageTitle: docName != null ? /*jsonDecode(docName)*/ docName : null,
        messageBody: callType == 'video'
            ? keysConstant.c_ns_msg_video
            : keysConstant.c_ns_msg_audio,
      );

      MessageDetails msg = MessageDetails(content: _content, payload: payLoad);

      CallPushNSModel callModel = CallPushNSModel(
          recipients: [
            (regController.careCoordinatorId.value != null
                ? regController.careCoordinatorId.value
                : null)!
          ],
          messageDetails: msg,
          transportMedium: [keysConstant.c_trans_medium_push],
          saveMessage: false);

      authToken = authToken != null ? /*jsonDecode(authToken)*/ authToken : '';

      var isCallSent = await apiResponse.callMessagingAPI(
          token: authToken, callModel: callModel);

      CallMetaData callMeta;
      if (isCallSent) {
        //call has been sent to patient
        if (isFromAppointment!) {
          callMeta = CallMetaData(
            mID as String,
            appointmentId!,
            patName!,
            patId!,
            patientDOB!,
            patientPicUrl!,
            gender!,
            docName,
            healthRecord!,
            patientPrescriptionId!,
            slotDuration: slotDuration,
          );
        } else {
          callMeta = CallMetaData(
              mID as String,
              '',
              patName ?? "",
              patId ?? "",
              patientDOB ?? '',
              patientPicUrl ?? "",
              '',
              docName,
              healthRecord != null ? healthRecord : null,
              patientPrescriptionId ?? "");
        }
        var qurhomeDashboardController =
            CommonUtil().onInitQurhomeDashboardController();
        qurhomeDashboardController.getModuleAccess();
        regController.getSOSButtonStatus();
        regController.loadingData.value = false;
        regController.meetingId.value =
            CommonUtil().validString(mID.toString());
        Navigator.push(
          context!,
          MaterialPageRoute(
            builder: (context) => CallingPage(
              id: mID,
              name: regController.isFromSOS.value
                  ? emergencyServices
                  : regController.careCoordinatorName.value,
              callMetaData: callMeta,
              healthOrganizationId: healthOrganizationId,
              isCallActualTime: isCallActualTime,
              patienInfo: patienInfo,
              isFromAppointment: isFromAppointment,
            ),
          ),
        );
      } else {
        // FlutterToast()
        //     .getToast('could not start call,please try again!', Colors.red);
      }

      //return isCallSent;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        print(e);
      }
    }
  }

  String capitalizeFirstofEach(String data) {
    try {
      return data
          .trim()
          .toLowerCase()
          .split(' ')
          .map((str) => '${str[0].toUpperCase()}${str.substring(1)}')
          .join(' ');
    } catch (e, stacktrace) {
      CommonUtil().appLogs(message: e, stackTrace: stacktrace);

      return data;
    }
  }

  void startTheCall(
      {required BuildContext context,
      required String bookId,
      String? appointmentId,
      required String patName,
      String? patId,
      required String patientDOB,
      String? patientPicUrl,
      String? gender,
      String? healthOrganizationId,
      dynamic slotDuration,
      HealthRecord? healthRecord,
      User? patienInfo,
      required bool isFromAppointment,
      String? startedTime,
      dynamic isDoctor}) async {
    var randomMID = getMyMeetingID();
    var age;
    try {
      var parsedDate = DateTime.parse(patientDOB);
      age = calculateAge(parsedDate);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    //await handleCameraAndMic();

    var channelName =
        (bookId.isNotEmpty || bookId != null) ? bookId : randomMID;
    Provider.of<RTCEngineProvider>(context, listen: false).isVideoPaused =
        false;
    // initialize agora sdk
    await initialize(
      context: context,
      channelName: channelName as String?,
      patName: capitalizeFirstofEach(patName) ?? '',
      patId: patId,
      isFromAppointment: isFromAppointment,
      bookId: bookId,
      appointmentId: appointmentId,
    );

    CommonUtil.isCallStarted = true;

    Get.off(
      CallMainMakeCall(
        channelName: channelName as String?,
        role: ClientRole.Broadcaster,
        appointmentId: appointmentId,
        patName: capitalizeFirstofEach(patName) ?? patName,
        patId: patId,
        bookId: bookId,
        patDOB: isFromAppointment ? age.toString() : patientDOB,
        patPicUrl: patientPicUrl,
        gender: gender,
        healthOrganizationId: healthOrganizationId,
        slotDuration: slotDuration,
        healthRecords: healthRecord,
        patienInfo: patienInfo,
        isFromAppointment: isFromAppointment,
        startedTime: startedTime,
        isDoctor: isDoctor,
      ),
    );
  }

  Future<void> initialize({
    BuildContext? context,
    String? channelName,
    String? patName,
    String? patId,
    bool? isFromAppointment,
    String? appointmentId,
    String? bookId,
  }) async {
    if (APP_ID.isEmpty) {
      // setState(() {
      //   _infoStrings.add(
      //     'APP_ID missing, please provide your APP_ID in settings.dart',
      //   );
      //   _infoStrings.add('Agora Engine is not starting');
      // });

      return;
    }
    var rtcProvider = Provider.of<RTCEngineProvider>(context!, listen: false);
    await rtcProvider.startRtcEngine();

    /// Create agora sdk instance and initialize
    rtcProvider.rtcEngine?.setEventHandler(rtcEngineEventHandler);
    _addAgoraEventHandlers(
        patId: patId,
        isFromAppointment: isFromAppointment,
        patName: patName,
        bookId: bookId,
        appointmentId: appointmentId,
        context: context);
    await _initAgoraRtcEngine(rtcProvider, context: context);
    await rtcProvider.rtcEngine?.joinChannel(null, channelName!, null, 0);
    var regController = Get.find<QurhomeRegimenController>();
    /*await platform.invokeMethod(
        parameters.startOnGoingNS, {parameters.mode: parameters.start});*/
    /*await platform.invokeMethod("startOnGoingNS", {
      'name':
          '${regController.onGoingSOSCall.value ? "Emergency Services" : patName}',
      'mode': 'start'
    });*/
  }

  Future<void> _initAgoraRtcEngine(RTCEngineProvider rtcProvider,
      {BuildContext? context}) async {
    final audioStatus =
        Provider.of<AudioCallProvider>(Get.context!, listen: false);
    if (!audioStatus.isAudioCall) {
      //* Video call
      await rtcProvider.rtcEngine?.enableWebSdkInteroperability(true);
      VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
      configuration.dimensions = VideoDimensions(width: 640, height: 360);
      configuration.frameRate = VideoFrameRate.Fps15;
      configuration.bitrate = 200;
      await rtcProvider.rtcEngine?.setVideoEncoderConfiguration(configuration);
      await rtcProvider.rtcEngine?.enableVideo();
      await rtcProvider?.rtcEngine?.setEnableSpeakerphone(true);
    } else {
      await rtcProvider?.rtcEngine?.setEnableSpeakerphone(false);

      //* Audio call
      // if audio call means, diable video and put on inEar
      //await rtcProvider?.rtcEngine?.setEnableSpeakerphone(true);
    }
    await rtcProvider.rtcEngine
        ?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await rtcProvider.rtcEngine?.setClientRole(ClientRole.Broadcaster);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers({
    String? patId,
    bool? isFromAppointment,
    String? appointmentId,
    String? bookId,
    String? patName,
    required BuildContext context,
  }) {
    var rtcProvider = Provider.of<RTCEngineProvider>(context, listen: false);
    final audioStatus =
        Provider.of<AudioCallProvider>(Get.context!, listen: false);
    var user_id;
    rtcEngineEventHandler.error = (dynamic code) {
      printError(info: code.toString());
    };

    rtcEngineEventHandler.joinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      // setState(() {
      //   final info = 'onJoinChannel: $channel, uid: $uid';
      // });
    };

    rtcEngineEventHandler.leaveChannel = (RtcStats rtcStats) {
      Provider.of<RTCEngineProvider>(
        Get.context!,
        listen: false,
      ).clearUsers();
      // _users.clear();
      //FlutterToast().getToast('Call Ended', Colors.red);
    };

    rtcEngineEventHandler.userJoined = (int uid, int elapsed) {
      user_id = uid;
      final info = 'userJoined: $uid';
      var regController = Get.find<QurhomeRegimenController>();
      regController.UID.value = CommonUtil().validString(uid.toString());
      Provider.of<RTCEngineProvider>(
        Get.context!,
        listen: false,
      ).addUser(uid);
      VideoCallCommonUtils().StartTrackMyCall(appsID: appointmentId);
    };

    rtcEngineEventHandler.remoteAudioStateChanged = (int uid,
        AudioRemoteState state, AudioRemoteStateReason reason, int elapsed) {
      // setState(() {
      //   //get the remote user mute status
      // });
    };

    prepareMyData();
    rtcEngineEventHandler.userOffline = (int uid, UserOfflineReason reason) {
      if (reason == UserOfflineReason.Dropped) {
        noResponseDialog(
          Get.context,
          'Disconnected due to Network Failure!',
          patId: patId,
          isFromAppointment: isFromAppointment,
          appointmentId: appointmentId,
          bookId: bookId,
          patName: patName,
        );
        //print('user is OFFLINE');
      } else {
        try {
          if (!isFromAppointment!) {
            callApiToUpdateNonAppointment();
          }
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        }
        final call_start_time =
            DateFormat(keysConstant.c_yMd_Hms).format(DateTime.now());
        VideoCallCommonUtils().terminate(
            appsID: appointmentId,
            bookId: bookId,
            patName: patName,
            callStartTime: call_start_time);
        var regController = Get.find<QurhomeRegimenController>();
        regController.onGoingSOSCall.value = false;
        regController.meetingId.value = "";
        Navigator.pop(Get.context!);
      }
    };

    rtcEngineEventHandler.remoteVideoStateChanged = (
      int uid,
      VideoRemoteState videoRemoteState,
      VideoRemoteStateReason videoRemoteStateReason,
      int elapsed,
    ) {
      // setState(() {
      //   // final info = 'firstRemoteVideo: $uid ${width}x $height';
      //   // _infoStrings.add(info);
      // });
    };

    rtcEngineEventHandler.localVideoStateChanged =
        (LocalVideoStreamState localVideoStreamState,
            LocalVideoStreamError localVideoStreamError) {
      if (localVideoStreamState == LocalVideoStreamState.Stopped) {
        //FlutterToast().getToast('your video has been stopped', Colors.red);
      } else if (localVideoStreamState == LocalVideoStreamState.Failed) {
        //FlutterToast().getToast('The local video fails to start.', Colors.red);
      } else if (localVideoStreamState == LocalVideoStreamState.Capturing) {
        // FlutterToast().getToast(
        //     'The local video capturer starts successfully.', Colors.green);
      } else if (localVideoStreamState == LocalVideoStreamState.Encoding) {
        // FlutterToast().getToast(
        //     'The first local video frame encodes successfully.', Colors.green);
      }

      if (localVideoStreamError == LocalVideoStreamError.OK) {
        //FlutterToast().getToast('The local video is normal.', Colors.green);
      } else if (localVideoStreamError ==
          LocalVideoStreamError.CaptureFailure) {
        // FlutterToast().getToast(
        //     'The local video capture fails. Check whether the capturer is working properly.',
        //     Colors.red);
      } else if (localVideoStreamError ==
          LocalVideoStreamError.DeviceNoPermission) {
        // FlutterToast().getToast(
        //     'No permission to use the local video device.', Colors.red);
      } else if (localVideoStreamError == LocalVideoStreamError.DeviceBusy) {
        // FlutterToast()
        //     .getToast('The local video capturer is in use.', Colors.red);
      } else if (localVideoStreamError == LocalVideoStreamError.EncodeFailure) {
        //FlutterToast().getToast('The local video encoding fails.', Colors.red);
      } else if (localVideoStreamError == LocalVideoStreamError.Failure) {
        // FlutterToast().getToast(
        //     'No specified reason for the local video failure.', Colors.red);
      }
    };

    // rtcEngineEventHandler.userEnableVideo = (uid, isEnabled) async {
    //   if (isEnabled && audioStatus?.isAudioCall) {
    //     if (CommonUtil.isVideoRequestSent) {
    //       CommonUtil.isVideoRequestSent = false;
    //       Get.back();
    //       Provider?.of<HideProvider>(Get.context, listen: false)
    //           ?.swithToVideo();
    //       Provider.of<AudioCallProvider>(Get.context, listen: false)
    //           ?.disableAudioCall();
    //       Provider?.of<VideoIconProvider>(Get.context, listen: false)
    //           ?.turnOnVideo();
    //       Provider.of<RTCEngineProvider>(Get.context, listen: false)
    //           ?.changeLocalVideoStatus(false);
    //     }
    //   } else {
    //     if (Get.isDialogOpen) {
    //       Get.back();
    //       Get.rawSnackbar(
    //           messageText: Center(
    //             child: Text(
    //               'Request Canceled',
    //               style: TextStyle(
    //                   color: Colors.white, fontWeight: FontWeight.w500),
    //             ),
    //           ),
    //           snackPosition: SnackPosition.BOTTOM,
    //           snackStyle: SnackStyle.GROUNDED,
    //           duration: Duration(seconds: 3),
    //           backgroundColor: Colors.red.shade400);
    //     }
    //     /* if (CommonUtil.isVideoRequestSent) {
    //       // declined
    //       FlutterToast()
    //           .getToast('Video call request Declined by patient', Colors.black);
    //     }
    //     else {
    //       FlutterToast()
    //           .getToast('Video call request canceled by patient', Colors.green);
    //     } */

    //     videoPauseResumeState = 0;
    //   }
    // };

    rtcEngineEventHandler.remoteVideoStateChanged =
        (uid, state, reason, elapsed) async {
      if (state == VideoRemoteState.Starting ||
          state == VideoRemoteState.Decoding) {
        //TODO firstRemoteVideoFrame callback
      }

      //its a video call
      if (reason == VideoRemoteStateReason.Internal) {
        //FlutterToast().getToast('Remote User Went to OFFLINE', Colors.yellow);
        CommonUtil.isRemoteUserOnPause = false;
      } else if (reason == VideoRemoteStateReason.RemoteUnmuted) {
        CommonUtil.isRemoteUserOnPause = false;
        if (!audioStatus.isAudioCall) {
          FlutterToast().getToast('Patient Video is resumed', Colors.green);
        }
        videoPauseResumeState = 1;
      } else if (reason == VideoRemoteStateReason.RemoteMuted) {
        CommonUtil.isRemoteUserOnPause = true;

        if (CommonUtil.isLocalUserOnPause) {
          CommonUtil.isLocalUserOnPause = false;
          await rtcProvider.rtcEngine?.disableVideo();
          await rtcProvider.rtcEngine?.enableLocalVideo(false);
          await rtcProvider.rtcEngine?.muteLocalVideoStream(true);
          Provider.of<HideProvider>(Get.context!, listen: false).swithToAudio();
          Provider.of<AudioCallProvider>(Get.context!, listen: false)
              .enableAudioCall();
          Provider.of<VideoIconProvider>(Get.context!, listen: false)
              .turnOffVideo();
        } else {
          if (!(Provider.of<AudioCallProvider>(Get.context!, listen: false)
              .isAudioCall)) {
            FlutterToast().getToast('Patient Video is paused', Colors.red);
          }
          videoPauseResumeState = 2;
        }
      } else {
        CommonUtil.isRemoteUserOnPause = false;
      }
    };

    rtcEngineEventHandler.localAudioStateChanged = (state, error) {
      if (state == AudioLocalState.Recording) {
        //FlutterToast().getToast('Your on UnMute', Colors.red);
      } else {
        //FlutterToast().getToast('Your on Mute', Colors.green);
      }
    };

    rtcEngineEventHandler.remoteAudioStateChanged =
        (uid, state, reason, elapsed) {
      var regController = Get.find<QurhomeRegimenController>();
      String strText = "Patient";
      if (regController.isFromSOS.value) {
        strText = emergencyServices;
      } else {
        strText = regController.careCoordinatorName.value;
      }
      if (state == AudioRemoteState.Stopped) {
        //FlutterToast().getToast('$strText is on Mute', Colors.red);
      } else if (reason == AudioRemoteStateReason.RemoteMuted) {
        FlutterToast().getToast('$strText is on Mute', Colors.red);
      } else if (reason == AudioRemoteStateReason.RemoteUnmuted) {
        FlutterToast().getToast('$strText is on UnMute', Colors.green);
      }
      //uid is ID of the user whose audio state changes.
      /* if (reason == 1) {
        //print('REMOTE_AUDIO_REASON_NETWORK_CONGESTION- Network congestion.');
      } else if (reason == 3) {
        FlutterToast().getToast('Your on Mute', Colors.red);
        // print(
        //     'REMOTE_AUDIO_REASON_LOCAL_MUTED- The local user stops receiving the remote audio stream or disables the audio module.');
      } else if (reason == 4) {
        FlutterToast().getToast('Your on UnMute', Colors.red);
        // print(
        //     'REMOTE_AUDIO_REASON_LOCAL_UNMUTED- The local user resumes receiving the remote audio stream or enables the audio module.');
      } else if (reason == 5) {
        FlutterToast().getToast('Patient is on Mute', Colors.red);

        // print(
        //     'REMOTE_AUDIO_REASON_REMOTE_MUTED- The remote user stops sending the audio stream or disables the audio module.');
      } else if (reason == 6) {
        FlutterToast().getToast('Patient is on UnMute', Colors.red);

        // print(
        //     'REMOTE_AUDIO_REASON_REMOTE_UNMUTED- The remote user resumes sending the audio stream or enables the audio module.');
      } else if (reason == 7) {
        print(
            'REMOTE_AUDIO_REASON_REMOTE_OFFLINE- The remote user leaves the channel.');
      } */
    };

    rtcEngineEventHandler.networkTypeChanged = (networkType) {
      if (networkType == NetworkType.LAN) {
        print('network type is LAN');
      } else if (networkType == NetworkType.WIFI) {
        print('network type is WIFI');
      } else if (networkType == NetworkType.Mobile2G) {
        print('network type is Mobile2G');
      } else if (networkType == NetworkType.Mobile3G) {
        print('network type is Mobile3G');
      } else if (networkType == NetworkType.Mobile4G) {
        print('network type is Mobile4G');
      } else if (networkType == NetworkType.Disconnected) {
        print('network type is Disconnected');
      } else {
        print('network type is Unknown');
      }
    };

    if (user_id != null && user_id != '') {
      Provider.of<RTCEngineProvider>(Get.context!, listen: false)
          .rtcEngine
          ?.getUserInfoByUid(user_id)
          .then((value) {
        //print('connected user info ${value?.userAccount}');
      });
    }

    rtcEngineEventHandler.rejoinChannelSuccess = (channel, uid, elapsedTime) {
      print('After rejoining channel successfully');
      //print('channel $channel &uid $uid &elapsedTime $elapsedTime');
    };

    //Local user call status
    rtcEngineEventHandler.connectionStateChanged = (nwState, reason) {
      if (nwState == ConnectionStateType.Disconnected) {
        FlutterToast().getToast('Disconnected', Colors.red);
        //print('call was disconnected');
      } else if (nwState == ConnectionStateType.Connecting) {
        FlutterToast().getToast('Connecting..', Colors.green);
        //print('call is connecting');
      } else if (nwState == ConnectionStateType.Connected) {
        FlutterToast().getToast('Connected', Colors.green);
      } else if (nwState == ConnectionStateType.Reconnecting) {
        FlutterToast().getToast('Trying to Reconnect..', Colors.red);
        //print('call is reconnecting');
      } else if (nwState == ConnectionStateType.Failed) {
        FlutterToast().getToast('Connection Failed', Colors.red);
        //print('call is connection failed');
      }
    };

    rtcEngineEventHandler.networkQuality = (uid, tx, rx) {
      //uplink quality speed of local network state

      if (tx == NetworkQuality.Excellent) {
        print('The quality is excellent QUALITY_EXCELLENT');
      } else if (tx == NetworkQuality.Good) {
        print(
            'The quality is quite good, but the bitrate may be slightly lower than excellent. QUALITY_GOOD');
      } else if (tx == NetworkQuality.Poor) {
        print(
            'Users can feel the communication slightly impaired. QUALITY_POOR');
      } else if (tx == NetworkQuality.Bad) {
      } else if (tx == NetworkQuality.VBad) {
      } else if (tx == NetworkQuality.Down) {
      } else if (tx == NetworkQuality.Detecting) {
        print('The SDK is detecting the network quality. QUALITY_DETECTING');
      } else if (tx == NetworkQuality.Unknown) {
        print('The quality is unknown. QUALITY_UNKNOWN');
      }

      //downlink quality speed of local network state
      if (rx == NetworkQuality.Excellent) {
        print('The quality is excellent QUALITY_EXCELLENT');
      } else if (rx == NetworkQuality.Good) {
        print(
            'The quality is quite good, but the bitrate may be slightly lower than excellent. QUALITY_GOOD');
      } else if (rx == NetworkQuality.Poor) {
        print(
            'Users can feel the communication slightly impaired. QUALITY_POOR');
      } else if (tx == NetworkQuality.Bad) {
      } else if (tx == NetworkQuality.VBad) {
      } else if (tx == NetworkQuality.Down) {
      } else if (rx == NetworkQuality.Detecting) {
        print('The SDK is detecting the network quality. QUALITY_DETECTING');
      } else if (rx == NetworkQuality.Unknown) {
        print('The quality is unknown. QUALITY_UNKNOWN');
      }
    };

    rtcEngineEventHandler.remoteVideoStats = (stats) {
      if (videoPauseResumeState != 0) {
        // dont show try to reconnect view
      } else {
        /* if (stats.receivedBitrate == 0 &&
            !(Provider.of<RTCEngineProvider>(
              Get.context,
              listen: false,
            ).isCustomViewShown)) {
          Provider.of<RTCEngineProvider>(
            Get.context,
            listen: false,
          ).updateCustomViewShown(true);
        } else if (stats.receivedBitrate > 100 &&
            (Provider.of<RTCEngineProvider>(
              Get.context,
              listen: false,
            ).isCustomViewShown)) {
          Provider.of<RTCEngineProvider>(
            Get.context,
            listen: false,
          ).updateCustomViewShown(false);
        } else {
          //do nothing
        } */
      }
    };
  }

  noResponseDialog(
    BuildContext? mContext,
    String message, {
    String? patId,
    bool? isFromAppointment,
    String? appointmentId,
    String? bookId,
    String? patName,
  }) {
    return showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                prepareMyData();
                try {
                  if (!isFromAppointment!) {
                    callApiToUpdateNonAppointment();
                  }
                } catch (e, stackTrace) {
                  CommonUtil().appLogs(message: e, stackTrace: stackTrace);
                }
                final call_start_time =
                    DateFormat(keysConstant.c_yMd_Hms).format(DateTime.now());
                VideoCallCommonUtils().terminate(
                    appsID: appointmentId,
                    bookId: bookId,
                    patName: patName,
                    callStartTime: call_start_time);
                // Navigator.of(mContext).pop();
                // Navigator.of(mContext).popUntil((route) => route.isFirst);
                if (Platform.isIOS) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
                /*Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeSecreen(
                            arguments: HomeScreenArguments(
                                authToken: token,
                                doctorId: doctor_id,
                                title: mtTitle,
                                speciality: specialityName,
                                bookindId: '',
                                isHighLightAppointment: false,
                                userId: userIdForNotify,
                                isUpdateAlertShow: false),
                          )),
                  (route) => false,
                );*/
                // setState(() {
                //   final info = 'userOffline: $uid';
                //   _infoStrings.add(info);
                //   _users.remove(uid);
                //   //_users.clear();

                // });
              },
              child: Text(
                'Ok',
                style: TextStyle(
                  color: mAppThemeProvider.primaryColor,
                  fontSize: 18.0.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void prepareMyData() async {
    PreferenceUtil prefs = PreferenceUtil();

    /*try {
      mtTitle = await prefs.getValueBasedOnKey("display_name");
    } catch (e,stackTrace) {}
    try {
      specialityName = await prefs.getValueBasedOnKey("speciality");
    } catch (e,stackTrace) {}
    try {
      doctor_id = await prefs.getValueBasedOnKey("doctor_id");
    } catch (e,stackTrace) {}*/
    try {
      final SharedPreferences sharedPrefs =
          await SharedPreferences.getInstance();
      userIdForNotify = await sharedPrefs.getString('userID');
      userIdForNotify = json.decode(userIdForNotify!);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  callApiToUpdateNonAppointment() async {
    try {
      var regController = Get.find<QurhomeRegimenController>();
      final apiResponse = QurHomeApiProvider();
      Map<String, dynamic> body = Map();
      final now = DateTime.now();
      String endTime =
          '${DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').format(now)}';

      var startedTime =
          DateFormat(keysConstant.c_yMd_Hms).format(DateTime.now());
      body['startTime'] = startedTime;
      body['endTime'] = endTime;
      body['callerUser'] = regController.userId.value;
      body['recipientUser'] = regController.careCoordinatorId.value;

      await apiResponse.putNonAppointmentCall(body).then((value) {
        if (value['isSuccess'] != null && value['isSuccess']) {
          print('SUCCESSSSSSSSSSSSSSSSSSSSSSSSS NON APPOINTMENT CALL UPDATED');
        }
      });
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Future<bool> handleCameraAndMic({bool isAudioCall = false}) async {
//    await PermissionHandler().requestPermissions(
////      [PermissionGroup.camera, PermissionGroup.microphone],
////    );

    if (isAudioCall) {
      PermissionStatus micStatus = await Permission.microphone.request();
      if (micStatus == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {
      PermissionStatus status;
      status = await Permission.microphone.request();
      PermissionStatus cameraStatus = await Permission.camera.request();

      if (status == PermissionStatus.granted &&
          cameraStatus == PermissionStatus.granted) {
        return true;
      } else {
        _handleInvalidPermissions(cameraStatus, status);
        return false;
      }
    }
  }

  static void _handleInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus microphonePermissionStatus,
  ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      print("Access to camera and microphone denied");
      // throwPlatformException(
      //     code: "PERMISSION_DENIED",
      //     message: "Access to camera and microphone denied",
      //     details: null);
    } else if (cameraPermissionStatus == PermissionStatus.permanentlyDenied &&
        microphonePermissionStatus == PermissionStatus.permanentlyDenied) {
      print("Access to camera and microphone denied permanently");

      // throwPlatformException(
      //     code: "PERMISSION_DISABLED",
      //     message: "Location data is not available on device",
      //     details: null);
    }
  }

  Future<bool> getCurrentVideoCallRelatedPermission(
      {bool isAudioCall = false}) async {
    if (isAudioCall) {
      var micSts = await Permission.microphone.status;
      if (micSts == PermissionStatus.granted) {
        //do nothing
        return true;
      } else {
        return handleCameraAndMic(isAudioCall: isAudioCall);
      }
    } else {
      var cameraSts = await Permission.camera.status;
      var micSts = await Permission.microphone.status;
      if (cameraSts == PermissionStatus.granted &&
          micSts == PermissionStatus.granted) {
        //do nothing
        return true;
      } else {
        return handleCameraAndMic(isAudioCall: isAudioCall);
      }
    }
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  void callEnd(BuildContext context, dynamic id) async {
    try {
      Provider.of<RTCEngineProvider>(context, listen: false).stopRtcEngine();
      await myDB
          .collection("call_log")
          .doc("$id")
          .set({"call_status": "call_ended_by_user"});
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    try {
      CommonUtil.isCallStarted = false;
      Navigator.pop(context);
      var regController = Get.find<QurhomeRegimenController>();
      regController.meetingId.value = "";
      if (regController.isFromSOS.value) {
        regController.onGoingSOSCall.value = false;
      } else {
        var sheelaAIController = Get.find<SheelaAIController>();
        sheelaAIController.updateTimer(enable: true);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Future<bool?> updateCallCurrentStatus(
      {BuildContext? mContext,
      String? cid,
      CallMetaData? callMetaData,
      String? healthOrganizationId,
      AudioPlayer? audioPlayer,
      dynamic isCallActualTime,
      HealthRecord? healthRecord,
      User? patienInfo,
      bool? isFromAppointment,
      dynamic isDoctor}) async {
    try {
      await myDB
          .collection("call_log")
          .doc("$cid")
          .set({"call_status": "unknown"});
      listenForReceiverActions(
          cid: cid,
          context: mContext,
          callMetaData: callMetaData,
          healthOrganizationId: healthOrganizationId,
          audioPlayer: audioPlayer,
          isCallActualTime: isCallActualTime,
          healthRecord: healthRecord,
          patienInfo: patienInfo,
          isFromAppointment: isFromAppointment,
          isDoctor: isDoctor);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  void listenForReceiverActions(
      {BuildContext? context,
      String? cid,
      CallMetaData? callMetaData,
      String? healthOrganizationId,
      AudioPlayer? audioPlayer,
      dynamic isCallActualTime,
      HealthRecord? healthRecord,
      User? patienInfo,
      bool? isFromAppointment,
      bool? isFromSOS,
      dynamic isDoctor}) {
    try {
      FlutterToast toast = FlutterToast();
      final apiResponse = QurHomeApiProvider();
      var regController = Get.find<QurhomeRegimenController>();
      bool callPageShouldEndAutomatically = true;
      Future.delayed(Duration(seconds: 30), () async {
        if (callPageShouldEndAutomatically) {
          String? appointMentId = (callMetaData!.mappointmentId != null ||
                  callMetaData.mappointmentId.isNotEmpty)
              ? callMetaData.mappointmentId
              : '';
          if (appointMentId == '') {
            try {
              clearAudioPlayer(audioPlayer!);
              try {
                Provider.of<RTCEngineProvider>(context!, listen: false)
                    .stopRtcEngine();
                myDB
                    .collection("call_log")
                    .doc("$cid")
                    .set({"call_status": "call_ended_by_user"});
                regController.meetingId.value = "";
              } catch (e, stackTrace) {}
              Navigator.pop(context!);
            } catch (e, stackTrace) {
              CommonUtil().appLogs(message: e, stackTrace: stackTrace);

              print(e);
            }
          } else {
            if (isCallActualTime) {
              await apiResponse
                  .updateCallStatus((callMetaData.mappointmentId != null ||
                          callMetaData.mappointmentId.isNotEmpty)
                      ? callMetaData.mappointmentId
                      : '')
                  .then((value) {
                clearAudioPlayer(audioPlayer!);
                Navigator.pop(context!);
              });
            } else {
              //do nothing
              clearAudioPlayer(audioPlayer!);
              Navigator.pop(context!);
            }
          }
          if (callMetaData != null && !isMissedCallNsSent) {
            isMissedCallNsSent = true;
            if (regController.isFromSOS.value) {
              regController.onGoingSOSCall.value = false;
            } else {
              unavailabilityOfCC();
            }
            createMissedCallNS(
                docName: regController.userName.value,
                patId: regController.careCoordinatorId.value,
                bookingId: callMetaData.bookId);
            regController.meetingId.value = "";
          }
        }
      });
      myDB.collection('call_log').doc(cid).snapshots().listen(
          (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) async {
        Map<String, dynamic> firestoreInfo = documentSnapshot.data() ?? {};

        var recStatus = firestoreInfo['call_status'];
        if (recStatus != null && recStatus == "accept") {
          String startedTime = '';
          clearAudioPlayer(audioPlayer!);
          if (!isFromAppointment!) {
            Map<String, dynamic> body = Map();
            final now = DateTime.now();
            startedTime =
                '${DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').format(now)}';
            var randomMID = getMyMeetingID();

            body['startedTime'] = startedTime;
            body['appointment'] = randomMID;
            body['callerUser'] = regController.userId.value;
            body['recipientUser'] = regController.careCoordinatorId.value;
            String params = json.encode(body);

            await apiResponse.insertCallNonAppointment(params).then((value) {
              if (value['isSuccess'] != null && value['isSuccess']) {
                print('SUCCESSSSSSSSSSSSSSSSSSSSSSSSS NON APPOINTMENT CALL');
              }
            });
          }
          VideoCallCommonUtils().startTheCall(
              context: context!,
              bookId: callMetaData!.mbookId,
              appointmentId: (callMetaData.mappointmentId != null ||
                      callMetaData.mappointmentId.isNotEmpty)
                  ? callMetaData.mappointmentId
                  : '',
              healthOrganizationId: healthOrganizationId,
              gender: callMetaData.mgender != null ? callMetaData.mgender : '',
              patId: callMetaData.patientPrescriptionId != null
                  ? callMetaData.patientPrescriptionId
                  : '',
              patName:
                  (callMetaData.patName != null ? callMetaData.patName : ''),
              patientDOB: (callMetaData.patientDOB != null
                  ? callMetaData.patientDOB
                  : ''),
              patientPicUrl: callMetaData.mpatientPicUrl != null
                  ? callMetaData.mpatientPicUrl
                  : '',
              slotDuration: callMetaData.slotDuration,
              healthRecord: healthRecord,
              patienInfo: patienInfo,
              isFromAppointment: isFromAppointment,
              startedTime: startedTime,
              isDoctor: isDoctor);
          callPageShouldEndAutomatically = false;
        } else if (recStatus != null && recStatus == "decline") {
          clearAudioPlayer(audioPlayer!);
          callPageShouldEndAutomatically = false;
          CommonUtil.isCallStarted = false;
          callActions.value = CallActions.DECLINED;
          var regController = Get.find<QurhomeRegimenController>();
          if (regController.isFromSOS.value) {
            regController.onGoingSOSCall.value = false;
          } else {
            unavailabilityOfCC();
          }
          regController.meetingId.value = "";
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pop(context!);
          });
        }
      }).onError((e) {});
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Future<void> terminate(
      {String? appsID,
      String? bookId,
      String? patName,
      String? callStartTime}) async {
    try {
      String callEndTime = '';

      ///invoke call log api when receipent join call
      callEndTime = DateFormat(keysConstant.c_yMd_Hms).format(DateTime.now());
      final apiResponse = QurHomeApiProvider();
      await PreferenceUtil.init();
      var regController = Get.find<QurhomeRegimenController>();
      /*UpdatedInfo _updateInfo =
              UpdatedInfo(actualStartDateTime: callStartTime, bookingId: appsID);*/

      if (regController.isFromSOS.value) {
        AdditionalInfo additionalInfo =
            AdditionalInfo(location: regController.locationModel);

        CallEndModel callLogModel = CallEndModel(
            callerUser: regController.userId.value,
            recipientUser: regController.careCoordinatorId.value,
            startedTime: regController.callStartTime.value,
            endTime: callEndTime,
            status: "Completed",
            id: regController.resultId.value,
            additionalInfo: additionalInfo);

        var callLogResponse =
            await apiResponse.callLogEndData(request: callLogModel);

        var callEndRecordLogResponse = await apiResponse.stopRecordSOSCall();

        regController.onGoingSOSCall.value = false;
      } else {
        var sheelaAIController = Get.find<SheelaAIController>();
        sheelaAIController.updateTimer(enable: true);
      }
      /*else {
        UpdatedInfo updateInfo = UpdatedInfo(
            actualEndDateTime: callEndTime,
            actualStartDateTime: callStartTime,
            bookingId: appsID);

        var callLogForSheelaCommand =
            await apiResponse.recordCallLogForSheelaCommand(
                request: updateInfo, url: 'appointmentEnds');
      }*/

      //clear the call_log from firebase db
      await FirebaseFirestore.instance
          .collection('call_log')
          .doc('$bookId')
          .delete();

      await Provider.of<RTCEngineProvider>(Get.context!, listen: false)
          .stopRtcEngine();
      /*await platform.invokeMethod("startOnGoingNS", {
            'name':
                '${regController.onGoingSOSCall.value ? "Emergency Services" : patName}',
            'mode': 'stop'
          });*/
      CommonUtil.isCallStarted = false;
      CommonUtil.bookedForId = null;
      regController.meetingId.value = "";
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Future<void> StartTrackMyCall({
    String? appsID,
  }) async {
    try {
      String callStartTime = '';

      ///invoke call log api when receipent join call
      callStartTime = DateFormat(keysConstant.c_yMd_Hms).format(DateTime.now());
      final apiResponse = QurHomeApiProvider();
      await PreferenceUtil.init();
      var regController = Get.find<QurhomeRegimenController>();

      UpdatedInfo _updateInfo =
          UpdatedInfo(actualStartDateTime: callStartTime, bookingId: appsID);

      if (regController.isFromSOS.value) {
        await apiResponse.callLogData(
            request: getCallLogModel(callStartTime, "", "Started", true));
        await apiResponse.startRecordSOSCall();
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  createMissedCallNS(
      {String? docName, String? patId, String? bookingId}) async {
    try {
      String callStartTime = '';
      callStartTime = DateFormat(keysConstant.c_yMd_Hms).format(DateTime.now());
      final apiResponse = QurHomeApiProvider();
      await PreferenceUtil.init();
      var regController = Get.find<QurhomeRegimenController>();

      if (regController.isFromSOS.value) {
        await apiResponse.callMissedCallNsAlertAPI(
            request: getCallLogModel(callStartTime, callStartTime, "", false));
      } else {
        var body = {
          "doctorName": docName,
          "recipientId": patId,
          "bookingId": bookingId,
          "patientName": regController.userName.value,
          "isCareCoordinator": true
        };
        await apiResponse.callMissedCallNsAlertAPI(isFromSheelaRequest: body);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  CallLogModel getCallLogModel(
      String callStartTime, String callEndTime, String status, bool isCallLog) {
    var regController = Get.find<QurhomeRegimenController>();
    AdditionalInfo additionalInfo =
        AdditionalInfo(location: regController.locationModel);

    CallLogModel callLogModel = CallLogModel(
        callerUser: regController.userId.value,
        recipientUser: regController.careCoordinatorId.value,
        recipientId: regController.careCoordinatorId.value,
        startedTime: callStartTime,
        endTime: !isCallLog ? callEndTime : null,
        patientName: regController.userName.value,
        status: status,
        additionalInfo: additionalInfo);

    return callLogModel;
  }

  void clearAudioPlayer(AudioPlayer audioPlayer) async {
    await audioPlayer.stop();
    await audioPlayer.release();
  }

  /*List<String> getAssociateRecords(HealthRecord healthRecord) {
    List<String> metaId =List();

    if (healthRecord.associatedRecords != null &&
        healthRecord.associatedRecords.length > 0) {
      metaId.addAll(healthRecord.associatedRecords);
    }

    return metaId;
  }*/

  getDob(String dob) {
    if (dob != '' && dob != null) {
      String currentYear = dob.split('-')[0];
      DateFormat format = DateFormat("yyyy");

      DateTime dt = format.parse(currentYear);
      final date2 = DateTime.now().year;

      int yearDiff = date2 - dt.year;
      //print('${date2-dt.year}');
      return yearDiff.toString();
    } else {
      return '';
    }
  }

  unavailabilityOfCC() async {
    try {
      var sheelaAIController = Get.find<SheelaAIController>();
      sheelaAIController.isUnAvailableCC = true;
      sheelaAIController.isCallStartFromSheela = false;
      sheelaAIController.updateTimer(enable: true);
      sheelaAIController.getAIAPIResponseFor(strCallMyCC, null);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }
}

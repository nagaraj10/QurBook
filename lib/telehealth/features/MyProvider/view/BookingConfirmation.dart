import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/BadgesBlue.dart';
import 'package:gmiwidgetspackage/widgets/FlutterToast.dart';
import 'package:gmiwidgetspackage/widgets/IconButtonWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart'; //FU2.5

import '../../../../add_family_user_info/models/add_family_user_info_arguments.dart';
import '../../../../add_family_user_info/services/add_family_user_info_repository.dart';
import '../../../../common/CommonConstants.dart';
import '../../../../common/FHBBasicWidget.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../common/common_circular_indicator.dart';
import '../../../../common/errors_widget.dart';
import '../../../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../../../constants/fhb_constants.dart' as Constants;
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/fhb_parameters.dart';
import '../../../../constants/fhb_parameters.dart' as parameters;
import '../../../../constants/fhb_query.dart';
import '../../../../constants/router_variable.dart' as router;
import '../../../../constants/variable_constant.dart';
import '../../../../landing/view/landing_arguments.dart';
import '../../../../main.dart';
import '../../../../my_family/bloc/FamilyListBloc.dart';
import '../../../../my_family/models/FamilyMembersRes.dart';
import '../../../../my_providers/models/Doctors.dart';
import '../../../../my_providers/models/GetDoctorsByIdModel.dart';
import '../../../../src/blocs/Category/CategoryListBlock.dart';
import '../../../../src/model/Category/catergory_result.dart';
import '../../../../src/model/home_screen_arguments.dart';
import '../../../../src/model/user/MyProfileModel.dart';
import '../../../../src/model/user/UserAddressCollection.dart';
import '../../../../src/resources/network/ApiResponse.dart';
import '../../../../src/ui/MyRecord.dart';
import '../../../../src/ui/MyRecordsArguments.dart';
import '../../../../src/utils/FHBUtils.dart';
import '../../../../src/utils/language/language_utils.dart';
import '../../../../src/utils/screenutils/size_extensions.dart';
import '../../../../styles/styles.dart' as fhbStyles;
import '../../../../widgets/GradientAppBar.dart';
import '../../Payment/PaymentPage.dart';
import '../../appointments/model/fetchAppointments/past.dart';
import '../model/DoctorsFromHospitalModel.dart';
import '../model/appointments/AppointmentNotificationPayment.dart';
import '../model/appointments/CreateAppointmentModel.dart';
import '../model/associaterecords/associate_success_response.dart';
import '../model/getAvailableSlots/SlotSessionsModel.dart';
import '../model/healthOrganization/HealthOrganizationResult.dart';
import '../viewModel/CreateAppointmentViewModel.dart';
import '../viewModel/MyProviderViewModel.dart';
import 'CommonWidgets.dart';
import 'TelehealthProviders.dart';

import 'dart:developer' as dev;

class BookingConfirmation extends StatefulWidget {
  final followUpFee;
  bool? isNewAppointment;
  final List<Doctors?>? docs;
  final List<DoctorResult?>? docsReschedule;
  final int? i;
  final int? doctorListIndex;
  final DateTime? selectedDate;
  final List<SlotSessionsModel>? sessionData;
  final int? rowPosition;
  final int? itemPosition;
  final bool? isFollowUp;
  Past? doctorsData;
  final List<HealthOrganizationResult>? healthOrganizationResult;
  final List<ResultFromHospital>? resultFromHospitalList;
  final int? doctorListPos;
  Function(String)? closePage;
  Function()? refresh;
  bool? isFromHospital;
  bool? isFromFollowReschedule;

  bool? isFromFollowUpApp;
  bool? isFromFollowUpTake;
  bool isFromPaymentNotification = false;
  num? doctorAppoinmentTransLimit;
  num? noOfDoctorAppointments;
  String? appointmentId;

  BookingConfirmation(
      {this.docs,
      this.docsReschedule,
      this.i,
      this.doctorListIndex,
      this.selectedDate,
      this.sessionData,
      this.rowPosition,
      this.followUpFee,
      this.itemPosition,
      this.isNewAppointment,
      this.isFollowUp,
      this.doctorsData,
      this.healthOrganizationResult,
      this.resultFromHospitalList,
      this.doctorListPos,
      this.closePage,
      this.refresh,
      this.isFromHospital,
      this.isFromFollowReschedule,
      this.isFromFollowUpApp,
      this.isFromFollowUpTake,
      this.isFromPaymentNotification = false,
      this.appointmentId = '',
      this.doctorAppoinmentTransLimit,
      this.noOfDoctorAppointments});

  @override
  BookingConfirmationState createState() => BookingConfirmationState();
}

class BookingConfirmationState extends State<BookingConfirmation> {
  CommonWidgets commonWidgets = CommonWidgets();
  CommonUtil commonUtil = CommonUtil();
  late MyProviderViewModel providerViewModel;
  late CreateAppointMentViewModel createAppointMentViewModel;
  late FamilyListBloc _familyListBloc;
  FamilyMembers familyMembersModel = FamilyMembers();
  List<SharedByUsers> sharedbyme = [];
  FlutterToast toast = FlutterToast();
  FamilyMembers? familyData = FamilyMembers();

  List<SharedByUsers> _familyNames = [];
  List<String> healthRecords = [];

  int recordIdCount = 0;
  int notesIdCount = 0;
  int voiceIdCount = 0;
  bool? isActiveMember;

  String? slotNumber = '',
      slotTime = '',
      createdBy = '',
      createdFor = '',
      doctorSessionId = '',
      scheduleDate = '',
      fees = '';
  String? apiStartTime = '', apiEndTime = '';
  SharedByUsers? selectedUser;
  String? selectedId = '';
  late ProgressDialog pr; // FU2.5

  CategoryListBlock? _categoryListBlock;

  List<CategoryResult>? categoryDataList = [];
  List<CategoryResult> filteredCategoryData = [];
  CategoryResult categoryDataObjClone = CategoryResult();

  String? doctorId;

  bool isFamilyChanged = false;

  MyProfileModel? myProfile;
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  bool? checkedValue = false;

  String? INR_Price = '';
  //Added for storing a temp original price to retrieve when membershipApplied.
  String? originalPrice = '';
  String? applyMembershipDiscountedAmount = '';

  String btnLabelChange = payNow;
  bool isMembershipDiscount = false;
  bool isApplyMemberShipBenefits= false;
  String? MembershipDiscountPercent;
  bool? isResident = false;
  String? profilePicThumbnailUrl,
      doctorName = '',
      speciality = '',
      patientName = '',
      shortURL = '',
      paymentID = '';
  bool? status;
  Doctor? doctorFromNotification;
  @override
  void initState() {
    providerViewModel = MyProviderViewModel();
    createAppointMentViewModel = CreateAppointMentViewModel();
    createdBy = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    selectedId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    _familyListBloc = FamilyListBloc();
    _familyListBloc.getFamilyMembersListNew();
    FABService.trackCurrentScreen(FBAConfirmationDetailsScreen);
    _categoryListBlock = null;
    _categoryListBlock = CategoryListBlock();
    getCategoryList();
    getDataFromWidget();
    setLengthValue();
    showDialogForMembershipDiscount();
    try {
      INR_Price = commonWidgets.getMoneyWithForamt((widget.isFromFollowUpApp! &&
              widget.isFromFollowUpTake == false &&
              isFollowUp())
          ? getFollowUpFee()
          : widget.isFromHospital!
              ? getFeesFromHospital(
                  widget.resultFromHospitalList![widget.doctorListIndex!],
                  false)
              : getFees(widget.healthOrganizationResult![widget.i!], false));
      originalPrice = INR_Price;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  addHealthRecords() {
    healthRecords.addAll(CommonUtil.notesId!);
    healthRecords.addAll(CommonUtil.voiceIds!);
  }

  clearAttachedRecords() {
    CommonUtil.recordIds!.clear();
    CommonUtil.notesId!.clear();
    CommonUtil.voiceIds!.clear();
    voiceIdCount = 0;
    recordIdCount = 0;
    notesIdCount = 0;
  }

  Future<FamilyMembers> getList() async {
    _familyListBloc.getFamilyMembersListNew().then((familyMembersList) {
      familyMembersModel = familyMembersList;

      for (int i = 0;
          i < familyMembersModel.result!.sharedByUsers!.length;
          i++) {
        sharedbyme.add(familyMembersModel.result!.sharedByUsers![i]);
      }
    });

    return familyMembersModel;
  }

  getDataFromWidget() {
    try {
      slotTime = commonUtil.removeLastThreeDigits(widget
          .sessionData![widget.rowPosition!]
          .slots![widget.itemPosition!]
          .startTime!);
      apiStartTime = widget.sessionData![widget.rowPosition!]
          .slots![widget.itemPosition!].startTime;
      apiEndTime = widget.sessionData![widget.rowPosition!]
          .slots![widget.itemPosition!].endTime;
      slotNumber = widget.sessionData![widget.rowPosition!]
          .slots![widget.itemPosition!].slotNumber
          .toString();
      doctorSessionId =
          widget.sessionData![widget.rowPosition!].doctorSessionId;
      scheduleDate = CommonUtil.dateConversionToApiFormat(widget.selectedDate!);
      isResident = widget.isFromHospital!
          ? widget.resultFromHospitalList![widget.doctorListIndex!].doctor!
              .isResident
          : widget.isFromFollowReschedule!
              ? widget.docsReschedule![widget.doctorListPos!]!.isResident
              : widget.docs![widget.doctorListPos!]!.isResident;
      doctorId = widget.isFromHospital!
          ? widget
              .resultFromHospitalList![widget.doctorListIndex!].doctor!.user!.id
          : widget.isFromFollowReschedule!
              ? widget.docsReschedule![widget.doctorListPos!]!.user!.id
              : widget.docs![widget.doctorListPos!]!.user!.id;
    } catch (exception) {}
  }

  Widget getDataFromResponse(
      AppointmentNotificationPayment? appointmentNotificationPayment) {
    if (appointmentNotificationPayment != null) {
      slotTime = CommonUtil.getDateStringFromDateTime(
          appointmentNotificationPayment
              .result!.appointment!.plannedStartDateTime!,
          forNotification: true);
      apiStartTime = appointmentNotificationPayment
          .result!.appointment!.plannedStartDateTime;
      apiEndTime = appointmentNotificationPayment
          .result!.appointment!.plannedEndDateTime;
      slotNumber = appointmentNotificationPayment
          .result!.appointment!.slotNumber
          .toString();
      doctorSessionId =
          appointmentNotificationPayment.result?.appointment?.doctorSessionId;
      scheduleDate = CommonUtil.dateConversionToApiFormat(DateTime.tryParse(
          appointmentNotificationPayment
              .result!.appointment!.plannedStartDateTime!)!);
      isResident =
          appointmentNotificationPayment.result?.doctor?.isResident ?? false;
      doctorId = appointmentNotificationPayment.result?.doctor?.id;
      profilePicThumbnailUrl = appointmentNotificationPayment
          .result?.doctor?.user?.profilePicThumbnailUrl;
      doctorFromNotification = appointmentNotificationPayment.result?.doctor;
      status = appointmentNotificationPayment.result?.doctor?.user?.isActive ??
          strFalse as bool?;
      speciality =
          appointmentNotificationPayment.result?.doctor?.specialization ?? '';
      if (appointmentNotificationPayment.result?.payment != null) {
        INR_Price =
            appointmentNotificationPayment.result?.payment?.amount ?? '';
        originalPrice = INR_Price;
        shortURL =
            appointmentNotificationPayment.result?.payment?.longUrl ?? '';
        paymentID = appointmentNotificationPayment.result?.payment?.id ?? '';
      }
      selectedId =
          appointmentNotificationPayment.result?.appointment?.bookedFor != null
              ? appointmentNotificationPayment
                  .result?.appointment?.bookedFor!.id
              : '';
      try {
        var firstName = appointmentNotificationPayment
                    .result?.appointment?.bookedFor?.firstName !=
                null
            ? appointmentNotificationPayment
                .result?.appointment?.bookedFor?.firstName
            : '';
        var lastName = appointmentNotificationPayment
                    .result?.appointment?.bookedFor?.lastName !=
                null
            ? appointmentNotificationPayment
                .result?.appointment?.bookedFor?.lastName
            : '';
        patientName =
            appointmentNotificationPayment.result?.appointment?.bookedFor !=
                    null
                ? firstName! + ' ' + lastName!
                : '';
      } catch (e, stackTrace) {
        patientName = '';
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }

      doctorName = appointmentNotificationPayment.result?.doctor?.user != null
          ? toBeginningOfSentenceCase((appointmentNotificationPayment
                          .result?.doctor?.user?.name !=
                      null &&
                  appointmentNotificationPayment.result?.doctor?.user?.name !=
                      '')
              ? appointmentNotificationPayment
                  .result?.doctor?.user?.name!.capitalizeFirstofEach
              : appointmentNotificationPayment
                              .result?.doctor?.user?.firstName !=
                          null &&
                      appointmentNotificationPayment
                              .result?.doctor?.user!.lastName !=
                          null
                  ? (appointmentNotificationPayment.result!.doctor!.user!
                          .firstName!.capitalizeFirstofEach +
                      appointmentNotificationPayment.result!.doctor!.user!
                          .lastName!.capitalizeFirstofEach)
                  : '')
          : '';

      isFamilyChanged = true;
      return getBodyMain();
    }
    return ErrorsWidget();
  }

  Widget getDropdown() {
    return StreamBuilder<ApiResponse<FamilyMembers>>(
      stream: _familyListBloc.familyMemberListNewStream,
      builder: (context, AsyncSnapshot<ApiResponse<FamilyMembers>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return Center(
                child: SizedBox(
                  child: CommonCircularIndicator(),
                  width: 30,
                  height: 30,
                ),
              );

            case Status.ERROR:
              return FHBBasicWidget.getRefreshContainerButton(
                  snapshot.data!.message, () {
                setState(() {});
              });

            case Status.COMPLETED:
              print(snapshot.data.toString());
              if (snapshot.data!.data!.result != null) {
                familyData = snapshot.data!.data;
              }

              return dropDownButton(snapshot.data!.data!.result != null
                  ? snapshot.data!.data!.result!.sharedByUsers
                  : null);
          }
        } else {
          return Container(height: 0, color: Colors.white);
        }
      },
    );
  }

  Widget dropDownButton(List<SharedByUsers>? sharedByMeList) {
    MyProfileModel? myProfile;
    String fulName = '';
    try {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
      fulName = myProfile!.result != null
          ? myProfile.result!.firstName!.capitalizeFirstofEach +
              ' ' +
              myProfile.result!.lastName!.capitalizeFirstofEach
          : '';
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    if (sharedByMeList == null) {
      sharedByMeList = [];
      sharedByMeList
          .add(SharedByUsers(id: myProfile?.result?.id, nickName: 'Self'));
    } else {
      sharedByMeList.insert(
          0, SharedByUsers(id: myProfile?.result?.id, nickName: 'Self'));
    }
    if (_familyNames.length == 0) {
      for (int i = 0; i < sharedByMeList.length; i++) {
        _familyNames.add(sharedByMeList[i]);
      }
    }

    if (_familyNames.length > 0) {
      for (SharedByUsers sharedByUsers in _familyNames) {
        if (sharedByUsers != null) {
          if (sharedByUsers.child != null) {
            if (sharedByUsers.child!.id == selectedId) {
              selectedUser = sharedByUsers;
            }
          }
        }
      }
    }

    return SizedBoxWithChild(
      height: 30,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: DropdownButton<SharedByUsers>(
          value: selectedUser,
          underline: const SizedBox(),
          isExpanded: true,
          hint: Row(
            children: <Widget>[
              SizedBoxWidget(width: 20),
              Text(parameters.self,
                  style: TextStyle(
                    fontSize: 14.0.sp,
                  )),
            ],
          ),
          items: _familyNames
              .map((SharedByUsers user) => DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        SizedBoxWidget(width: 20),
                        Text(
                            user.child == null
                                ? 'Self'
                                : ((user.child?.firstName ?? '') +
                                        ' ' +
                                        (user.child?.lastName ?? ''))
                                    .capitalizeFirstofEach,
                            style: TextStyle(
                              fontSize: 14.0.sp,
                            )),
                      ],
                    ),
                    value: user,
                  ))
              .toList(),
          onChanged: (SharedByUsers? user) {
            isFamilyChanged = true;
            setState(() {
              if (selectedUser != user) {
                clearAttachedRecords();
              }
              selectedUser = user;
              if (user!.child != null) {
                if (user.child!.id != null) {
                  selectedId = user.child!.id;
                }
              } else {
                selectedId = createdBy;
              }
            });
          },
        ),
      ),
    );
  }

  Widget nameDateCard() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: Column(
        children: <Widget>[
          SizedBoxWidget(
            height: 10,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text(parameters.theAppointmentIsFor,
                    style: TextStyle(fontSize: 12.0.sp, color: Colors.grey)),
              ],
            ),
          ),
          SizedBoxWidget(
            height: 8,
          ),
          widget.isFromPaymentNotification
              ? Row(
                  children: <Widget>[
                    SizedBoxWidget(width: 20),
                    Text(patientName!,
                        style: TextStyle(
                          fontSize: 14.0.sp,
                        )),
                  ],
                )
              : getDropdown(),
          SizedBoxWidget(
            height: 10,
          ),
          Container(
            child: Row(
              children: <Widget>[
                TextWidget(
                  text: parameters.dateAndTime,
                  fontsize: 12.0.sp,
                  colors: Colors.grey,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    commonWidgets.getIcon(
                        width: fhbStyles.imageWidth,
                        height: fhbStyles.imageHeight,
                        icon: Icons.mode_edit,
                        onTap: () {
                          if (widget.isFromPaymentNotification == false) {
                            Navigator.pop(context);
                            widget.refresh!();
                          }
                        }),
                    SizedBoxWidget(
                      width: 10,
                    ),
                    TextWidget(
                      text: widget.selectedDate != null
                          ? commonUtil
                              .dateConversionToDayMonthYear(
                                  widget.selectedDate!)
                              .toString()
                          : '',
                      fontsize: 14.0.sp,
                    ),
                    SizedBoxWidget(
                      width: 5,
                    ),
                    TextWidget(
                      text: slotTime != null ? slotTime : '0.00',
                      fontsize: 14.0.sp,
                    ),
                  ],
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color:
                        mAppThemeProvider.primaryColor, // border color
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2), // border width
                    child: Container(
                      // or ClipRRect if you need to clip the content
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: mAppThemeProvider.primaryColor, // inner circle color
                      ),
                      child: Center(
                        child: TextWidget(
                            text: slotNumber != null ? slotNumber : '0',
                            fontsize: 18.0.sp,
                            fontWeight: FontWeight.w900,
                            colors: Colors.white),
                      ), // inner content
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, type: ProgressDialogType.normal); //  FU2.5
    pr.style(
        message: checkSlots,
        borderRadius: 6,
        backgroundColor: Colors.white,
        progressWidget: SizedBox(
          height: 1.sh,
          child: Center(
            child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator()),
          ),
        ),
        elevation: 6,
        insetAnimCurve: Curves.easeInOut,
        progress: 0,
        maxProgress: 100,
        progressTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 12.0.sp,
            fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16.0.sp,
            fontWeight: FontWeight.w600));

    return WillPopScope(
      onWillPop: () async {
        if (widget.isFromPaymentNotification) {
          Get.offAllNamed(router.rt_notification_main);
          return true;
        } else {
          Navigator.pop(context);
          if (widget.isFromPaymentNotification == false) widget.refresh!();
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          leading: GestureDetector(
            onTap: () {
              if (widget.isFromPaymentNotification) {
                Get.offAllNamed(router.rt_notification_main);
              } else {
                if (widget.isFromPaymentNotification == false)
                  widget.refresh!();
                Navigator.pop(context);
              }
            },
            child: Icon(
              Icons.arrow_back_ios, // add custom icons also
              size: 24.0.sp,
            ),
          ),
          title: getTitle(parameters.confirmDetails),
        ),
        body: widget.isFromPaymentNotification
            ? getAppointmentDetailsUsingId()
            : getBodyMain(),
      ),
    );
  }

  Widget getCSRCheckBox(String? discount, String originalFees) {
    Widget widget;
    if (discount != null &&
        discount != '' &&
        originalFees != null &&
        originalFees != '') {
      if (discount != '0.00' && discount != '0') {
        try {
          discount = CommonUtil()
              .doubleWithoutDecimalToInt(double.parse(discount))
              .toString();
        } catch (e, stackTrace) {
          widget = const SizedBox.shrink();
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        }
        widget = Center(
          child: CheckboxListTile(
            title: Text('Qurhealth Discount (${discount!}%)',
            style: TextStyle(
                fontSize: 12
            ),),
            value: checkedValue,
            activeColor: Colors.green,
            onChanged: (newValue) {
              setState(() {
                checkedValue = newValue;
                originalPrice = originalFees;
                if (checkedValue!) {
                  if(isApplyMemberShipBenefits){
                    isApplyMemberShipBenefits =false;
                    INR_Price =originalPrice;
                  }
                  if (originalFees.contains(',')) {
                    originalFees = originalFees.replaceAll(',', '');
                  }
                  INR_Price = getDiscountedFee(
                      double.parse(discount!), double.parse(originalFees));
                  if (INR_Price == '0' || INR_Price == '0.00') {
                    btnLabelChange = bookNow;
                  } else {
                    btnLabelChange = payNow;
                  }
                } else {
                  INR_Price = originalFees;
                  btnLabelChange = payNow;
                }
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
        );
      } else {
        widget = const SizedBox.shrink();
      }
    } else {
      widget = const SizedBox.shrink();
    }
    return widget;
  }

  profileValidationCheck(BuildContext context, String userId) async {
    await addFamilyUserInfoRepository.getMyProfileInfoNew(userId).then((value) {
      myProfile = value;
    });

    if (myProfile != null) {
      addressValidation(context);
    } else {
      toast.getToast(noGender, Colors.red);
    }
  }

  String? getFollowUpFee() {
    if (widget.followUpFee != null && widget.followUpFee != '') {
      return widget.followUpFee;
    } else {
      return '';
    }
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 8),
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
                          padding: const EdgeInsets.all(8),
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
                                        padding: const EdgeInsets.all(8),
                                      ),
                                      onPressed: () {
                                        if (widget.isFromPaymentNotification) {
                                          Get.offNamed(
                                              router.rt_notification_main);
                                        } else {
                                          Navigator.pop(context);
                                        }
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
                                        padding: const EdgeInsets.all(8),
                                      ),
                                      onPressed: () {
                                        if (widget.isFromPaymentNotification) {
                                          if (shortURL != null) {
                                            PreferenceUtil.saveString(
                                                Constants.KEY_USERID_BOOK, '');

                                            goToPaymentPage(shortURL, paymentID,
                                                true, widget.appointmentId);
                                          } else {
                                            pr.hide();
                                            toast.getToast(
                                                someWentWrong, Colors.red);
                                          }
                                        } else {
                                          addHealthRecords();
                                          Navigator.pop(context);
                                          bookAppointment(
                                            createdBy,
                                            selectedId,
                                            doctorSessionId,
                                            scheduleDate,
                                            slotNumber,
                                            (healthRecords != null &&
                                                    healthRecords.length > 0)
                                                ? true
                                                : false,
                                            (widget.isFromFollowUpApp! &&
                                                widget.isFromFollowUpTake ==
                                                    false &&
                                                isFollowUp()),
                                            (healthRecords != null &&
                                                    healthRecords.length > 0)
                                                ? healthRecords
                                                : [],
                                            doc: widget.isFollowUp!
                                                ? widget.doctorsData
                                                : null,
                                            isResidentDoctorMembership:
                                                isMembershipDiscount,
                                            walletDeductionAmount: applyMembershipDiscountedAmount
                                          );
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

  bool isFollowUp() {
    if (widget.doctorsData?.plannedFollowupDate != null &&
        widget.followUpFee != null &&
        widget.isFollowUp == true) {
      if (widget.doctorsData!.isFollowUpTaken == true) {
        if (widget.selectedDate!
                .difference(
                    DateTime.parse(widget.doctorsData!.plannedFollowupDate!))
                .inDays <=
            0) {
          return true;
        } else {
          return false;
        }
      } else if (widget.doctorsData?.plannedFollowupDate == null) {
        return false;
      } else {
        if (widget.selectedDate!
                .difference(
                    DateTime.parse(widget.doctorsData!.plannedFollowupDate!))
                .inDays <=
            0) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }

  Future<CreateAppointmentModel> bookAppointmentCall(
    String? createdBy,
    String? bookedFor,
    String? doctorSessionId,
    String? scheduleDate,
    String? slotNumber,
    bool isMedicalShared,
    bool isFollowUp,
    List<String> healthRecords,
    bool? isCSRDiscount, {
    Past? doc,
    bool isResidentDoctorMembership = false,
    String? walletDeductionAmount,
  }) async {
    CreateAppointmentModel? bookAppointmentModel =
        await createAppointMentViewModel.putBookAppointment(
            createdBy,
            bookedFor,
            doctorSessionId,
            scheduleDate,
            slotNumber,
            isMedicalShared,
            isFollowUp,
            healthRecords,
            isCSRDiscount,
            doc: doc,
            isResidentDoctorMembership: isResidentDoctorMembership,
            walletDeductionAmount: walletDeductionAmount);

    return bookAppointmentModel!;
  }

  bookAppointment(
    String? createdBy,
    String? bookedFor,
    String? doctorSessionId,
    String? scheduleDate,
    String? slotNumber,
    bool isMedicalShared,
    bool isFollowUp,
    List<String> healthRecords, {
    Past? doc,
    bool isResidentDoctorMembership = false,
        String? walletDeductionAmount,
  }) {
    setState(() {
      pr.show();
    });

    try {
      if (CommonUtil.recordIds!.length > 0) {
        associateRecords(doctorId, selectedId, CommonUtil.recordIds)
            .then((value) {
          if (value != null && value.isSuccess!) {
            bookAppointmentOnly(
              createdBy,
              bookedFor,
              doctorSessionId,
              scheduleDate,
              slotNumber,
              isMedicalShared,
              isFollowUp,
              healthRecords,
              checkedValue,
              doc: doc,
              isResidentDoctorMembership: isResidentDoctorMembership,
              walletDeductionAmount: applyMembershipDiscountedAmount
            );
          } else {
            pr.hide();
            toast.getToast(errAssociateRecords, Colors.red);
          }
        });
      } else {
        bookAppointmentOnly(
          createdBy,
          bookedFor,
          doctorSessionId,
          scheduleDate,
          slotNumber,
          isMedicalShared,
          isFollowUp,
          healthRecords,
          checkedValue,
          doc: doc,
          isResidentDoctorMembership: isResidentDoctorMembership,
          walletDeductionAmount: applyMembershipDiscountedAmount
        );
      }
    } catch (e, stackTrace) {
      pr.hide();
      toast.getToast(someWentWrong, Colors.red);
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  bookAppointmentOnly(
    String? createdBy,
    String? bookedFor,
    String? doctorSessionId,
    String? scheduleDate,
    String? slotNumber,
    bool isMedicalShared,
    bool isFollowUp,
    List<String> healthRecords,
    bool? isCSRDiscount, {
    Past? doc,
    bool isResidentDoctorMembership = false,
        String? walletDeductionAmount,
  }) {
    bookAppointmentCall(
      createdBy,
      bookedFor,
      doctorSessionId,
      scheduleDate,
      slotNumber,
      isMedicalShared,
      isFollowUp,
      healthRecords,
      isCSRDiscount,
      doc: doc,
      isResidentDoctorMembership: isResidentDoctorMembership,
      walletDeductionAmount: walletDeductionAmount
    ).then((value) {
      if (value != null) {
        if (value.isSuccess != null &&
            value.message != null &&
            value.result != null) {
          if (value.isSuccess == true &&
              value.message == appointmentCreatedMessage) {
            if (value.result?.paymentInfo != null &&
                value.result!.paymentInfo?.payload?.paymentGatewayDetail !=
                    null) {
              if (value.result?.paymentInfo?.payload?.paymentGatewayDetail
                      ?.responseInfo?.paymentGateWay ==
                  STR_RAZOPAY) {
                if (value.result?.paymentInfo?.payload?.paymentGatewayDetail
                        ?.responseInfo?.shorturl !=
                    null) {
                  PreferenceUtil.saveString(Constants.KEY_USERID_BOOK, '');

                  goToPaymentPage(
                      value.result?.paymentInfo?.payload?.paymentGatewayDetail
                          ?.responseInfo?.shorturl,
                      value.result?.paymentInfo?.payload?.payment?.id,
                      true,
                      value.result?.appointmentInfo?.id);
                } else {
                  pr.hide();
                  toast.getToast(
                      value.message != null ? value.message! : someWentWrong,
                      Colors.red);
                }
              } else {
                if (value.result?.paymentInfo?.payload?.paymentGatewayDetail
                        ?.responseInfo?.longurl !=
                    null) {
                  PreferenceUtil.saveString(Constants.KEY_USERID_BOOK, '');

                  goToPaymentPage(
                      value.result?.paymentInfo?.payload?.paymentGatewayDetail
                          ?.responseInfo?.longurl,
                      value.result?.paymentInfo?.payload?.payment?.id,
                      false,
                      value.result?.appointmentInfo?.id);
                } else {
                  pr.hide();
                  toast.getToast(noUrl, Colors.red);
                }
              }
            } else {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TelehealthProviders(
                            arguments: HomeScreenArguments(selectedIndex: 0),
                          )));
            }
          } else {
            pr.hide();
            toast.getToast(
                value.message != null ? value.message! : someWentWrong,
                Colors.red);
          }
        } else {
          pr.hide();
          // Checking if the value.message is not null and not empty, otherwise  "Something went wrong" will show.
          toast.getToast(value.message?.isNotEmpty ?? false ? value.message! : noUrl, Colors.red);
        }
        PreferenceUtil.saveString(Constants.KEY_USERID_BOOK, '');
      }
    });
  }

  goToPaymentPage(
      String? longurl, String? paymentId, bool isRazor, String? appointmentId) {
    CommonUtil.recordIds!.clear();
    CommonUtil.notesId!.clear();
    CommonUtil.voiceIds!.clear();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentPage(
                  redirectUrl: longurl,
                  paymentId: paymentId,
                  appointmentId: appointmentId,
                  isFromSubscribe: false,
                  isFromRazor: isRazor,
                  isPaymentFromNotification: widget.isFromPaymentNotification,
                  closePage: (value) {
                    if (value == 'success') {
                      if (widget.isFromPaymentNotification == false) {
                        widget.closePage!(value);
                        Navigator.pop(context);
                      } else {
                        Get.offAllNamed(
                          router.rt_Landing,
                          arguments: const LandingArguments(
                            needFreshLoad: false,
                          ),
                        );
                      }
                    } else {
                      if (widget.isFromPaymentNotification == false) {
                        widget.refresh!();
                        Navigator.pop(context);
                      } else {
                        Get.offNamed(router.rt_notification_main);
                      }
                    }
                  },
                )));
  }

  Widget getTitle(String title) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.0.sp,
            ),
          ),
        ),
        CommonUtil().getNotificationIcon(context),
        //SwitchProfile().buildActions(context, _key, callBackToRefresh),
      ],
    );
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
  }

  Widget getDoctorsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: commonWidgets.getClipOvalImageBookConfirm(
                  widget.isFromPaymentNotification
                      ? profilePicThumbnailUrl
                      : widget.isFromHospital!
                          ? widget
                              .resultFromHospitalList![widget.doctorListIndex!]
                              .doctor!
                              .user!
                              .profilePicThumbnailUrl
                          : widget.isFromFollowReschedule!
                              ? widget.docsReschedule![widget.doctorListPos!]!
                                  .user!.profilePicThumbnailUrl
                              : widget.docs![widget.doctorListPos!]!.user!
                                  .profilePicThumbnailUrl),
            ),
            /* Container(
              alignment: Alignment.center,
              child: widget.isFromHospital?commonWidgets.getClipOvalImageForHos(widget.resultFromHospitalList[widget.doctorListIndex]
                  .doctor):commonWidgets.getClipOvalImageNew(widget.docs[widget.doctorListPos]),
            ),*/
            Positioned(
              bottom: 0,
              right: 2,
              child: widget.isFromPaymentNotification
                  ? commonWidgets.getDoctorStatusWidgetNewForHos(null, 0,
                      status: '${status}')
                  : widget.isFromHospital!
                      ? commonWidgets.getDoctorStatusWidgetNewForHos(
                          widget
                              .resultFromHospitalList![widget.doctorListIndex!]
                              .doctor,
                          widget.i)
                      : widget.isFromFollowReschedule!
                          ? commonWidgets.getDoctorStatusWidgetForReschedule(
                              widget.docsReschedule![widget.doctorListPos!]!,
                              widget.i)
                          : commonWidgets.getDoctorStatusWidgetNew(
                              widget.docs![widget.doctorListPos!]!, widget.i),
            )
          ],
        ),
        commonWidgets.getSizeBoxWidth(10),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Container(
                          constraints: BoxConstraints(maxWidth: 160.w),
                          child: widget.isFromPaymentNotification
                              ? commonWidgets
                                  .getWidgetWithDoctorName(doctorName!)
                              : widget.isFromHospital!
                                  ? commonWidgets.setDoctornameForHos(widget
                                      .resultFromHospitalList![
                                          widget.doctorListIndex!]
                                      .doctor!
                                      .user)
                                  : commonWidgets.setDoctorname(
                                      widget.isFromFollowReschedule!
                                          ? widget
                                              .docsReschedule![
                                                  widget.doctorListPos!]!
                                              .user
                                          : widget.docs![widget.doctorListPos!]!
                                              .user)),

                      //commonWidgets.getSizeBoxWidth(10.0),
                      commonWidgets.getIcon(
                          width: fhbStyles.imageWidth,
                          height: fhbStyles.imageHeight,
                          icon: Icons.info,
                          onTap: () {
                            widget.isFromHospital!
                                ? commonWidgets.showDoctorDetailViewNewForHos(
                                    widget
                                        .resultFromHospitalList![
                                            widget.doctorListIndex!]
                                        .doctor,
                                    context)
                                : widget.isFromFollowReschedule!
                                    ? commonWidgets
                                        .showDoctorDetailViewForReschedule(
                                            widget.docsReschedule![
                                                widget.doctorListPos!],
                                            context)
                                    : commonWidgets.showDoctorDetailViewNew(
                                        widget.docs![widget.doctorListPos!],
                                        context);
                          }),
                    ],
                  )),
                  widget.isFromPaymentNotification
                      ? commonWidgets.getIcon(
                          width: fhbStyles.imageWidth,
                          height: fhbStyles.imageHeight,
                          icon: Icons.check_circle,
                          onTap: () {})
                      : widget.isFromHospital!
                          ? widget
                                  .resultFromHospitalList![
                                      widget.doctorListIndex!]
                                  .doctor!
                                  .isActive!
                              ? commonWidgets.getIcon(
                                  width: fhbStyles.imageWidth,
                                  height: fhbStyles.imageHeight,
                                  icon: Icons.check_circle,
                                  onTap: () {})
                              : widget.isFromFollowReschedule!
                                  ? widget
                                          .docsReschedule![
                                              widget.doctorListIndex!]!
                                          .isActive!
                                      ? commonWidgets.getIcon(
                                          width: fhbStyles.imageWidth,
                                          height: fhbStyles.imageHeight,
                                          icon: Icons.check_circle,
                                          onTap: () {})
                                      : widget.docs![widget.doctorListPos!]!
                                              .isActive!
                                          ? commonWidgets.getIcon(
                                              width: fhbStyles.imageWidth,
                                              height: fhbStyles.imageHeight,
                                              icon: Icons.check_circle,
                                              onTap: () {})
                                          : const SizedBox()
                                  : const SizedBox()
                          : const SizedBox(),
                ],
              ),
              commonWidgets.getSizedBox(5),
              Row(children: [
                Expanded(
                    child: widget.isFromPaymentNotification
                        ? commonWidgets.getDoctorSpecialityText(speciality!)
                        : widget.isFromHospital!
                            ? commonWidgets.getDoctoSpecialistOnlyForHos(widget
                                .resultFromHospitalList![
                                    widget.doctorListIndex!]
                                .doctor!)
                            : widget.isFromFollowReschedule!
                                ? commonWidgets.getDoctoSpecialistForReschedule(
                                    widget.docsReschedule![
                                        widget.doctorListPos!]!)
                                : commonWidgets.getDoctoSpecialistOnly(
                                    widget.docs![widget.doctorListPos!]!)),
              ]),
              commonWidgets.getSizedBox(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                    widget.isFromPaymentNotification
                        ? ''
                        : widget.isFromHospital!
                            ? '' +
                                commonWidgets.getCityDoctorsModelForHos(widget
                                    .resultFromHospitalList![
                                        widget.doctorListIndex!]
                                    .doctor!)!
                            : widget.isFromFollowReschedule!
                                ? '' +
                                    commonWidgets
                                        .getCityDoctorsModelForReschedule(
                                            widget.docsReschedule![
                                                widget.doctorListPos!]!)!
                                : commonWidgets.getCityDoctorsModel(
                                    widget.docs![widget.doctorListPos!]!)!,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.grey[600],
                        fontSize: fhbStyles.fnt_city),
                  )),
                  widget.isFromPaymentNotification
                      ? commonWidgets.getMCVerified(
                          doctorFromNotification?.isMciVerified ?? false,
                          'Verified')
                      : widget.isFromHospital!
                          ? widget
                                  .resultFromHospitalList![
                                      widget.doctorListIndex!]
                                  .doctor!
                                  .isMciVerified!
                              ? commonWidgets.getMCVerified(
                                  widget.isFromHospital!
                                      ? widget
                                          .resultFromHospitalList![
                                              widget.doctorListIndex!]
                                          .doctor!
                                          .isMciVerified!
                                      : widget
                                          .resultFromHospitalList![
                                              widget.doctorListIndex!]
                                          .doctor!
                                          .isMciVerified!,
                                  'Verified')
                              : commonWidgets.getMCVerified(
                                  widget.isFromHospital!
                                      ? widget
                                          .resultFromHospitalList![
                                              widget.doctorListIndex!]
                                          .doctor!
                                          .isMciVerified!
                                      : widget
                                          .resultFromHospitalList![
                                              widget.doctorListIndex!]
                                          .doctor!
                                          .isMciVerified!,
                                  'Not Verified')
                          : widget.isFromFollowReschedule!
                              ? widget.docsReschedule![widget.doctorListPos!]!
                                      .isMciVerified!
                                  ? commonWidgets.getMCVerified(
                                      widget.isFromHospital!
                                          ? widget
                                              .resultFromHospitalList![
                                                  widget.doctorListPos!]
                                              .doctor!
                                              .isMciVerified!
                                          : widget
                                              .docsReschedule![
                                                  widget.doctorListPos!]!
                                              .isMciVerified!,
                                      'Verified')
                                  : commonWidgets.getMCVerified(
                                      widget.isFromHospital!
                                          ? widget
                                              .resultFromHospitalList![
                                                  widget.doctorListPos!]
                                              .doctor!
                                              .isMciVerified!
                                          : widget
                                              .docsReschedule![
                                                  widget.doctorListPos!]!
                                              .isMciVerified!,
                                      'Not Verified')
                              : widget.docs![widget.doctorListPos!]!
                                      .isMciVerified!
                                  ? commonWidgets.getMCVerified(
                                      widget.isFromHospital!
                                          ? widget
                                              .resultFromHospitalList![
                                                  widget.doctorListPos!]
                                              .doctor!
                                              .isMciVerified!
                                          : widget.docs![widget.doctorListPos!]!
                                              .isMciVerified!,
                                      'Verified')
                                  : commonWidgets.getMCVerified(
                                      widget.isFromHospital!
                                          ? widget
                                              .resultFromHospitalList![
                                                  widget.doctorListPos!]
                                              .doctor!
                                              .isMciVerified!
                                          : widget.docs![widget.doctorListPos!]!
                                              .isMciVerified!,
                                      'Not Verified'),
                  commonWidgets.getSizeBoxWidth(10),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  List<CategoryResult>? getCategoryList() {
    if (filteredCategoryData == null || filteredCategoryData.length == 0) {
      _categoryListBlock!.getCategoryLists().then((value) {
        categoryDataList = value!.result;

        filteredCategoryData = CommonUtil().fliterCategories(categoryDataList!);

        //filteredCategoryData.add(categoryDataObjClone);
        return filteredCategoryData;
      });
    } else {
      return filteredCategoryData;
    }
  }

  getCategoryPosition(String categoryName) {
    int categoryPosition;
    switch (categoryName) {
      case AppConstants.notes:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;

      case AppConstants.prescription:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;

      case AppConstants.voiceRecords:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;
      default:
        categoryPosition = 0;
        return categoryPosition;

        break;
    }
  }

  int pickPosition(String categoryName) {
    int position = 0;
    List<CategoryResult>? categoryDataList = getCategoryList();
    for (int i = 0; i < categoryDataList!.length; i++) {
      if (categoryName == categoryDataList[i].categoryName) {
        saveCategoryToprefernce(categoryDataList[i]);
        position = i;
      }
    }
    if (categoryName == AppConstants.prescription) {
      return position;
    } else {
      return position;
    }
  }

  void FetchRecords(int position, bool allowSelect, bool isAudioSelect,
      bool isNotesSelect, List<String>? mediaIds) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => MyRecords(
        argument: MyRecordsArgument(
            categoryPosition: position,
            allowSelect: allowSelect,
            isAudioSelect: isAudioSelect,
            isNotesSelect: isNotesSelect,
            selectedMedias: mediaIds,
            isFromChat: false,
            showDetails: false,
            isAssociateOrChat: true,
            userID: selectedId,
            fromClass: 'appointments'),
      ),
    ))
        .then((results) {
      if (results?.containsKey(STR_META_ID)) {
        var metaIds = results[STR_META_ID];
        print(metaIds.toString());

        if (allowSelect) {
          CommonUtil.recordIds = results['metaId'].cast<String>();
          recordIdCount = CommonUtil.recordIds!.length;
        } else if (isAudioSelect) {
          CommonUtil.voiceIds = results['metaId'].cast<String>();

          voiceIdCount = CommonUtil.voiceIds!.length;
        } else if (isNotesSelect) {
          CommonUtil.notesId = results['metaId'].cast<String>();

          notesIdCount = CommonUtil.notesId!.length;
        }
        print(recordIdCount);
        setState(() {});
        print(metaIds.toString());
      }
    });
  }

  setLengthValue() {
    recordIdCount = CommonUtil.recordIds!.length;
    voiceIdCount = CommonUtil.voiceIds!.length;
    notesIdCount = CommonUtil.notesId!.length;
  }

  Future<AssociateSuccessResponse> associateRecords(
      String? doctorId, String? userId, List<String>? healthRecords) async {
    AssociateSuccessResponse? associateResponseList = await providerViewModel
        .associateRecords(doctorId, userId, healthRecords);

    return associateResponseList!;
  }

  Container getMembershipDiscountCheckBox() {
    return (MembershipDiscountPercent ?? '').isNotEmpty
        ? Container(
            child: Center(
              child: CheckboxListTile(
                title: Text(
                  'Membership Discount (' + MembershipDiscountPercent! + '%)',
                  style: const TextStyle(color: Colors.grey,
                  fontSize: 12),
                ),
                value: true,
                activeColor: Colors.grey,
                onChanged: null,
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
            ),
          )
        : Container();
  }

  applyMemberShipBenefitsWidget()=> CheckboxListTile(
      title: Text(
        '${parameters.applyMemberShipBenefit}${(widget.doctorAppoinmentTransLimit!=null && widget.doctorAppoinmentTransLimit! >0)?' (${parameters.max} ${widget.doctorAppoinmentTransLimit})':''}',
        style: TextStyle(
            color: Colors.black,
          fontSize: 12
        ),
      ),
      value: isApplyMemberShipBenefits,
      activeColor:mAppThemeProvider.primaryColor,
      onChanged:(value){
        setState(() {
          isApplyMemberShipBenefits = value!;
          if(value==true){
            if(checkedValue==true){
              checkedValue =false;
              INR_Price = originalPrice;
            }
            applyMembershipDiscountedAmount =  updateTheMembershipBenefit();
          }else{
           INR_Price= originalPrice;
           applyMembershipDiscountedAmount ='';
          }
          if (INR_Price == '0' || INR_Price == '0.00') {
            btnLabelChange = bookNow;
          } else {
            btnLabelChange = payNow;
          }
        });
      },
      controlAffinity:
      ListTileControlAffinity.leading, //  <-- leading Checkbox
    );


  updateTheMembershipBenefit() {
    INR_Price = CommonUtil().replaceSeparator(value: INR_Price!, separator: ',');
    double currentAmount = double.parse(INR_Price!);
    num deductedAmount = 0.0;

    if (widget.noOfDoctorAppointments != null && widget.noOfDoctorAppointments! > 0) {
      if (widget.doctorAppoinmentTransLimit != null && widget.doctorAppoinmentTransLimit! > 0) {
        double remainingAmount = currentAmount - widget.doctorAppoinmentTransLimit!;
        // Deducted amount is either the remaining amount (if positive) or the current amount (if negative)
        deductedAmount = remainingAmount <= 0 ? currentAmount : widget.doctorAppoinmentTransLimit!;
        // Update INR_Price based on the remaining amount
        INR_Price = commonWidgets.getMoneyWithForamt((remainingAmount <= 0 ? 0 : remainingAmount).toStringAsFixed(2));
      } else {
        // Deduct from noOfDoctorAppointments if transaction limit is not present or zero
        double remainingAmount = currentAmount - widget.noOfDoctorAppointments!;
        // Deducted amount is either the remaining amount (if positive) or the current amount (if negative)
        deductedAmount = remainingAmount <= 0 ? currentAmount : widget.noOfDoctorAppointments!;
        // Update INR_Price based on the remaining amount
        INR_Price = commonWidgets.getMoneyWithForamt((remainingAmount <= 0 ? 0 : remainingAmount).toStringAsFixed(2));
      }
    } else {
      // If noOfDoctorAppointments is not present or zero, do not deduct anything
      deductedAmount = currentAmount;
      INR_Price = commonWidgets.getMoneyWithForamt(currentAmount.toStringAsFixed(2));
    }
    return deductedAmount.toStringAsFixed(2);
  }





  showDialogForMembershipDiscount() async {
    isActiveMember = await PreferenceUtil.getActiveMembershipStatus();
    setState(() {});
    if (!isResident!) return;
    String? originalFees;
    String? discountPercent;
    String? discount;
    if (!(isActiveMember ?? false)) return;
    if (widget.isFromHospital!) {
      ResultFromHospital result =
          widget.resultFromHospitalList![widget.doctorListIndex!];
      if (result.doctorFeeCollection != null) {
        if (result.doctorFeeCollection!.length > 0) {
          for (int i = 0; i < result.doctorFeeCollection!.length; i++) {
            String? feesCode = result.doctorFeeCollection![i].feeType!.code;
            bool? isActive = result.doctorFeeCollection![i].isActive;
            if (feesCode == qr_MEMBERSHIP_DISCOUNT && isActive!) {
              discountPercent = result.doctorFeeCollection![i].fee;
            } else if (feesCode == CONSULTING && isActive!) {
              originalFees = result.doctorFeeCollection![i].fee;
            }
          }
        }
      }
    } else {
      HealthOrganizationResult result =
          widget.healthOrganizationResult![widget.i!];
      if (result.doctorFeeCollection != null) {
        if (result.doctorFeeCollection!.length > 0) {
          for (int i = 0; i < result.doctorFeeCollection!.length; i++) {
            String? feesCode = result.doctorFeeCollection![i].feeType!.code;
            bool? isActive = result.doctorFeeCollection![i].isActive;
            if (feesCode == qr_MEMBERSHIP_DISCOUNT && isActive!) {
              discountPercent = result.doctorFeeCollection![i].fee;
            } else if (feesCode == CONSULTING && isActive!) {
              originalFees = result.doctorFeeCollection![i].fee;
            }
          }
        }
      }
    }
    if (widget.isFromFollowUpApp! &&
        widget.isFromFollowUpTake == false &&
        isFollowUp()) {
      originalFees = getFollowUpFee();
    }
    if ((discountPercent ?? '').isNotEmpty && (originalFees ?? '').isNotEmpty) {
      if (discountPercent != '0.00' && discountPercent != '0') {
        try {
          discountPercent = CommonUtil()
              .doubleWithoutDecimalToInt(
                double.parse(discountPercent!),
              )
              .toString();
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);

          return;
        }
        if (originalFees!.contains(',')) {
          originalFees = originalFees.replaceAll(',', '');
        }
        discount = getDiscountedFee(
          double.parse(discountPercent),
          double.parse(originalFees),
          twoDecimal: true,
        );
      }

      if ((discount ?? '').isNotEmpty) {
        MembershipDiscountPercent = discountPercent;
        await Future.delayed(const Duration(seconds: 1));
        final val = await Get.dialog(
          AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Text(
                    'Congratulations! Your appointment fee is revised to $discount INR as part of your membership benefit',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () => Get.back(
                    result: true,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(mAppThemeProvider.primaryColor),// Set background color here
                    // You can also customize other properties such as padding, shape, etc.
                  ),
                  child: const Text(
                    Constants.okButton,
                  ),
                )
              ],
            ),
          ),
          barrierDismissible: false,
        );
        setState(
          () {
            isMembershipDiscount = isActiveMember ?? false;
            INR_Price = discount;
            originalPrice = INR_Price;
            if (INR_Price == '0' || INR_Price == '0.00') {
              btnLabelChange = bookNow;
            } else {
              btnLabelChange = payNow;
            }
          },
        );
      }
    }
  }

  String? getFees(HealthOrganizationResult result, bool isCSRDiscount) {
    String? fees;
    if (result.doctorFeeCollection != null) {
      if (result.doctorFeeCollection!.length > 0) {
        for (int i = 0; i < result.doctorFeeCollection!.length; i++) {
          String? feesCode = result.doctorFeeCollection![i].feeType!.code;
          bool? isActive = result.doctorFeeCollection![i].isActive;
          if (isCSRDiscount) {
            if (feesCode == CSR_DISCOUNT && isActive == true) {
              fees = result.doctorFeeCollection![i].fee;
            }
          } else {
            if (feesCode == CONSULTING && isActive == true) {
              fees = result.doctorFeeCollection![i].fee;
            }
          }
        }
      } else {
        fees = '';
      }
    } else {
      fees = '';
    }
    return fees;
  }

  String? getFeesFromHospital(ResultFromHospital result, bool isCSRDiscount) {
    String? fees;
    if (result.doctorFeeCollection != null) {
      if (result.doctorFeeCollection!.length > 0) {
        for (int i = 0; i < result.doctorFeeCollection!.length; i++) {
          String? feesCode = result.doctorFeeCollection![i].feeType!.code;
          bool? isActive = result.doctorFeeCollection![i].isActive;
          if (isCSRDiscount) {
            if (feesCode == CSR_DISCOUNT && isActive == true) {
              fees = result.doctorFeeCollection![i].fee;
            }
          } else {
            if (feesCode == CONSULTING && isActive == true) {
              fees = result.doctorFeeCollection![i].fee;
            }
          }
        }
      } else {
        fees = '';
      }
    } else {
      fees = '';
    }
    return fees;
  }

  void saveCategoryToprefernce(CategoryResult category) async {
    await PreferenceUtil.saveString(
        Constants.KEY_CATEGORYNAME, category.categoryName!);
    await PreferenceUtil.saveString(Constants.KEY_CATEGORYID, category.id!);
    await PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, selectedId!);
  }

  addressValidation(BuildContext context) {
    if (myProfile != null) {
      if (myProfile!.isSuccess!) {
        if (myProfile!.result != null) {
          if (myProfile!.result!.gender != null &&
              myProfile!.result!.gender!.isNotEmpty) {
            if (myProfile!.result!.dateOfBirth != null &&
                myProfile!.result!.dateOfBirth!.isNotEmpty) {
              if (myProfile!.result!.additionalInfo != null) {
                if ((myProfile!.result!.additionalInfo!.height != null &&
                        myProfile!
                            .result!.additionalInfo!.height!.isNotEmpty) ||
                    myProfile!.result!.additionalInfo!.heightObj != null) {
                  if (myProfile!.result!.additionalInfo!.weight != null &&
                      myProfile!.result!.additionalInfo!.weight!.isNotEmpty) {
                    if (myProfile!.result!.userAddressCollection3 != null) {
                      if (myProfile!.result!.userAddressCollection3!.length >
                          0) {
                        if (myProfile!.result!.userAddressCollection3![0]
                                    .addressLine1 !=
                                null &&
                            myProfile!.result!.userAddressCollection3![0]
                                .addressLine1!.isNotEmpty &&
                            myProfile!.result!.userAddressCollection3![0]
                                    .pincode !=
                                null &&
                            myProfile!.result!.userAddressCollection3![0]
                                .pincode!.isNotEmpty) {
                          if (myProfile!.result!.userAddressCollection3![0]
                                      .addressLine1 !=
                                  null &&
                              myProfile!.result!.userAddressCollection3![0]
                                  .addressLine1!.isNotEmpty) {
                            if (myProfile!.result!.userAddressCollection3![0]
                                        .pincode !=
                                    null &&
                                myProfile!.result!.userAddressCollection3![0]
                                    .pincode!.isNotEmpty) {
                              patientAddressCheck(
                                  myProfile!.result!.userAddressCollection3![0],
                                  context);
                            } else {
                              showInSnackBar(noZipcode, 'Add');
                            }
                          } else {
                            showInSnackBar(noAddress1, 'Add');
                          }
                        } else {
                          showInSnackBar(no_addr1_zip, 'Add');
                        }
                      } else {
                        //toast.getToast(noAddress, Colors.red);
                        showInSnackBar(noAddressFamily, 'Add');
                        //CommonUtil().mSnackbar(context, noAddress, 'Add');
                      }
                    } else {
                      //toast.getToast(noAddress, Colors.red);
                      showInSnackBar(noAddressFamily, 'Add');
                      //CommonUtil().mSnackbar(context, noAddress, 'Add');
                    }
                  } else {
                    //toast.getToast(noWeight, Colors.red);
                    showInSnackBar(noWeightFamily, 'Add');
                    //CommonUtil().mSnackbar(context, noWeight, 'Add');
                  }
                } else {
                  //toast.getToast(noHeight, Colors.red);
                  showInSnackBar(noHeightFamily, 'Add');
                  //CommonUtil().mSnackbar(context, noHeight, 'Add');
                }
              } else {
                //toast.getToast(noAdditionalInfo, Colors.red);
                showInSnackBar(noAdditionalInfoFamily, 'Add');
                //CommonUtil().mSnackbar(context, noAdditionalInfo, 'Add');
              }
            } else {
              //toast.getToast(noDOB, Colors.red);
              showInSnackBar(noDOBFamily, 'Add');
              //CommonUtil().mSnackbar(context, noDOB, 'Add');
            }
          } else {
            showInSnackBar(noGenderFamily, 'Add');
            //toast.getToast(noGender, Colors.red);
          }
        } else {
          //toast.getToast(noAddress, Colors.red);
          showInSnackBar(noAddressFamily, 'Add');
          //CommonUtil().mSnackbar(context, noAddress, 'Add');
        }
      } else {
        //toast.getToast(noAddress, Colors.red);
        showInSnackBar(noAddressFamily, 'Add');
        //CommonUtil().mSnackbar(context, noAddress, 'Add');
      }
    } else {
      //toast.getToast(noAddress, Colors.red);
      showInSnackBar(noAddressFamily, 'Add');
      //CommonUtil().mSnackbar(context, noAddress, 'Add');
    }
  }

  patientAddressCheck(
      UserAddressCollection3 userAddressCollection, BuildContext context) {
    String? address1 = userAddressCollection.addressLine1 != null
        ? userAddressCollection.addressLine1
        : '';
    String? city = userAddressCollection.city!.name != null
        ? userAddressCollection.city!.name
        : '';
    String? state = userAddressCollection.state!.name != null
        ? userAddressCollection.state!.name
        : '';

    if (address1 != '' && city != '' && state != '') {
      //normal appointment
      if (btnLabelChange == bookNow) {
        bookAppointment(
          createdBy,
          selectedId,
          doctorSessionId,
          scheduleDate,
          slotNumber,
          (healthRecords != null && healthRecords.length > 0) ? true : false,
          isFollowUp(),
          (healthRecords != null && healthRecords.length > 0)
              ? healthRecords
              : [],
          doc: widget.isFollowUp! ? widget.doctorsData : null,
          isResidentDoctorMembership: isMembershipDiscount,
            walletDeductionAmount: applyMembershipDiscountedAmount
        );
      } else {
        _displayDialog(context);
      }
    } else {
      toast.getToast(noAddress, Colors.red);
    }
  }

  void showInSnackBar(String message, String actionName) {
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: mAppThemeProvider.primaryColor,
        elevation: 5,
        action: SnackBarAction(
            label: actionName,
            onPressed: () async {
              if (myProfile?.result != null) {
                Navigator.pushNamed(context, router.rt_AddFamilyUserInfo,
                    arguments: AddFamilyUserInfoArguments(
                        isFromAppointmentOrSlotPage: true,
                        isForFamilyAddition: false,
                        isForFamily: false,
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

  String getDiscountedFee(
    double percent,
    double price, {
    bool twoDecimal = false,
  }) {
    var discountedPrice;
    String? priceLast;
    if (percent != null && price != null && percent != '' && price != '') {
      discountedPrice = (percent / 100) * price;
      price = price - discountedPrice;
      try {
        priceLast = twoDecimal
            ? price.toStringAsFixed(2)
            : CommonUtil()
                .doubleWithoutDecimalToInt(double.parse(price.toString()))
                .toStringAsFixed(2)
                .toString();
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);

        return price.toString();
      }
    }
    return priceLast.toString();
  }

  getBodyMain() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.grey[100],
            child: Card(
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 10,
              child: Container(
                margin: const EdgeInsets.all(8),
                child: getDoctorsWidget(),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                nameDateCard(),
                Divider(
                  color: Colors.grey[400],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(parameters.preConsultingDetails,
                              style: TextStyle(
                                  fontSize: 12.0.sp, color: Colors.grey)),
                        ],
                      ),
                      SizedBoxWidget(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBoxWidget(
                            width: 10,
                          ),
                          Column(
                            children: <Widget>[
                              Stack(
                                clipBehavior: Clip.none,
                                children: <Widget>[
                                  SizedBoxWithChild(
                                    height: 22,
                                    width: 22,
                                    child: IconButtonWidget(
                                      iconPath: Constants.NOTES_ICON_LINK,
                                      size: 18,
                                      color: mAppThemeProvider.primaryColor,
                                      padding: const EdgeInsets.all(1),
                                      onPressed: () {
                                        if (widget.isFromPaymentNotification ==
                                            false)
                                          FetchRecords(
                                              getCategoryPosition(
                                                  AppConstants.notes),
                                              false,
                                              false,
                                              true,
                                              CommonUtil.notesId);
                                      },
                                    ),
                                  ),
                                  notesIdCount > 0
                                      ? const Positioned(
                                          top: -5,
                                          right: -5,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 15,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                              SizedBoxWidget(height: 2),
                              TextWidget(
                                  text: parameters.addNotes,
                                  fontsize: 10.0.sp,
                                  colors: Colors.grey),
                            ],
                          ),
                          SizedBoxWidget(
                            width: 25,
                          ),
                          Column(
                            children: <Widget>[
                              Stack(
                                clipBehavior: Clip.none,
                                children: <Widget>[
                                  SizedBoxWithChild(
                                    height: 22,
                                    width: 22,
                                    child: IconButtonWidget(
                                      iconPath: Constants.VOICE_ICON_LINK,
                                      size: 18,
                                      color: mAppThemeProvider.primaryColor,
                                      padding: const EdgeInsets.all(1),
                                      onPressed: () {
                                        if (widget.isFromPaymentNotification ==
                                            false)
                                          FetchRecords(
                                              getCategoryPosition(
                                                  AppConstants.voiceRecords),
                                              false,
                                              true,
                                              false,
                                              CommonUtil.voiceIds);
                                      },
                                    ),
                                  ),
                                  voiceIdCount > 0
                                      ? const Positioned(
                                          top: -5,
                                          right: -5,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 15,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                              SizedBoxWidget(height: 2),
                              TextWidget(
                                  text: parameters.addVoice,
                                  fontsize: 10.0.sp,
                                  colors: Colors.grey),
                            ],
                          ),
                          SizedBoxWidget(
                            width: 25,
                          ),
                          Column(
                            children: <Widget>[
                              Stack(
                                clipBehavior: Clip.none,
                                children: <Widget>[
                                  SizedBoxWithChild(
                                    height: 22,
                                    width: 22,
                                    child: IconButtonWidget(
                                      iconPath: Constants.RECORDS_ICON_LINK,
                                      size: 18,
                                      color: mAppThemeProvider.primaryColor,
                                      padding: const EdgeInsets.all(1),
                                      onPressed: () {
                                        if (widget.isFromPaymentNotification ==
                                            false)
                                          FetchRecords(
                                              getCategoryPosition(
                                                  AppConstants.prescription),
                                              true,
                                              false,
                                              false,
                                              CommonUtil.recordIds);
                                      },
                                    ),
                                  ),
                                  recordIdCount > 0
                                      ? BadgesBlue(
                                          badgeValue: recordIdCount.toString(),
                                          backColor: mAppThemeProvider.primaryColor)
                                      : const SizedBox(),
                                ],
                              ),
                              SizedBoxWidget(height: 2),
                              TextWidget(
                                  text: parameters.records,
                                  fontsize: 10.0.sp,
                                  colors: Colors.grey),
                            ],
                          ),
                          SizedBoxWidget(
                            width: 25,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBoxWidget(height: 10),
                Divider(
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
          widget.isFromPaymentNotification
              ? const SizedBox.shrink()
              : isFollowUp()
                  ? const SizedBox.shrink()
                  : isMembershipDiscount
                      ? const SizedBox.shrink()
                      : getCSRCheckBox(
                          widget.isFromHospital!
                              ? getFeesFromHospital(
                                  widget.resultFromHospitalList![
                                      widget.doctorListIndex!],
                                  true,
                                )
                              : getFees(
                                  widget.healthOrganizationResult![widget.i!],
                                  true,
                                ),
                          commonWidgets.getMoneyWithForamt(
                            widget.isFromHospital!
                                ? getFeesFromHospital(
                                    widget.resultFromHospitalList![
                                        widget.doctorListIndex!],
                                    false,
                                  )
                                : getFees(
                                    widget.healthOrganizationResult![widget.i!],
                                    false,
                                  ),
                          ),
                        ),
          SizedBoxWidget(height: 10),
          isMembershipDiscount
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getMembershipDiscountCheckBox(),
                    SizedBoxWidget(height: 10),
                  ],
                )
              : const SizedBox.shrink(),
          Visibility(
              visible: isActiveMember == true &&
                  (widget.noOfDoctorAppointments != null && widget.noOfDoctorAppointments! > 0),
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child:applyMemberShipBenefitsWidget(),
              )),//visible only if  no of doctor appoinment amount is greater than 0
          Container(
            child: Center(
              child: Text(
                'Pay ${CommonUtil.CURRENCY}' + INR_Price!,
                maxLines: 1,
                style: TextStyle(
                    fontSize: 22.0.sp,
                    fontWeight: FontWeight.w500,
                    color: mAppThemeProvider.primaryColor),
              ),
            ),
          ),
          SizedBoxWidget(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBoxWithChild(
                  width: 130.0.w,
                  height: 40.0.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                              color: mAppThemeProvider.primaryColor)),
                      backgroundColor: Colors.transparent,
                      foregroundColor: mAppThemeProvider.primaryColor,
                      padding: const EdgeInsets.all(8),
                    ),
                    onPressed: () {
                      if (widget.isFromPaymentNotification == false)
                        widget.refresh!();
                      Navigator.pop(context);
                    },
                    child: TextWidget(
                      text: Constants.Cancel,
                      fontsize: 14.0.sp,
                    ),
                  ),
                ),
                SizedBoxWithChild(
                  width: 130.0.w,
                  height: 40.0.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                              color: mAppThemeProvider.primaryColor)),
                      backgroundColor: Colors.transparent,
                      foregroundColor: mAppThemeProvider.primaryColor,
                      padding: const EdgeInsets.all(8),
                    ),
                    onPressed: () {
                      FHBUtils().check().then((intenet) {
                        if (intenet != null && intenet) {
                          if (isFamilyChanged) {
                            profileValidationCheck(
                                context,
                                selectedId != ''
                                    ? selectedId!
                                    : PreferenceUtil.getStringValue(
                                        Constants.KEY_USERID)!);
                          } else {
                            if (btnLabelChange == bookNow) {
                              bookAppointment(
                                createdBy,
                                selectedId,
                                doctorSessionId,
                                scheduleDate,
                                slotNumber,
                                (healthRecords != null &&
                                        healthRecords.length > 0)
                                    ? true
                                    : false,
                                isFollowUp(),
                                (healthRecords != null &&
                                        healthRecords.length > 0)
                                    ? healthRecords
                                    : [],
                                doc: widget.isFollowUp!
                                    ? widget.doctorsData
                                    : null,
                                isResidentDoctorMembership:
                                    isMembershipDiscount,
                                  walletDeductionAmount: applyMembershipDiscountedAmount
                              );
                            } else {
                              _displayDialog(context);
                            }
                          }
                        } else {
                          toast.getToast(
                              Constants.STR_NO_CONNECTIVITY, Colors.black54);
                        }
                      });
                    },
                    child: TextWidget(
                      text: btnLabelChange,
                      fontsize: 14.0.sp,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getAppointmentDetailsUsingId() {
    return FutureBuilder<AppointmentNotificationPayment?>(
      future: createAppointMentViewModel
          .getAppointmentDetailsUsingId(widget.appointmentId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CommonCircularIndicator(),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          return getDataFromResponse(snapshot.data);
        }
      },
    );
  }
}

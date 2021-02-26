import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/UserAddressCollection.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorsFromHospitalModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/SlotsResultModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationResult.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/BookingConfirmation.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/SessionList.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/telehealth/features/Notifications/services/notification_services.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart'
    as AppointmentConstant;
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/model/resheduleAppointments/resheduleModel.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/appointmentsListViewModel.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/resheduleAppointmentViewModel.dart';
import 'package:provider/provider.dart';

class GetTimeSlots extends StatelessWidget {
  SlotsResultModel dateSlotTimingsObj;
  final List<Doctors> docs;
  final int j;
  final int doctorListIndex;
  Past doctorsData;
  final DateTime selectedDate;
  bool isReshedule;
  FlutterToast toast = new FlutterToast();
  List<String> bookingIds = [];
  final List<HealthOrganizationResult> healthOrganizationResult;
  final List<ResultFromHospital> resultFromHospitalList;
  final int doctorListPos;
  Function(String) closePage;
  Function() isRefresh;
  bool isFromNotification;
  bool isFromHospital;
  dynamic body;

  MyProfileModel myProfile;
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();

  GetTimeSlots(
      {this.dateSlotTimingsObj,
      this.docs,
      this.j,
      this.doctorListIndex,
      this.selectedDate,
      this.isReshedule,
      this.doctorsData,
      this.healthOrganizationResult,
      this.resultFromHospitalList,
      this.doctorListPos,
      this.closePage,
      this.isRefresh,
      this.isFromNotification,
      this.isFromHospital,
      this.body});

  @override
  Widget build(BuildContext context) {
    int rowPosition = -1;
    int itemPosition = -1;
    return Column(
      children: <Widget>[
        SessionList(
          sessionData: dateSlotTimingsObj.sessions,
          selectedPosition: (rowPos, itemPos) {
            rowPosition = rowPos;
            itemPosition = itemPos;
          },
        ),
        SizedBoxWidget(
          height: 10.0.h,
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBoxWithChild(
            width: 95.0.w,
            height: 35.0.h,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(
                      color: Color(new CommonUtil().getMyPrimaryColor()))),
              color: Colors.transparent,
              textColor: Color(new CommonUtil().getMyPrimaryColor()),
              padding: EdgeInsets.all(
                8.0.sp,
              ),
              onPressed: () {
                if (isReshedule == true) {
                  String docSesstionID =
                      dateSlotTimingsObj.sessions[rowPosition].doctorSessionId;
                  String selectedSlot = dateSlotTimingsObj
                      .sessions[rowPosition].slots[itemPosition].slotNumber
                      .toString();
                  resheduleAppoitment(context, [doctorsData], selectedSlot,
                      selectedDate.toString().substring(0, 10), docSesstionID);
                } else {
                  if (rowPosition > -1 && itemPosition > -1) {
                    if (doctorsData == null) {
                      new FHBUtils().check().then((intenet) {
                        if (intenet != null && intenet) {
                          var userId = PreferenceUtil.getStringValue(
                              Constants.KEY_USERID);
                          profileValidationCheck(
                              context, rowPosition, itemPosition, userId);
                        } else {
                          toast.getToast(
                              Constants.STR_NO_CONNECTIVITY, Colors.red);
                        }
                      });
                    } else {
                      //follow up appointment
                      navigateToConfirmBook(context, rowPosition, itemPosition,
                          doctorsData.doctorFollowUpFee, true, true);
                    }
                  } else {
                    toast.getToast(selectSlotsMsg, Colors.red);
                  }
                }
              },
              child: TextWidget(
                text: bookNow,
                fontsize: 14.0.sp,
              ),
            ),
          ),
        ),
        SizedBoxWidget(
          height: 10.0.h,
        ),
      ],
    );
  }

  navigateToConfirmBook(BuildContext context, int rowPos, int itemPos,
      String followUpFee, bool isNewAppointment, bool isFollowUp) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmation(
            docs: docs,
            followUpFee: followUpFee,
            isNewAppointment: isNewAppointment,
            i: j,
            doctorListIndex: doctorListIndex,
            selectedDate: selectedDate,
            sessionData: dateSlotTimingsObj.sessions,
            rowPosition: rowPos,
            itemPosition: itemPos,
            isFollowUp: isFollowUp,
            doctorsData: doctorsData,
            healthOrganizationResult: healthOrganizationResult,
            resultFromHospitalList: resultFromHospitalList,
            doctorListPos: doctorListPos,
            closePage: (value) {
              closePage(value);
            },
            refresh: () {
              isRefresh();
            },
            isFromHospital: isFromHospital,
          ),
        ));
  }

  resheduleAppoitment(BuildContext context, List<Past> appointments,
      String slotNumber, String resheduledDate, String doctorSessionId) {
    resheduleAppointment(
            context, appointments, slotNumber, resheduledDate, doctorSessionId)
        .then((value) {
      if (isFromNotification == true) {
        if (body != null && body != '') {
          FetchNotificationService().updateNsActionStatus(body).then((data) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => TelehealthProviders(
                          arguments: HomeScreenArguments(selectedIndex: 0),
                        )),
                (Route<dynamic> route) => route.isFirst).then((value) {});
          });
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => TelehealthProviders(
                        arguments: HomeScreenArguments(selectedIndex: 0),
                      )),
              (Route<dynamic> route) => route.isFirst).then((value) {});
        }
      } else {
        if (body != null && body != '') {
          FetchNotificationService().updateNsActionStatus(body).then((data) {
            if (data['isSuccess']) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
            }
          });
        } else {
          Navigator.pop(context);
        }
      }
      if (value == null) {
        toast.getToast(AppointmentConstant.SLOT_NOT_AVAILABLE, Colors.red);
      } else if (value.isSuccess == true) {
        toast.getToast(
            AppointmentConstant.YOUR_RESHEDULE_SUCCESS, Colors.green);
        //TODO call the ns action api
      } else if (value.message.contains(AppointmentConstant.NOT_AVAILABLE)) {
        toast.getToast(AppointmentConstant.SLOT_NOT_AVAILABLE, Colors.red);
      } else {
        toast.getToast(AppointmentConstant.RESHEDULE_CANCEL, Colors.red);
      }
    });
  }

  Future<ResheduleModel> resheduleAppointment(
      BuildContext context,
      List<Past> appointments,
      String slotNumber,
      String resheduledDate,
      String doctorSessionId) async {
    for (int i = 0; i < appointments.length; i++) {
      bookingIds.add(appointments[i].bookingId);
    }
    ResheduleAppointmentViewModel reshedule =
        Provider.of<ResheduleAppointmentViewModel>(context, listen: false);
    ResheduleModel resheduleAppointment = await reshedule.resheduleAppointment(
        bookingIds, slotNumber.toString(), resheduledDate, doctorSessionId);
    return resheduleAppointment;
  }

  profileValidationCheck(BuildContext context, int rowPosition,
      int itemPosition, String userId) async {
    await addFamilyUserInfoRepository.getMyProfileInfoNew(userId).then((value) {
      myProfile = value;
    });

    if (myProfile != null) {
      addressValidation(context, rowPosition, itemPosition);
    } else {
      toast.getToast(noGender, Colors.red);
    }
  }

  addressValidation(BuildContext context, int rowPosition, int itemPosition) {
    if (myProfile != null) {
      if (myProfile.isSuccess) {
        if (myProfile.result != null) {
          if (myProfile.result.gender != null &&
              myProfile.result.gender.isNotEmpty) {
            if (myProfile.result.dateOfBirth != null &&
                myProfile.result.dateOfBirth.isNotEmpty) {
              if (myProfile.result.additionalInfo != null) {
                if (myProfile.result.additionalInfo.height != null &&
                    myProfile.result.additionalInfo.height.isNotEmpty) {
                  if (myProfile.result.additionalInfo.weight != null &&
                      myProfile.result.additionalInfo.weight.isNotEmpty) {
                    if (myProfile.result.userAddressCollection3 != null) {
                      if (myProfile.result.userAddressCollection3.length > 0) {
                        patientAddressCheck(
                            myProfile.result.userAddressCollection3[0],
                            context,
                            rowPosition,
                            itemPosition);
                      } else {
                        //toast.getToast(noAddress, Colors.red);
                        CommonUtil().mSnackbar(context, noAddress, 'Add');
                      }
                    } else {
                      //toast.getToast(noAddress, Colors.red);
                      CommonUtil().mSnackbar(context, noAddress, 'Add');
                    }
                  } else {
                    //toast.getToast(noWeight, Colors.red);
                    CommonUtil().mSnackbar(context, noWeight, 'Add');
                  }
                } else {
                  //toast.getToast(noHeight, Colors.red);
                  CommonUtil().mSnackbar(context, noHeight, 'Add');
                }
              } else {
                //toast.getToast(noAdditionalInfo, Colors.red);
                CommonUtil().mSnackbar(context, noAdditionalInfo, 'Add');
              }
            } else {
              //toast.getToast(noDOB, Colors.red);
              CommonUtil().mSnackbar(context, noDOB, 'Add');
            }
          } else {
            CommonUtil().mSnackbar(context, noGender, 'Add');
            //toast.getToast(noGender, Colors.red);
          }
        } else {
          //toast.getToast(noAddress, Colors.red);
          CommonUtil().mSnackbar(context, noAddress, 'Add');
        }
      } else {
        //toast.getToast(noAddress, Colors.red);
        CommonUtil().mSnackbar(context, noAddress, 'Add');
      }
    } else {
      //toast.getToast(noAddress, Colors.red);
      CommonUtil().mSnackbar(context, noAddress, 'Add');
    }
  }

  patientAddressCheck(UserAddressCollection3 userAddressCollection,
      BuildContext context, int rowPosition, int itemPosition) {
    String address1 = userAddressCollection.addressLine1 != null
        ? userAddressCollection.addressLine1
        : '';
    String city = userAddressCollection.city.name != null
        ? userAddressCollection.city.name
        : '';
    String state = userAddressCollection.state.name != null
        ? userAddressCollection.state.name
        : '';

    if (address1 != '' && city != '' && state != '') {
      //normal appointment
      navigateToConfirmBook(
          context, rowPosition, itemPosition, null, false, false);
    } else {
      toast.getToast(noAddress, Colors.red);
    }
  }
}

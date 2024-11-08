import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/ClipImage/ClipOvalImage.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';

import '../../../constants/fhb_constants.dart' as Constants;
import '../../add_providers/models/add_providers_arguments.dart';
import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart' as router;
import '../../main.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/MyProvider/view/CommonWidgets.dart';
import '../../telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import '../bloc/providers_block.dart';
import '../models/Doctors.dart';
import 'my_provider.dart';

class MyProvidersDoctorsList extends StatefulWidget {
  final List<Doctors?>? doctorsModel;
  final ProvidersBloc? providersBloc;
  final MyProviderState? myProviderState;
  Function? refresh;

  MyProvidersDoctorsList(
      {this.doctorsModel,
      this.providersBloc,
      this.myProviderState,
      this.refresh});

  @override
  _MyProvidersDoctorsList createState() => _MyProvidersDoctorsList();
}

class _MyProvidersDoctorsList extends State<MyProvidersDoctorsList> {
  List<Doctors?>? doctorsModel;
  List<Doctors?>? copyOfdoctorsModel;
  late MyProviderState myProviderState;
  late MyProviderViewModel providerViewModel;
  CommonWidgets commonWidgets = CommonWidgets();
  FlutterToast toast = FlutterToast();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  var authtoken;
  @override
  void initState() {
    providerViewModel = MyProviderViewModel();
    setAuthToken();
    super.initState();
    filterDuplicateDoctor();
  }

  void filterDuplicateDoctor() {
    if (widget.doctorsModel!.isNotEmpty) {
      copyOfdoctorsModel = widget.doctorsModel;
      var ids = copyOfdoctorsModel!.map((e) => e?.user?.id).toSet();
      copyOfdoctorsModel!.retainWhere((x) => ids.remove(x?.user?.id));
      doctorsModel = copyOfdoctorsModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildPlayersList();
  }

  Widget buildPlayersList() {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          _refreshIndicatorKey.currentState?.show(atTop: true);
          widget.refresh!();
          _refreshIndicatorKey.currentState?.show(atTop: false);
        },
        child: ListView.separated(
          padding: EdgeInsets.only(bottom: 200),
          itemBuilder: (context, index) {
            var eachDoctorModel = doctorsModel![index];
            var specialization = eachDoctorModel
                        ?.doctorProfessionalDetailCollection !=
                    null
                ? eachDoctorModel!
                        .doctorProfessionalDetailCollection!.isNotEmpty
                    ? eachDoctorModel.doctorProfessionalDetailCollection![0]
                                .specialty !=
                            null
                        ? (eachDoctorModel
                                        .doctorProfessionalDetailCollection![0]
                                        .specialty!
                                        .name !=
                                    null &&
                                eachDoctorModel
                                        .doctorProfessionalDetailCollection![0]
                                        .specialty!
                                        .name !=
                                    '')
                            ? eachDoctorModel
                                .doctorProfessionalDetailCollection![0]
                                .specialty!
                                .name
                            : ''
                        : ''
                    : ''
                : '';
            return InkWell(
                onTap: () {
                  callMethodToNavigate(eachDoctorModel!);
                },
                child: Container(
                    padding: EdgeInsets.only(
                        left: 10, right: 5, top: 10, bottom: 10),
                    margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(fhbColors.cardShadowColor),
                          blurRadius:
                              16, // has the effect of extending the shadow
                        )
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        ClipOval(
                            child: eachDoctorModel?.user != null
                                ? (eachDoctorModel?.user?.profilePicThumbnailUrl !=
                                            null ||
                                        (eachDoctorModel?.user?.firstName != null &&
                                            eachDoctorModel?.user?.lastName !=
                                                null))
                                    ? getProfilePicWidget(
                                        eachDoctorModel?.user
                                                ?.profilePicThumbnailUrl ??
                                            "",
                                        eachDoctorModel?.user?.firstName ?? "",
                                        eachDoctorModel?.user?.lastName ?? "",
                                        mAppThemeProvider.primaryColor,
                                        CommonUtil().isTablet!
                                            ? imageTabHeader
                                            : Constants.imageMobileHeader,
                                        CommonUtil().isTablet!
                                            ? tabHeader1
                                            : Constants.mobileHeader1,
                                        authtoken: authtoken)
                                    : Container(
                                        width: CommonUtil().isTablet!
                                            ? imageTabHeader
                                            : Constants.imageMobileHeader,
                                        height: CommonUtil().isTablet!
                                            ? imageTabHeader
                                            : Constants.imageMobileHeader,
                                        padding: EdgeInsets.all(12),
                                        color:
                                            Color(fhbColors.bgColorContainer))
                                : Container(
                                    width: CommonUtil().isTablet!
                                        ? imageTabHeader
                                        : Constants.imageMobileHeader,
                                    height: CommonUtil().isTablet!
                                        ? imageTabHeader
                                        : Constants.imageMobileHeader,
                                    padding: EdgeInsets.all(12),
                                    color: Color(fhbColors.bgColorContainer))),
                        SizedBox(
                          width: 15.0.w,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 5.0.h),
                              AutoSizeText(
                                eachDoctorModel?.user != null
                                    ? CommonUtil()
                                        .getDoctorName(eachDoctorModel!.user!)!
                                    : '',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: CommonUtil().isTablet!
                                      ? tabHeader1
                                      : Constants.mobileHeader1,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 5.0.h),
                              if (specialization != null)
                                AutoSizeText(
                                  specialization != null
                                      ? toBeginningOfSentenceCase(
                                          specialization)!
                                      : '',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: CommonUtil().isTablet!
                                          ? tabHeader2
                                          : Constants.mobileHeader2,
                                      fontWeight: FontWeight.w400,
                                      color: ColorUtils.lightgraycolor),
                                  textAlign: TextAlign.start,
                                )
                              else
                                SizedBox(height: 0.0.h, width: 0.0.h),
                              SizedBox(height: 5.0.h),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                          child: Column(
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent)),
                                child: Container(
                                    child: Text(
                                  eachDoctorModel!.isPatientAssociatedRequest!
                                      ? "Waiting for approval"
                                      : "",
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                  ),
                                )),
                                onPressed: () {
                                  callMethodToNavigate(eachDoctorModel,
                                      isButton: true);
                                },
                              )
                            ],
                          ),
                        )),
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              commonWidgets
                                  .getBookMarkedIconNew(eachDoctorModel, () {
                                if (eachDoctorModel
                                    .isPatientAssociatedRequest!) {
                                  toast.getToast('Approval request is pending',
                                      Colors.black54);
                                } else {
                                  providerViewModel
                                      .bookMarkDoctor(
                                          eachDoctorModel,
                                          false,
                                          'ListItem',
                                          eachDoctorModel.sharedCategories)
                                      .then((status) {
                                    if (status!) {
                                      widget.refresh!();
                                    }
                                  });
                                }
                              }),
                            ],
                          ),
                        ),
                      ],
                    )));
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 0.0.h,
              color: Colors.transparent,
            );
          },
          itemCount: doctorsModel!.length,
        ));
  }

  callMethodToNavigate(Doctors eachDoctorModel, {bool isButton = false}) {
    if (eachDoctorModel.isPatientAssociatedRequest!) {
      toast.getToast('Approval request is pending', Colors.black54);
    } else {
      Navigator.pushNamed(context, router.rt_AddProvider,
          arguments: AddProvidersArguments(
              searchKeyWord: CommonConstants.doctors,
              doctorsModel: eachDoctorModel,
              fromClass: router.rt_myprovider,
              hasData: true,
              isRefresh: () {
                widget.refresh!();
              })).then((value) {
//                providersBloc.getMedicalPreferencesList();
        myProviderState.refreshPage();
      });
    }
  }

  void setAuthToken() async {
    authtoken = await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
  }
}

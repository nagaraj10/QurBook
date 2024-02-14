import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../add_providers/models/add_providers_arguments.dart';
import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart' as router;
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/MyProvider/view/CommonWidgets.dart';
import '../../telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import '../bloc/providers_block.dart';
import '../models/Hospitals.dart';
import 'my_provider.dart';

class MyProvidersHospitalsList extends StatefulWidget {
  final List<Hospitals>? hospitalsModel;
  final ProvidersBloc? providersBloc;
  final MyProviderState? myProviderState;
  Function? isRefresh;

  MyProvidersHospitalsList(
      {this.hospitalsModel,
      this.providersBloc,
      this.myProviderState,
      this.isRefresh});

  @override
  _MyProvidersDoctorsList createState() => _MyProvidersDoctorsList();
}

class _MyProvidersDoctorsList extends State<MyProvidersHospitalsList> {
  List<Hospitals>? hospitalsModel;
  ProvidersBloc? providersBloc;
  late MyProviderState myProviderState;
  late MyProviderViewModel providerViewModel;
  CommonWidgets commonWidgets = CommonWidgets();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerViewModel = MyProviderViewModel();
    return buildPlayersList();
  }

  Widget buildPlayersList() {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          _refreshIndicatorKey.currentState?.show(atTop: true);
          widget.isRefresh!();
          _refreshIndicatorKey.currentState?.show(atTop: false);
        },
        child: ListView.separated(
          padding: EdgeInsets.only(bottom: 200),
          itemBuilder: (context, index) {
            var eachHospitalModel = widget.hospitalsModel![index];
            return ((getHospitalName(eachHospitalModel) ?? '').isNotEmpty)
                ? InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, router.rt_AddProvider,
                          arguments: AddProvidersArguments(
                              searchKeyWord: CommonConstants.hospitals,
                              hospitalsModel: eachHospitalModel,
                              fromClass: router.rt_myprovider,
                              hasData: true,
                              isRefresh: () {
                                widget.isRefresh!();
                              })).then((value) {
                        myProviderState.refreshPage();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 10,
                          bottom: CommonUtil.isUSRegion() &&
                                  eachHospitalModel.isPrimaryProvider!
                              ? 0
                              : 10),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: CommonUtil().isTablet! ? 35 : 20,
                                child: ClipOval(
                                    child: eachHospitalModel != null
                                        ? /*myProfile.result.profilePicThumbnailUrl != null
                                  ? FHBBasicWidget().getProfilePicWidgeUsingUrl(
                                      myProfile.result.profilePicThumbnailUrl)
                                  :*/
                                        Container(
                                            height: CommonUtil().isTablet!
                                                ? imageTabHeader
                                                : imageMobileHeader,
                                            width: CommonUtil().isTablet!
                                                ? imageTabHeader
                                                : imageMobileHeader,
                                            color: Color(
                                                fhbColors.bgColorContainer),
                                            child: Center(
                                              child: Text(
                                                getHospitalName(
                                                        eachHospitalModel)![0]
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize:
                                                        CommonUtil().isTablet!
                                                            ? tabHeader1
                                                            : mobileHeader1,
                                                    color: Color(CommonUtil()
                                                        .getMyPrimaryColor())),
                                              ),
                                            ))
                                        : Container(
                                            height: CommonUtil().isTablet!
                                                ? imageTabHeader
                                                : imageMobileHeader,
                                            width: CommonUtil().isTablet!
                                                ? imageTabHeader
                                                : imageMobileHeader,
                                            color: Color(
                                                fhbColors.bgColorContainer),
                                          )),
                              ),
                              SizedBox(
                                width: 20.0.w,
                              ),
                              Expanded(
                                flex: 6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 5.0.h),
                                    AutoSizeText(
                                      getHospitalName(
                                          eachHospitalModel)! /* toBeginningOfSentenceCase(
                                        eachHospitalModel.name) */
                                      ,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: CommonUtil().isTablet!
                                            ? tabHeader1
                                            : mobileHeader1,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(height: 5.0.h),
                                    AutoSizeText(
                                      '' +
                                          commonWidgets.getCityHospital(
                                              eachHospitalModel)!,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: CommonUtil().isTablet!
                                              ? tabHeader2
                                              : mobileHeader2,
                                          fontWeight: FontWeight.w400,
                                          color: ColorUtils.lightgraycolor),
                                    ),
                                    SizedBox(height: 5.0.h),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    commonWidgets.getBookMarkedIconHealth(
                                        eachHospitalModel, () {
                                      providerViewModel
                                          .bookMarkHealthOrg(
                                              eachHospitalModel,
                                              false,
                                              'ListItem',
                                              eachHospitalModel
                                                  .sharedCategories)
                                          .then((status) {
                                        if (status!) {
                                          widget.isRefresh!();
                                        }
                                      });
                                    }),
                                  ],
                                ),
                              )),
                            ],
                          ),
                          if (CommonUtil.isUSRegion() &&
                              eachHospitalModel.isPrimaryProvider!)
                            CommonUtil().primaryProviderIndication(),
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink();
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 0.0.h,
              color: Colors.transparent,
            );
          },
          itemCount: widget.hospitalsModel!.length,
        ));
  }

  String? getHospitalName(Hospitals eachHospitalModel) {
    String? name = "";

    if (eachHospitalModel.name != null) {
      if (eachHospitalModel.name != "Self" &&
          eachHospitalModel.name != "self") {
        name = eachHospitalModel.name?.capitalizeFirstofEach;
      } else {
        if (eachHospitalModel.createdBy != null) {
          if (eachHospitalModel.createdBy!.firstName != "" &&
              eachHospitalModel.createdBy!.firstName != null) {
            name = eachHospitalModel.createdBy!.firstName;
          }
          if (eachHospitalModel.createdBy!.lastName != "" &&
              eachHospitalModel.createdBy!.lastName != null) {
            name = name! + " " + eachHospitalModel.createdBy!.lastName!;
          }
        }
      }
    }
    return name;
  }
}

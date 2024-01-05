// import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../add_providers/models/add_providers_arguments.dart';
import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart' as router;
import '../bloc/providers_block.dart';
import '../models/Hospitals.dart';
import 'package:myfhb/my_providers/screens/my_provider.dart';
import '../../src/utils/colors_utils.dart';
import '../../telehealth/features/MyProvider/view/CommonWidgets.dart';
import '../../telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'my_provider.dart';

class MyProvidersLabsList extends StatefulWidget {
  final List<Hospitals>? labsModel;
  final ProvidersBloc? providersBloc;
  final MyProviderState? myProviderState;
  Function? isRefresh;

  MyProvidersLabsList(
      {this.labsModel,
      this.providersBloc,
      this.myProviderState,
      this.isRefresh});

  @override
  _MyProvidersLabsList createState() => _MyProvidersLabsList();
}

class _MyProvidersLabsList extends State<MyProvidersLabsList> {
  List<Hospitals>? labsModel;
  ProvidersBloc? providersBloc;
  late MyProviderState myProviderState;
  late MyProviderViewModel providerViewModel;
  CommonWidgets commonWidgets = CommonWidgets();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'My Providers Lab list Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
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
            final eachLabModel = widget.labsModel![index];
            return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, router.rt_AddProvider,
                      arguments: AddProvidersArguments(
                          searchKeyWord: CommonConstants.labs,
                          labsModel: eachLabModel,
                          fromClass: router.rt_myprovider,
                          hasData: true,
                          labsDataList: widget.labsModel,
                          isRefresh: () {
                            widget.isRefresh!();
                          })).then((value) {
//                providersBloc.getMedicalPreferencesList();
                    myProviderState.refreshPage();
                  });
                },
                child: Container(
                    padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 10,
                        bottom: CommonUtil.isUSRegion() &&
                                eachLabModel.isPrimaryProvider!
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
                                  child: eachLabModel != null
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
                                          color:
                                              Color(fhbColors.bgColorContainer),
                                          child: Center(
                                            child: Text(
                                              eachLabModel.name != null
                                                  ? eachLabModel.name![0]
                                                      .toUpperCase()
                                                  : '',
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
                                          color:
                                              Color(fhbColors.bgColorContainer),
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
                                    eachLabModel.name != null
                                        ? eachLabModel.name!
                                            .capitalizeFirstofEach //toBeginningOfSentenceCase(eachLabModel.name)
                                        : "",
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
                                        commonWidgets
                                            .getCityHospital(eachLabModel)!,
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
                                      eachLabModel, () {
                                    providerViewModel
                                        .bookMarkHealthOrg(eachLabModel, false,
                                            'ListItem', null)
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
                            eachLabModel.isPrimaryProvider!)
                          CommonUtil().primaryProviderIndication(),
                      ],
                    )));
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 0.0.h,
              color: Colors.transparent,
            );
          },
          itemCount: widget.labsModel!.length,
        ));
  }
}

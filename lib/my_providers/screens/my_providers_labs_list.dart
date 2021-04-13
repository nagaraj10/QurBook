import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_providers/models/add_providers_arguments.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'my_provider.dart';

class MyProvidersLabsList extends StatefulWidget {
  final List<Hospitals> labsModel;
  final ProvidersBloc providersBloc;
  final MyProviderState myProviderState;
  Function isRefresh;

  MyProvidersLabsList(
      {this.labsModel,
      this.providersBloc,
      this.myProviderState,
      this.isRefresh});

  @override
  _MyProvidersLabsList createState() => _MyProvidersLabsList();
}

class _MyProvidersLabsList extends State<MyProvidersLabsList> {
  List<Hospitals> labsModel;
  ProvidersBloc providersBloc;
  MyProviderState myProviderState;
  MyProviderViewModel providerViewModel;
  CommonWidgets commonWidgets = new CommonWidgets();

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
    providerViewModel = new MyProviderViewModel();
    return buildPlayersList();
  }

  Widget buildPlayersList() {
    return ListView.separated(
      itemBuilder: (BuildContext context, index) {
        Hospitals eachLabModel = widget.labsModel[index];
        return InkWell(
            onTap: () {
              Navigator.pushNamed(context, router.rt_AddProvider,
                  arguments: AddProvidersArguments(
                      searchKeyWord: CommonConstants.labs,
                      labsModel: eachLabModel,
                      fromClass: router.rt_myprovider,
                      hasData: true,
                      isRefresh: () {
                        widget.isRefresh();
                      })).then((value) {
//                providersBloc.getMedicalPreferencesList();
                myProviderState.refreshPage();
              });
            },
            child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(fhbColors.cardShadowColor),
                      blurRadius: 16, // has the effect of softening the shadow
                      spreadRadius: 0, // has the effect of extending the shadow
                    )
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 18,
                      child: ClipOval(
                          child: eachLabModel != null
                              ? /*myProfile.result.profilePicThumbnailUrl != null
                              ? new FHBBasicWidget().getProfilePicWidgeUsingUrl(
                                  myProfile.result.profilePicThumbnailUrl)
                              :*/
                              Container(
                                  height: 50.0.h,
                                  width: 50.0.h,
                                  color: Color(fhbColors.bgColorContainer),
                                  child: Center(
                                    child: Text(
                                      eachLabModel.name != null
                                          ? eachLabModel.name[0].toUpperCase()
                                          : '',
                                      style: TextStyle(
                                          color: Color(CommonUtil()
                                              .getMyPrimaryColor())),
                                    ),
                                  ))
                              : Container(
                                  height: 50.0.h,
                                  width: 50.0.h,
                                  color: Color(fhbColors.bgColorContainer),
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
                                ? toBeginningOfSentenceCase(eachLabModel.name)
                                : '',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 5.0.h),
                          AutoSizeText(
                            '' + commonWidgets.getCityHospital(eachLabModel),
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 15.0.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorUtils.lightgraycolor),
                          ),
                          SizedBox(height: 5.0.h),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              commonWidgets
                                  .getBookMarkedIconHealth(eachLabModel, () {
                                providerViewModel
                                    .bookMarkHealthOrg(
                                        eachLabModel, false, 'ListItem')
                                    .then((status) {
                                  if (status) {
                                    widget.isRefresh();
                                  }
                                });
                              }),
                            ],
                          ),
                        )),
                  ],
                )));
      },
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          height: 0.0.h,
          color: Colors.transparent,
        );
      },
      itemCount: widget.labsModel.length,
    );
  }
}

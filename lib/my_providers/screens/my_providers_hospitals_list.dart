import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_providers/models/add_providers_arguments.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';

import 'my_provider.dart';

class MyProvidersHospitalsList extends StatefulWidget {

  final List<Hospitals> hospitalsModel;
  final ProvidersBloc providersBloc;
  final MyProviderState myProviderState;
  Function isRefresh;


  MyProvidersHospitalsList(
      {this.hospitalsModel, this.providersBloc, this.myProviderState,this.isRefresh});

  @override
  _MyProvidersDoctorsList createState() => _MyProvidersDoctorsList();

  }
  class _MyProvidersDoctorsList extends State<MyProvidersHospitalsList>{
    List<Hospitals> hospitalsModel;
    ProvidersBloc providersBloc;
    MyProviderState myProviderState;
    MyProviderViewModel providerViewModel;
    CommonWidgets commonWidgets = new CommonWidgets();

    @override
    Widget build(BuildContext context) {
      providerViewModel = new MyProviderViewModel();
      return buildPlayersList();
    }

    Widget buildPlayersList() {
      return ListView.separated(
        itemBuilder: (BuildContext context, index) {
          widget.hospitalsModel.sort((a, b) => (a?.name ?? '')
              .toLowerCase()
              .trim()
              .compareTo((b?.name ?? '').toLowerCase().trim()));
          widget.hospitalsModel.sort((a, b) => (a.isDefault
              ? (a?.name ?? '')
              .toString()
              .toLowerCase().trim()
              .compareTo((b?.name ?? '').toString().toLowerCase().trim())
              : 0)
              .compareTo(b.isDefault
              ? (a?.name ?? '')
              .toString()
              .toLowerCase().trim()
              .compareTo((b?.name ?? '').toString().toLowerCase().trim())
              : 0));
          Hospitals eachHospitalModel = widget.hospitalsModel[index];
          return InkWell(
              onTap: () {
                Navigator.pushNamed(context, router.rt_AddProvider,
                    arguments: AddProvidersArguments(
                        searchKeyWord: CommonConstants.hospitals,
                        hospitalsModel: eachHospitalModel,
                        fromClass: router.rt_myprovider,
                        hasData: true,
                        isRefresh: (){
                          widget.isRefresh();
                        }

                    ))
                    .then((value) {
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
                            child: eachHospitalModel != null
                                ? /*myProfile.result.profilePicThumbnailUrl != null
                              ? new FHBBasicWidget().getProfilePicWidgeUsingUrl(
                                  myProfile.result.profilePicThumbnailUrl)
                              :*/
                            Container(
                                height: 50,
                                width: 50,
                                color: Color(fhbColors.bgColorContainer),
                                child: Center(
                                  child: Text(
                                    eachHospitalModel.name != null
                                        ?
                                    eachHospitalModel.name[0].toUpperCase()
                                        : '',
                                    style: TextStyle(
                                        color: Color(
                                            CommonUtil().getMyPrimaryColor())),
                                  ),
                                ))
                                : Container(
                              height: 50,
                              width: 50,
                              color: Color(fhbColors.bgColorContainer),
                            )),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5),
                            AutoSizeText(
                              eachHospitalModel.name != null
                                  ? toBeginningOfSentenceCase(
                                  eachHospitalModel.name)
                                  : '',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 5),
                             AutoSizeText(
                               '' +
                                   commonWidgets.getCityHospital(eachHospitalModel),
                               maxLines: 1,
                               style: TextStyle(
                                   fontSize: 13.0,
                                   fontWeight: FontWeight.w400,
                                   color: ColorUtils.lightgraycolor),
                             ),
                            SizedBox(height: 5),
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
                                commonWidgets.getBookMarkedIconHealth(eachHospitalModel, () {
                                  providerViewModel
                                      .bookMarkHealthOrg(eachHospitalModel,false, 'ListItem')
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
            height: 0.0,
            color: Colors.transparent,
          );
        },
        itemCount: widget.hospitalsModel.length,
      );
    }

  }

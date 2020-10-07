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
import 'package:myfhb/my_providers/models/Hospital.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';

import 'my_provider.dart';

class MyProvidersHospitalsList extends StatelessWidget {
  List<Hospitals> hospitalsModel;
  ProvidersBloc providersBloc;
  MyProviderState myProviderState;

  MyProvidersHospitalsList(
      {this.hospitalsModel, this.providersBloc, this.myProviderState});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return buildPlayersList();
  }

  Widget buildPlayersList() {
    return ListView.separated(
      itemBuilder: (BuildContext context, index) {
        Hospitals eachHospitalModel = hospitalsModel[index];
        return InkWell(
            onTap: () {
              Navigator.pushNamed(context, router.rt_AddProvider,
                      arguments: AddProvidersArguments(
                          searchKeyWord: CommonConstants.hospitals,
                          hospitalsModel: eachHospitalModel,
                          fromClass: router.rt_myprovider,
                          hasData: true))
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
                    // ClipOval(
                    //     child: eachHospitalModel.logo != null
                    //         ? Image.network(
                    //             Constants.BASE_URL + eachHospitalModel.logo,
                    //             height: 50,
                    //             width: 50,
                    //             fit: BoxFit.cover,
                    //           )
                    //         : Container(
                    //             width: 50,
                    //             height: 50,
                    //             padding: EdgeInsets.all(12),
                    //             color: Color(fhbColors.bgColorContainer))),
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
                          // AutoSizeText(
                          //   eachHospitalModel.addressLine1 != null
                          //       ? eachHospitalModel.addressLine1
                          //       : '' + eachHospitalModel.addressLine2 != null
                          //           ? eachHospitalModel.addressLine2
                          //           : '',
                          //   maxLines: 1,
                          //   style: TextStyle(
                          //       fontSize: 13.0,
                          //       fontWeight: FontWeight.w400,
                          //       color: ColorUtils.lightgraycolor),
                          // ),
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
                              InkWell(
                                  child: eachHospitalModel.isActive == true
                                      ? ImageIcon(
                                          AssetImage(
                                              variable.icon_record_fav_active),
                                          color: Color(new CommonUtil()
                                              .getMyPrimaryColor()),
                                          size: 20,
                                        )
                                      : Container(
                                          height: 0,
                                          width: 0,
                                        )),
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
      itemCount: hospitalsModel.length,
    );
  }
}

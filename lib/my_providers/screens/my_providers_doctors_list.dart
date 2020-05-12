import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_providers/models/add_providers_arguments.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/src/utils/colors_utils.dart';

class MyProvidersDoctorsList extends StatelessWidget {
  List<DoctorsModel> doctorsModel;
  ProvidersBloc providersBloc;

  MyProvidersDoctorsList({this.doctorsModel, this.providersBloc});

  @override
  Widget build(BuildContext context) {
    return buildPlayersList();
  }

  Widget buildPlayersList() {
    return ListView.separated(
      itemBuilder: (BuildContext context, index) {
        DoctorsModel eachDoctorModel = doctorsModel[index];
        print(index);
        return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/add_providers',
                      arguments: AddProvidersArguments(
                          searchKeyWord: CommonConstants.doctors,
                          doctorsModel: eachDoctorModel,
                          fromClass: CommonConstants.fromClass,
                          hasData: true))
                  .then((value) {
                providersBloc.getMedicalPreferencesList();
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
                    ClipOval(
                        child: eachDoctorModel.profilePic != null
                            ? Image.memory(
                                Uint8List.fromList(
                                    eachDoctorModel.profilePic.data),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                padding: EdgeInsets.all(12),
                                color: Color(fhbColors.bgColorContainer))),
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
                            eachDoctorModel.name != null
                                ? toBeginningOfSentenceCase(
                                    eachDoctorModel.name)
                                : '',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 5),
                          eachDoctorModel.specialization != null
                              ? AutoSizeText(
                                  eachDoctorModel.specialization != null
                                      ? toBeginningOfSentenceCase(
                                          eachDoctorModel.specialization)
                                      : '',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w400,
                                      color: ColorUtils.lightgraycolor),
                                  textAlign: TextAlign.start,
                                )
                              : SizedBox(height: 0, width: 0),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                  child: eachDoctorModel.isDefault == true
                                      ? ImageIcon(
                                          AssetImage(
                                              'assets/icons/record_fav_active.png'),
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
          height: 0,
          color: Colors.transparent,
        );
      },
      itemCount: doctorsModel.length,
    );
  }
}

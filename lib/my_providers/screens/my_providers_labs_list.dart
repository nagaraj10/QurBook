import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/add_providers/models/add_providers_arguments.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/src/utils/colors_utils.dart';

class MyProvidersLabsList extends StatelessWidget {
  List<LaboratoryModel> labsModel;
  ProvidersBloc providersBloc;

  MyProvidersLabsList({this.labsModel, this.providersBloc});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return buildPlayersList();
  }

  Widget buildPlayersList() {
    return ListView.separated(
      itemBuilder: (BuildContext context, index) {
        LaboratoryModel eachLabModel = labsModel[index];
        return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/add_providers',
                      arguments: AddProvidersArguments(
                          searchKeyWord: CommonConstants.labs,
                          labsModel: eachLabModel,
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
                        child: eachLabModel.logo != null
                            ? Image.network(
                                Constants.BASERURL + eachLabModel.logo,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/launcher/myfhb.png',
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          AutoSizeText(
                            eachLabModel.name != null ? eachLabModel.name : '',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 5),
                          AutoSizeText(
                            eachLabModel.addressLine1 != null
                                ? eachLabModel.addressLine1
                                : '' + eachLabModel.addressLine2 != null
                                    ? eachLabModel.addressLine2
                                    : '',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: ColorUtils.lightgraycolor),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              /* InkWell(
                                child: Icon(
                                  Icons.more_horiz,
                                  size: 22,
                                  color: Colors.grey,
                                ),
                                onTap: () {},
                              ), */
                              SizedBox(height: 20),
                              InkWell(
                                  child: eachLabModel.isDefault == true
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
                                        )

                                  /* Icon(
                                          Icons.bookmark,
                                          size: 22,
                                          color: Colors.grey,
                                        ) */
                                  ),
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
      itemCount: labsModel.length,
    );
  }
}

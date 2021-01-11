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
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';

import 'my_provider.dart';

class MyProvidersDoctorsList extends StatefulWidget {
  final List<Doctors> doctorsModel;
  final ProvidersBloc providersBloc;
  final MyProviderState myProviderState;
  Function refresh;

  MyProvidersDoctorsList(
      {this.doctorsModel,
      this.providersBloc,
      this.myProviderState,
      this.refresh});

  @override
  _MyProvidersDoctorsList createState() => _MyProvidersDoctorsList();
}

class _MyProvidersDoctorsList extends State<MyProvidersDoctorsList> {
  List<Doctors> doctorsModel;
  List<Doctors> copyOfdoctorsModel;
  MyProviderState myProviderState;
  MyProviderViewModel providerViewModel;
  CommonWidgets commonWidgets = new CommonWidgets();

  @override
  void initState() {
    providerViewModel = new MyProviderViewModel();
    super.initState();
    filterDuplicateDoctor();
  }

  void filterDuplicateDoctor() {
    if (widget?.doctorsModel.length > 0) {
      copyOfdoctorsModel = widget.doctorsModel;
      final ids = copyOfdoctorsModel.map((e) => e?.user?.id).toSet();
      copyOfdoctorsModel.retainWhere((x) => ids.remove(x?.user?.id));
      doctorsModel = copyOfdoctorsModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildPlayersList();
  }

  Widget buildPlayersList() {
    return ListView.separated(
      itemBuilder: (BuildContext context, index) {
        doctorsModel.sort((a, b) => (a?.user?.name ?? '')
            .toLowerCase()
            .trim()
            .compareTo((b?.user?.name ?? '').toLowerCase().trim()));
        doctorsModel.sort((a, b) => (a.isDefault
            ? (a?.user?.name ?? '')
            .toString()
            .toLowerCase().trim()
            .compareTo((b?.user?.name ?? '').toString().toLowerCase().trim())
            : 0)
            .compareTo(b.isDefault
            ? (a?.user?.name ?? '')
            .toString()
            .toLowerCase().trim()
            .compareTo((b?.user?.name ?? '').toString().toLowerCase().trim())
            : 0));
        Doctors eachDoctorModel = doctorsModel[index];
        String specialization =
            eachDoctorModel.doctorProfessionalDetailCollection != null
                ? eachDoctorModel.doctorProfessionalDetailCollection.length > 0
                    ? eachDoctorModel.doctorProfessionalDetailCollection[0]
                                .specialty !=
                            null
                        ? (eachDoctorModel.doctorProfessionalDetailCollection[0]
                                        .specialty.name !=
                                    null &&
                                eachDoctorModel
                                        .doctorProfessionalDetailCollection[0]
                                        .specialty
                                        .name !=
                                    '')
                            ? eachDoctorModel
                                .doctorProfessionalDetailCollection[0]
                                .specialty
                                .name
                            : ''
                        : ''
                    : ''
                : '';
        return InkWell(
            onTap: () {
              Navigator.pushNamed(context, router.rt_AddProvider,
                  arguments: AddProvidersArguments(
                      searchKeyWord: CommonConstants.doctors,
                      doctorsModel: eachDoctorModel,
                      fromClass: router.rt_myprovider,
                      hasData: true,
                      isRefresh: () {
                        widget.refresh();
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
                    ClipOval(
                        child: eachDoctorModel.user != null
                            ? eachDoctorModel.user.profilePicThumbnailUrl !=
                                    null
                                ? Image.network(
                                    eachDoctorModel.user.profilePicThumbnailUrl,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 50,
                                    height: 50,
                                    padding: EdgeInsets.all(12),
                                    color: Color(fhbColors.bgColorContainer))
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
                            eachDoctorModel.user != null
                                ? eachDoctorModel.user.name != null
                                    ? toBeginningOfSentenceCase(
                                        eachDoctorModel.user.name)
                                    : ''
                                : '',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 5),
                          specialization != null
                              ? AutoSizeText(
                                  specialization != null
                                      ? toBeginningOfSentenceCase(
                                          specialization)
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
                              commonWidgets
                                  .getBookMarkedIconNew(eachDoctorModel, () {
                                providerViewModel
                                    .bookMarkDoctor(
                                        eachDoctorModel, false, 'ListItem')
                                    .then((status) {
                                  if (status) {
                                    widget.refresh();
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
          height: 0,
          color: Colors.transparent,
        );
      },
      itemCount: doctorsModel.length,
    );
  }
}

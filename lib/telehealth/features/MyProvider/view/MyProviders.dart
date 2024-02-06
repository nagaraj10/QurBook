import 'package:flutter/material.dart';

import '../../../../common/CommonConstants.dart';
import '../../../../common/CommonUtil.dart';
import '../../../../common/common_circular_indicator.dart';
import '../../../../common/errors_widget.dart';
import '../../../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/router_variable.dart' as router;
import '../../../../constants/variable_constant.dart' as variable;
import '../../../../my_providers/bloc/providers_block.dart';
import '../../../../my_providers/models/Doctors.dart';
import '../../../../my_providers/models/MyProviderResponseData.dart';
import '../../../../my_providers/models/MyProviderResponseNew.dart';
import '../../../../my_providers/models/ProviderRequestCollection3.dart';
import '../../../../search_providers/models/search_arguments.dart';
import '../../../../src/utils/screenutils/size_extensions.dart';
import '../../../../styles/styles.dart' as fhbStyles;
import '../../SearchWidget/view/SearchWidget.dart';
import '../model/getAvailableSlots/AvailableTimeSlotsModel.dart';
import '../model/getAvailableSlots/SlotSessionsModel.dart';
import '../model/getAvailableSlots/Slots.dart';
import '../model/provider_model/DoctorIds.dart';
import '../viewModel/MyProviderViewModel.dart';
import 'CommonWidgets.dart';
import 'healthOrganization/HealthOrganization.dart';

class MyProviders extends StatefulWidget {
  MyProviders({super.key, this.closePage, this.isRefresh});
  Function(String)? closePage;
  bool? isRefresh;
  @override
  _MyProvidersState createState() => _MyProvidersState();
}

class _MyProvidersState extends State<MyProviders> {
  late MyProviderViewModel providerViewModel;
  int selectedPosition = 0;
  bool firstTym = false;
  String? doctorsName;
  CommonWidgets commonWidgets = CommonWidgets();
  bool isSearch = false;

  List<DoctorIds> doctorData = [];
  List<Doctors?> doctors = [];

  List<AvailableTimeSlotsModel> doctorTimeSlotsModel =
      <AvailableTimeSlotsModel>[];
  List<SlotSessionsModel> sessionTimeModel = <SlotSessionsModel>[];
  List<Slots> slotsModel = <Slots>[];
  late ProvidersBloc _providersBloc;
  MyProvidersResponse? myProvidersResponseList;
  List<Doctors?>? copyOfdoctorsModel = [];
  Future<MyProvidersResponse?>? _medicalPreferenceList;
  List<Doctors?> doctorsModelPatientAssociated = [];

  @override
  void initState() {
    super.initState();
    FABService.trackCurrentScreen(FBAMyProviderScreen);
    getDataForProvider();
    _providersBloc = ProvidersBloc();
    _medicalPreferenceList = _providersBloc.getMedicalPreferencesForDoctors();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isRefresh!) {
      providerViewModel.doctorIdsList = null;
      setState(() {
        _medicalPreferenceList =
            _providersBloc.getMedicalPreferencesForDoctors();
      });
      widget.isRefresh != widget.isRefresh;
    }
    return Scaffold(
        body: Container(
            child: Column(
          children: [
            SearchWidget(
              onChanged: (doctorsName) {
                if (doctorsName != '' && doctorsName.length > 3) {
                  isSearch = true;
                  onSearchedNew(doctorsName);
                } else {
                  setState(() {
                    isSearch = false;
                  });
                }
              },
              onClosePress: () {
                FocusManager.instance.primaryFocus!.unfocus();
              },
            ),
            Expanded(
              child: (widget.isRefresh! && myProvidersResponseList != null)
                  ? myProviderList(myProvidersResponseList)
                  : getDoctorProviderListNew(),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          heroTag: "btn2",
          onPressed: () {
            FocusManager.instance.primaryFocus!.unfocus();
            Navigator.pushNamed(
              context,
              router.rt_SearchProvider,
              arguments: SearchArguments(
                searchWord: CommonConstants.doctors,
                fromClass: router.rt_TelehealthProvider,
              ),
            ).then((value) {
              providerViewModel.doctorIdsList = null;
              setState(() {
                _medicalPreferenceList =
                    _providersBloc.getMedicalPreferencesForDoctors();
              });
            });
          },
          child: Icon(
            Icons.add,
            color: Color(CommonUtil().getMyPrimaryColor()),
            size: 24.0.sp,
          ),
        ));
  }

  void getDataForProvider() async {
    if (firstTym == false) {
      firstTym = true;
      providerViewModel = MyProviderViewModel();
    }
  }

  onSearched(String doctorName) {
    doctorData.clear();
    if (doctorName != null) {
      for (DoctorIds fiterData
          in providerViewModel.getFilterDoctorList(doctorName)) {
        doctorData.add(fiterData);
      }
    }

    setState(() {});
  }

  onSearchedNew(String doctorName) async {
    doctors.clear();
    if (doctorName != null) {
      doctors = await _providersBloc.getFilterDoctorListNew(doctorName);
    }
    setState(() {});
  }

  Widget getFees(DoctorIds doctorId) => doctorId.fees != null
      ? commonWidgets.getHospitalDetails(doctorId.fees!.consulting != null
          ? '${CommonUtil.REGION_CODE != "IN" ? variable.strDollar : variable.strRs} ${doctorId.fees!.consulting!.fee!}'
          : '')
      : const Text('');

  Widget getDoctorProviderListNew() => FutureBuilder<MyProvidersResponse?>(
        future: _medicalPreferenceList,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CommonCircularIndicator();
          } else if (snapshot.hasError) {
            return ErrorsWidget();
          } else {
            final items = snapshot.data ??
                <MyProvidersResponseData>[]; // handle the case that data is null

            return (snapshot.data != null && snapshot.data!.result != null)
                ? myProviderList(snapshot.data)
                : Container(
                    child: const Center(
                    child: Text(variable.strNoDoctordata),
                  ));
          }
        },
      );

  Widget myProviderList(MyProvidersResponse? myProvidersResponse) {
    copyOfdoctorsModel = null;
    copyOfdoctorsModel = [];
    if (myProvidersResponse!.result!.doctors != null &&
        myProvidersResponse.result!.doctors!.length > 0)
      copyOfdoctorsModel!.addAll(myProvidersResponse.result!.doctors!);

    if (myProvidersResponse != null && myProvidersResponse.isSuccess!) {
      if (myProvidersResponse.result!.providerRequestCollection3 != null &&
          myProvidersResponse.result!.providerRequestCollection3!.length > 0)
        for (ProviderRequestCollection3 providerRequestCollection3
            in myProvidersResponse.result!.providerRequestCollection3!) {
          Doctors patientAddedDoctor = providerRequestCollection3.doctor!;
          patientAddedDoctor.isPatientAssociatedRequest = true;
          doctorsModelPatientAssociated.add(providerRequestCollection3.doctor);
        }

      if (doctorsModelPatientAssociated.isNotEmpty &&
          doctorsModelPatientAssociated.length > 0) {
        copyOfdoctorsModel!.addAll(doctorsModelPatientAssociated);
      }
      final ids = copyOfdoctorsModel!.map((e) => e?.user?.id).toSet();
      copyOfdoctorsModel!.retainWhere((x) => ids.remove(x?.user?.id));
      if (copyOfdoctorsModel != null && copyOfdoctorsModel!.isNotEmpty) {
        return ListView.separated(
          itemBuilder: (BuildContext context, index) =>
              providerDoctorItemWidget(
                  index, isSearch ? doctors : copyOfdoctorsModel!),
          separatorBuilder: (BuildContext context, index) => Divider(
            height: 0.0.h,
            color: Colors.transparent,
          ),
          itemCount: isSearch ? doctors.length : copyOfdoctorsModel!.length,
        );
      } else {
        return const Center(
          child: Text(variable.strNoDoctordata),
        );
      }
    } else {
      return const Center(
        child: Text(variable.strNoDoctordata),
      );
    }
  }

  Widget providerDoctorItemWidget(int i, List<Doctors?> docs) => InkWell(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
          navigateToHelathOrganizationList(context, docs, i);
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(left: 15, right: 15, top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFe3e2e2),
                blurRadius: 16, // has the effect of softening the shadow
                spreadRadius: 5, // has the effect of extending the shadow
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: commonWidgets.getClipOvalImageNew(docs[i]),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 2,
                    child: commonWidgets.getDoctorStatusWidgetNew(docs[i]!, i),
                  )
                ],
              ),
              commonWidgets.getSizeBoxWidth(10.0.w),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            commonWidgets.setDoctorname(docs[i]!.user),
                            commonWidgets.getSizeBoxWidth(10.0.w),
                            commonWidgets.getIcon(
                                width: fhbStyles.imageWidth,
                                height: fhbStyles.imageHeight,
                                icon: Icons.info,
                                onTap: () {
                                  commonWidgets.showDoctorDetailViewNew(
                                      docs[i], context);
                                }),
                          ],
                        )),
                        commonWidgets.getSizeBoxWidth(10.0.w),
                        commonWidgets.getBookMarkedIconNew(docs[i]!, () {
                          providerViewModel
                              .bookMarkDoctor(docs[i]!, false, 'ListItem',
                                  docs[i]!.sharedCategories)
                              .then((status) {
                            if (status!) {
                              setState(() {
                                _medicalPreferenceList = _providersBloc
                                    .getMedicalPreferencesForDoctors();
                              });
                            }
                          });
                        }),
                        commonWidgets.getSizeBoxWidth(15.0.w),
                        if (docs[i]!.isTelehealthEnabled!)
                          commonWidgets.getIcon(
                              width: fhbStyles.imageWidth,
                              height: fhbStyles.imageHeight,
                              icon: Icons.check_circle,
                              onTap: () {})
                        else
                          const SizedBox(),
                      ],
                    ),
                    commonWidgets.getSizedBox(5),
                    Row(
                      children: [
                        Expanded(
                            child: (docs[i]!.doctorProfessionalDetailCollection !=
                                        null &&
                                    docs[i]!
                                            .doctorProfessionalDetailCollection!
                                            .length >
                                        0)
                                ? docs[i]!
                                            .doctorProfessionalDetailCollection![
                                                0]
                                            .specialty !=
                                        null
                                    ? docs[i]!
                                                .doctorProfessionalDetailCollection![
                                                    0]
                                                .specialty!
                                                .name !=
                                            null
                                        ? commonWidgets.getDoctoSpecialist(
                                            '${docs[i]!.doctorProfessionalDetailCollection![0].specialty!.name}')
                                        : const SizedBox()
                                    : const SizedBox()
                                : const SizedBox()),
                        commonWidgets.getSizeBoxWidth(10.0.w),
                      ],
                    ),
                    commonWidgets.getSizedBox(5.0.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          commonWidgets.getCityDoctorsModel(docs[i]!)!,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                              fontWeight: FontWeight.w200,
                              color: Colors.grey[600],
                              fontSize: fhbStyles.fnt_city),
                        )),
                        if (docs[i]!.isMciVerified!)
                          commonWidgets.getMCVerified(
                              docs[i]!.isMciVerified!, STR_MY_VERIFIED)
                        else
                          commonWidgets.getMCVerified(
                              docs[i]!.isMciVerified!, STR_NOT_VERIFIED),
                        commonWidgets.getSizeBoxWidth(10.0.w),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  void navigateToHelathOrganizationList(
      BuildContext context, List<Doctors?> docs, int i) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HealthOrganization(
            doctors: docs,
            index: i,
            closePage: (value) {
              widget.closePage!(value);
            },
          ),
        ));
  }
}

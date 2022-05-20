import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/add_provider_plan/model/AddProviderPlanResponse.dart';
import 'package:myfhb/add_provider_plan/model/ProviderOrganizationResponse.dart';
import 'package:myfhb/add_provider_plan/service/PlanProviderViewModel.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/common/firebase_analytics_service.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/plan_wizard/view/widgets/Rounded_CheckBox.dart';
import 'package:myfhb/src/ui/loader_class.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:provider/provider.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;

class AddProviderPlan extends StatefulWidget {
  String selectedTag;
  AddProviderPlan(this.selectedTag);

  @override
  AddProviderPlanState createState() => AddProviderPlanState();
}

class AddProviderPlanState extends State<AddProviderPlan> {
  Future<ProviderOrganisationResponse> providerOrganizationResult;
  List<Result> providerMainList = [];

  bool isSearch = false;

  PlanProviderViewModel planListProvider;
  List<String> selectedCategories = [];
  FlutterToast toast = new FlutterToast();

  bool isSelectedALL = false;
  bool hasData = false;

  @override
  void initState() {
    try {
// TODO: implement initState
      mInitialTime = DateTime.now();
      providerOrganizationResult =
          Provider.of<PlanProviderViewModel>(context, listen: false)
              .getCarePlanList(widget.selectedTag);
      //Provider.of<PlanProviderViewModel>(context, listen: false).hasSelectAllData=false;
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    try {
      FocusManager.instance.primaryFocus.unfocus();
      super.dispose();
      fbaLog(eveName: 'qurbook_screen_event', eveParams: {
        'eventTime': '${DateTime.now()}',
        'pageName': 'AddProviderPlan Screen',
        'screenSessionTime':
            '${DateTime.now().difference(mInitialTime).inSeconds} secs'
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    planListProvider = Provider.of<PlanProviderViewModel>(context);

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back_ios, // add custom icons also
                size: 24.0.sp,
              ),
            ),
            title: Text("Add Provider")),
        body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
                child: Column(
              children: [
                Expanded(
                  child: getPlanList(),
                ),
              ],
            )),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: EdgeInsets.only(
            //       bottom: 20.0.h,
            //     ),
            //     child: getTheRegimen(),
            //   ),
            // ),
          ],
        ));
  }

  Widget _showAddButton(List<Result> providerList) {
    final addButtonWithGesture = GestureDetector(
      onTap: () {
        try {
          _addBtnTapped(providerList);
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        width: 100.0.w,
        height: 40.0.h,
        decoration: BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: BorderRadius.all(Radius.circular(25)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            variable.Add,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: addButtonWithGesture);
  }

  Widget getPlanList() {
    return FutureBuilder<ProviderOrganisationResponse>(
      future: providerOrganizationResult,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 4.5,
              child: Center(
                child: SizedBox(
                  width: 30.0.h,
                  height: 30.0.h,
                  child: CommonCircularIndicator(),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          hasData = false;
          planListProvider.updateBool(false);

          return ErrorsWidget();
        } else {
          /*if (providerMainList != null && providerMainList.length > 0) {
            return hospitalList(providerMainList);
          } else*/
          if (snapshot?.hasData &&
              snapshot?.data?.result != null &&
              snapshot?.data?.result.isNotEmpty) {
            //providerMainList = snapshot.data.result;
            hasData = true;
            planListProvider.updateBool(true);
            return hospitalList(snapshot.data.result);
          } else {
            hasData = false;
            planListProvider.updateBool(false);

            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    child: Center(
                  child: Text(variable.strNoHospitaldata),
                )),
              ),
            );
          }
        }
      },
    );
  }

  onSearchedNew(String providerName) async {
    try {
      providerMainList.clear();
      if (providerName != null) {
        providerMainList = planListProvider.getProviderSearch(providerName);
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Widget hospitalList(List<Result> providerList) {
    return (providerList != null && providerList.length > 0)
        ? Column(
            children: [
              SearchWidget(
                onChanged: (providerName) {
                  if (providerName != '' && providerName.length > 2) {
                    isSearch = true;
                    onSearchedNew(providerName);
                  } else {
                    setState(() {
                      isSearch = false;
                    });
                  }
                },
                onClosePress: () {
                  FocusManager.instance.primaryFocus.unfocus();
                },
              ),
              SizedBox(
                height: 5.0.h,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(left: 10, right: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(),
                    ),
                    Text(
                      "Select All",
                      style: TextStyle(
                          color: Color(CommonUtil().getMyPrimaryColor())),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    RoundedCheckBox(
                      isSelected: isSelectedALL,
                      onTap: () {
                        checkIfAllIsSelectedOrNot(
                            isSearch ? providerMainList : providerList);

                        setState(() {
                          isSelectedALL = !isSelectedALL;
                        });
                      },
                    )
                  ],
                ),
                height: 50,
              ),
              SizedBox(
                height: 5.0.h,
              ),
              Expanded(
                  child: isSearch && providerMainList.length == 0
                      ? Container(
                          child: Center(
                          child: Text(variable.strNoHospitaldata),
                        ))
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                            bottom: 50.0.h,
                          ),
                          itemBuilder: (BuildContext ctx, int i) =>
                              CreateDoctorProviderCard(
                            planList: isSearch
                                ? providerMainList[i]
                                : providerList[i],
                            onClick: () {},
                          ),
                          itemCount: isSearch
                              ? providerMainList.length
                              : providerList.length,
                        )),
              _showAddButton(providerList),
              SizedBox(
                height: 5.0.h,
              ),
            ],
          )
        : SafeArea(
            child: SizedBox(
              height: 1.sh / 1.3,
              child: Container(
                  child: Center(
                child: Text(variable.strNoHospitaldata),
              )),
            ),
          );
  }

  getLogo(Result planList) {
    if ((planList.domainUrl ?? '').isNotEmpty) {
      return CircleAvatar(
        radius: 25,
        backgroundColor: const Color(fhbColors.bgColorContainer),
        child: Image.network(
          planList.domainUrl,
          height: 25.0.h,
          width: 25.0.h,
          fit: BoxFit.cover,
          errorBuilder: (context, exception, stackTrace) {
            return Container(
              height: 25.h,
              width: 25.h,
              child: Center(
                child: Text(
                  ((planList.name ?? '').isNotEmpty
                      ? planList.name[0].toUpperCase()
                      : ''),
                  style: TextStyle(
                    color: Color(
                      CommonUtil().getMyPrimaryColor(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return CircleAvatar(
        radius: 25,
        backgroundColor: const Color(fhbColors.bgColorContainer),
        child: Container(
          color: Color(fhbColors.bgColorContainer),
          height: 25.0.h,
          width: 25.0.h,
        ),
      );
    }
  }

  CreateDoctorProviderCard({Result planList, Function() onClick}) {
    String specialityName = "";
    try {
      if (planList.specialty != null && planList.specialty.length > 0) {
        specialityName = planList.specialty[0].name;
      }
    } catch (e) {}
    return InkWell(
      onLongPress: () {},
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
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
            getLogo(planList),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    planList?.name,
                    style: TextStyle(fontWeight: FontWeight.w500),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    specialityName ?? "",
                    style:
                        TextStyle(color: Colors.grey[400], fontSize: 14.0.sp),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RoundedCheckBox(
                    isSelected: planList.isBookmarked,
                    onTap: () async {

                      planList.isBookmarked = !planList.isBookmarked;
                      setState(() {});
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addBtnTapped(List<Result> providerList) async {
    try {
      addSelectedcategoriesToList(isSearch ? providerMainList : providerList);

      if (selectedCategories != null && selectedCategories.length > 0) {
        LoaderClass.showLoadingDialog(context);
        AddProviderPlanResponse response =
            await planListProvider?.addproviderPlan(selectedCategories);
        LoaderClass.hideLoadingDialog(context);
        if (response.isSuccess) {
          toast.getToast("Added Successfully", Colors.green);
          Get.back();
        }
      } else {
        toast.getToast("Please select a provider", Colors.red);
      }
    } catch (e) {
      print(e);
    }
  }

  void addSelectedcategoriesToList(List<Result> result) {
    try {
      selectedCategories = [];
      for (final mediaResultObj in result) {
        if (!selectedCategories
                .contains(mediaResultObj.healthOrganizationType.id) &&
            mediaResultObj.isBookmarked) {
          selectedCategories.add(mediaResultObj.id);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void checkIfAllIsSelectedOrNot(List<Result> providerList) {
    try {
      for (final mediaResultObj in providerList) {
        mediaResultObj.isBookmarked = !isSelectedALL;
      }
    } catch (e) {
      print(e);
    }
  }
}

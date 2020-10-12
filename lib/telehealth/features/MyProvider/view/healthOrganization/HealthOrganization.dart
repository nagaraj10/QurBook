import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/AvailableTimeSlotsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/SlotSessionsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/Slots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationResult.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/DoctorSessionTimeSlot.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

class HealthOrganization extends StatefulWidget {
  final List<Doctors> doctors;
  final int index;

  @override
  _HealthOrganizationState createState() => _HealthOrganizationState();

  HealthOrganization({this.doctors,this.index}) {}
}

class _HealthOrganizationState extends State<HealthOrganization> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  MyProviderViewModel providerViewModel;
  DateTime _selectedValue = DateTime.now();
  int selectedPosition = 0;
  bool firstTym = false;
  String doctorsName;
  CommonWidgets commonWidgets = new CommonWidgets();

  List<AvailableTimeSlotsModel> doctorTimeSlotsModel =
      new List<AvailableTimeSlotsModel>();
  List<SlotSessionsModel> sessionTimeModel = new List<SlotSessionsModel>();
  List<Slots> slotsModel = new List<Slots>();
  ProvidersBloc _providersBloc;
  MyProvidersResponse myProvidersResponseList;
  String placeHolder = null;

  @override
  void initState() {
    super.initState();
    getDataForProvider();
    _providersBloc = new ProvidersBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios, // add custom icons also
            ),
          ),
          // you can put Icon as well, it accepts any widget.
          title:
              getTitle() /* Column(
            children: [
              Text("My Providers"),
            ],
          ),
          actions: [
            Icon(Icons.notifications),
            new SwitchProfile()
                .buildActions(context, _keyLoader, callBackToRefresh),
            Icon(Icons.more_vert),
          ],*/
          ),
      body: Container(
          child: Column(
        children: [
          /* SearchWidget(
              onChanged: (doctorsName) {
                if (doctorsName != '' && doctorsName.length > 3) {
                  isSearch = true;
                  onSearched(doctorsName);
                } else {
                  setState(() {
                    isSearch = false;
                  });
                }
              },
            ),*/
          Expanded(
            child: (providerViewModel.healthOrganizationResult != null &&
                    providerViewModel.healthOrganizationResult.length > 0)
                ? providerListWidget(providerViewModel.healthOrganizationResult)
                : getHospitalProviderList(widget.doctors[widget.index].id),
            /*:Container(
                    child: Center(
                      child: Text(variable.strNoDoctordata),
                    ),
                  ),*/
          )
        ],
      )),
      /*floatingActionButton: FloatingActionButton(
          onPressed: () {
            //PageNavigator.goTo(context, '/add_appointments');

            Navigator.pushNamed(context, router.rt_SearchProvider,
                arguments: SearchArguments(
                  searchWord: CommonConstants.doctors,
                  fromClass: router.cn_teleheathProvider,
                )).then((value) {
              providerViewModel.doctorIdsList = null;
              setState(() {});
            });
          },
          child: Icon(
            Icons.add,
            color: Color(new CommonUtil().getMyPrimaryColor()),
          ),
        )*/
    );
  }

  Widget getTitle() {
    return Row(
      children: [
        Expanded(
          child: Text(
            HealthOrg,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        /*Icon(Icons.notifications),
        new SwitchProfile()
            .buildActions(context, _keyLoader, callBackToRefresh),*/
        // Icon(Icons.more_vert),
      ],
    );
  }

  Widget hospitalListItem(
      BuildContext ctx, int i, List<HealthOrganizationResult> docs) {
    return ExpandableNotifier(
      child: Container(
        padding: EdgeInsets.all(2.0),
        margin: EdgeInsets.only(left: 12, right: 12, top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFe3e2e2),
              blurRadius: 16, // has the effect of softening the shadow
              spreadRadius: 5.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: Expandable(
          collapsed: collapseListItem(ctx, i, docs),
          expanded: expandedListItem(ctx, i, docs),
        ),
      ),
    );
  }

  Widget collapseListItem(
      BuildContext ctx, int i, List<HealthOrganizationResult> docs) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: ExpandableButton(
        child: getHospitalWidget(i, docs),
      ),
    );
  }

  Widget expandedListItem(
      BuildContext ctx, int i, List<HealthOrganizationResult> docs) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      child: ExpandableButton(
        child: Column(
          children: [
            getHospitalWidget(i, docs),
            commonWidgets.getSizedBox(20.0),
            DoctorSessionTimeSlot(
                date: _selectedValue.toString(),
                doctorId: widget.doctors[widget.index].id,
                docs: widget.doctors,
                isReshedule: false,
                i: i,
                healthOrganizationId: docs[i].healthOrganization.id,
                healthOrganizationResult: docs,
                doctorListPos: widget.index,
            ),
          ],
        ),
      ),
    );
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
  }

  Widget getHospitalWidget(
      int i, List<HealthOrganizationResult> eachHospitalModel) {
    return Row(
      children: <Widget>[
        placeHolder != null
            ? ClipOval(
                child: Image.network(
                placeHolder,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ))
            : CircleAvatar(
                backgroundColor: Colors.greenAccent,
                child: Icon(Icons.local_hospital)),
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
                eachHospitalModel[i].healthOrganization.name != null
                    ? toBeginningOfSentenceCase(
                        eachHospitalModel[i].healthOrganization.name)
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
                 ''+commonWidgets.getCity(eachHospitalModel[i]),
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
                    flex: 3,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: TextWidget(
                                  text:'INR '+commonWidgets.getMoneyWithForamt(getFees(eachHospitalModel[i])),
                                  fontsize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  colors: Colors.blue[800]),
                            ),
                          ),
                        ],
                      ),
                    )),
      ],
    );
  }

  void getDataForProvider() async {
    if (firstTym == false) {
      firstTym = true;
      providerViewModel = new MyProviderViewModel();
    }
  }

  String getFees(HealthOrganizationResult result) {

    String fees;
    if(result.doctorFeeCollection.isNotEmpty){
      if(result.doctorFeeCollection.length>0){
        for(int i = 0;i<result.doctorFeeCollection.length;i++){
          String feesCode = result.doctorFeeCollection[i].feeType.code;
          if(feesCode==CONSULTING){
             fees = result.doctorFeeCollection[i].fee;
          }else{
            fees = '';
          }
        }
      }else{
        fees = '';
      }
    }else{
      fees = '';
    }
    return fees;
  }

  Widget getHospitalProviderList(String doctorId) {
    return new FutureBuilder<List<HealthOrganizationResult>>(
      future: providerViewModel.getHealthOrgFromDoctor(doctorId),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Center(
            child: new CircularProgressIndicator(
              backgroundColor: Colors.grey,
            ),
          );
        } else if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else {
          final items = snapshot.data ??
              <DoctorIds>[]; // handle the case that data is null

          return providerListWidget(snapshot.data);
        }
      },
    );
  }

  Widget providerListWidget(List<HealthOrganizationResult> hospitalList) {
    return (hospitalList != null && hospitalList.length > 0)
        ? new ListView.builder(
            itemBuilder: (BuildContext ctx, int i) =>
                hospitalListItem(ctx, i, hospitalList),
            itemCount: hospitalList.length,
          )
        : Container(
            child: Center(
              child: Text(variable.strNoHospitaldata),
            ),
          );
  }
}

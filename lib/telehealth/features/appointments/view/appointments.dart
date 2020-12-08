import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart'
    as Constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/appointmentsModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/view/DoctorUpcomingAppointments.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsCommonWidget.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/appointmentsListViewModel.dart';
import 'package:myfhb/telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DoctorPastAppointments.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  ChatViewModel chatViewModel = ChatViewModel();
  TextEditingController _searchQueryController = TextEditingController();
  AppointmentsListViewModel appointmentsViewModel;
  AppointmentsCommonWidget commonWidget = AppointmentsCommonWidget();
  List<Past> upcomingInfo = List();
  List<String> bookingIds = new List();
  List<Past> historyInfo = List();
  bool isSearch = false;
  List<Past> upcomingTimeInfo = List();
  SharedPreferences prefs;
  Function(String) closePage;
  final GlobalKey<State> _key = new GlobalKey<State>();

  @override
  void initState() {
    //commonWidget.getCategoryPosition(Constants.STR_NOTES);
    Provider.of<AppointmentsListViewModel>(context, listen: false)
        .fetchAppointments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: body(),
        appBar: appBar(),
        floatingActionButton: commonWidget.floatingButton(context));
  }

  Widget search() {
    appointmentsViewModel =
        Provider.of<AppointmentsListViewModel>(context, listen: false);
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Padding(
          padding: EdgeInsets.only(top: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 40),
                  decoration: BoxDecoration(
                      color: Color(fhbColors.cardShadowColor),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: TextField(
                    controller: _searchQueryController,
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black54,
                      ),
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black45, fontSize: 12),
                    ),
                    style: TextStyle(color: Colors.black54, fontSize: 16.0),
                    onChanged: (value) {
                      if (value.trim().length > 1) {
                        setState(() {
                          isSearch = true;
                          upcomingInfo = appointmentsViewModel
                              .filterSearchResults(value)
                              .upcoming;
                          historyInfo = appointmentsViewModel
                              .filterSearchResults(value)
                              .past;
                        });
                      } else {
                        setState(() {
                          isSearch = false;
                          upcomingInfo.clear();
                          historyInfo.clear();
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget body() {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBoxWidget(
                width: 0,
                height: 20,
              ),
              search(),
              getDoctorsAppoinmentsList()
            ],
          )),
    );
  }

  Widget getDoctorsAppoinmentsList() {
    var appointmentData = Provider.of<AppointmentsListViewModel>(context);
    switch (appointmentData.loadingStatus) {
      case LoadingStatus.searching:
        return new Center(
          child: new CircularProgressIndicator(
              backgroundColor:
              Color(new CommonUtil().getMyPrimaryColor())
          ),
        );
      case LoadingStatus.completed:
        return Consumer<AppointmentsListViewModel>(
          builder: (context, appointmentsViewModel, child) {
            final AppointmentsModel appointmentsData =
                appointmentsViewModel.appointments;
            if (appointmentsData != null) {
              return ((appointmentsData?.result?.past != null &&
                          appointmentsData?.result?.past?.length > 0) ||
                      (appointmentsData?.result?.upcoming != null &&
                          appointmentsData?.result?.upcoming?.length > 0))
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBoxWidget(
                          width: 0,
                          height: 10,
                        ),
                        isSearch
                            ? (upcomingInfo != null && upcomingInfo.length != 0)
                                ? commonWidget
                                    .title(Constants.Appointments_upcoming)
                                : Container()
                            : (appointmentsData.result.upcoming != null &&
                                    appointmentsData.result.upcoming.length !=
                                        0)
                                ? commonWidget
                                    .title(Constants.Appointments_upcoming)
                                : Container(),
                        SizedBoxWidget(
                          width: 0,
                          height: 10,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext ctx, int i) {
                            appointmentsData.result.upcoming.sort((a, b) =>
                                a.plannedStartDateTime.compareTo(
                                    b.plannedStartDateTime.toLowerCase()));
                            upcomingInfo.sort((a, b) => a.plannedStartDateTime
                                .compareTo(
                                    b.plannedStartDateTime.toLowerCase()));
                            return DoctorUpcomingAppointments(
                                doc: isSearch
                                    ? upcomingInfo[i]
                                    : appointmentsData.result.upcoming[i],
                                onChanged: (value) {
                                  refreshAppointments();
                                });
                          },
                          itemCount: !isSearch
                              ? appointmentsData.result.upcoming.length
                              : upcomingInfo.length,
                        ),
                        SizedBoxWidget(
                          width: 0,
                          height: 10,
                        ),
                        isSearch
                            ? (historyInfo != null && historyInfo.length != 0)
                                ? commonWidget
                                    .title(Constants.Appointments_history)
                                : Container()
                            : (appointmentsData.result.past != null &&
                                    appointmentsData.result.past.length != 0)
                                ? commonWidget
                                    .title(Constants.Appointments_history)
                                : Container(),
                        SizedBoxWidget(
                          width: 0,
                          height: 10,
                        ),
                        (appointmentsData?.result?.past != null &&
                                appointmentsData?.result?.past.length > 0)
                            ? new ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctx, int i) {
                                  appointmentsData.result.past.sort((b, a) => a
                                      .plannedStartDateTime
                                      .compareTo(b.plannedStartDateTime
                                          .toLowerCase()));
                                  historyInfo.sort((b, a) => a
                                      .plannedStartDateTime
                                      .compareTo(b.plannedStartDateTime
                                          .toLowerCase()));
                                  return DoctorPastAppointments(
                                      doc: isSearch
                                          ? historyInfo[i]
                                          : appointmentsData.result.past[i],
                                      onChanged: (value) {
                                        refreshAppointments();
                                      },closePage: (value){
                                       Navigator.pop(context);
                                  },);
                                },
                                itemCount: isSearch
                                    ? historyInfo.length
                                    : appointmentsData.result.past.length,
                              )
                            : Container()
                      ],
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height / 2,
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(variable.strNoAppointments),
                      ),
                    );
            } else {
              return new Center(
                child: new CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                ),
              );
            }
          },
        );
      case LoadingStatus.empty:
      default:
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          alignment: Alignment.center,
          child: Center(
            child: Text(variable.strNoAppointments),
          ),
        );
    }
  }

  Widget appBar() {
    return AppBar(
        flexibleSpace: GradientAppBar(),
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBoxWidget(
              height: 0,
              width: 30,
            ),
            IconWidget(
              icon: Icons.arrow_back_ios,
              colors: Colors.white,
              size: 20,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        title: getTitle());
  }

  Widget getTitle() {
    return Row(
      children: [
        Expanded(
          child: TextWidget(
            text: Constants.Appointments_Title,
            colors: Colors.white,
            overflow: TextOverflow.visible,
            fontWeight: FontWeight.w600,
            fontsize: 18,
            softwrap: true,
          ),
        ),
        IconWidget(
          icon: Icons.notifications,
          colors: Colors.white,
          size: 22,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationMain()),
            );
          },
        ),
        SwitchProfile().buildActions(context, _key, callBackToRefresh),
        // IconWidget(
        //   icon: Icons.more_vert,
        //   colors: Colors.white,
        //   size: 24,
        //   onTap: () {},
        // ),
      ],
    );
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
    refreshAppointments();
  }

  void refreshAppointments(){
    Provider.of<AppointmentsListViewModel>(
        context,
        listen: false)
      ..clearAppointments()
      ..fetchAppointments();
  }
}

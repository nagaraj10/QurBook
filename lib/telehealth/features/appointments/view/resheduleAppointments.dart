import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/DoctorSessionTimeSlot.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart' as Constants;
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsCommonWidget.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';

class ResheduleAppointments extends StatefulWidget {
  Past doc;
  bool isReshedule;

  ResheduleAppointments({this.doc, this.isReshedule});

  @override
  _ResheduleAppointmentsState createState() => _ResheduleAppointmentsState();
}

class _ResheduleAppointmentsState extends State<ResheduleAppointments> {
  DateTime _selectedValue = DateTime.now();
  CommonWidgets commonWidgets = CommonWidgets();
  AppointmentsCommonWidget appointmentsCommonWidget =
      AppointmentsCommonWidget();
  MyProviderViewModel providerViewModel = MyProviderViewModel();
  List<DoctorIds> doctorIdsList = new List();
  DoctorIds docs = DoctorIds();
  bool noData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MyProviderViewModel providerViewModel =
        Provider.of<MyProviderViewModel>(context, listen: false);
    providerViewModel.fetchProviderDoctors().then((value) => setState(() {
          doctorIdsList = value;
          docs = doctorIdsList
              .firstWhere((element) => element.id == widget.doc.doctor.id);
          noData = docs.name == null ? true : false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: docs.name == null
          ? Center(
              child: new CircularProgressIndicator(
                backgroundColor: Colors.grey,
              ),
            )
          : Container(
              child: Column(
              children: <Widget>[
                Expanded(child: doctorsListItem(context, 0, [docs])),
              ],
            )),
    );
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
      title: TextWidget(
        text: widget.doc.doctor.user.name ?? '',
        colors: Colors.white,
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.w600,
        fontsize: 18,
        softwrap: true,
      ),
    );
  }

  Widget doctorsListItem(BuildContext ctx, int i, List<DoctorIds> docs) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext ctx, int i) => ExpandableNotifier(
          initialExpanded: false,
          child: Container(
            padding: EdgeInsets.all(2.0),
            margin: EdgeInsets.only(left: 20, right: 20, top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFe3e2e2),
                  blurRadius: 16,
                  spreadRadius: 5.0,
                  offset: Offset(
                    0.0,
                    0.0,
                  ),
                )
              ],
            ),
            child: Expandable(
              collapsed: collapseListItem(ctx, i, docs),
              expanded: expandedListItem(ctx, i, docs),
            ),
          )),
    );
  }

  Widget collapseListItem(BuildContext ctx, int i, List<DoctorIds> docs) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: ExpandableButton(
        child: getDoctorsWidget(i, docs),
      ),
    );
  }

  Widget getDoctorsWidget(int i, List<DoctorIds> docs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: commonWidgets.getClipOvalImageNew(
                  docs[i].profilePicThumbnailURL, fhbStyles.cardClipImage),
            ),
            new Positioned(
              bottom: 0.0,
              right: 2.0,
              child: commonWidgets.getDoctorStatusWidget(docs[i], i),
            )
          ],
        ),
        commonWidgets.getSizeBoxWidth(10.0),
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
                      commonWidgets.getTextForDoctors('${docs[i].name}'),
                      commonWidgets.getSizeBoxWidth(10.0),
                      commonWidgets.getIcon(
                          width: fhbStyles.imageWidth,
                          height: fhbStyles.imageHeight,
                          icon: Icons.info,
                          onTap: () {
                            commonWidgets.showDoctorDetailView(
                                docs[i], context);
                          }),
                    ],
                  )),
                  docs[i].isActive
                      ? commonWidgets.getIcon(
                          width: fhbStyles.imageWidth,
                          height: fhbStyles.imageHeight,
                          icon: Icons.check_circle,
                          onTap: () {})
                      : SizedBox(),
                  commonWidgets.getSizeBoxWidth(15.0),
                  /*commonWidgets.getBookMarkedIcon(docs[i], () {
                    providerViewModel
                        .bookMarkDoctor(!(docs[i].isDefault), docs[i])
                        .then((status) {
                      if (status) {
                        providerViewModel.doctorIdsList.clear();
                        setState(() {});
                      }
                    });
                  }),*/
                  commonWidgets.getSizeBoxWidth(10.0),
                ],
              ),
              commonWidgets.getSizedBox(5.0),
              Row(children: [
                Expanded(
                    child: docs[i].professionalDetails != null
                        ? docs[i].professionalDetails[0].specialty != null
                            ? docs[i].professionalDetails[0].specialty.name !=
                                    null
                                ? commonWidgets.getDoctoSpecialist(
                                    '${docs[i].professionalDetails[0].specialty.name}')
                                : SizedBox()
                            : SizedBox()
                        : SizedBox()),
                docs[i].fees != null
                    ? docs[i].fees.consulting != null
                        ? (docs[i].fees.consulting != null &&
                                docs[i].fees.consulting != '')
                            ? commonWidgets.getDoctoSpecialist(
                                'INR ${docs[i].fees.consulting.fee}')
                            : SizedBox()
                        : SizedBox()
                    : SizedBox(),
                commonWidgets.getSizeBoxWidth(10.0),
              ]),
              commonWidgets.getSizedBox(5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child:
                          commonWidgets.getDoctorsAddress('${docs[i].city}')),
                  docs[i].isMCIVerified
                      ? commonWidgets.getMCVerified(
                          docs[i].isMCIVerified, Constants.VERIFIED)
                      : commonWidgets.getMCVerified(
                          docs[i].isMCIVerified, Constants.NOT_VERIFIED),
                  commonWidgets.getSizeBoxWidth(10.0),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget expandedListItem(BuildContext ctx, int i, List<DoctorIds> docs) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      child: ExpandableButton(
        child: Column(
          children: [
            getDoctorsWidget(i, docs),
            commonWidgets.getSizedBox(20.0),
           /* DoctorSessionTimeSlot(
                isReshedule: widget.isReshedule,
                date: _selectedValue.toString(),
                doctorId: docs[i].id,
                docs: docs,
//                doctorsData: widget.doc,
                i: i),*/
          ],
        ),
      ),
    );
  }
}

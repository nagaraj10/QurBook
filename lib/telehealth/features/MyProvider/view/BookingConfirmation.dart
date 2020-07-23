import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/TelehealthProviderModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/MyProviders.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/styles/styles.dart' as fhbStyles;

class DoctorDetail extends StatefulWidget {

  final List<DoctorIds> docs;
  final int i;

  DoctorDetail({this.docs,this.i});

  @override
  _DoctorDetail createState() => _DoctorDetail();
}

class _DoctorDetail extends State<DoctorDetail> {

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  CommonWidgets commonWidgets = new CommonWidgets();
  MyProviderViewModel providerViewModel;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(flexibleSpace: GradientAppBar(),
          title: getTitle('Confirmation Details'),),
        body: Container(
          padding: EdgeInsets.all(2.0),
          //child: getDoctorsWidget(),
        ),
    );
  }

  Widget getTitle(String title) {
    return Row(
      children: [
        Expanded(
          child: Text(title),
        ),
        Icon(Icons.notifications),
        new SwitchProfile()
            .buildActions(context, _keyLoader, callBackToRefresh),
      ],
    );
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
  }

  Widget getDoctorsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: commonWidgets.getClipOvalImageNew(
                  widget.docs[widget.i].profilePicThumbnail, fhbStyles.cardClipImage),
            ),
            new Positioned(
              bottom: 0.0,
              right: 2.0,
              child: commonWidgets.getDoctorStatusWidget(widget.docs[widget.i], widget.i),
            )
          ],
        ),
        commonWidgets.getSizeBoxWidth(10.0),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                      child: Row(
                        children: [
                          commonWidgets.getTextForDoctors('${widget.docs[widget.i].name}'),
                          commonWidgets.getSizeBoxWidth(10.0),
                          commonWidgets.getIcon(
                              width: fhbStyles.imageWidth,
                              height: fhbStyles.imageHeight,
                              icon: Icons.info,
                              onTap: () {
                               
                                commonWidgets.showDoctorDetailView(
                                    widget.docs[widget.i], context);
                              }),
                        ],
                      )),
                  widget.docs[widget.i].isActive
                      ? commonWidgets.getIcon(
                      width: fhbStyles.imageWidth,
                      height: fhbStyles.imageHeight,
                      icon: Icons.check_circle,
                      onTap: () {
                        
                      })
                      : SizedBox(),
                  commonWidgets.getSizeBoxWidth(15.0),
                  commonWidgets.getBookMarkedIcon(widget.docs[widget.i], () {
                    providerViewModel
                        .bookMarkDoctor(!(widget.docs[widget.i].isDefault), widget.docs[widget.i])
                        .then((status) {
                      if (status) {
                        setState(() {});
                      }
                    });
                  }),
                  commonWidgets.getSizeBoxWidth(10.0),
                ],
              ),
              commonWidgets.getSizedBox(5.0),
              Row(children: [
                commonWidgets.getDoctoSpecialist('${widget.docs[widget.i].specialization}'),
              ]),
              commonWidgets.getSizedBox(5.0),
              commonWidgets.getDoctorsAddress('${widget.docs[widget.i].city}')
            ],
          ),
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/landing/view/widgets/landing_card.dart';
import 'package:myfhb/src/utils/alert.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/ticket_support/model/ticket_types_model.dart';
import 'package:myfhb/ticket_support/view/ticket_types_screen.dart';
import 'package:myfhb/ticket_support/view/tickets_list_view.dart';
import 'package:myfhb/ticket_support/view_model/tickets_view_model.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart' as tckConstants;
import 'package:myfhb/colors/fhb_colors.dart' as colors;
import '../../widgets/GradientAppBar.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart'
    as constants;
import '../../src/utils/screenutils/size_extensions.dart';
import 'my_tickets_screen.dart';
import '../../src/utils/FHBUtils.dart';
import '../../constants/variable_constant.dart' as variable;

class CreateTicketScreen extends StatefulWidget {
  CreateTicketScreen(this.ticketList);

  final ticketList;

  @override
  State createState() {
    return _CreateTicketScreenState();
  }
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  TicketViewModel ticketViewModel = TicketViewModel();
  DateTime dateTime = DateTime.now();
  var preferredDateStr;

  final preferredDateController = TextEditingController(text: '');
  final titleController = TextEditingController();
  final descController = TextEditingController();
  FocusNode preferredDateFocus = FocusNode();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  GlobalKey<ScaffoldState> scaffold_state = GlobalKey<ScaffoldState>();

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        initialDatePickerMode: DatePickerMode.day,
        context: context,
        initialDate: dateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        dateTime = picked ?? dateTime;
        preferredDateStr =
            FHBUtils().getPreferredDateString(dateTime.toString());
        preferredDateController.text = preferredDateStr;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getInitialDate(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        elevation: 0,
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(tckConstants.strAddMyTicket),
      ),
      body: ListView(
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Text(tckConstants.strTicketTitle,
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      autofocus: false,
                      controller: titleController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(width: 0, color: Colors.white),
                        ),
                        enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(
                                  new CommonUtil().getMyPrimaryColor()),),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Text(tckConstants.strTicketDesc,
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      autofocus: false,
                      maxLines: 10,
                      controller: descController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(width: 0, color: Colors.white),
                        ),
                        enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(
                                  new CommonUtil().getMyPrimaryColor()),),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Text(tckConstants.strTicketPreferredDate,
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      child: TextFormField(
                        autofocus: false,
                        enableInteractiveSelection: false,
                        readOnly: true,
                        controller: preferredDateController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          suffixIcon: IconButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            iconSize: 15,
                            icon: ShaderMask(
                              blendMode: BlendMode.srcATop,
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      Color(
                                          new CommonUtil().getMyGredientColor())
                                    ]).createShader(bounds);
                              },
                              child: Image.asset(
                                'assets/icons/05.png',
                                // color: Color(CommonUtil().getMyPrimaryColor())
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide:
                                BorderSide(width: 0, color: Colors.white),
                          ),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(color: getColorFromHex('#fffff')),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            FHBUtils().check().then((internet) {
                              if (internet != null && internet) {
                                _validateAndCreateTicket(
                                    context, widget.ticketList);
                              } else {
                                FHBBasicWidget().showInSnackBar(
                                    tckConstants.STR_NO_CONNECTIVITY,
                                    scaffold_state);
                              }
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            padding: EdgeInsets.all(15.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.shade200,
                                      offset: Offset(2, 4),
                                      blurRadius: 5,
                                      spreadRadius: 2)
                                ],
                                gradient: LinearGradient(

                                    // end: Alignment.topCenter,
                                    stops: [0.3, 1.0],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(CommonUtil().getMyPrimaryColor()),
                                      Color(CommonUtil().getMyGredientColor()),
                                    ])),
                            child: Text(
                              tckConstants.strSubmitNewTicket,
                              style: TextStyle(
                                  fontSize: 16.0.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndCreateTicket(var context, var ticketListData) {
    CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);
    if (titleController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        preferredDateController.text.isNotEmpty) {
      tckConstants.tckTitle = titleController.text.toString();
      tckConstants.tckDesc = descController.text.toString();
      tckConstants.tckPrefDate = preferredDateController.text.toString();
      tckConstants.ticketType = ticketListData.id;
      tckConstants.tckPriority = ticketListData.id;

      ticketViewModel.createTicket().then((value) {
        if (value != null) {
          Navigator.of(context, rootNavigator: true).pop();
          print('Hitting API .. : ${value.toJson()}');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyTicketsListScreen()),
          );
        }
      }).catchError((error) {
        Navigator.of(context, rootNavigator: true).pop();
        print('Error Occured : $error');
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Alert.displayAlert(context,
          title: variable.Error, content: CommonConstants.all_fields);
    }
  }

  void _getInitialDate(BuildContext context) {
    preferredDateStr = FHBUtils().getPreferredDateString(dateTime.toString());
    preferredDateController.text = preferredDateStr;
  }
}

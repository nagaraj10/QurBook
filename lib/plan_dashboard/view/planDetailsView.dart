import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:path/path.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:get/get.dart';

class MyPlanDetailView extends StatefulWidget {
  final String title;
  final String description;
  final String price;
  final String issubscription;
  final String packageId;
  final String providerName;
  final String packageDuration;
  final String providerId;
  final bool isDisable;

  MyPlanDetailView({
    Key key,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.issubscription,
    @required this.packageId,
    @required this.providerName,
    @required this.packageDuration,
    @required this.providerId,
    @required this.isDisable,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlanDetail();
  }
}

class PlanDetail extends State<MyPlanDetailView> {
  String title;
  String description;
  String price;
  String issubscription;
  String packageId;
  String providerName;
  String packageDuration;
  String providerId;
  bool isDisable;

  @override
  void initState() {
    super.initState();
    setValues();
  }

  void setValues() {
    title = widget.title;
    description = widget.description;
    price = widget.price;
    issubscription = widget.issubscription;
    packageId = widget.packageId;
    providerName = widget.providerName;
    packageDuration = widget.packageDuration;
    providerId = widget.providerId;
    isDisable = widget.isDisable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios, // add custom icons also
            size: 24.0,
          ),
        ),
        title: Text(
          'Plans',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Builder(
        builder: (contxt) =>
            Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/launcher/myfhb1.png'),
                      radius: 50.sp,
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      title != null && title != '' ? title : '-',
                      style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      providerName != null && providerName != ''
                          ? providerName
                          : '-',
                      style: TextStyle(
                          fontSize: 14.sp, color: Colors.grey[600]),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Duration: ',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14.sp),
                            ),
                            Text(
                              packageDuration != null && packageDuration != ''
                                  ? '$packageDuration days'
                                  : '-',
                              style: TextStyle(
                                  color: Color(
                                      CommonUtil().getMyPrimaryColor()),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              'Price: ',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14.sp),
                            ),
                            Text(
                              price != null && price != '' ? 'INR $price' : '-',
                              style: TextStyle(
                                  color: Color(
                                      CommonUtil().getMyPrimaryColor()),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      height: 0.55.sh,
                      child: SingleChildScrollView(
                        child: Html(
                          data: description.replaceAll('src="//', 'src="'),
                          shrinkWrap: true,
                          onLinkTap: (linkUrl) {
                            CommonUtil()
                                .openWebViewNew(widget.title, linkUrl, false);
                          },
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlineButton(
                          //hoverColor: Color(getMyPrimaryColor()),
                          child: Text(
                            issubscription == '0'
                                ? 'subscribe'.toUpperCase()
                                : 'unsubscribe'.toUpperCase(),
                            style: TextStyle(
                              color: getTextColor(isDisable, issubscription),
                              fontSize: 13.sp,
                            ),
                          ),
                          onPressed: isDisable
                              ? null
                              : () async {
                            if (issubscription == '0') {
                              CommonUtil().profileValidationCheck(contxt,
                                  packageId: packageId,
                                  isSubscribed: issubscription,
                                  isFrom: strIsFromSubscibe,
                                  providerId: providerId);
                            } else {
                              CommonUtil().unSubcribeAlertDialog(context,
                                  packageId: packageId, refresh: () {
                                    setState(() {});
                                  });
                            }
                          },
                          borderSide: BorderSide(
                            color: issubscription == '0' ? Color(
                              CommonUtil().getMyPrimaryColor(),
                            ) : Colors.red,
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        OutlineButton(
                          //hoverColor: Color(getMyPrimaryColor()),
                          child: Text(
                            'cancel'.toUpperCase(),
                            style: TextStyle(
                              color: Color(CommonUtil().getMyPrimaryColor()),
                              fontSize: 13.sp,
                            ),
                          ),
                          onPressed: () async {
                            // open profile page
                            Navigator.of(context).pop();
                          },
                          borderSide: BorderSide(
                            color: Color(
                              CommonUtil().getMyPrimaryColor(),
                            ),
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Color getTextColor(bool disable, String isSubscribe) {
    if (isDisable) {
      return Colors.grey;
    } else {
      if (isSubscribe == '0') {
        return Color(CommonUtil().getMyPrimaryColor());
      } else {
        return Colors.red;
      }
    }
  }
}

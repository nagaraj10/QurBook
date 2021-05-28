import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/myPlan/model/myPlanDetailModel.dart';
import 'package:myfhb/myPlan/viewModel/myPlanViewModel.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:path_provider/path_provider.dart';

class MyPlanDetail extends StatefulWidget {
  final String title;
  final String providerName;
  final String docName;
  final String startDate;
  final String endDate;
  final String packageId;
  final String isExpired;
  final String icon;
  final String catIcon;
  final String providerIcon;
  final String descriptionURL;

  MyPlanDetail(
      {Key key,
      @required this.title,
      @required this.providerName,
      @required this.docName,
      @required this.startDate,
      @required this.endDate,
      @required this.packageId,
      @required this.isExpired,
      @required this.icon,
      @required this.catIcon,
      @required this.providerIcon,
      @required this.descriptionURL})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlanDetail();
  }
}

class PlanDetail extends State<MyPlanDetail> {
  MyPlanViewModel myPlanViewModel = new MyPlanViewModel();

  String title;
  String providerName;
  String docName;
  String startDate;
  String endDate;
  String packageId;
  String isExpired;
  String icon = '';
  String catIcon = '';
  String providerIcon = '';
  String descriptionURL = '';

  InAppWebViewController webView;

  @override
  void initState() {
    super.initState();
    setValues();
  }

  void setValues() {
    title = widget.title;
    providerName = widget.providerName;
    docName = widget.docName;
    startDate = widget.startDate;
    endDate = widget.endDate;
    packageId = widget.packageId;
    isExpired = widget.isExpired;
    icon = widget.icon;
    catIcon = widget.catIcon;
    providerIcon = widget.providerIcon;
    descriptionURL = widget.descriptionURL;
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
              size: 24.0.sp,
            ),
          ),
          title: Text(
            'My Plan',
            style: TextStyle(
              fontSize: 18.0.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: getMainWidget());
  }

  Widget getMainWidget() {
    return Builder(
      builder: (contxt) => Container(
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        radius: 26,
                        child: CommonUtil().customImage(getImage())),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title != null && title != ''
                              ? toBeginningOfSentenceCase(title)
                              : '-',
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          providerName != null && providerName != ''
                              ? toBeginningOfSentenceCase(providerName)
                              : '-',
                          style: TextStyle(
                              fontSize: 16.sp, color: Colors.grey[600]),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                            docName != null && docName != ''
                                ? toBeginningOfSentenceCase(docName)
                                : '-',
                            style: TextStyle(fontSize: 16.sp)),
                        SizedBox(
                          height: 3.h,
                        ),
                        Row(
                          children: [
                            Text("Start Date: ", style: TextStyle(fontSize: 9)),
                            Text(
                                startDate != null && startDate != ''
                                    ? new CommonUtil()
                                        .dateFormatConversion(startDate)
                                    : '-',
                                style: TextStyle(
                                    fontSize: 9, fontWeight: FontWeight.bold)),
                            SizedBox(width: 5),
                            Text("End Date: ", style: TextStyle(fontSize: 9)),
                            Text(
                                endDate != null && endDate != ''
                                    ? new CommonUtil()
                                        .dateFormatConversion(endDate)
                                    : '-',
                                style: TextStyle(
                                    fontSize: 9, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              descriptionURL != null && descriptionURL != ''
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: 0.65.sh,
                      child: InAppWebView(
                          initialUrl: "${descriptionURL}",
                          initialHeaders: {},
                          initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(
                                debuggingEnabled: true,
                                useOnDownloadStart: true),
                          ),
                          onWebViewCreated: (controller) {
                            webView = controller;
                          },
                          onLoadStart: (InAppWebViewController controller,
                              String url) {},
                          onLoadStop: (InAppWebViewController controller,
                              String url) {},
                          onDownloadStart: (controller, url) async {
                            final taskId = await FlutterDownloader.enqueue(
                              url: url,
                              savedDir:
                                  (await getExternalStorageDirectory()).path,
                              showNotification: true,
                              // show download progress in status bar (for Android)
                              openFileFromNotification:
                                  true, // click on notification to open downloaded file (for Android)
                            );
                          }),
                      //),
                    )
                  : Column(
                    children: [
                      SizedBox(height: 20.h),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[400])
                              ),
                              height: 0.55.sh,
                              width: 0.42.sh,
                              child:
                                  Center(child: Text('Content is getting ready')),
                              //),
                            ),
                          ],
                        ),
                    ],
                  ),
              SizedBox(height: 5.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlineButton(
                    child: Text(
                      isExpired == '1' ? strIsRenew : strUnSubscribe,
                      style: TextStyle(
                        color: isExpired == '1'
                            ? Color(new CommonUtil().getMyPrimaryColor())
                            : Colors.red,
                        fontSize: 13.sp,
                      ),
                    ),
                    onPressed: () async {
                      if (isExpired == '1') {
                        CommonUtil().renewAlertDialog(context,
                            packageId: packageId);
                      } else {
                        CommonUtil().unSubcribeAlertDialog(context,
                            packageId: packageId);
                      }
                    },
                    borderSide: BorderSide(
                      color: isExpired == '1'
                          ? Color(new CommonUtil().getMyPrimaryColor())
                          : Colors.red,
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
    );
  }

  ///// removed activities list for new UI screen changed

  /*Widget getActivityList() {
    return new FutureBuilder<MyPlanDetailModel>(
      future: myPlanViewModel.getMyPlanDetails(packageId),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 4.5,
              child: new Center(
                child: SizedBox(
                  width: 20.0.h,
                  height: 20.0.h,
                  child: new CircularProgressIndicator(
                      strokeWidth: 1.0,
                      backgroundColor:
                      Color(new CommonUtil().getMyPrimaryColor())),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          if (snapshot?.hasData &&
              snapshot?.data?.result != null &&
              snapshot?.data?.result?.length > 0) {
            return activitiesList(snapshot.data.result);
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 5.0,
                child: Container(
                    child: Center(
                      child: Text(
                        variable.strNoActivities,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    )),
              ),
            );
          }
        }
      },
    );
  }

  Widget activitiesList(List<MyPlanDetailResult> actList) {
    return (actList != null && actList.length > 0)
        ? new Container(
      constraints: BoxConstraints(minHeight: 20, maxHeight: 280),
      margin: new EdgeInsets.symmetric(horizontal: 50.0),
      child: Scrollbar(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: actList.length,
          itemBuilder: (BuildContext ctx, int i) =>
              getEventCardWidget(ctx, i, actList),
        ),
      ),
    )
        : SafeArea(
      child: SizedBox(
        height: 1.sh / 5.0,
        child: Container(
            child: Center(
              child: Text(
                variable.strNoActivities,
                style: TextStyle(fontSize: 12.sp),
              ),
            )),
      ),
    );
  }

  Widget getEventCardWidget(
      BuildContext context, int i, List<MyPlanDetailResult> actList) {
    return Container(
        padding: EdgeInsets.all(4.0),
        margin: EdgeInsets.only(top: 4.0),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE7FC),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200.sp,
              child: Text(
                  actList[i].titletext != null && actList[i].titletext != ''
                      ? actList[i].titletext
                      : '',
                  style: TextStyle(fontSize: 10.sp)),
            ),
            SizedBox(height: 4.0.sp),
            SizedBox(
              width: 200.sp,
              child: Text(
                actList[i].repeattext != null && actList[i].repeattext != ''
                    ? actList[i].repeattext
                    : '',
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ));
  }*/

  String getImage() {
    String image;
    if (icon != null && icon != '') {
      image = icon;
    } else {
      if (catIcon != null && catIcon != '') {
        image = catIcon;
      } else {
        if (providerIcon != null && providerIcon != '') {
          image = providerIcon;
        } else {
          image = '';
        }
      }
    }

    return image;
  }
}

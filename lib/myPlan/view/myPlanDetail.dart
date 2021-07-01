import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import '../../authentication/constants/constants.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/responseModel.dart';
import '../viewModel/myPlanViewModel.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/GradientAppBar.dart';

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

  const MyPlanDetail(
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
  MyPlanViewModel myPlanViewModel = MyPlanViewModel();

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        key: _scaffoldKey,
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
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        height: 1.sh - AppBar().preferredSize.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: 0.25.sh,
              ),
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 26,
                          child: CommonUtil().customImage(getImage())),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title != null && title != ''
                                ? toBeginningOfSentenceCase(title.trim())
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
                              Text('Start Date: ',
                                  style: TextStyle(fontSize: 9)),
                              Text(
                                  startDate != null && startDate != ''
                                      ? CommonUtil()
                                          .dateFormatConversion(startDate)
                                      : '-',
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 5),
                              Text('End Date: ', style: TextStyle(fontSize: 9)),
                              Text(
                                  endDate != null && endDate != ''
                                      ? CommonUtil()
                                          .dateFormatConversion(endDate)
                                      : '-',
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            descriptionURL != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlineButton.icon(
                          icon: ImageIcon(
                            AssetImage(planDownload),
                            color: Color(CommonUtil().getMyPrimaryColor()),
                          ),
                          label: Text(
                            'Download Plan',
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              color: Color(CommonUtil().getMyPrimaryColor()),
                            ),
                          ),
                          onPressed: () async {
                            var common = CommonUtil();
                            var updatedData =
                                common.getFileNameAndUrl(descriptionURL);
                            if (updatedData.isEmpty) {
                              common.showStatusToUser(
                                  ResultFromResponse(false,
                                      'incorrect url, Failed to download'),
                                  _scaffoldKey);
                            } else {
                              if (Platform.isIOS) {
                                downloadFileForIos(updatedData);
                              } else {
                                await common.downloader(updatedData.first);
                              }
                            }
                          },
                          borderSide: BorderSide(
                            color: Color(
                              CommonUtil().getMyPrimaryColor(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Expanded(
              child: descriptionURL != null && descriptionURL != ''
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: 0.65.sh,
                      child: InAppWebView(
                          initialUrlRequest: URLRequest(
                            url: Uri.parse(
                                descriptionURL ?? ''),
                            headers: {},
                          ),
                          initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(
                                // debuggingEnabled: true,
                                useOnDownloadStart: true),
                          ),
                          onWebViewCreated: (controller) {
                            webView = controller;
                          },
                          onLoadStart: (controller,
                              url) {},
                          onLoadStop: (controller,
                              url) {},
                          onDownloadStart: (controller, url) async {
                            var common = CommonUtil();
                            //TODO: Check if any error in Inappwebview
                            var updatedData = common.getFileNameAndUrl(url.path);
                            if (updatedData.isEmpty) {
                              common.showStatusToUser(
                                  ResultFromResponse(false,
                                      'incorrect url, Failed to download'),
                                  _scaffoldKey);
                            } else {
                              if (Platform.isIOS) {
                                downloadFileForIos(updatedData);
                              } else {
                                await common.downloader(updatedData.first);
                              }
                            }
                          }),
                      //),
                    )
                  : Column(
                      children: [
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[400])),
                              height: 0.62.sh,
                              width: 0.45.sh,
                              child: Center(child: Text(strEmptyWebView)),
                              //),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlineButton(
                  onPressed: () async {
                    if (isExpired == '1') {
                      await CommonUtil()
                          .renewAlertDialog(context, packageId: packageId);
                    } else {
                      await CommonUtil().unSubcribeAlertDialog(
                        context,
                        packageId: packageId,
                        fromDetail: true,
                      );
                    }
                  },
                  borderSide: BorderSide(
                    color: isExpired == '1'
                        ? Color(CommonUtil().getMyPrimaryColor())
                        : Colors.red,
                  ),
                  child: Text(
                    isExpired == '1' ? strIsRenew : strUnSubscribe,
                    style: TextStyle(
                      color: isExpired == '1'
                          ? Color(new CommonUtil().getMyPrimaryColor())
                          : Colors.red,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                OutlineButton(
                  //hoverColor: Color(getMyPrimaryColor()),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  borderSide: BorderSide(
                    color: Color(
                      CommonUtil().getMyPrimaryColor(),
                    ),
                  ),
                  //hoverColor: Color(getMyPrimaryColor()),
                  child: Text(
                    'cancel'.toUpperCase(),
                    style: TextStyle(
                      color: Color(CommonUtil().getMyPrimaryColor()),
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
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
  downloadFileForIos(List<String> updatedData) async {
    var response = await CommonUtil()
        .loadPdf(url: updatedData.first, fileName: updatedData.last);
    CommonUtil().showStatusToUser(response, _scaffoldKey);
  }

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

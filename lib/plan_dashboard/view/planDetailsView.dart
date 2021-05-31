import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:path/path.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myfhb/plan_dashboard/model/MetaDataForURL.dart';

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
  final String hosIcon;
  final String iconApi;
  final String catIcon;
  final MetaDataForURL metaDataForURL;

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
    @required this.hosIcon,
    @required this.iconApi,
    @required this.catIcon,
    @required this.metaDataForURL,
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
  String hosIcon = '';
  String iconApi = '';
  String catIcon = '';
  InAppWebViewController webView;

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
    hosIcon = widget.hosIcon;
    iconApi = widget.iconApi;
    catIcon = widget.catIcon;
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
        builder: (contxt) => Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          //alignment: Alignment.center,
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
                          radius: 30,
                          child: CommonUtil().customImage(getImage())),
                      // child: ClipOval(
                      //   // backgroundColor: Colors.grey[200],
                      //   // radius: 35,
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     height: 70,
                      //     width: 70,
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: Colors.transparent,
                      //     ),
                      //     child: iconApi != null && iconApi != ''
                      //         ? iconApi
                      //                 .toString()
                      //                 .toLowerCase()
                      //                 ?.contains('.svg')
                      //             ? Center(
                      //                 child: SizedBox(
                      //                   height: 50,
                      //                   width: 50,
                      //                   child: SvgPicture.network(
                      //                     iconApi,
                      //                     placeholderBuilder: (BuildContext
                      //                             context) =>
                      //                         new CircularProgressIndicator(
                      //                             strokeWidth: 1.5,
                      //                             backgroundColor: Color(
                      //                                 new CommonUtil()
                      //                                     .getMyPrimaryColor())),
                      //                   ),
                      //                 ),
                      //               )
                      //             : CachedNetworkImage(
                      //                 imageUrl: iconApi,
                      //                 placeholder: (context, url) =>
                      //                     new CircularProgressIndicator(
                      //                         strokeWidth: 1.5,
                      //                         backgroundColor: Color(
                      //                             new CommonUtil()
                      //                                 .getMyPrimaryColor())),
                      //                 errorWidget: (context, url, error) =>
                      //                     ClipOval(
                      //                         child: CircleAvatar(
                      //                   backgroundImage:
                      //                       AssetImage(qurHealthLogo),
                      //                   radius: 32,
                      //                   backgroundColor: Colors.transparent,
                      //                 )),
                      //                 imageBuilder: (context, imageProvider) =>
                      //                     Container(
                      //                   width: 80.0,
                      //                   height: 80.0,
                      //                   decoration: BoxDecoration(
                      //                     shape: BoxShape.circle,
                      //                     image: DecorationImage(
                      //                         image: imageProvider,
                      //                         fit: BoxFit.fill),
                      //                   ),
                      //                 ),
                      //               )
                      //         : icon != null && icon != ''
                      //             ? icon
                      //                     .toString()
                      //                     .toLowerCase()
                      //                     ?.contains('.svg')
                      //                 ? SvgPicture.network(
                      //                     icon,
                      //                     placeholderBuilder: (BuildContext
                      //                             context) =>
                      //                         new CircularProgressIndicator(
                      //                             strokeWidth: 1.5,
                      //                             backgroundColor: Color(
                      //                                 new CommonUtil()
                      //                                     .getMyPrimaryColor())),
                      //                   )
                      //                 : CachedNetworkImage(
                      //                     imageUrl: icon,
                      //                     placeholder: (context, url) =>
                      //                         new CircularProgressIndicator(
                      //                             strokeWidth: 1.5,
                      //                             backgroundColor: Color(
                      //                                 new CommonUtil()
                      //                                     .getMyPrimaryColor())),
                      //                     errorWidget: (context, url, error) =>
                      //                         ClipOval(
                      //                             child: CircleAvatar(
                      //                       backgroundImage:
                      //                           AssetImage(qurHealthLogo),
                      //                       radius: 32,
                      //                       backgroundColor: Colors.transparent,
                      //                     )),
                      //                     imageBuilder:
                      //                         (context, imageProvider) =>
                      //                             Container(
                      //                       width: 80.0,
                      //                       height: 80.0,
                      //                       decoration: BoxDecoration(
                      //                         shape: BoxShape.circle,
                      //                         image: DecorationImage(
                      //                             image: imageProvider,
                      //                             fit: BoxFit.fill),
                      //                       ),
                      //                     ),
                      //                   )
                      //             : ClipOval(
                      //                 child: CircleAvatar(
                      //                 backgroundImage:
                      //                     AssetImage(qurHealthLogo),
                      //                 radius: 32,
                      //                 backgroundColor: Colors.transparent,
                      //               )),
                      //   ),
                      // ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title != null && title != '' ? title : '-',
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            providerName != null && providerName != ''
                                ? providerName
                                : '-',
                            style: TextStyle(
                                fontSize: 14.sp, color: Colors.grey[600]),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Duration: ',
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14.sp),
                                  ),
                                  Text(
                                    packageDuration != null &&
                                            packageDuration != ''
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
                                width: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Price: ',
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14.sp),
                                  ),
                                  Text(
                                    price != null && price != ''
                                        ? 'INR $price'
                                        : '-',
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
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    description != null && description != ''
                        ? description
                        : '-',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                /* Container(
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
                    ) */
                widget?.metaDataForURL?.descriptionURL != null &&
                        widget?.metaDataForURL?.descriptionURL != ''
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 0.55.sh,
                        child: InAppWebView(
                            initialUrl:
                                "${widget?.metaDataForURL?.descriptionURL}",
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
                    : Container(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlineButton(
                      //hoverColor: Color(getMyPrimaryColor()),
                      child: Text(
                        issubscription == '0'
                            ? strSubscribe
                            : strSubscribed,
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
                                    providerId: providerId, refresh: () {
                                  Navigator.of(context).pop();
                                });
                              } /*else {
                                CommonUtil().unSubcribeAlertDialog(context,
                                    packageId: packageId, refresh: () {
                                  Navigator.of(context).pop();
                                });
                              }*/
                            },
                      borderSide: BorderSide(
                        color: issubscription == '0'
                            ? Color(
                                CommonUtil().getMyPrimaryColor(),
                              )
                            : Colors.grey,
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

  String getImage() {
    String image;
    if (iconApi != null && iconApi != '') {
      image = iconApi;
    } else {
      if (catIcon != null && catIcon != '') {
        image = catIcon;
      } else {
        if (hosIcon != null && hosIcon != '') {
          image = hosIcon;
        } else {
          image = '';
        }
      }
    }

    return image;
  }

  Color getTextColor(bool disable, String isSubscribe) {
    if (isDisable) {
      return Colors.grey;
    } else {
      if (isSubscribe == '0') {
        return Color(CommonUtil().getMyPrimaryColor());
      } else {
        return Colors.grey;
      }
    }
  }
}

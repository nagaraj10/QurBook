import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_parameters.dart';
import '../../constants/responseModel.dart';
import '../../widgets/GradientAppBar.dart';
import 'package:path/path.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import '../model/MetaDataForURL.dart';

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

  const MyPlanDetailView({
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        leading: GestureDetector(
          onTap: Get.back,
          child: Icon(
            Icons.arrow_back_ios, // add custom icons also
            size: 24,
          ),
        ),
        title: Text(
          'Plans',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Builder(
        builder: (contxt) => Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          //alignment: Alignment.center,
          height: 1.sh - AppBar().preferredSize.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title != null && title != '' ? title.trim() : '-',
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
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Duration: ',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 14.sp),
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
                                      color: Colors.grey[600], fontSize: 14.sp),
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
              Visibility(
                visible: description != null && description != '',
                child: Container(
                  width: 1.sw,
                  constraints: BoxConstraints(
                    maxHeight: 0.15.sh,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1.0.h,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Text(
                        description != null && description != ''
                            ? description.trim()
                            : '-',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              widget?.metaDataForURL?.descriptionURL != null
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
                              var updatedData = common.getFileNameAndUrl(
                                  widget?.metaDataForURL?.descriptionURL);
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
              SizedBox(
                height: 10.h,
              ),
              /* Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    height: 0.55.sh,
                    child: SingleChildScrollView(
                      child: Html(
                        data: description.replaceAll('src="//', 'src="'),
                        shrinkWrap: true,
                        onLinkTap: (linkUrl,
                   context,
                   attributes,
                   element) {
                          CommonUtil()
                              .openWebViewNew(widget.title, linkUrl, false);
                        },
                      ),
                    ),
                  ) */
              Expanded(
                child: widget?.metaDataForURL?.descriptionURL != null &&
                        widget?.metaDataForURL?.descriptionURL != ''
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: InAppWebView(
                            initialUrlRequest: URLRequest(
                              url: Uri.parse(
                                  widget?.metaDataForURL?.descriptionURL ?? ''),
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
                            onLoadStart: (controller, url) {},
                            onLoadStop: (controller, url) {},
                            onDownloadStart: (controller, url) async {
                              var common = CommonUtil();
                              //TODO: Check if any error in Inappwebview
                              var updatedData =
                                  common.getFileNameAndUrl(url.path);
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
                    : Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlineButton(
                    //hoverColor: Color(getMyPrimaryColor()),
                    onPressed: isDisable
                        ? null
                        : () async {
                            if (issubscription == '0') {
                              CommonUtil().profileValidationCheck(contxt,
                                  packageId: packageId,
                                  isSubscribed: issubscription,
                                  isFrom: strIsFromSubscibe,
                                  feeZero: price == '' || price == '0',
                                  providerId: providerId, refresh: () {
                                Navigator.of(context).pop();
                              });
                            }
                            /*else {
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
                    ),
                    //hoverColor: Color(getMyPrimaryColor()),
                    child: Text(
                      issubscription == '0' ? strSubscribe : strSubscribed,
                      style: TextStyle(
                        color: getTextColor(isDisable, issubscription),
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
                      // open profile page
                      //Navigator.of(context).pop();
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

  downloadFileForIos(List<String> updatedData) async {
    var response = await CommonUtil()
        .loadPdf(url: updatedData.first, fileName: updatedData.last);
    CommonUtil().showStatusToUser(response, _scaffoldKey);
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

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/claim/bloc/ClaimListBloc.dart';
import 'package:myfhb/claim/model/claimmodel/ClaimListResult.dart';
import 'package:myfhb/claim/model/claimmodel/ClaimRecordDetail.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';
import 'package:myfhb/src/ui/imageSlider.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/chat/model/GetRecordIdsFilter.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonConstants.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import 'package:myfhb/claim/service/ClaimListRepository.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/styles/styles.dart' as fhbStyles;


class ClaimRecordDisplay extends StatefulWidget {
  Function(String) closePage;
  final String claimID;

  @override
  _ClaimRecordDisplayState createState() => _ClaimRecordDisplayState();

  ClaimRecordDisplay(
      {this.closePage, this.claimID}) {}
}

class _ClaimRecordDisplayState extends State<ClaimRecordDisplay> {
  FHBBasicWidget fhbBasicWidget = FHBBasicWidget();
  GlobalKey<ScaffoldState> scaffold_state = GlobalKey<ScaffoldState>();
  int _current = 0;
  int index = 0;
  int length = 0;
  CarouselController carouselSlider;
  String authToken;

  String billName = "",
      claimNo = "",
      submittedDate = "",
      amount = "",
      plan = "",
      familyMember = "",
      status = "";
  ClaimListRepository claimListRepository;
  ClaimListBloc claimListBloc;
  GetRecordIdsFilter getRecordIdsFilter;
  ClaimRecordDetails claimRecordDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    claimListRepository = new ClaimListRepository();
    setAuthToken();
  }

  void setAuthToken() async {
    authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(fhbColors.bgColorContainer),
        key: scaffold_state,
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          title: AutoSizeText(
            "My Claim ",
            maxLines: 1,
            maxFontSize: 16,
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 24.0.sp,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            claimRecordDetails!=null && claimRecordDetails.result!=null?getClaimDetails():getClaimDetailsFromFutureBuilder()
          ],
        ));
  }

  Widget getClaimDetails(){
    initializeData();
    return ListView(
      children: <Widget>[
        Container(
            constraints: BoxConstraints(
              maxHeight: 300.0.h,
            ),
            color: Colors.black87,
            child: (getRecordIdsFilter != null &&
                getRecordIdsFilter.result != null &&
                getRecordIdsFilter.result.length > 0 &&
                getRecordIdsFilter
                    .result[0].healthRecordCollection !=
                    null &&
                getRecordIdsFilter
                    .result[0].healthRecordCollection.length >
                    0)
                ? getWidgetForImages(
                getRecordIdsFilter.result[0].healthRecordCollection)
                : getImageFromMetaId(claimRecordDetails?.result?.
            documentMetadata[0]?.healthRecordId)),
        Padding(
          padding: EdgeInsets.all(5),
          child: Builder(
            builder: (contxt) {
              return Container(
                child: Text(""),
              );
            },
          ),
        ),
        Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                    flex:1,
                    child:  Text("Bill Name",style:getTextStyleForTags())),
                Text(":"),
                Expanded(
                    flex:2,
                    child:  Text("   "+billName??"",style:getTextStyleForValue()))
              ],
            )),
        getDivider(),
        Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                    flex:1,
                    child:  Text("Claim no",style:getTextStyleForTags())),
                Text(":"),
                Expanded(
                    flex:2,
                    child:  Text("   "+claimNo??"",style:getTextStyleForValue()))
              ],
            )),
        getDivider(),
        Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                    flex:1,
                    child: Text("Submitted date",style:getTextStyleForTags())),
                Text(":"),
                Expanded(
                    flex:2,
                    child:  Text("   "+submittedDate??"",style:getTextStyleForValue()))
              ],
            )),
        getDivider(),
        Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                    flex:1,
                    child:  Text("Amount",style:getTextStyleForTags())),
                Text(":"),
                Expanded(
                    flex:2,
                    child:  Text("   "+amount??"",style:getTextStyleForValue()))
              ],
            )),
        getDivider(),
        Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                    flex:1,
                    child:  Text("Plan",style:getTextStyleForTags())),
                Text(":"),
                Expanded(
                    flex:2,
                    child:  Text("   "+plan??"",style:getTextStyleForValue()))
              ],
            )),
        getDivider(),
        Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                    flex:1,
                    child: Text("Family Member",style:getTextStyleForTags())),
                Text(":"),
                Expanded(
                  flex:2,
                  child:  Text("   "+familyMember??"",style:getTextStyleForValue()),)
              ],
            )),
        getDivider(),
        Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                    flex:1,
                    child: Text("Status",style:getTextStyleForTags())),
                Text(":"),
                Expanded(
                    flex:2,
                    child:  Text("   "+status??"",style:getTextStyleForValue()))
              ],
            )),
      ],
    );
  }
  getCarousalImage(List<HealthRecordCollection> imagesPath) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 400.0.h,
      ),
      color: Colors.black87,
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: [Expanded(
            child: CarouselSlider(
              carouselController: carouselSlider,
              items: imagesPath.map((imgUrl) {
                return Builder(
                  builder: (context) {
                    return Container(
                        height: double.infinity,
                        child: Image.network(
                          imgUrl.healthRecordUrl,
                          height: 200.0.h,
                          width: 200.0.h,
                          headers: {
                            HttpHeaders.authorizationHeader: authToken
                          },
                        ));
                    /*Container(
                                height: double.infinity,
                                child: Image.memory(
                                  Uint8List.fromList(imgUrl),
                                  fit: BoxFit.fill,
                                ),
                              );*/
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 400.0.h,
                //width: 1.sw,
                initialPage: 0,
                enlargeCenterPage: true,
                reverse: false,
                enableInfiniteScroll: false,
                // pauseAutoPlayOnTouch: Duration(seconds: 10),
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, carouselPageChangedReason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
          )],)),
    );
  }

  void initializeData() {
    if(claimRecordDetails!=null && claimRecordDetails.result!=null) {
      billName = claimRecordDetails?.result?.documentMetadata[0].billName;
      claimNo = claimRecordDetails?.result?.claimNumber;
      amount = variable.strRs + ". " +
          claimRecordDetails?.result?.documentMetadata[0].claimAmount;
      final df = new DateFormat('dd-MMM-yyyy');

      submittedDate = df.format(
          DateTime.parse(claimRecordDetails?.result?.submitDate));
      status = claimRecordDetails?.result?.status;
      plan = claimRecordDetails?.result?.planDescription;
      familyMember = claimRecordDetails?.result?.submittedForFirstName+
          " " +
          claimRecordDetails?.result?.submittedForLastName;
    }
  }

  getImageFromMetaId(String healthRecordID) {
    return FutureBuilder<GetRecordIdsFilter>(
      future: claimListRepository.getHealthRecordDetailViaId(healthRecordID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot?.data?.isSuccess != null &&
              snapshot?.data?.result != null) {
            if (snapshot.data.isSuccess) {
              getRecordIdsFilter = snapshot.data;
              return getWidgetForImages(
                  getRecordIdsFilter?.result[0]?.healthRecordCollection);
            } else {
              return Container(child: Center(child: Text("Error In Loading")));
            }
          } else {
            return Container(child: Center(child: Text("Error In Loading")));
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CommonCircularIndicator();
        } else {
          return Container(child: Center(child: Text("Error In Loading")));
        }
      },
    );
  }

  Widget getErrorText(String msg) {
    return Text(
      msg,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
          fontFamily: variable.font_poppins,
          fontSize: 14.0.sp,
          color: Colors.white),
    );
  }

  getWidgetForImages(List<HealthRecordCollection> healthRecordCollection) {
    if (healthRecordCollection != null && healthRecordCollection.isNotEmpty) {
      index = _current + 1;
      _current = 0;
      length = healthRecordCollection.length;
    }
    return Column(
      children: <Widget>[
        Expanded(
            flex: 4,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: getCarousalImage(healthRecordCollection))),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    if (healthRecordCollection.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageSlider(
                                imageList: healthRecordCollection,
                              )));
                    }
                  },
                  icon: Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 24.0.sp,
                  ),
                ),
                Text(
                  '$index /$length',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget getDivider(){
    return Divider(
      color: Colors.grey[300],
      thickness: 2.0.h,
      height: 2.0.h,
    );
  }
  Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
  }

  getTextStyleForValue() {
    return TextStyle(fontWeight: FontWeight.w800, fontSize: fhbStyles.fnt_doc_name);
  }
  getTextStyleForTags() {
    return TextStyle(fontWeight: FontWeight.w800, fontSize: fhbStyles.fnt_doc_specialist,color: Colors.grey[600]);
  }

  getClaimDetailsFromFutureBuilder() {
    return FutureBuilder<ClaimRecordDetails>(
      future: claimListRepository.getClaimRecordDetails(widget.claimID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot?.data?.isSuccess != null &&
              snapshot?.data?.result != null) {
            if (snapshot.data.isSuccess) {
              claimRecordDetails = snapshot.data;
              return getClaimDetails();
            } else {
              return getErrorText('Error in Loading');
            }
          } else {
            return getErrorText('Error in Loading');
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CommonCircularIndicator();
        } else {
          return getErrorText('Error in Loading');
        }
      },
    );
  }


}

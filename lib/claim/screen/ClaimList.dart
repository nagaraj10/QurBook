import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/claim/bloc/ClaimListBloc.dart';
import 'package:myfhb/claim/model/claimmodel/ClaimListResponse.dart';
import 'package:myfhb/claim/model/claimmodel/ClaimListResult.dart';
import 'package:myfhb/claim/model/credit/CreditBalance.dart';
import 'package:myfhb/claim/model/members/MembershipDetails.dart';
import 'package:myfhb/claim/screen/ClaimRecordDisplay.dart';
import 'package:myfhb/claim/service/ClaimListRepository.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/blocs/Category/CategoryListBlock.dart';
import 'package:myfhb/src/model/Category/catergory_data_list.dart';
import 'package:myfhb/src/model/Category/catergory_result.dart';
import 'package:myfhb/src/resources/repository/CategoryRepository/CategoryResponseListRepository.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/router_variable.dart' as router;
import '../../../constants/fhb_constants.dart' as Constants;
import 'package:myfhb/styles/styles.dart' as fhbStyles;

class ClaimList extends StatefulWidget {
  @override
  _ClaimListState createState() => _ClaimListState();
}

class _ClaimListState extends State<ClaimList> {
  ClaimListRepository claimListRepository;
  ClaimListBloc claimListBloc;
  ClaimListResponse claimListResponse;
  String memberShipType = "",
      memberShipEndDate = "",
      ClaimAmount = "",
      memberShipId = "",
      memberShipName = "";

  List<CategoryResult> categoryDataList = new List();
  CategoryResponseListRepository _categoryResponseListRepository;
  CategoryListBlock _categoryListBlock;

  FlutterToast toast = FlutterToast();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
    claimListRepository = new ClaimListRepository();
    _categoryResponseListRepository = new CategoryResponseListRepository();
    claimListResponse = new ClaimListResponse();
    callImportantMethods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(1.sh * 0.16), child: getAppBar()),
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: (claimListResponse != null &&
                        claimListResponse.result != null &&
                        claimListResponse.result.length > 0)
                    ? getCliamList()
                    : getClaimListFromFutureBuilder()),
          ],
        )),
        floatingActionButton: FloatingActionButton(
          heroTag: "btn2",
          onPressed: () {
            FocusManager.instance.primaryFocus.unfocus();
           if (memberShipEndDate != "" &&
                memberShipEndDate != null &&
                memberShipType != "" &&
                memberShipType != null) {
              Navigator.pushNamed(context, router.rt_TakePictureScreen)
                  .then((value) {});
            } else {
              toast.getToast("No Membership Available", Colors.green);
            }
          },
          child: Icon(
            Icons.add,
            color: Color(new CommonUtil().getMyPrimaryColor()),
            size: 24.0.sp,
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Health Organization Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  getCliamList() {
    return (claimListResponse != null &&
            claimListResponse.result != null &&
            claimListResponse.result.length > 0)
        ? ClaimWidget()
        : Expanded(
            child: Container(
            child: Center(
              child: Text("No Claim List Available",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: variable.font_poppins,
                      fontSize: 24.0.sp,
                      color: Colors.black)),
            ),
          ));
  }

  getAppBar() {
    return PreferredSize(
        preferredSize: Size.fromHeight(350.0), // here the desired height
        child: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                    Color(new CommonUtil().getMyPrimaryColor()),
                    Color(new CommonUtil().getMyGredientColor())
                  ],
                      stops: [
                    0.3,
                    1.0
                  ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 24.0.sp,
                          ),
                          onTap: () {
                            //Add code for tapping back
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                          child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "My Claim",
                              style: TextStyle(
                                  fontFamily: variable.font_poppins,
                                  fontSize: 20.0.sp,
                                  color: Colors.white),
                            ),
                            (memberShipEndDate != "" &&
                                    memberShipEndDate != null &&
                                    memberShipType != "" &&
                                    memberShipType != null)
                                ? getMemberTypeAndEndDate()
                                : getMemberTypeAndEndDateFromFutureBuilder(),
                            (ClaimAmount != null && ClaimAmount != "")
                                ? getClaimAmount()
                                : getClaimAmountBalance(),
                          ],
                        ),
                      ))
                    ],
                  ),
                ],
              ),
            )));
  }

  getMemberTypeAndEndDate() {
    String memberShipValue = (memberShipType != null && memberShipType != "")
        ? (memberShipType + " ( " + memberShipName + " )")
        : " ";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Membership Type : ' + memberShipValue,
          style: TextStyle(
              fontFamily: variable.font_poppins,
              fontSize: 14.0.sp,
              color: Colors.white),
        ),
        Text(
          'Membership End Date : ' + memberShipEndDate,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              fontFamily: variable.font_poppins,
              fontSize: 14.0.sp,
              color: Colors.white),
        ),
      ],
    );
  }

  Widget getLoadingText() {
    return Text(
      'Loading Text',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
          fontFamily: variable.font_poppins,
          fontSize: 14.0.sp,
          color: Colors.white),
    );
  }

  getMemberTypeAndEndDateFromFutureBuilder() {
    return FutureBuilder<MemberShipDetails>(
      future: claimListRepository.getMemberShip(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot?.data?.isSuccess != null &&
              snapshot?.data?.result != null) {
            if (snapshot.data.isSuccess) {
              memberShipType = snapshot.data.result[0].planName;
              memberShipName = snapshot.data.result[0].healthOrganizationName;
              memberShipEndDate = snapshot.data.result[0].planEndDate;
              memberShipId = snapshot.data.result[0].id;
              PreferenceUtil.save(Constants.keyMembeShipID, memberShipId);
              PreferenceUtil.save(Constants.keyHealthOrganizationId,
                  snapshot.data.result[0].healthOrganizationId);
              return getMemberTypeAndEndDate();
            } else {
              return getMemberTypeAndEndDate();
            }
          } else {
            return getMemberTypeAndEndDate();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return getLoadingText();
        } else {
          return getMemberTypeAndEndDate();
        }
      },
    );
  }

  getClaimAmountBalance() {
    return FutureBuilder<CreditBalance>(
      future: claimListRepository.getCreditBalance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot?.data?.isSuccess != null &&
              snapshot?.data?.result != null) {
            if (snapshot.data.isSuccess) {
              ClaimAmount = snapshot.data.result?.balanceAmount;
              PreferenceUtil.save(Constants.keyClaimAmount, ClaimAmount);

              return getClaimAmount();
            } else {
              return getClaimAmount();
            }
          } else {
            return getClaimAmount();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return getLoadingText();
        } else {
          return getClaimAmount();
        }
      },
    );
  }

  getClaimAmount() {
    String claimAmountValue = (ClaimAmount != null && ClaimAmount != "")
        ? '\u{20B9} ' + ClaimAmount
        : "";
    return Text(
      "Claim Amount Balance : " + claimAmountValue,
      style: TextStyle(
          fontFamily: variable.font_poppins,
          fontSize: 16.0.sp,
          color: Colors.white),
    );
  }

  getClaimListFromFutureBuilder() {
    return FutureBuilder<ClaimListResponse>(
      future: claimListRepository.getClaimList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot?.data?.isSuccess != null &&
              snapshot?.data?.result != null) {
            if (snapshot.data.isSuccess) {
              claimListResponse = snapshot.data;
              return getCliamList();
            } else {
              return getCliamList();
            }
          } else {
            return getCliamList();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return getLoadingText();
        } else {
          return getCliamList();
        }
      },
    );
  }

  void callImportantMethods() async {
    try {
      categoryDataList = await PreferenceUtil.getCategoryType();
      if (categoryDataList == null && categoryDataList.length < 0) {
        _categoryListBlock = new CategoryListBlock();
        _categoryListBlock.getCategoryLists();

        CategoryDataList categoryDataListObj =
            await _categoryResponseListRepository.getCategoryLists();
        setCategoryId(categoryDataListObj.result);
      } else {
        setCategoryId(categoryDataList);
      }
    } catch (e) {
      _categoryListBlock = new CategoryListBlock();
      _categoryListBlock.getCategoryLists();

      CategoryDataList categoryDataListObj =
          await _categoryResponseListRepository.getCategoryLists();
      setCategoryId(categoryDataListObj.result);
    }
  }

  void setCategoryId(List<CategoryResult> categoryDataList) {
    for (CategoryResult dataObj in categoryDataList) {
      if (dataObj.categoryName == Constants.STR_CLAIMSRECORD) {
        PreferenceUtil.saveString(Constants.KEY_DEVICENAME, '').then((onValue) {
          PreferenceUtil.saveString(
                  Constants.KEY_CATEGORYNAME, dataObj.categoryName)
              .then((onValue) {
            PreferenceUtil.saveString(Constants.KEY_CATEGORYID, dataObj.id)
                .then((value) {});
          });
        });
      }
    }
  }

  ClaimWidget() {
    return ListView.separated(
      itemBuilder: (BuildContext context, index) =>
          cliamWidgetList(index, claimListResponse.result),
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          height: 0.0.h,
          color: Colors.transparent,
        );
      },
      itemCount: claimListResponse.result.length,
    );
  }

  cliamWidgetList(int index, List<ClaimListResult> claimResultList) {
    if(claimResultList[index].documentMetadata!=null && claimResultList[index].documentMetadata.length>0) {
      return InkWell(
          onTap: () {
            FocusManager.instance.primaryFocus.unfocus();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ClaimRecordDisplay(
                        claimID: claimResultList[index]?.id,
                        closePage: (value) {},
                      ),
                ));
          },
          child: Container(
              padding: EdgeInsets.all(12.0),
              margin: EdgeInsets.only(left: 15, right: 15, top: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFe3e2e2),
                    blurRadius: 16, // has the effect of softening the shadow
                    spreadRadius: 5.0, // has the effect of extending the shadow
                    offset: Offset(
                      0.0, // horizontal, move right 10
                      0.0, // vertical, move down 10
                    ),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                              child: Column(
                                children: [
                                  Row(children: [
                                    Text(
                                        toBeginningOfSentenceCase(
                                            claimResultList[index]
                                                ?.submittedFor
                                                ?.firstName) +
                                            " " +
                                            toBeginningOfSentenceCase(
                                                claimResultList[index]
                                                    ?.submittedFor
                                                    ?.lastName),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: fhbStyles.fnt_doc_name))
                                  ]),
                                  Row(
                                    children: [
                                      Text("Claim no :",
                                          style: getTextStyleForTags()),
                                      Text(" " +
                                          claimResultList[index]?.claimNumber,
                                          style: getTextStyleForValue())
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Membership :",
                                          style: getTextStyleForTags()),
                                      Text(" " + memberShipType,
                                          style: getTextStyleForValue())
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Bill Name :",
                                          style: getTextStyleForTags()),
                                      Text(
                                          " " +
                                              claimResultList[index]
                                                  ?.documentMetadata[0]
                                                  ?.billName??'',
                                          style: getTextStyleForValue())
                                    ],
                                  ),
                                ],
                              ))),
                      Expanded(
                          flex: 1,
                          child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      getFormattedBillDate(
                                          claimResultList[index]
                                              ?.documentMetadata[0]
                                              ?.billDate??''),
                                      style: getTextStyleForTags()),
                                 /* Text(
                                      "Rs " +
                                          claimResultList[index]
                                              ?.documentMetadata[0]
                                              ?.claimAmount??'',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: fhbStyles.fnt_doc_name)),*/
                                  Text("status",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: fhbStyles.fnt_day,
                                          color: Colors.grey[600])),
                                  Text(claimResultList[index]?.status.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: fhbStyles.fnt_day,
                                          color: getColorBasedOnSatus(
                                              claimResultList[index]?.status
                                                  .code))),
                                ],
                              ))),
                    ],
                  ),
                ],
              )));
    }
  }

  getTextStyleForValue() {
    return TextStyle(fontWeight: FontWeight.w800, fontSize: fhbStyles.fnt_date);
  }

  getTextStyleForTags() {
    return TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: fhbStyles.fnt_doc_specialist,
        color: Colors.grey[600]);
  }

  String getFormattedBillDate(String billDate) {
    DateFormat format = DateFormat("dd-MM-yyyy");

    var now = format.parse(billDate);
    final df = new DateFormat('dd-MMM-yyyy');

    return df.format(now);
  }

  getColorBasedOnSatus(String status) {
    switch (status) {
      case "CLAIM_INITIATED":
        return Colors.amber;
      case "CLAIM_REJECTED":
        return Colors.red;
      case "CLAIM_ACCEPTED":
        return Colors.green;
      default:
        return Color(new CommonUtil().getMyPrimaryColor());
    }
  }
}

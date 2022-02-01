import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/claim/bloc/ClaimListBloc.dart';
import 'package:myfhb/claim/model/claimexpiry/ClaimExpiryResponse.dart';
import 'package:myfhb/claim/model/claimexpiry/ClaimExpiryResult.dart';
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
import 'package:myfhb/src/resources/network/ApiResponse.dart';
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
      memberShipStartDate = "",
      ClaimAmount = "",
      memberShipId = "",
      memberShipName = "";

  bool isCreditBalnceZero = false;

  List<CategoryResult> categoryDataList = new List();
  CategoryResponseListRepository _categoryResponseListRepository;
  CategoryListBlock _categoryListBlock;

  FlutterToast toast = FlutterToast();
  List<ClaimExpiryResult> claimExpiryList = new List();
  int _selected;
  ClaimListBloc _claimListBloc;
  Future<ClaimExpiryResponse> claimExpiryResponse;

  List<String> exercises = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
    claimListRepository = new ClaimListRepository();
    _categoryResponseListRepository = new CategoryResponseListRepository();
    claimListResponse = new ClaimListResponse();

    _claimListBloc = new ClaimListBloc();
    claimExpiryResponse = _claimListBloc.getExpiryListResponse();
    callImportantMethods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        key: _scaffoldKey,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(1.sh * 0.16), child: getAppBar()),
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: (claimListResponse != null &&
                        claimListResponse?.result != null &&
                        claimListResponse?.result.length > 0)
                    ? getCliamList()
                    : getClaimListFromFutureBuilder()),
          ],
        )),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              FocusManager.instance.primaryFocus.unfocus();
              alertDialogWithMemberShip();
            },
            child: Icon(
              Icons.add,
              color: Color(new CommonUtil().getMyPrimaryColor()),
              size: 24.0.sp,
            ),
          ),
          visible: isCreditBalnceZero ? false : true,
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
            (claimListResponse?.isSuccess ?? false) &&
            claimListResponse?.result != null &&
            claimListResponse?.result.length > 0)
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
          'Membership End Date : ' +
              getFormattedBillDateForMember(memberShipEndDate),
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

  Widget getLoadingText(String msg) {
    return Text(
      msg,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
          fontFamily: variable.font_poppins,
          fontSize: 14.0.sp,
          color: Color(CommonUtil().getMyPrimaryColor())),
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
              memberShipStartDate = snapshot.data.result[0].planStartDate;
              memberShipId = snapshot.data.result[0].id;
              PreferenceUtil.save(Constants.keyMembeShipID, memberShipId);
              PreferenceUtil.save(Constants.keyHealthOrganizationId,
                  snapshot.data.result[0].healthOrganizationId);
              PreferenceUtil.save(
                  Constants.keyMembershipStartDate, memberShipStartDate);
              PreferenceUtil.save(
                  Constants.keyMembershipEndDate, memberShipEndDate);

              return getMemberTypeAndEndDate();
            } else {
              return getMemberTypeAndEndDate();
            }
          } else {
            return getMemberTypeAndEndDate();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return getLoadingText('Loading');
        } else {
          return getLoadingText('Error in loading');
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
          return getLoadingText('Loading');
        } else {
          return getLoadingText('Error in loading');
        }
      },
    );
  }

  getClaimAmount() {
    try {
      String claimAmountTotal;
      if (ClaimAmount.contains(".")) {
        claimAmountTotal =
            ClaimAmount.contains(".") ? ClaimAmount.split(".")[0] : ClaimAmount;
      } else {
        claimAmountTotal = ClaimAmount;
      }

      if (int.parse(claimAmountTotal) > 0) {
        isCreditBalnceZero = false;
      } else {
        isCreditBalnceZero = false;
      }
    } catch (e) {
      ClaimAmount = "";
      isCreditBalnceZero = false;
    }
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
          return getLoadingText('Loading');
        } else {
          return getLoadingText('Error in loading');
        }
      },
    );
  }

  getClaimMemberShipListFromFutureBuilder() {
    return FutureBuilder<ClaimExpiryResponse>(
      future: claimListRepository.getClaimExpiryResponseList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot?.data?.isSuccess != null &&
              snapshot?.data?.result != null) {
            if (snapshot.data.isSuccess) {
              claimExpiryList = snapshot?.data?.result;
              return getWidgetForMemberShipList();
            } else {
              return getWidgetForMemberShipList();
            }
          } else {
            return getWidgetForMemberShipList();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return getLoadingText('Loading ');
        } else {
          return getLoadingText('Error in loading');
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
    if (claimResultList[index].documentMetadata != null &&
        claimResultList[index].documentMetadata.length > 0) {
      return InkWell(
          onTap: () {
            FocusManager.instance.primaryFocus.unfocus();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClaimRecordDisplay(
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
                                                    ?.firstName ??
                                                '') +
                                        " " +
                                        toBeginningOfSentenceCase(
                                            claimResultList[index]
                                                    ?.submittedFor
                                                    ?.lastName ??
                                                ''),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: fhbStyles.fnt_doc_name))
                              ]),
                              Row(
                                children: [
                                  Text("Claim no :",
                                      style: getTextStyleForTags()),
                                  Text(
                                      " " +
                                              claimResultList[index]
                                                  ?.claimNumber ??
                                          '',
                                      style: getTextStyleForValue())
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Membership : ",
                                      style: getTextStyleForTags()),
                                  Text(
                                      (claimResultList[index]?.planName !=
                                                  null &&
                                              claimResultList[index]
                                                      ?.planName !=
                                                  '')
                                          ? claimResultList[index]?.planName
                                          : memberShipType,
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
                                                  ?.billName ??
                                          '',
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
                                  getFormattedBillDate(claimResultList[index]
                                          ?.documentMetadata[0]
                                          ?.billDate ??
                                      ''),
                                  style: getTextStyleForTags()),
                              Text("status",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: fhbStyles.fnt_day,
                                      color: Colors.grey[600])),
                              Text(claimResultList[index]?.status?.name ?? '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: fhbStyles.fnt_day,
                                      color: getColorBasedOnSatus(
                                          claimResultList[index]
                                                  ?.status
                                                  ?.code ??
                                              ''))),
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
    if (billDate != "" && billDate != null) {
      try {
        DateFormat format = DateFormat("dd-MM-yyyy");

        var now = format.parse(billDate);
        final df = new DateFormat('dd-MMM-yyyy');

        return df.format(now);
      } catch (e) {
        return "";
      }
    } else {
      return "";
    }
  }

  String getFormattedBillDateForMember(String billDate) {
    if (billDate != "" && billDate != null) {
      try {
        DateFormat format = DateFormat("yyyy-MM-dd");

        var now = format.parse(billDate);
        final df = new DateFormat('dd-MMM-yyyy');

        return df.format(now);
      } catch (e) {
        return "";
      }
    } else {
      return "";
    }
  }

  getColorBasedOnSatus(String status) {
    if (status != "") {
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

  Future<Widget> alertDialogWithMemberShip() {
    final dialog = StatefulBuilder(builder: (context, setState) {
      Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = TextButton(
        child: Text("Continue"),
        onPressed: () {},
      );

      return AlertDialog(
        title: Text("Select a Membership"),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        actions: <Widget>[
          cancelButton,
        ],
        content: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Divider(),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child:
                      (claimExpiryList != null && claimExpiryList?.length > 0)
                          ? getWidgetForMemberShipList()
                          : getClaimMemberShipListFromFutureBuilder(),
                ),
                Divider(),
              ],
            ),
          ),
        ),
      );
    });

    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => dialog);
  }

  getWidgetForMemberShipList() {
    return claimExpiryList.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: claimExpiryList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () async {
                    conditionToCheckAmt(index);
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(claimExpiryList[index].planName +
                          " (" +
                          claimExpiryList[index].healthOrganizationName +
                          " )")));
            })
        : Container(child: getLoadingText("No MemberShip Found"));
  }

  void convertStringToInt(String balanceAmt, int index) {
    if (int.parse(balanceAmt) > 0) {
      PreferenceUtil.save(
          Constants.keyMembeShipID, claimExpiryList[index]?.membershipId);
      PreferenceUtil.save(Constants.keyHealthOrganizationId,
          claimExpiryList[index]?.healthOrganizationId);
      PreferenceUtil.save(Constants.keyPlanSubscriptionInfoId,
          claimExpiryList[index]?.planSubscriptionInfoId);
      PreferenceUtil.save(Constants.keyMembershipStartDate,
          claimExpiryList[index]?.additionalInfo?.planStartDate);
      PreferenceUtil.save(Constants.keyMembershipEndDate,
          claimExpiryList[index]?.additionalInfo?.planEndDate);
      PreferenceUtil.save(
          Constants.keyClaimAmount, claimExpiryList[index]?.balanceAmount);
      if (claimExpiryList[index]?.membershipStatus.toLowerCase() == "active") {
        PreferenceUtil.saveIfMemberShipIsActive(true);
      } else {
        PreferenceUtil.saveIfMemberShipIsActive(false);
      }

      Navigator.pop(context);

      Navigator.pushNamed(context, router.rt_TakePictureScreen)
          .then((value) {});
    } else {
      showSnackBar('No Balance Amount Available');
    }
  }

  void conditionToCheckAmt(int index) {
    String balanceAmt = claimExpiryList[index]?.balanceAmount;
    if (balanceAmt.contains(".")) {
      balanceAmt =
          balanceAmt.contains(".") ? balanceAmt.split(".")[0] : balanceAmt;
      convertStringToInt(balanceAmt, index);
    } else {
      convertStringToInt(balanceAmt, index);
    }
  }

  void showSnackBar(String msg) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 5),
        content: Text(
          msg,
        ),
        backgroundColor: Color(
          CommonUtil().getMyPrimaryColor(),
        ),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            _scaffoldKey.currentState.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

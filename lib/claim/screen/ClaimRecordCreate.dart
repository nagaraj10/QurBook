import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/claim/screen/ClaimList.dart';
import 'package:myfhb/claim/service/ClaimListRepository.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/src/blocs/Media/MediaTypeBlock.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Category/catergory_result.dart';
import 'package:myfhb/src/model/Media/media_result.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFModel.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFView.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFViewerController.dart';
import 'package:open_file/open_file.dart';

import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_parameters.dart' as parameters;
import '../../my_family/bloc/FamilyListBloc.dart';
import '../../my_family/models/FamilyMembersRes.dart';
import '../../src/model/Health/asgard/health_record_collection.dart';
import '../../src/model/Health/asgard/health_record_list.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../src/ui/imageSlider.dart';
import '../../src/utils/FHBUtils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/GradientAppBar.dart';

export 'package:myfhb/my_family/models/relationship_response_list.dart';
import '../../constants/variable_constant.dart' as variable;

class ClaimRecordCreate extends StatefulWidget {
  final List<String> imagePath;

  ClaimRecordCreate({this.imagePath});

  @override
  _ClaimRecordCreateState createState() => _ClaimRecordCreateState();
}

class _ClaimRecordCreateState extends State<ClaimRecordCreate> {
  FHBBasicWidget fhbBasicWidget = FHBBasicWidget();
  GlobalKey<ScaffoldState> scaffold_state = GlobalKey<ScaffoldState>();
  int _current = 0;
  int index = 0;
  int length = 0;
  CarouselController carouselSlider;
  String authToken;

  TextEditingController billDate = TextEditingController();
  TextEditingController fileName = TextEditingController();
  TextEditingController claimAmount = TextEditingController();

  DateTime dateTime = DateTime.now();
  String dateofBirthStr;

  final dateOfBirthController = TextEditingController(text: '');
  FocusNode dateOfBirthFocus = FocusNode();

  FamilyListBloc _familyListBloc;
  FamilyMembers familyData = new FamilyMembers();
  List<SharedByUsers> _familyNames = new List();
  bool isFamilyChanged = false;

  SharedByUsers selectedUser;
  var selectedId = '', createdBy = '';
  String categoryName;
  String categoryID;
  String validationMsg;
  String selectedClaimType = "Pharmacy";

  CategoryResult categoryDataObj = CategoryResult();
  MediaResult mediaDataObj = MediaResult();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final HealthReportListForUserBlock _healthReportListForUserBlock =
  HealthReportListForUserBlock();
  HealthReportListForUserRepository _healthReportListForUserRepository;

  FlutterToast toast = FlutterToast();

  String claimAmountTotal;
  String memberShipStartDate, memberShipEndDate;
  bool ispdfPresent = false;
  var pdfFile;
  var pdfFileName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _healthReportListForUserRepository =
    new HealthReportListForUserRepository();
    if (widget.imagePath.isNotEmpty) {
      length = widget.imagePath.length;
      index = 1;
    }

    try {
      claimAmountTotal = new CommonUtil().getClaimAmount();
      claimAmountTotal = json.decode(claimAmountTotal);
      if(claimAmountTotal.contains('.')) {
        claimAmountTotal = claimAmountTotal.contains(".")
            ? claimAmountTotal.split(".")[0]
            : claimAmountTotal;
      }
    }catch(e){

    }

    memberShipStartDate = new CommonUtil().getMemberSipStartDate();
    memberShipEndDate = new CommonUtil().getMemberSipEndDate();

    memberShipStartDate=json.decode(memberShipStartDate);
    memberShipEndDate=json.decode(memberShipEndDate);
    setAuthToken();
    initializeData();

    if (length == 1 && new CommonUtil().checkIfFileIsPdf(widget.imagePath[0])) {
      ispdfPresent = true;
      pdfFile = File(widget.imagePath[0]);
      final fileNoun = pdfFile.path.split('/').last;
      pdfFileName = fileNoun;
    }

    _familyListBloc = new FamilyListBloc();
    _familyListBloc.getFamilyMembersListNew();
  }

  void initializeData() {
    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);

    categoryID = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYID);
    createdBy = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    selectedId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(fhbColors.bgColorContainer),
      key: scaffold_state,
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        title: AutoSizeText(
          "My Claim",
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
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  constraints: BoxConstraints(
                    maxHeight: 300.0.h,
                  ),
                  color: Colors.black87,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          flex: 4,
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: ispdfPresent
                                  ? getIconForPdf()
                                  : getCarousalImage(widget.imagePath))),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Visibility(
                                child: IconButton(
                                  onPressed: () {
                                    if (widget.imagePath.isNotEmpty) {}
                                  },
                                  icon: Icon(
                                    Icons.fullscreen,
                                    color: Colors.white,
                                    size: 24.0.sp,
                                  ),
                                ),
                                visible: false,
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
                  )),
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
              fhbBasicWidget.getTextForAlertDialogClaim(
                  context, CommonConstants.strBillName),
              fhbBasicWidget.getTextFieldWithNoCallbacksClaim(context, fileName,
                  isFileField: true),

              SizedBox(
                height: 10.0.h,
              ),
              fhbBasicWidget.getTextForAlertDialogClaim(
                  context, CommonConstants.strClaimType),
              SizedBox(
                height: 10.0.h,
              ),
              getClaimType(),

              SizedBox(
                height: 10.0.h,
              ),
              fhbBasicWidget.getTextForAlertDialogClaim(
                  context, CommonConstants.strBillDate),
              _showDateOfVisit(context, billDate),
              SizedBox(
                height: 15.0.h,
              ),
              fhbBasicWidget.getTextForAlertDialogClaim(
                  context, CommonConstants.strClaimAmt + " (\u{20B9}) *"),

              TextField(
                enabled: true,
                cursorColor: Color(CommonUtil().getMyPrimaryColor()),
                controller: claimAmount,
                enableInteractiveSelection: false,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                style: fhbBasicWidget.getTextStyleForValue(),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]),
                  ),
                  contentPadding: EdgeInsets.only(left: 20.0),
                  counterText: '',
                  labelStyle: TextStyle(
                      fontSize: 15.0.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorUtils.myFamilyGreyColor),
                  hintStyle: TextStyle(
                    fontSize: 16.0.sp,
                    color: ColorUtils.myFamilyGreyColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0.h,
              ),
              fhbBasicWidget.getTextForAlertDialogClaim(
                  context, CommonConstants.strFamilyMember),
              SizedBox(
                height: 15.0.h,
              ),

              (familyData != null &&
                  familyData.result?.sharedByUsers != null &&
                  familyData.result?.sharedByUsers.length > 0)
                  ? FittedBox(
                  fit: BoxFit.cover,
                  child: Row(
                    children: [
                      dropDownButton(familyData.result?.sharedByUsers)
                    ],
                  ))
                  : FittedBox(
                  fit: BoxFit.cover,
                  child: Row(
                    children: [getDropdown()],
                  )),
              //Padding(child:_familyNames!=null && _familyNames.length>0?dropDownButton(_familyNames):getDropdown(),padding: EdgeInsets.symmetric(vertical: 10.0,horizontal:20.0),),

              SizedBox(
                height: 10.0.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _showClaimButton(),
                ],
              ),
              SizedBox(
                height: 20.0.h,
              ),
            ],
          )),
    );
  }

  Widget getCarousalImage(List<String> imagesPath) {
    if (imagesPath != null && imagesPath.isNotEmpty) {
      index = _current + 1;
      _current = 0;
      length = imagesPath.length;
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          (widget.imagePath != null && widget.imagePath.isNotEmpty)
              ? Expanded(
            child: CarouselSlider(
              carouselController: carouselSlider,
              items: widget.imagePath.map((imgUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: 1.sw,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(),
                        child: Container(
                          height: double.infinity,
                          child: Image.file(
                            File(imgUrl),
                            fit: BoxFit.scaleDown,
                          ),
                        ));
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
          )
              : Container(
              child: Text("Error",
                  style: TextStyle(
                    color: Colors.black,
                  )))
        ],
      ),
    );
  }

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  /*Future<PermissionStatus> requestPermission(
      Permission storagePermission) async {
    final status = await storagePermission.request();

    setState(() {
      permissionStatus = status;
    });

    return status;
  }*/

  HealthRecordCollection checkIfMp3IsPresent(HealthResult data) {
    HealthRecordCollection mediaMetaId;

    if (data.healthRecordCollection != null &&
        data.healthRecordCollection.isNotEmpty) {
      mediaMetaId = CommonUtil()
          .getMediaMasterIDForAudioFileType(data.healthRecordCollection);
    }
    return mediaMetaId;
  }

  void setAuthToken() async {
    authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
  }

  showBillEntryWidget() {
    return Column(
      children: [
        fhbBasicWidget.getTextForAlertDialog(
            context, CommonConstants.strFileName),
        fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
      ],
    );
  }

  _showDateWidget() {
    return Column(
      children: [
        fhbBasicWidget.getTextForAlertDialog(
            context, CommonConstants.strDateOfVisit),
        _showDateOfVisit(context, billDate),
      ],
    );
  }

  void dateOfBirthTapped(
      BuildContext context, TextEditingController dateOfVisit) {
    _selectDate(context, dateOfVisit);
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController dateOfVisitSample) async {
    var dateTime = DateTime.now();
    var startDate = DateFormat('yyyy-MM-dd').parse(memberShipStartDate);
    var endDate = DateFormat('yyyy-MM-dd').parse(memberShipEndDate);
    final picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: startDate,
        lastDate: endDate);

    if (picked != null) {
      dateTime = picked ?? dateTime;
      dateOfVisitSample.text =
          FHBUtils().getFormattedDateOnly(dateTime.toString());
    }
    setState(() {
      billDate.text = dateOfVisitSample.text;
    });
  }

  _showClaimButton() {
    final addButtonWithGesture = GestureDetector(
      onTap: _addClaim,
      child: Container(
        width: 130.0.w,
        height: 40.0.h,
        decoration: BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: BorderRadius.all(Radius.circular(2)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Save',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: addButtonWithGesture);
  }

  Widget getDropdown() {
    return StreamBuilder<ApiResponse<FamilyMembers>>(
      stream: _familyListBloc.familyMemberListNewStream,
      builder: (context, AsyncSnapshot<ApiResponse<FamilyMembers>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: SizedBox(
                      child: CommonCircularIndicator(),
                      width: 30,
                      height: 30,
                    )),
              );
              break;

            case Status.ERROR:
              return FHBBasicWidget.getRefreshContainerButton(
                  snapshot.data.message, () {
                setState(() {});
              });
              break;

            case Status.COMPLETED:
            //_healthReportListForUserBlock = null;
              print(snapshot.data.toString());
              if (snapshot.data.data.result != null) {
                familyData = snapshot.data.data;
              }

              return dropDownButton(snapshot.data.data.result != null
                  ? snapshot.data.data.result.sharedByUsers
                  : null);
              break;
          }
        } else {
          return Container(height: 0, color: Colors.white);
        }
      },
    );
  }

  Widget dropDownButton(List<SharedByUsers> sharedByMeList) {
    MyProfileModel myProfile;
    String fulName = '';
    try {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
      fulName = myProfile.result != null
          ? myProfile.result.firstName?.capitalizeFirstofEach +
          ' ' +
          myProfile.result.lastName?.capitalizeFirstofEach
          : '';
    } catch (e) {}

    if (sharedByMeList == null) {
      sharedByMeList = new List();
      sharedByMeList
          .add(new SharedByUsers(id: myProfile?.result?.id, nickName: 'Self'));
    } else {
      sharedByMeList.insert(
          0, new SharedByUsers(id: myProfile?.result?.id, nickName: 'Self'));
    }
    if (_familyNames.length == 0) {
      for (int i = 0; i < sharedByMeList.length; i++) {
        _familyNames.add(sharedByMeList[i]);
      }
    }

    if (_familyNames.length > 0) {
      for (SharedByUsers sharedByUsers in _familyNames) {
        if (sharedByUsers != null) {
          if (sharedByUsers.child != null) {
            if (sharedByUsers.child.id == selectedId) {
              selectedUser = sharedByUsers;
            }
          }
        }
      }
    }

    return getFamilyDropDown();
  }

  Widget _showDateOfVisit(
      BuildContext context, TextEditingController dateOfVisit) {
    return GestureDetector(
      onTap: () {
        dateOfBirthTapped(context, dateOfVisit);
      },
      child: Container(
          child: TextField(
            style: fhbBasicWidget.getTextStyleForValue(),
            cursorColor: Color(CommonUtil().getMyPrimaryColor()),
            controller: dateOfVisit,
            readOnly: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onSubmitted: (term) {
              dateOfBirthFocus.unfocus();
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]),
              ),
              contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  _selectDate(context, dateOfVisit);
                },
              ),
            ),
          )),
    );
  }

  void _addClaim() async {
    if (doValidationbeforeSubmitting()) {
      CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);

      var postMainData = Map<String, dynamic>();
      var postMediaData = Map<String, dynamic>();

      var userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      postMainData[parameters.struserId] = userID;

      final catgoryDataList = PreferenceUtil.getCategoryType();

      categoryDataObj = CommonUtil()
          .getCategoryObjForSelectedLabel(categoryID, catgoryDataList);
      postMediaData[parameters.strhealthRecordCategory] =
          categoryDataObj.toJson();
      var _mediaTypeBlock = MediaTypeBlock();

      var mediaTypesResponse = await _mediaTypeBlock.getMediTypesList();

      final metaDataFromSharedPrefernce = mediaTypesResponse.result;
      mediaDataObj = CommonUtil().getMediaTypeInfoForParticularLabel(
          categoryID, metaDataFromSharedPrefernce, categoryName);

      postMediaData[parameters.strhealthRecordType] = mediaDataObj.toJson();
      postMediaData[parameters.strisDraft] = false;


      final params = json.encode(postMediaData);
      print(params);

      await _healthReportListForUserBlock
          .createHealtRecordsClaims(params.toString(), widget.imagePath, null)
          .then((value) {
        if (value != null && value.isSuccess) {
          createClaim(value.result[0].id);
        } else {
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          toast.getToast(Constants.ERR_MSG_RECORD_CREATE, Colors.red);
        }
      });
    } else {
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: Text(variable.strAPP_NAME),
              content: Text(validationMsg),
              actions: <Widget>[
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Center(
                            child: TextButton(
                              child: const Text(
                                'Ok',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )),
                        color: Color(new CommonUtil().getMyPrimaryColor()),
                      ),
                    ])
              ]));
    }
  }

  bool doValidationbeforeSubmitting() {
    bool condition = true;
    if (fileName.text != "" && fileName.text != null) {
      if (billDate.text != "" && billDate.text != null) {
        if (claimAmount.text != "" &&
            claimAmount.text != null &&
            int.parse(claimAmount.text) > 0) {
          if (int.parse(claimAmount.text) <= int.parse(claimAmountTotal)) {
            condition = true;
          } else {
            condition = false;
            validationMsg = "Current balance is  " +
                claimAmountTotal +
                " INR. Please enter a lesser amount";
          }
        } else {
          condition = false;
          validationMsg = CommonConstants.strClaimAmtEmpty;
        }
      } else {
        condition = false;
        validationMsg = CommonConstants.strBillDateEmpty;
      }
    } else {
      condition = false;
      validationMsg = CommonConstants.strBillNameEmpty;
    }
    return condition;
  }

  void createClaim(String healthRecordID) {
    var postMediaData = Map<String, dynamic>();
    var membership = {};
    String memberShipId = new CommonUtil().getMemberShipID();

    String healthOrganizationID = new CommonUtil().getHealthOrganizationID();
    membership[qr_str_id] = json.decode(memberShipId);
    postMediaData[qr_membership_tag] = membership;

    var submittedBY = {};
    submittedBY[qr_str_id] = createdBy;
    postMediaData[qr_submittedby] = submittedBY;

    var submittedFor = {};
    submittedFor[qr_str_id] = selectedId;
    postMediaData[qr_submittedfor] = submittedFor;
    double claimAmt = double.parse(claimAmountTotal);

    postMediaData[qr_remark] = "";
    postMediaData[qr_ClaimAmountTotal] = claimAmt;
    postMediaData[qr_health_org_id] = json.decode(healthOrganizationID);
    var planSubscriptionInfoId=PreferenceUtil.getStringValue(Constants.keyPlanSubscriptionInfoId);
    postMediaData[parameters.strPlanSubscriptionInfoId] = json.decode(planSubscriptionInfoId);

    var documentType = [];
    var billType = Map<String, dynamic>();

    billType[qr_billName] = fileName.text;
    billType[qr_billDate] = billDate.text;
    billType[qr_claimType] = selectedClaimType;
    billType[qr_memoText] = "";
    billType[qr_healthRecordId] = healthRecordID;
    billType[qr_claimAmount] = claimAmount.text;

    documentType = [billType];
    postMediaData[qr_documentMetadata] = documentType;

    final params = json.encode(postMediaData);
    print(params);

    _healthReportListForUserRepository.createClaimRecord(params).then((value) {
      if (value != null && value.isSuccess) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ClaimList()));
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        toast.getToast(
            value.diagnostics?.message ?? "Error Occured While Creating Claim",
            Colors.red);
      }
    });
  }

  Widget getClaimType() {
    return Container(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Padding(
          child: Text(
            CommonConstants.strClaimType,
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
          ),
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 20),
        ),
        value: selectedClaimType != null
            ? toBeginningOfSentenceCase(selectedClaimType.toLowerCase())
            : "",
        items: variable.claimType.map((eachGender) {
          return DropdownMenuItem(
            child: Padding(
              child: Text(
                eachGender,
                style: fhbBasicWidget.getTextStyleForValue(),
              ),
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 20),
            ),
            value: eachGender,
          );
        }).toList(),
        onChanged: (newSelectedValue) {
          setState(() {
            selectedClaimType = newSelectedValue;
          });
        },
      ),
    );
  }

  Widget getFamilyDropDown() {
    return Container(
      width: 1.sw,
      child: DropdownButton<SharedByUsers>(
        isExpanded: true,
        value: selectedUser,
        hint: Row(
          children: <Widget>[
            Padding(
                child: Text(parameters.self,
                    style: fhbBasicWidget.getTextStyleForValue()),
                padding: EdgeInsets.only(left: 20, top: 10, bottom: 20)),
          ],
        ),
        items: _familyNames
            .map((SharedByUsers user) => DropdownMenuItem(
          child: Row(
            children: <Widget>[
              Padding(
                  child: Text(
                      user.child == null
                          ? 'Self'
                          : ((user?.child?.firstName ?? '') +
                          ' ' +
                          (user?.child?.lastName ?? ''))
                          ?.capitalizeFirstofEach ??
                          '',
                      style: fhbBasicWidget.getTextStyleForValue()),
                  padding:
                  EdgeInsets.only(left: 20, top: 10, bottom: 20)),
            ],
          ),
          value: user,
        ))
            .toList(),
        onChanged: (SharedByUsers user) {
          isFamilyChanged = true;
          setState(() {
            selectedUser = user;
            if (user.child != null) {
              if (user.child.id != null) {
                selectedId = user.child.id;
              }
            } else {
              selectedId = createdBy;
            }
          });
        },
      ),
    );
  }

  getIconForPdf() {
    return Container(
      child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'View PDF',
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                tooltip: 'View PDF',
                icon: ImageIcon(AssetImage(variable.icon_attach),
                    color: Colors.white),
                onPressed: () async {
                  await OpenFile.open(
                    pdfFile.path,
                  );
                },
              )
            ],
          )),
    );
  }
}

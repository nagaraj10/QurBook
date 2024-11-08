import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/authentication/view/verifypatient_screen.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/src/model/user/Tags.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';
import 'package:myfhb/src/ui/SheelaAI/Controller/SheelaAIController.dart';
import 'package:myfhb/widgets/DropdownWithTags.dart';
import '../../constants/fhb_constants.dart';
import '../../language/model/Language.dart';
import '../../language/repository/LanguageRepository.dart';
import '../../main.dart';
import '../../src/model/GetDeviceSelectionModel.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../bloc/add_family_user_info_bloc.dart';
import '../models/add_family_user_info_arguments.dart';
import '../models/address_result.dart';
import '../models/update_relatiosnship_model.dart';
import '../services/add_family_user_info_repository.dart';
import '../viewmodel/doctor_personal_viewmodel.dart';
import '../widget/address_type_widget.dart';
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../my_family/bloc/FamilyListBloc.dart';
import '../../my_family/models/relationship_response_list.dart';
import '../../my_family/models/relationships.dart';
import '../../src/model/common_response.dart';
import '../../src/model/user/AddressTypeModel.dart';
import '../../src/model/user/City.dart';
import '../../src/model/user/MyProfileModel.dart';
import '../../src/model/user/MyProfileResult.dart';
import '../../src/model/user/UserAddressCollection.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../src/ui/authentication/OtpVerifyScreen.dart';
import '../../src/utils/FHBUtils.dart';
import '../../src/utils/alert.dart';
import '../../src/utils/colors_utils.dart';
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart' as variable;
import '../../src/model/user/State.dart' as stateObj;
import 'package:myfhb/telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'dart:convert' as convert;
import 'package:myfhb/widgets/TagsList.dart';

class AddFamilyUserInfoScreen extends StatefulWidget {
  AddFamilyUserInfoArguments? arguments;

  AddFamilyUserInfoScreen({this.arguments});

  @override
  AddFamilyUserInfoScreenState createState() => AddFamilyUserInfoScreenState();
}

class AddFamilyUserInfoScreenState extends State<AddFamilyUserInfoScreen> {
  GlobalKey<ScaffoldMessengerState> scaffold_state =
      GlobalKey<ScaffoldMessengerState>();
  final double circleRadius = 100.0.h;
  final double circleBorderWidth = 2.0.w;
  File? imageURI;

  final mobileNoController = TextEditingController(text: '');
  FocusNode mobileNoFocus = FocusNode();

  final firstNameController = TextEditingController(text: '');
  FocusNode firstNameFocus = FocusNode();

  final middleNameController = TextEditingController(text: '');
  FocusNode middleNameFocus = FocusNode();

  final lastNameController = TextEditingController(text: '');
  FocusNode lastNameFocus = FocusNode();

  final relationShipController = TextEditingController(text: '');
  FocusNode relationShipFocus = FocusNode();

  final emailController = TextEditingController(text: '');
  FocusNode emailFocus = FocusNode();

  final genderController = TextEditingController(text: '');
  FocusNode genderFocus = FocusNode();

  final bloodGroupController = TextEditingController(text: '');
  FocusNode bloodGroupFocus = FocusNode();

  final dateOfBirthController = TextEditingController(text: '');
  FocusNode dateOfBirthFocus = FocusNode();

  final heightController = TextEditingController(text: '');
  FocusNode heightFocus = FocusNode();
  final heightInchController = TextEditingController(text: '');
  FocusNode heightInchFocus = FocusNode();

  final weightController = TextEditingController(text: '');
  FocusNode weightFocus = FocusNode();
  FocusNode dobFocus = FocusNode();
  AddFamilyUserInfoBloc? addFamilyUserInfoBloc;
  late AddFamilyUserInfoRepository _addFamilyUserInfoRepository;

  List<RelationsShipModel>? relationShipResponseList;
  RelationsShipModel? selectedRelationShip;
  bool isCalled = false;

  String? selectedGender;

  String? currentselectedBloodGroup;
  String? currentselectedBloodGroupRange;
  var currentAddressID;

  DateTime dateTime = DateTime.now();
  String? dateofBirthStr;

  var cntrlr_addr_one = TextEditingController(text: '');
  var cntrlr_addr_two = TextEditingController(text: '');
  var cntrlr_addr_city = TextEditingController(text: '');
  var cntrlr_addr_state = TextEditingController(text: '');
  var cntrlr_addr_zip = TextEditingController(text: '');

  var cntrlr_corp_name = TextEditingController(text: '');

  final _formkey = GlobalKey<FormState>();

  City? cityVal = City();
  stateObj.State? stateVal = stateObj.State();

  AddressResult _addressResult = AddressResult();
  List<DropdownMenuItem<String>> languagesList = [];
  List<DropdownMenuItem<String>> languagesNameList = [];
  String? selectedLanguage;
  List<AddressResult> _addressList = [];
  String? addressTypeId;

  String? city = '';
  String? state = '';

  late var dialogContext;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  String strErrorMsg = '';
  bool updateProfile = false;
  CommonUtil commonUtil = CommonUtil();
  DoctorPersonalViewModel doctorPersonalViewModel = DoctorPersonalViewModel();

  String? currentUserID;

  UserContactCollection3? mContactInfo;
  ChatViewModel chatViewModel = ChatViewModel();

  LanguageRepository languageBlock = LanguageRepository();
  late LanguageModel languageModelList;

  late AddFamilyUserInfoRepository addFamilyUserInfoRepository;
  MyProfileModel myProfile = MyProfileModel();

  bool isFeetOrInches = true;
  bool isKg = true;

  late HealthReportListForUserRepository _healthReportListForUserRepository;
  List<Tags>? selectedTags = [];
  List<Tags> mediaResultFiltered = [];

  String? heightUnit = 'feet', weightUnit = 'kg';

  SheelaAIController? sheelaAIcontroller =
      CommonUtil().onInitSheelaAIController();
  var isPortrait;
  double tagTextSize =
      CommonUtil().isTablet! ? 22 : 16; //incrase the size of text in tablet
  @override
  void initState() {
    super.initState();
    sheelaAIcontroller!.getLanguagesFromApi().then((value) {
      getSupportedLanguages();
    });
    addFamilyUserInfoBloc = AddFamilyUserInfoBloc();
    _addFamilyUserInfoRepository = AddFamilyUserInfoRepository();
    addFamilyUserInfoBloc!.getCustomRoles();
    _healthReportListForUserRepository = HealthReportListForUserRepository();

    getDefaultHeightAndWeight();

    setUserId();
    addFamilyUserInfoBloc!.getDeviceSelectionValues().then((value) {
      //fetchUserProfileInfo();
    });

    setUnit();

    _healthReportListForUserRepository.getTags().then((value) {
      List<Tags> tagslist = value.result!;

      mediaResultFiltered = removeUnwantedCategories(tagslist);

      setTheValuesForDropdown(mediaResultFiltered);
    });
    setValuesInEditText();

    languageBlock = LanguageRepository();
  }

  @override
  void dispose() {
    checkCSIRPackageVaildation();
    super.dispose();
  }

  fetchUserProfileInfo() async {
    addFamilyUserInfoRepository = AddFamilyUserInfoRepository();
    var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;
    myProfile = await addFamilyUserInfoRepository.getMyProfileInfoNew(userid);

    return myProfile;
  }

  dynamic checkAddressValidation(
      UserAddressCollection3 userAddressCollection3) {
    var addrLine1 = userAddressCollection3.addressLine1;
    var city = userAddressCollection3.city?.name;
    var state = userAddressCollection3.state?.name;
    if (addrLine1 != '' && city != '' && state != '') {
      return true;
    } else {
      return false;
    }
  }

  void checkCSIRPackageVaildation() async {
    /* if(widget?.arguments?.isFromCartPage){
      MyProfileModel myProfile = await CommonUtil().fetchUserProfileInfo();
      if (myProfile?.result?.userAddressCollection3?.isNotEmpty) {
        final callback = checkAddressValidation(
            myProfile?.result?.userAddressCollection3[0]);
        if (callback) {
          CheckoutPageWidgets().mDisclaimerAlertDialog(
            context: Get.context,
            packageId: widget.arguments.packageId,
            isSubscribed: widget.arguments.isSubscribed,
            providerId: widget.arguments.providerId,
            feeZero: widget.arguments.feeZero,
            refresh: widget.arguments.refresh,
          );
        } else {}
      }
    }
    else  */
    if (widget.arguments!.isFromCSIR) {
      var myProfile = await CommonUtil().fetchUserProfileInfo();
      if (myProfile.result!.userAddressCollection3!.isNotEmpty) {
        var callback = checkAddressValidation(
            myProfile.result!.userAddressCollection3![0]);
        if (callback) {
          await CommonUtil().mDisclaimerAlertDialog(
            context: Get.context!,
            packageId: widget.arguments!.packageId,
            isSubscribed: widget.arguments!.isSubscribed,
            providerId: widget.arguments!.providerId,
            feeZero: widget.arguments!.feeZero,
            refresh: widget.arguments!.refresh,
          );
        } else {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    dialogContext = context;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return Future.value(true);
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 24.0.sp,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  //Navigator.of(context).pop();
                },
              )),
          key: scaffold_state,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 80.0.h,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                    child: Container(
                      width: 100.0.h,
                      height: 100.0.h,
                      decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          color: mAppThemeProvider.primaryColor),
                      child: Padding(
                        padding: EdgeInsets.all(circleBorderWidth),
                        child: InkWell(
                          onTap: () {
                            saveMediaDialog(context);
                          },
                          child: ClipOval(
                              child: (imageURI != null && imageURI != '')
                                  ? Image.file(
                                      imageURI!,
                                      fit: BoxFit.cover,
                                      width: 60.0.h,
                                      height: 60.0.h,
                                    )
                                  : showProfileImageNew()),
                        ),
                      ),
                    )),
//                Stack(
//                  alignment: Alignment.bottomLeft,
//                  children: <Widget>[
//                    Padding(
//                      padding: EdgeInsets.only(bottom: circleRadius / 2.0),
//                      child: Container(
//                        color: mAppThemeProvider.primaryColor,
//                        height: 160.0.h,
//                        child: Stack(
//                            fit: StackFit.expand,
//                            overflow: Overflow.visible,
//                            children: [
//                              Container(
//                                color: Colors.black.withOpacity(0.2),
//                              )
//                            ]),
//                      ),
//                    ),
//                    Padding(
//                        padding: EdgeInsets.only(left: 10),
//                        child: Container(
//                          width: circleRadius,
//                          height: circleRadius,
//                          decoration: ShapeDecoration(
//                              shape: CircleBorder(),
//                              color:
//                                  mAppThemeProvider.primaryColor),
//                          child: Padding(
//                            padding: EdgeInsets.all(circleBorderWidth),
//                            child: InkWell(
//                              child: ClipOval(
//                                  child: (imageURI != null && imageURI != '')
//                                      ? Image.file(
//                                          imageURI,
//                                          fit: BoxFit.cover,
//                                          width: 60.0.h,
//                                          height: 60.0.h,
//                                        )
//                                      : showProfileImageNew()),
//                              onTap: () {
//                                saveMediaDialog(context);
//                              },
//                            ),
//                          ),
//                        )),
//                  ],
//                ),
                _showCommonEditText(
                  mobileNoController,
                  mobileNoFocus,
                  firstNameFocus,
                  CommonConstants.mobile_numberWithStar,
                  CommonConstants.mobile_number,
                  false,
                ),
                _showCommonEditText(
                    firstNameController,
                    firstNameFocus,
                    middleNameFocus,
                    CommonConstants.firstNameWithStar,
                    CommonConstants.firstName,
                    true,
                    maxLength: 35),
                _showCommonEditText(
                    middleNameController,
                    middleNameFocus,
                    lastNameFocus,
                    CommonConstants.middleName,
                    CommonConstants.middleName,
                    true,
                    maxLength: 35),
                _showCommonEditText(
                    lastNameController,
                    lastNameFocus,
                    relationShipFocus,
                    CommonConstants.lastNameWithStar,
                    CommonConstants.lastName,
                    true,
                    maxLength: 35),
                widget.arguments!.fromClass == CommonConstants.my_family
                    ? (relationShipResponseList != null &&
                            relationShipResponseList!.isNotEmpty)
                        ? Row(
                            children: <Widget>[
                              Expanded(
                                child: getRelationshipDetails(
                                    relationShipResponseList!),
                              )
                            ],
                          )
                        : _showRelationShipTextField()
                    : widget.arguments!.isForFamilyAddition == true
                        ? getAllCustomRoles()
                        : widget.arguments!.fromClass ==
                                CommonConstants.user_update
                            ? Container()
                            : _showRelationShipTextField(),
                _showCommonEditText(
                    emailController,
                    emailFocus,
                    genderFocus,
                    CommonUtil.REGION_CODE == "IN"
                        ? CommonConstants.emailWithStar
                        : CommonConstants.emailWithoutStar,
                    CommonConstants.email_address_optional,
                    (widget.arguments!.fromClass ==
                                CommonConstants.user_update ||
                            widget.arguments!.fromClass ==
                                CommonConstants.add_family)
                        ? true
                        : false,
                    maxLength: 50),
                Row(
                  children: <Widget>[Expanded(child: getGenderDetails())],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: getBloodGroupDetails()),
                    Expanded(child: getBloodRangeDetails())
                  ],
                ),
                isFeetOrInches
                    ? Container(
                        child: Row(
                        children: [
                          Expanded(
                              child: _showCommonEditText(
                                  heightController,
                                  heightFocus,
                                  heightInchFocus,
                                  CommonConstants.heightNameFeetInd,
                                  CommonConstants.heightNameFeetInd,
                                  true,
                                  isheightOrWeight: true,
                                  maxLength: 3)),
                          Expanded(
                              child: _showCommonEditText(
                                  heightInchController,
                                  heightInchFocus,
                                  middleNameFocus,
                                  CommonConstants.heightNameInchInd,
                                  CommonConstants.heightNameInchInd,
                                  true,
                                  isheightOrWeight: true,
                                  maxLength: 3)),
                          Expanded(
                              child: _showCommonEditText(
                                  weightController,
                                  weightFocus,
                                  middleNameFocus,
                                  isKg
                                      ? CommonConstants.weightName
                                      : CommonConstants.weightNameUS,
                                  isKg
                                      ? CommonConstants.weightName
                                      : CommonConstants.weightNameUS,
                                  true,
                                  isheightOrWeight: true,
                                  maxLength: 3))
                        ],
                      ))
                    : Row(
                        children: [
                          Expanded(
                              child: _showCommonEditText(
                                  heightController,
                                  heightFocus,
                                  middleNameFocus,
                                  CommonConstants.heightName,
                                  CommonConstants.heightName,
                                  true,
                                  isheightOrWeight: true,
                                  maxLength: 3)),
                          Expanded(
                              child: _showCommonEditText(
                                  weightController,
                                  weightFocus,
                                  middleNameFocus,
                                  isKg
                                      ? CommonConstants.weightName
                                      : CommonConstants.weightNameUS,
                                  isKg
                                      ? CommonConstants.weightName
                                      : CommonConstants.weightNameUS,
                                  true,
                                  isheightOrWeight: true,
                                  maxLength: 3))
                        ],
                      ),
                if (widget.arguments!.fromClass == CommonConstants.user_update)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 12),
                        child: Text(
                          CommonConstants.preferredLanguage,
                          style: TextStyle(
                              fontSize: 12.0.sp,
                              color: ColorUtils.myFamilyGreyColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      getLanguageWidget()
                    ],
                  )
                else
                  Container(),
                if (widget.arguments!.fromClass == CommonConstants.user_update)
                  //getDropDownWithTagsdrop()

                  Column(
                    children: [
                      getTagsWithButton(context),
                      selectedTags != null && selectedTags!.length > 0
                          ? Taglist(
                              forMyProfile: false,
                              tags: selectedTags,
                              onChecked: (result) {
                                addSelectedcategoriesToList(result!);
                              },
                            ) /*Container(
                              child: GridView.count(
                                  crossAxisCount: CommonUtil().isTablet!
                                      ? isPortrait
                                          ? 2
                                          : 3
                                      : 2,
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 5),
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: (itemWidth / itemHeight) > 0
                                      ? (itemWidth / itemHeight)
                                      : 4.0,
                                  crossAxisSpacing: 10.0,
                                  controller: ScrollController(
                                      keepScrollOffset: false),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: selectedTags!.map((Tags tagObj) {
                                    return Container(
                                      height: 60.0.h,
                                      margin: EdgeInsets.all(
                                        1.0.sp,
                                      ),
                                      padding: EdgeInsets.all(
                                        5.0.sp,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: mAppThemeProvider.primaryColor),
                                        borderRadius: BorderRadius.circular(
                                          10.0.sp,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: TextWidget(
                                                text: tagObj.name,
                                                fontsize: tagTextSize,
                                                colors: Color(new CommonUtil()
                                                    .getMyPrimaryColor()),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList()))
                          */
                          : SizedBox()
                    ],
                  )
                else
                  Container(),

                CommonUtil.isUSRegion()
                    ? _showDateOfBirthTextField()
                    : _showDateOfBirthTextFieldNew(),
                cntrlr_corp_name.text != ''
                    ? Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(fontSize: 16.0.sp),
                          controller: cntrlr_corp_name,
                          enabled: false,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 16.0.sp),
                            labelText: CommonConstants.corpname,
                          ),
                        ),
                      )
                    : SizedBox(),
                AddressTypeWidget(
                  addressResult: _addressResult,
                  addressList: _addressList,
                  onSelected: (addressResult, addressList) {
                    setState(() {
                      _addressResult = addressResult!;
                      addressTypeId = addressResult.id;
                      _addressList = addressList!;
                    });
                  },
                ),
                _userAddressInfo(),
                _showSaveButton()
              ],
            ),
          )),
    );
  }

  void getSupportedLanguages() {
    var lan = CommonUtil.getCurrentLanCode();
    if (lan != 'undef') {
      var langCode = lan!.split('-').first;
      selectedLanguage = langCode;
    } else {
      selectedLanguage = "en";
      PreferenceUtil.saveString(SHEELA_LANG, strDefaultLanguage);
    }
    sheelaAIcontroller!.langaugeDropdownList.forEach((language, languageCode) {
      languagesList.add(
        DropdownMenuItem<String>(
          value: languageCode,
          child: Text(
            toBeginningOfSentenceCase(language)!,
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
          ),
        ),
      );
    });
    // return languagesList;
  }

  Widget getGenderDetails() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Container(
        width: 1.sw - 40,
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            CommonConstants.genderWithStar,
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
          ),
          value: selectedGender != null
              ? toBeginningOfSentenceCase(selectedGender!.toLowerCase())
              : selectedGender,
          items: variable.genderArray.map((eachGender) {
            return DropdownMenuItem(
              child: Text(eachGender,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0.sp,
                      color: ColorUtils.blackcolor)),
              value: eachGender,
            );
          }).toList(),
          onChanged: (newSelectedValue) {
            setState(() {
              selectedGender = newSelectedValue;
            });
          },
        ),
      ),
    );
  }

  Widget _showDateOfBirthTextField() {
    return GestureDetector(
      onTap: dateOfBirthTapped,
      child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5),
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            cursorColor: mAppThemeProvider.primaryColor,
            controller: dateOfBirthController,
            readOnly: true,
            onTap: dateOfBirthTapped,
            keyboardType: TextInputType.text,
            focusNode: dateOfBirthFocus,
            textInputAction: TextInputAction.done,
            onSubmitted: (term) {
              dateOfBirthFocus.unfocus();
            },
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0.sp,
                color: ColorUtils.blackcolor),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.calendar_today,
                  size: 24.0.sp,
                ),
                onPressed: () {
                  _selectDate(context);
                },
              ),
              labelText: CommonConstants.date_of_birthWithStar,
              hintText: CommonConstants.date_of_birth,
              labelStyle: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.myFamilyGreyColor),
              hintStyle: TextStyle(
                fontSize: 16.0.sp,
                color: ColorUtils.myFamilyGreyColor,
                fontWeight: FontWeight.w400,
              ),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
            ),
          )),
    );
  }

  Widget _showDateOfBirthTextFieldNew() {
    return _showCommonEditText(
        dateOfBirthController,
        dateOfBirthFocus,
        null,
        CommonConstants.year_of_birth_with_star,
        CommonConstants.year_of_birth,
        true,
        isheightOrWeight: true,
        maxLength: 4);
  }

  void dateOfBirthTapped() {
    _selectDate(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (picked != null) {
      setState(() {
        dateTime = picked;

        dateofBirthStr =
            FHBUtils().getFormattedDateForUserBirth(dateTime.toString());
        if (CommonUtil.isUSRegion()) {
          dateOfBirthController.text =
              FHBUtils().getFormattedDateOnly(dateTime.toString())!;
        } else {
          dateOfBirthController.text =
              FHBUtils().getFormattedDateOnlyNew(dateTime.toString())!;
        }
      });
    }
  }

  Widget _showCommonEditText(
    TextEditingController textEditingController,
    FocusNode focusNode,
    FocusNode? nextFocusNode,
    String labelText,
    String hintText,
    bool isEnabled, {
    int? maxLength,
    bool isheightOrWeight = false,
  }) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          enabled: isEnabled,
          cursorColor: mAppThemeProvider.primaryColor,
          controller: textEditingController,
          onChanged: (value) {
            if (maxLength == 4) {
              dateofBirthStr =
                  FHBUtils().getFormattedDateForUserBirth(value.toString());
            }
          },
          enableInteractiveSelection: false,
          maxLength: maxLength,
          keyboardType:
              isheightOrWeight ? TextInputType.number : TextInputType.text,
          focusNode: focusNode,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            if (maxLength == 4) {
              dateofBirthStr =
                  FHBUtils().getFormattedDateForUserBirth(term.toString());
            }
            FocusScope.of(context).requestFocus(nextFocusNode);
          },
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
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
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          ),
          inputFormatters: (textEditingController == firstNameController ||
                  textEditingController == lastNameController ||
                  textEditingController == middleNameController)
              ? [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]*'))]
              : [],
        ));
  }

  Widget _userAddressInfo() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                fontSize: 16.0.sp,
              ),
              controller: cntrlr_addr_one,
              enabled: true,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.myFamilyGreyColor),
                hintStyle: TextStyle(
                  fontSize: 16.0.sp,
                  color: ColorUtils.myFamilyGreyColor,
                  fontWeight: FontWeight.w400,
                ),
                labelText: CommonConstants.addr_line_1,
              ),
              /* validator: (res) {
                return (res.isEmpty || res == null)
                    ? 'Address line1 can\'t be empty'
                    : null;
              }, */
            ),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                fontSize: 16.0.sp,
              ),
              controller: cntrlr_addr_two,
              enabled: true,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.myFamilyGreyColor),
                hintStyle: TextStyle(
                  fontSize: 16.0.sp,
                  color: ColorUtils.myFamilyGreyColor,
                  fontWeight: FontWeight.w400,
                ),
                labelText: CommonConstants.addr_line_2,
              ),
            ),
            TypeAheadFormField<City>(
              textFieldConfiguration: TextFieldConfiguration(
                  controller: cntrlr_addr_city,
                  onChanged: (value) {
                    cityVal = null;
                  },
                  decoration: InputDecoration(
                    hintText: 'City*',
                    labelText: 'City*',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                        fontSize: 15.0.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.myFamilyGreyColor),
                    hintStyle: TextStyle(
                      fontSize: 16.0.sp,
                      color: ColorUtils.myFamilyGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  )),
              suggestionsCallback: (pattern) async {
                if (pattern.length >= 3) {
                  return await getCitybasedOnSearch(
                    pattern,
                    'city',
                  ) as FutureOr<Iterable<City>>;
                } else {
                  return [];
                }
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(
                    suggestion.name!,
                    style: TextStyle(
                      fontSize: 16.0.sp,
                    ),
                  ),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              errorBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(
                    'Oops. We could not find the city you typed.',
                    style: TextStyle(
                      fontSize: 16.0.sp,
                    ),
                  ),
                );
              },
              onSuggestionSelected: (suggestion) {
                cntrlr_addr_city.text = suggestion.name ?? '';
                cityVal = suggestion;
                if (cityVal != null && cityVal?.state != null) {
                  cntrlr_addr_state.text = suggestion.state!.name ?? '';
                  stateVal = suggestion.state;
                }
                //stateVal = suggestion.state;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please select a city';
                } else if (cityVal == null) {
                  return 'Please select a City from list';
                }
                return null;
              },
              onSaved: (value) => city = value,
            ),
            TypeAheadFormField<stateObj.State>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: cntrlr_addr_state,
                decoration: InputDecoration(
                  hintText: 'State',
                  labelText: 'State',
                  border: InputBorder.none,
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
                onChanged: (value) {
                  stateVal = null;
                },
              ),
              suggestionsCallback: (pattern) async {
                if (pattern.length >= 3) {
                  return await (getStateBasedOnSearch(
                    pattern,
                    'state',
                  ) as FutureOr<Iterable<stateObj.State>>);
                } else {
                  return [];
                }
              }, //as FutureOr<Iterable<stateObj.State>> Function(String),
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(
                    suggestion.name ?? '',
                    style: TextStyle(
                      fontSize: 16.0.sp,
                    ),
                  ),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              errorBuilder: (context, suggestion) {
                stateVal = null;
                return ListTile(
                  title: Text(
                    'Oops. We could not find the state you typed.',
                    style: TextStyle(
                      fontSize: 16.0.sp,
                    ),
                  ),
                );
              },
              onSuggestionSelected: (suggestion) {
                cntrlr_addr_state.text = suggestion.name ?? '';
                stateVal = suggestion;
                cntrlr_addr_city.text = "";
                cityVal = null;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please select a State';
                } else if (stateVal == null) {
                  return 'Please select a State from list';
                }
                return null;
              },
              onSaved: (value) => state = value,
            ),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                fontSize: 16.0.sp,
              ),
              controller: cntrlr_addr_zip,
              enabled: true,
              maxLength: CommonUtil.REGION_CODE == 'IN' ? 6 : 5,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.myFamilyGreyColor),
                hintStyle: TextStyle(
                  fontSize: tagTextSize,
                  color: ColorUtils.myFamilyGreyColor,
                  fontWeight: FontWeight.w400,
                ),
                labelText: CommonUtil.REGION_CODE == 'IN'
                    ? CommonConstants.addr_pin
                    : CommonConstants.addr_zip,
              ),
              /* validator: (res) {
                return (res.isEmpty || res == null)
                    ? 'Zip can\'t be empty'
                    : null;
              }, */
            ),
          ],
        ),
      ),
    );
  }

  Widget _showSaveButton() {
    var addButtonWithGesture = GestureDetector(
      onTap: _saveBtnTappedClone,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            width: 150.0.w,
            height: 40.0.h,
            decoration: BoxDecoration(
              color: mAppThemeProvider.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
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
                (widget.arguments!.isForFamilyAddition == true)
                    ? CommonConstants.add
                    : (widget.arguments!.fromClass ==
                                CommonConstants.my_family ||
                            widget.arguments!.fromClass ==
                                CommonConstants.user_update)
                        ? CommonConstants.update
                        : CommonConstants.save,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: addButtonWithGesture);
  }

  Widget _showOKButton() {
    var addButtonWithGesture = GestureDetector(
      onTap: _onOkPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            width: 150.0.w,
            height: 40.0.h,
            decoration: BoxDecoration(
              color: mAppThemeProvider.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
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
                CommonConstants.ok,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: addButtonWithGesture);
  }

  void _onOkPressed() {
    Navigator.pop(context);
    setState(() {});
  }

  void verifyEmail() {
    addFamilyUserInfoBloc!.verifyEmail().then((value) {
      if (value!.success! &&
          value.message!.contains(Constants.MSG_VERIFYEMAIL_VERIFIED)) {
        FHBBasicWidget().showInSnackBar(value.message!, scaffold_state);
      } else {
        PreferenceUtil.saveString(
            Constants.PROFILE_EMAIL, emailController.text);

        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => OtpVerifyScreen(
                      enteredMobNumber:
                          PreferenceUtil.getStringValue(Constants.MOB_NUM),
                      selectedCountryCode: PreferenceUtil.getIntValue(
                              CommonConstants.KEY_COUNTRYCODE)
                          .toString(),
                      fromSignIn: true,
                      forEmailVerify: true,
                    )))
            .then((value) {
          Navigator.popUntil(context, (route) {
            var shouldPop = false;
            if (route.settings.name == router.rt_UserAccounts) {
              shouldPop = true;
            }
            return shouldPop;
          });
        });
      }
    });
  }

  Widget getRelationshipDetails(List<RelationsShipModel> data) {
    var currentSelectedUserRole = data[15];
    if (widget.arguments!.isForFamilyAddition == true &&
        selectedRelationShip == null)
      selectedRelationShip = currentSelectedUserRole;

    if (selectedRelationShip != null)
      for (final model in data) {
        if (model.id == selectedRelationShip!.id) {
          currentSelectedUserRole = model;
        }
      }

    return Container(
      color: widget.arguments!.isForFamilyAddition!
          ? Colors.yellow[300]
          : Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: DropdownButton<RelationsShipModel>(
          hint: Text(
            CommonConstants.relationship,
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
          ),
          isExpanded: true,
          value: currentSelectedUserRole,
          items: data.map((val) {
            return DropdownMenuItem<RelationsShipModel>(
              value: val,
              child: Text(
                val.name!,
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
              ),
            );
          }).toList(),
          onChanged: (newSelectedValue) {
            setState(() {
              selectedRelationShip = newSelectedValue;
            });
          },
        ),
      ),
    );
  }

  Widget _showRelationShipTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          onTap: () {
            widget.arguments!.fromClass == CommonConstants.my_family
                ? relationShipResponseList != null
                    ? Row(
                        children: <Widget>[
                          getRelationshipDetails(relationShipResponseList!)
                        ],
                      )
                    : getAllCustomRoles()
                : widget.arguments!.isForFamilyAddition == true
                    ? getAllCustomRoles()
                    : widget.arguments!.fromClass == CommonConstants.user_update
                        ? Container()
                        : _showRelationShipTextField();
          },
          cursorColor: mAppThemeProvider.primaryColor,
          controller: relationShipController,
          enabled: (widget.arguments!.fromClass == CommonConstants.my_family ||
                  widget.arguments!.fromClass == CommonConstants.add_family ||
                  widget.arguments!.isForFamilyAddition == true)
              ? true
              : false,
          keyboardType: TextInputType.text,
          //          focusNode: relationShipFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(emailFocus);
          },
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.relationship,
            hintText: CommonConstants.relationship,
            labelStyle: TextStyle(
                fontSize: 15.0.sp,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 16.0.sp,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          ),
        ));
  }

  Widget getBloodGroupDetails() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Container(
        width: 1.sw / 2 - 40,
        child: DropdownButton<String>(
          hint: Text(
            CommonConstants.blood_groupWithStar,
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
          ),
          value: currentselectedBloodGroup,
          items: variable.bloodGroupArray.map((eachBloodGroup) {
            return DropdownMenuItem<String>(
              value: eachBloodGroup,
              child: Text(eachBloodGroup,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0.sp,
                      color: ColorUtils.blackcolor)),
            );
          }).toList(),
          onChanged: (newSelectedValue) {
            setState(() {
              currentselectedBloodGroup = newSelectedValue;
            });
          },
        ),
      ),
    );
  }

  Widget getBloodRangeDetails() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Container(
        width: 1.sw / 2 - 40,
        child: DropdownButton<String>(
          hint: Text(
            CommonConstants.blood_rangeWithStar,
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
          ),
          isExpanded: true,
          value: currentselectedBloodGroupRange,
          items: variable.bloodRangeArray.map((eachBloodGroup) {
            return DropdownMenuItem<String>(
              value: eachBloodGroup,
              child: Text(eachBloodGroup,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0.sp,
                      color: ColorUtils.blackcolor)),
            );
          }).toList(),
          onChanged: (newSelectedValue) {
            setState(() {
              currentselectedBloodGroupRange = newSelectedValue;
            });
          },
        ),
      ),
    );

    /* return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
          child: Container(
              width: 1.sw / 2 - 40,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(CommonConstants.blood_rangeWithStar),
                value: selectedBloodRange,
                items: variable.bloodRangeArray.map((eachBloodGroup) {
                  return DropdownMenuItem(
                    child: Text(eachBloodGroup,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0.sp,
                            color: ColorUtils.blackcolor)),
                    value: eachBloodGroup,
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    selectedBloodRange = newValue;
                  });
                },
              )));
    }); */
  }

  void _saveBtnTappedClone() {
    FHBUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        //address fields validation
        if (_formkey.currentState!.validate()) {
          var _familyListBloc = FamilyListBloc();
          //NOTE this would be called when family member profile update
          if (widget.arguments!.isForFamilyAddition == true) {
            CommonUtil.showLoadingDialog(
                dialogContext, _keyLoader, variable.Please_Wait);
            methodToAddFamilyFromNotification();
          } else if (widget.arguments!.fromClass == CommonConstants.my_family) {
            addFamilyUserInfoBloc!.userId = widget.arguments!.id;
            addFamilyUserInfoBloc!.relationship = UpdateRelationshipModel(
                id: widget.arguments!.sharedbyme!.id,
                relationship: selectedRelationShip);

            setValues();
          } else if (widget.arguments!.fromClass ==
              CommonConstants.user_update) {
            addFamilyUserInfoBloc!.userId =
                widget.arguments!.myProfileResult!.id;

            setValues();
          } else {
            addFamilyUserInfoBloc!.userId =
                widget.arguments!.addFamilyUserInfo!.childInfo!.id;

            setValues();
          }
        } else {
          //address validation not valid.
          print('invalid user input');
        }
      } else {
        FHBBasicWidget()
            .showInSnackBar(Constants.STR_NO_CONNECTIVITY, scaffold_state);
      }
    });
  }

  Future<List<City>> getCitybasedOnSearch(
    String cityname,
    String apibody,
  ) async {
    List<City> citylist;
    citylist = await addFamilyUserInfoBloc!.getCityDataList(cityname, apibody)
        as List<City>;
    return citylist;
  }

  Future<List<stateObj.State>> getStateBasedOnSearch(
    String stateName,
    String apibody,
  ) async {
    List<stateObj.State> stateList;
    stateList = await addFamilyUserInfoBloc!.geStateDataList(stateName, apibody)
        as List<stateObj.State>;
    return stateList;
  }

  bool doValidation() {
    var isValid = false;

    var emailValid = '@'.allMatches(emailController.text.trim()).length > 1
        ? false
        : RegExp(patternEmail as String).hasMatch(emailController.text);

    if (firstNameController.text == '') {
      isValid = false;
      strErrorMsg = variable.enterFirstName;
    } else if (lastNameController.text == '') {
      isValid = false;
      strErrorMsg = variable.enterLastName;
    } else if (selectedGender == null) {
      isValid = false;
      strErrorMsg = variable.selectGender;
    } else if (dateOfBirthController.text.toString().trim().isEmpty) {
      isValid = false;
      strErrorMsg = CommonUtil.isUSRegion()
          ? variable.selectDateOfBirth
          : variable.selectYOB;
    } else if (!CommonUtil.isUSRegion() &&
        dateOfBirthController.text.length < 4) {
      isValid = false;
      strErrorMsg = "Enter a Valid Year";
    } else if (!CommonUtil.isUSRegion() &&
        checkIfYearIsGreaterThanCurrentYear(
            int.parse(dateOfBirthController.text))) {
      isValid = false;
    } else if (_addressResult == null || _addressResult.id == null) {
      isValid = false;
      strErrorMsg = 'Select Address type';
    } else if (selectedLanguage == null || selectedLanguage!.isEmpty) {
      isValid = false;
      strErrorMsg = 'Select Preferred Language';
    } else if (currentselectedBloodGroup == null) {
      if (currentselectedBloodGroupRange == null) {
        isValid = false;
        strErrorMsg = variable.selectRHType;
      } else {
        addFamilyUserInfoBloc!.bloodGroup =
            currentselectedBloodGroup! + '_' + currentselectedBloodGroupRange!;
      }
      isValid = false;
      strErrorMsg = variable.selectBloodGroup;
    } else if (emailController.text != '' && !emailValid) {
      isValid = false;
      strErrorMsg = 'Invalid Email Address';
    } else {
      isValid = true;
    }

    return isValid;
  }

  void setValuesInEditText() async {
    try {
      languageModelList = await languageBlock.getLanguage();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    //* set the user data from input
    _addressList = await doctorPersonalViewModel.getAddressTypeList();
    if (widget.arguments!.fromClass == CommonConstants.user_update) {
      //* user profile update sections
      addFamilyUserInfoBloc!.userId = widget.arguments!.myProfileResult!.id;

      if (widget.arguments!.sharedbyme != null) {
        try {
          if (widget.arguments!.sharedbyme!.child!.userContactCollection3!
              .isNotEmpty) {
            mobileNoController.text = widget.arguments!.sharedbyme!.child!
                    .userContactCollection3![0].phoneNumber ??
                '';
            emailController.text = widget.arguments!.sharedbyme!.child!
                    .userContactCollection3![0].email ??
                '';
          }
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
          mobileNoController.text = '';
          emailController.text = '';
        }
      } else {
        if (widget.arguments!.isForFamilyAddition!) {
          try {
            if (widget.arguments!.myProfileResult!.userContactCollection3!
                .isNotEmpty) {
              mobileNoController.text = widget.arguments!.myProfileResult!
                      .userContactCollection3![0]!.phoneNumber ??
                  '';
              emailController.text = widget.arguments!.myProfileResult!
                      .userContactCollection3![0]!.email ??
                  '';
            }
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
            mobileNoController.text = '';
            emailController.text = '';
          }
        } else {
          try {
            var myProf =
                await PreferenceUtil.getProfileData(Constants.KEY_PROFILE) ??
                    PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
            if (myProf!.result!.userContactCollection3 != null &&
                myProf.result!.userContactCollection3!.length > 0) {
              if (myProf.result!.userContactCollection3!.isNotEmpty) {
                mobileNoController.text =
                    myProf.result!.userContactCollection3![0]!.phoneNumber ??
                        '';
                emailController.text =
                    myProf.result!.userContactCollection3![0]!.email ?? '';
              }
            } else {
              var myProf = await PreferenceUtil.getProfileData(
                  Constants.KEY_PROFILE_MAIN);
              if (myProf!.result!.userContactCollection3 != null &&
                  myProf.result!.userContactCollection3!.length > 0) {
                if (myProf.result!.userContactCollection3!.isNotEmpty) {
                  mobileNoController.text =
                      myProf.result!.userContactCollection3![0]!.phoneNumber ??
                          '';
                  emailController.text =
                      myProf.result!.userContactCollection3![0]!.email ?? '';
                }
              }
            }
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
            if (widget.arguments!.myProfileResult!.userContactCollection3 !=
                    null &&
                widget.arguments!.myProfileResult!.userContactCollection3!
                        .length >
                    0) {
              if (widget.arguments!.myProfileResult!.userContactCollection3!
                  .isNotEmpty) {
                mobileNoController.text = widget.arguments!.myProfileResult!
                        .userContactCollection3![0]!.phoneNumber ??
                    '';
                emailController.text = widget.arguments!.myProfileResult!
                        .userContactCollection3![0]!.email ??
                    '';
              }
            }
          }
        }

        if (widget.arguments!.myProfileResult!.dateOfBirth != null) {
          dateofBirthStr = FHBUtils().getFormattedDateForUserBirth(
              widget.arguments!.myProfileResult!.dateOfBirth!);
          if (CommonUtil.isUSRegion()) {
            dateOfBirthController.text = FHBUtils().getFormattedDateOnly(
                widget.arguments!.myProfileResult!.dateOfBirth ?? "");
          } else {
            dateOfBirthController.text = FHBUtils().getFormattedDateOnlyNew(
                widget.arguments!.myProfileResult!.dateOfBirth)!;
          }
        }

        if (widget.arguments!.myProfileResult!.userAddressCollection3 != null &&
            widget.arguments!.myProfileResult!.userAddressCollection3!
                .isNotEmpty &&
            widget.arguments!.myProfileResult!.userAddressCollection3!.length >
                0) {
          cntrlr_addr_one.text = widget.arguments!.myProfileResult!
                  .userAddressCollection3![0].addressLine1 ??
              '';
          cntrlr_addr_two.text = widget.arguments!.myProfileResult!
                  .userAddressCollection3![0].addressLine2 ??
              '';
          cntrlr_addr_city.text = widget.arguments!.myProfileResult!
                  .userAddressCollection3![0].city!.name ??
              '';
          cntrlr_addr_state.text = widget.arguments!.myProfileResult!
                  .userAddressCollection3![0].state!.name ??
              '';
          cntrlr_addr_zip.text = widget.arguments!.myProfileResult!
                  .userAddressCollection3![0].pincode ??
              '';

          cityVal = widget
              .arguments!.myProfileResult!.userAddressCollection3![0].city;
          stateVal = widget
              .arguments!.myProfileResult!.userAddressCollection3![0].state;
          setState(() {
            _addressResult = AddressResult(
                id: widget.arguments!.myProfileResult!
                        .userAddressCollection3![0].addressType!.id ??
                    '',
                code: widget.arguments!.myProfileResult!
                        .userAddressCollection3![0].addressType!.code ??
                    '',
                name: widget.arguments!.myProfileResult!
                        .userAddressCollection3![0].addressType!.name ??
                    '');
          });
        } else {
          try {
            print('inside try');
            setState(() {
              _addressResult = _addressList[0];
            });
            print('after try');
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
          }
        }

        if (widget.arguments!.myProfileResult!.firstName != null) {
          firstNameController.text =
              (widget.arguments!.myProfileResult!.firstName != null
                  ? widget.arguments?.myProfileResult?.firstName
                      ?.capitalizeFirstofEach
                  : '')!;
          middleNameController.text =
              (widget.arguments?.myProfileResult?.middleName != null
                  ? widget.arguments?.myProfileResult?.middleName
                      ?.capitalizeFirstofEach
                  : '')!;
          lastNameController.text =
              (widget.arguments?.myProfileResult?.lastName != null
                  ? widget.arguments?.myProfileResult?.lastName
                      ?.capitalizeFirstofEach
                  : '')!;
        }

        if (widget.arguments!.myProfileResult!.additionalInfo != null) {
          if (isFeetOrInches) {
            heightController.text = widget.arguments!.myProfileResult!
                    .additionalInfo?.heightObj?.valueFeet ??
                '';
            heightInchController.text = widget.arguments!.myProfileResult!
                    .additionalInfo?.heightObj?.valueInches ??
                '';
          } else {
            heightController.text =
                widget.arguments!.myProfileResult!.additionalInfo!.height ?? '';
          }

          weightController.text = widget
                  .arguments!.myProfileResult!.additionalInfo!.weight
                  .toString() ??
              '';
        }
        if (commonUtil.checkIfStringisNull(
            widget.arguments!.myProfileResult!.bloodGroup)) {
          currentselectedBloodGroup =
              widget.arguments!.myProfileResult!.bloodGroup!.split(' ')[0];
          currentselectedBloodGroupRange =
              widget.arguments!.myProfileResult!.bloodGroup!.split(' ')[1];
        } else {
          currentselectedBloodGroup = null;
          currentselectedBloodGroupRange = null;
        }

        if (widget.arguments!.myProfileResult!.gender != null) {
          selectedGender = widget.arguments!.myProfileResult!.gender ?? '';
        }

        if (widget.arguments!.myProfileResult!.membershipOfferedBy != null &&
            widget.arguments!.myProfileResult!.membershipOfferedBy != '') {
          cntrlr_corp_name.text =
              widget.arguments!.myProfileResult!.membershipOfferedBy ?? '';
        }
        selectedTags = addFamilyUserInfoBloc!.tagsList != null &&
                addFamilyUserInfoBloc!.tagsList!.length > 0
            ? addFamilyUserInfoBloc!.tagsList
            : [];
        setTheValuesForDropdown(selectedTags);
      }
      await setValueLanguages();
    } else if (widget.arguments!.fromClass == CommonConstants.my_family) {
      //* my-family member details update sections
      addFamilyUserInfoBloc!.userId = widget
          .arguments!.sharedbyme!.id; //widget.arguments.addFamilyUserInfo.id;

      relationShipResponseList = widget.arguments?.defaultrelationShips;

      if (widget.arguments?.sharedbyme?.relationship?.name != null) {
        selectedRelationShip = widget.arguments!.sharedbyme!.relationship;
      }

      if (widget.arguments!.sharedbyme!.child!.isVirtualUser != null) {
        try {
          if (widget.arguments!.sharedbyme!.child!.isVirtualUser!) {
            var myProf =
                PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN) ??
                    PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
            try {
              if (myProf!.result!.userContactCollection3 != null) {
                if (myProf.result!.userContactCollection3!.isNotEmpty) {
                  mobileNoController.text =
                      myProf.result!.userContactCollection3![0]!.phoneNumber ??
                          '';
                  emailController.text =
                      myProf.result!.userContactCollection3![0]!.email ?? '';
                }
              }
            } catch (e, stackTrace) {
              CommonUtil().appLogs(message: e, stackTrace: stackTrace);
              setMobileAndEmail();
            }

            try {
              if (myProf!.result!.userProfileSettingCollection3 != null &&
                  myProf.result!.userProfileSettingCollection3!.length > 0) {
                var preferredMesurement = myProf
                    .result
                    ?.userProfileSettingCollection3![0]
                    .profileSetting
                    ?.preferredMeasurement;

                if (preferredMesurement != null) {}
              }
            } catch (e, stackTrace) {
              CommonUtil().appLogs(message: e, stackTrace: stackTrace);
            }
          } else {
            //! this must be loook
            if (widget.arguments!.sharedbyme!.child!.userContactCollection3!
                .isNotEmpty) {
              mobileNoController.text = widget.arguments!.sharedbyme!.child!
                      .userContactCollection3![0].phoneNumber ??
                  '';
              emailController.text = widget.arguments!.sharedbyme!.child!
                      .userContactCollection3![0].email ??
                  '';
            } else {
              mobileNoController.text = '';
              emailController.text = '';
            }
          }
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
          mobileNoController.text = '';
          emailController.text = '';
        }

        if (widget.arguments!.sharedbyme!.membershipOfferedBy != null &&
            widget.arguments!.sharedbyme!.membershipOfferedBy != '') {
          cntrlr_corp_name.text =
              widget.arguments!.sharedbyme!.membershipOfferedBy ?? '';
        }
      } else {
        if (widget
            .arguments!.sharedbyme!.child!.userContactCollection3!.isNotEmpty) {
          mobileNoController.text = widget.arguments!.sharedbyme!.child!
                  .userContactCollection3![0].phoneNumber ??
              '';
          emailController.text = widget.arguments!.sharedbyme!.child!
                  .userContactCollection3![0].email ??
              '';
        }
        if (widget.arguments!.sharedbyme!.membershipOfferedBy != null &&
            widget.arguments!.sharedbyme!.membershipOfferedBy != '') {
          cntrlr_corp_name.text =
              widget.arguments!.sharedbyme!.membershipOfferedBy ?? '';
        }
      }
      if (widget.arguments!.sharedbyme != null) {
        if (widget.arguments!.sharedbyme!.child!.firstName != null) {
          firstNameController.text =
              (widget.arguments!.sharedbyme!.child!.firstName != null
                  ? widget.arguments?.sharedbyme?.child?.firstName
                      ?.capitalizeFirstofEach
                  : '')!;
          middleNameController.text =
              (widget.arguments!.sharedbyme!.child!.middleName != null
                  ? widget.arguments?.sharedbyme?.child?.middleName
                      ?.capitalizeFirstofEach
                  : '')!;
          lastNameController.text =
              (widget.arguments!.sharedbyme!.child!.lastName != null
                  ? widget.arguments?.sharedbyme?.child?.lastName
                      ?.capitalizeFirstofEach
                  : '')!;
        } else {
          firstNameController.text = '';
        }

        if (widget.arguments!.sharedbyme!.child!.additionalInfo != null) {
          if (widget.arguments!.sharedbyme!.child!.additionalInfo?.heightObj !=
              null) {
            isFeetOrInches = true;
            heightController.text = widget.arguments!.sharedbyme!.child!
                    .additionalInfo?.heightObj?.valueFeet ??
                '';
            heightInchController.text = widget.arguments!.sharedbyme!.child!
                    .additionalInfo?.heightObj?.valueInches ??
                '';
          } else {
            isFeetOrInches = false;

            heightController.text =
                widget.arguments!.sharedbyme!.child!.additionalInfo!.height ??
                    '';
          }

          if (widget.arguments!.sharedbyme!.child!.additionalInfo!
                  .weightUnitCode ==
              'lb') {
            isKg = false;
          } else {
            isKg = true;
          }
          weightController.text =
              widget.arguments!.sharedbyme!.child!.additionalInfo!.weight ?? '';
        }
        if (commonUtil.checkIfStringisNull(
            widget.arguments!.sharedbyme!.child!.bloodGroup)) {
          currentselectedBloodGroup =
              widget.arguments!.sharedbyme!.child!.bloodGroup!.split(' ')[0];
          currentselectedBloodGroupRange =
              widget.arguments!.sharedbyme!.child!.bloodGroup!.split(' ')[1];
        } else {
          currentselectedBloodGroup = null;
          currentselectedBloodGroupRange = null;
        }

        if (widget.arguments!.sharedbyme!.child!.gender != null) {
          selectedGender = widget.arguments!.sharedbyme!.child!.gender ?? '';
        }

        if (widget
            .arguments!.sharedbyme!.child!.userAddressCollection3!.isNotEmpty) {
          var currentAddress =
              widget.arguments!.sharedbyme!.child!.userAddressCollection3![0];
          cntrlr_addr_one.text = currentAddress.addressLine1 ?? '';
          cntrlr_addr_two.text = currentAddress.addressLine2 ?? '';
          cntrlr_addr_city.text = currentAddress.city!.name ?? '';
          cntrlr_addr_state.text = currentAddress.state!.name ?? '';
          cntrlr_addr_zip.text = currentAddress.pincode ?? '';
          setState(() {
            _addressResult = AddressResult(
                id: currentAddress.addressType!.id ?? '',
                code: currentAddress.addressType!.code ?? '',
                name: currentAddress.addressType!.name ?? '');
          });

          cityVal = currentAddress.city;
          stateVal = currentAddress.state;
        } else {
          try {
            setState(() {
              _addressResult = _addressList[0];
            });
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
          }
        }

        if (widget.arguments!.sharedbyme!.child!.dateOfBirth != null) {
          dateofBirthStr = FHBUtils().getFormattedDateForUserBirth(
              widget.arguments!.sharedbyme!.child!.dateOfBirth ?? '');
          if (CommonUtil.isUSRegion()) {
            dateOfBirthController.text = FHBUtils().getFormattedDateOnly(
                    widget.arguments!.sharedbyme!.child!.dateOfBirth ?? "") ??
                '';
          } else {
            dateOfBirthController.text = FHBUtils().getFormattedDateOnlyNew(
                    widget.arguments!.sharedbyme!.child!.dateOfBirth) ??
                '';
          }
        }
      }
    } else {
      //* primary user adding section

      getDefaultHeightAndWeight();
      setHeightAndWeightUnit();
      addFamilyUserInfoBloc!.userId =
          widget.arguments!.addFamilyUserInfo?.childInfo?.id;
      await addFamilyUserInfoBloc!.getMyProfileInfo().then((value) {
        if (widget.arguments!.isPrimaryNoSelected!) {
          try {
            var myProf =
                PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
            mobileNoController.text =
                myProf!.result!.userContactCollection3![0]!.phoneNumber ?? '';
            emailController.text =
                myProf.result!.userContactCollection3![0]!.email ?? '';
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
            setMobileAndEmail();
          }
        } else {
          mobileNoController.text =
              value!.result!.userContactCollection3![0]!.phoneNumber ?? '';
          if (value.result?.userContactCollection3![0]!.email != null &&
              value.result?.userContactCollection3![0]!.email != '') {
            emailController.text =
                value.result!.userContactCollection3![0]!.email ?? '';
          }

          mContactInfo = value.result?.userContactCollection3![0];
        }
        //*user already user exist set the address data if available
        if (value!.result!.userAddressCollection3!.isNotEmpty) {
          UserAddressCollection3 currentAddress =
              value.result!.userAddressCollection3![0];
          cntrlr_addr_one.text = currentAddress.addressLine1 ?? '';
          cntrlr_addr_two.text = currentAddress.addressLine2 ?? '';
          cntrlr_addr_city.text = currentAddress.city!.name ?? '';
          cntrlr_addr_state.text = currentAddress.state!.name ?? '';
          cntrlr_addr_zip.text = currentAddress.pincode ?? '';
          setState(() {
            _addressResult = AddressResult(
                id: currentAddress.addressType!.id ?? '',
                code: currentAddress.addressType!.code ?? '',
                name: currentAddress.addressType!.name ?? '');
          });

          cityVal = currentAddress.city;
          stateVal = currentAddress.state;
          currentAddressID = currentAddress.id;
        }

        firstNameController.text =
            value.result!.firstName!.capitalizeFirstofEach ?? '';
        middleNameController.text =
            value.result!.middleName!.capitalizeFirstofEach ?? '';
        lastNameController.text =
            value.result!.lastName!.capitalizeFirstofEach ?? '';
        //? check relatioship id against logged in user
        if (value.result!.userRelationshipCollection!.isNotEmpty) {
          for (var cRelationship in value.result!.userRelationshipCollection!) {
            if (cRelationship.parent?.id ==
                PreferenceUtil.getStringValue(Constants.KEY_USERID)) {
              relationShipController.text =
                  cRelationship.relationship!.name ?? '';
            } else {
              relationShipController.text =
                  widget.arguments!.relationShip!.name ?? '';
            }
          }
        } else {
          relationShipController.text =
              widget.arguments!.relationShip!.name ?? '';
        }
        try {
          setState(() {
            _addressResult = _addressList[0];
          });
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        }
        if (commonUtil.checkIfStringisNull(value.result!.bloodGroup)) {
          currentselectedBloodGroup = value.result!.bloodGroup!.split(' ')[0];
          currentselectedBloodGroupRange =
              value.result!.bloodGroup!.split(' ')[1];
        } else {
          currentselectedBloodGroup = null;
          currentselectedBloodGroupRange = null;
        }
        selectedGender = value.result!.gender == null
            ? null
            : toBeginningOfSentenceCase(value.result!.gender!.toLowerCase());

        dateofBirthStr = value.result!.dateOfBirth != null
            ? FHBUtils()
                .getFormattedDateForUserBirth(value.result!.dateOfBirth ?? '')
            : '';
        dateOfBirthController.text = value.result!.dateOfBirth != null
            ? CommonUtil.isUSRegion()
                ? FHBUtils().getFormattedDateOnly(
                        value.result!.dateOfBirth ?? "") ??
                    ''
                : FHBUtils()
                        .getFormattedDateOnlyNew(value.result!.dateOfBirth) ??
                    ''
            : '';

        if (value.result?.additionalInfo != null) {
          heightController.text = value.result?.additionalInfo?.height ?? '';
          weightController.text = value.result?.additionalInfo?.weight ?? '';
        }

        if (value.result!.membershipOfferedBy != null &&
            value.result!.membershipOfferedBy != '') {
          cntrlr_corp_name.text = value.result!.membershipOfferedBy ?? '';
        }
      });
    }
  }

  void setValues() async {
    addFamilyUserInfoBloc!.phoneNo = mobileNoController.text;
    var myProf = MyProfileModel();

    var profileResult = MyProfileResult();
    profileResult.firstName = firstNameController.text.trim();
    profileResult.middleName = middleNameController.text.trim();
    profileResult.lastName = lastNameController.text.trim();
    profileResult.dateOfBirth = dateofBirthStr;
    profileResult.isIeUser =
        addFamilyUserInfoBloc?.myprofileObject?.result?.isIeUser ?? false;
    profileResult.isCpUser =
        addFamilyUserInfoBloc?.myprofileObject?.result?.isCpUser ?? false;
    profileResult.isSignedIn =
        addFamilyUserInfoBloc?.myprofileObject?.result?.isSignedIn ?? false;
    profileResult.isVirtualUser =
        addFamilyUserInfoBloc?.myprofileObject?.result?.isVirtualUser ?? false;
    profileResult.isActive =
        addFamilyUserInfoBloc?.myprofileObject?.result?.isActive ?? true;
    profileResult.gender = selectedGender;
    profileResult.lastModifiedBy =
        addFamilyUserInfoBloc?.myprofileObject?.result?.lastModifiedBy ?? null;
    profileResult.lastModifiedOn =
        addFamilyUserInfoBloc?.myprofileObject?.result?.lastModifiedOn ?? null;
    profileResult.profilePicThumbnailUrl = addFamilyUserInfoBloc
            ?.myprofileObject?.result?.profilePicThumbnailUrl ??
        '';

    AdditionalInfo? additionalInfo = AdditionalInfo();
    if (widget.arguments!.myProfileResult?.additionalInfo != null) {
      additionalInfo = widget.arguments!.myProfileResult!.additionalInfo;
      var heightObj = HeightObj();
      if (isFeetOrInches) {
        heightObj.valueFeet = heightController.text;
        heightObj.valueInches = heightInchController.text;
        additionalInfo!.heightObj = heightObj;
      } else {
        additionalInfo!.height = heightController.text;
      }

      additionalInfo.weight = weightController.text;
    } else {
      var heightObj = HeightObj();
      if (isFeetOrInches) {
        heightObj.valueFeet = heightController.text;
        heightObj.valueInches = heightInchController.text;
        additionalInfo.heightObj = heightObj;
      } else {
        additionalInfo.height = heightController.text;
      }
      additionalInfo.weight = weightController.text;
      additionalInfo.age = 0;
      additionalInfo.mrdNumber = '';
      additionalInfo.patientHistory = '';
      additionalInfo.visitReason = '';
      additionalInfo.uhidNumber = '';
      additionalInfo.language = [];
    }

    profileResult.additionalInfo = additionalInfo;

    /*if (widget.arguments.fromClass == CommonConstants.user_update ||
        widget.arguments.fromClass == CommonConstants.my_family) {*/
    try {
      List<UserProfileSettingCollection3>? userProfileSettingCollection = [];
      List<UserProfileSettingCollection3> userProfileSettingCollectionClone =
          [];

      var userProfileSettingCollection3Obj = UserProfileSettingCollection3();
      var profileSetting = ProfileSetting();
      userProfileSettingCollection = addFamilyUserInfoBloc!
          .myprofileObject!.result!.userProfileSettingCollection3;
      if (userProfileSettingCollection!.isNotEmpty) {
        userProfileSettingCollection3Obj = addFamilyUserInfoBloc!
            .myprofileObject!.result!.userProfileSettingCollection3![0];
        if (userProfileSettingCollection3Obj.profileSetting != null) {
          var profileSettingClone =
              userProfileSettingCollection3Obj.profileSetting!;
          var preferredMeasuremntClone =
              profileSettingClone.preferredMeasurement;

          if (preferredMeasuremntClone != null) {
            var heightObj = Height(
                unitCode: preferredMeasuremntClone.height?.unitCode,
                unitName: preferredMeasuremntClone.height?.unitName);
            var weightObj = Height(
                unitCode: preferredMeasuremntClone.weight?.unitCode,
                unitName: preferredMeasuremntClone.weight?.unitName);
            var tempObj = Height(
                unitCode: preferredMeasuremntClone.temperature?.unitCode,
                unitName: preferredMeasuremntClone.temperature?.unitName);

            var preferredMeasurementNew = PreferredMeasurement(
                height: heightObj, weight: weightObj, temperature: tempObj);

            profileSetting.preferredMeasurement = preferredMeasurementNew;
            profileSetting.allowDevice = profileSettingClone.allowDevice;
            profileSetting.allowDigit = profileSettingClone.allowDigit;
            profileSetting.bpMonitor = profileSettingClone.bpMonitor;
            profileSetting.glucoMeter = profileSettingClone.glucoMeter;
            profileSetting.googleFit = profileSettingClone.googleFit;
            profileSetting.greColor = profileSettingClone.greColor;
            profileSetting.healthFit = profileSettingClone.healthFit;
            profileSetting.preColor = profileSettingClone.preColor;

            profileSetting.qa_subscription =
                profileSettingClone.qa_subscription;
            profileSetting.qurhomeDefaultUI =
                profileSettingClone.qurhomeDefaultUI;
          } else {
            if (CommonUtil.REGION_CODE == 'IN') {
              var heightObj = Height(
                  unitCode: Constants.STR_VAL_HEIGHT_IND,
                  unitName: 'feet/Inches');
              var weightObj = Height(
                  unitCode: Constants.STR_VAL_WEIGHT_IND,
                  unitName: 'kilograms');
              var tempObj = Height(
                  unitCode: Constants.STR_VAL_TEMP_IND,
                  unitName: variable.str_far.toLowerCase());

              var preferredMeasurementNew = PreferredMeasurement(
                  height: heightObj, weight: weightObj, temperature: tempObj);
              profileSetting.preferredMeasurement = preferredMeasurementNew;
            } else {
              var heightObj = Height(
                  unitCode: Constants.STR_VAL_HEIGHT_US,
                  unitName: 'centimeters');
              var weightObj = Height(
                  unitCode: Constants.STR_VAL_WEIGHT_US, unitName: 'pounds');
              var tempObj = Height(
                  unitCode: Constants.STR_VAL_TEMP_US, unitName: 'celsius');

              var preferredMeasurementNew = PreferredMeasurement(
                  height: heightObj, weight: weightObj, temperature: tempObj);
              profileSetting.preferredMeasurement = preferredMeasurementNew;
            }
          }

          profileSetting.preferred_language = selectedLanguage;

          userProfileSettingCollection3Obj.profileSetting = profileSetting;
          /*if (widget.arguments!.fromClass == CommonConstants.my_family &&
              (addFamilyUserInfoBloc!.myprofileObject!.result!
                  .userProfileSettingCollection3?.length ??
                  0) >
                  0) {
            userProfileSettingCollectionClone.insert(
                0, userProfileSettingCollection3Obj);
          } else if(widget.arguments!.fromClass == CommonConstants.user_update){
            userProfileSettingCollectionClone.insert(
                0, userProfileSettingCollection3Obj);
          }else {
            userProfileSettingCollectionClone = [];
          }*/
        } else {
          if (CommonUtil.REGION_CODE == 'IN') {
            var heightObj = Height(
                unitCode: Constants.STR_VAL_HEIGHT_IND,
                unitName: 'feet/Inches');
            var weightObj = Height(
                unitCode: Constants.STR_VAL_WEIGHT_IND,
                unitName: variable.str_Kilogram.toLowerCase());
            var tempObj = Height(
                unitCode: Constants.STR_VAL_TEMP_IND,
                unitName: variable.str_far.toLowerCase());

            var preferredMeasurementNew = PreferredMeasurement(
                height: heightObj, weight: weightObj, temperature: tempObj);
            profileSetting.preferredMeasurement = preferredMeasurementNew;
          } else {
            var heightObj = Height(
                unitCode: Constants.STR_VAL_HEIGHT_US,
                unitName: variable.str_centi.toLowerCase());
            var weightObj = Height(
                unitCode: Constants.STR_VAL_WEIGHT_US,
                unitName: variable.str_Pounds.toLowerCase());
            var tempObj = Height(
                unitCode: Constants.STR_VAL_TEMP_US,
                unitName: variable.str_celesius.toLowerCase());

            var preferredMeasurementNew = PreferredMeasurement(
                height: heightObj, weight: weightObj, temperature: tempObj);
            profileSetting.preferredMeasurement = preferredMeasurementNew;
          }
          profileSetting.preferred_language = selectedLanguage;
          userProfileSettingCollection3Obj.profileSetting = profileSetting;
          userProfileSettingCollectionClone.insert(
              0, userProfileSettingCollection3Obj);
        }
      } else {
        if (widget.arguments!.fromClass == CommonConstants.user_update ||
            widget.arguments!.fromClass == CommonConstants.my_family) {
          if (CommonUtil.REGION_CODE == 'IN') {
            var heightObj = Height(
                unitCode: Constants.STR_VAL_HEIGHT_IND,
                unitName: 'feet/Inches');
            var weightObj = Height(
                unitCode: Constants.STR_VAL_WEIGHT_IND,
                unitName: variable.str_Kilogram.toLowerCase());
            var tempObj = Height(
                unitCode: Constants.STR_VAL_TEMP_IND,
                unitName: variable.str_far.toLowerCase());

            var preferredMeasurementNew = PreferredMeasurement(
                height: heightObj, weight: weightObj, temperature: tempObj);
            profileSetting.preferredMeasurement = preferredMeasurementNew;
          } else {
            var heightObj = Height(
                unitCode: Constants.STR_VAL_HEIGHT_US,
                unitName: variable.str_centi.toLowerCase());
            var weightObj = Height(
                unitCode: Constants.STR_VAL_WEIGHT_US,
                unitName: variable.str_Pounds.toLowerCase());
            var tempObj = Height(
                unitCode: Constants.STR_VAL_TEMP_US,
                unitName: variable.str_celesius.toLowerCase());

            var preferredMeasurementNew = PreferredMeasurement(
                height: heightObj, weight: weightObj, temperature: tempObj);
            profileSetting.preferredMeasurement = preferredMeasurementNew;
          }
          profileSetting.preferred_language = selectedLanguage;
          userProfileSettingCollection3Obj.profileSetting = profileSetting;
          /*if(widget.arguments!.fromClass == CommonConstants.my_family&&(addFamilyUserInfoBloc!
              .myprofileObject!.result!.userProfileSettingCollection3?.length??0)>0){

            userProfileSettingCollectionClone
                .add(userProfileSettingCollection3Obj);
          }else {
            userProfileSettingCollectionClone = [];
          }*/
        } else {
          userProfileSettingCollectionClone = [];
        }
      }

      /*profileResult.userProfileSettingCollection3 =
          userProfileSettingCollectionClone;*/
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    /*  }*/

    addFamilyUserInfoBloc!.tagsList = selectedTags;

    if (currentselectedBloodGroup != null &&
        currentselectedBloodGroupRange != null) {
      profileResult.bloodGroup =
          currentselectedBloodGroup! + ' ' + currentselectedBloodGroupRange!;
    }
    var userAddressCollection3 = UserAddressCollection3();
    if (widget.arguments!.fromClass == CommonConstants.my_family) {
      addFamilyUserInfoBloc!.isUpdate = true;
      profileResult.id = widget.arguments!.sharedbyme!.id;

      if (widget
          .arguments!.sharedbyme!.child!.userAddressCollection3!.isNotEmpty) {
        userAddressCollection3.id =
            widget.arguments?.sharedbyme?.child?.userAddressCollection3![0].id;
      }
    } else if (widget.arguments!.fromClass == CommonConstants.user_update) {
      addFamilyUserInfoBloc!.isUpdate = false;
      profileResult.id = widget.arguments!.myProfileResult!.id;
      if (widget
          .arguments!.myProfileResult!.userAddressCollection3!.isNotEmpty) {
        userAddressCollection3.id =
            widget.arguments?.myProfileResult?.userAddressCollection3![0].id;
      }

      //allow only user who logged in to update their email address
      if (widget
          .arguments!.myProfileResult!.userContactCollection3!.isNotEmpty) {
        UserContactCollection3 userContact =
            widget.arguments!.myProfileResult!.userContactCollection3![0]!;
        userContact.email = emailController.text;
        final List<UserContactCollection3> userContactCollection3List = [];
        userContactCollection3List.add(userContact);
        profileResult.userContactCollection3 = userContactCollection3List;
      }
    } else {
      profileResult.id = widget.arguments!.addFamilyUserInfo!.childInfo!.id;
      addFamilyUserInfoBloc!.isUpdate = false;
      if (widget
          .arguments!.addFamilyUserInfo!.childInfo!.contactInfo!.isNotEmpty) {
        var userContact = mContactInfo;
        userContact?.email = emailController.text;
        var userContactCollection3List = <UserContactCollection3?>[];
        userContactCollection3List.add(userContact);
        profileResult.userContactCollection3 = userContactCollection3List;
      }
    }
    userAddressCollection3.addressLine1 = cntrlr_addr_one.text.trim();
    userAddressCollection3.addressLine2 = cntrlr_addr_two.text.trim();
    userAddressCollection3.pincode = cntrlr_addr_zip.text.trim();
    userAddressCollection3.city = cityVal;
    userAddressCollection3.state = stateVal;

    userAddressCollection3.isPrimary = true;
    userAddressCollection3.isActive = true;
    userAddressCollection3.createdOn =
        CommonUtil.dateFormatterWithdatetimeseconds(DateTime.now(),
            isIndianTime: true);
    userAddressCollection3.lastModifiedOn = null;
    if (widget.arguments!.fromClass == CommonConstants.my_family) {
      userAddressCollection3.createdBy = widget.arguments!.id;
    } else if (widget.arguments!.fromClass == CommonConstants.user_update) {
      userAddressCollection3.createdBy = widget.arguments!.myProfileResult!.id;
    } else {
      userAddressCollection3.createdBy =
          PreferenceUtil.getStringValue(Constants.KEY_USERID);

      if (currentAddressID != null) {
        //? adding address id if exists
        userAddressCollection3.id = currentAddressID;
      }
    }

    userAddressCollection3.addressType = AddressType(
      id: _addressResult.id,
      code: _addressResult.code,
      name: _addressResult.name,
      description: _addressResult.name,
      isActive: true,
      createdBy: widget.arguments!.fromClass == CommonConstants.user_update
          ? PreferenceUtil.getStringValue(Constants.KEY_USERID)
          : widget.arguments!.id,
      createdOn: CommonUtil.dateFormatterWithdatetimeseconds(DateTime.now(),
          isIndianTime: true),
    );

    var userAddressCollection3List = <UserAddressCollection3>[];
    userAddressCollection3List.add(userAddressCollection3);
    profileResult.userAddressCollection3 = userAddressCollection3List;

    myProf.result = profileResult;
    addFamilyUserInfoBloc!.myProfileModel = myProf;
    var _familyListBloc = FamilyListBloc();
    if (widget.arguments!.fromClass == CommonConstants.my_family) {
      //*update the myfamily member details
      if (doValidation()) {
        if (addFamilyUserInfoBloc!.profileBanner != null) {
          await PreferenceUtil.saveString(Constants.KEY_PROFILE_BANNER,
              addFamilyUserInfoBloc!.profileBanner!.path);
        }
        CommonUtil.showLoadingDialog(
            dialogContext, _keyLoader, variable.Please_Wait); //

        await addFamilyUserInfoBloc!.updateSelfProfile(false).then((value) {
          if (value != null && value.isSuccess!) {
            chatViewModel.upateUserNickname(myProf.result!.id,
                firstNameController.text + ' ' + lastNameController.text);
            _familyListBloc.getFamilyMembersListNew().then((value) {
              PreferenceUtil.saveFamilyData(
                      Constants.KEY_FAMILYMEMBER, value.result)
                  .then((value) {
                //saveProfileImage();
                /* MySliverAppBar.imageURI = null;
                      fetchedProfileData = null;*/
                imageURI = null;
                Navigator.pop(dialogContext);
                Navigator.pop(dialogContext);
                Navigator.pop(dialogContext, true);
              });
            });
          } else {
            Navigator.pop(dialogContext);
            Alert.displayAlertPlain(context,
                title: variable.Error,
                content: value?.message ?? 'Error while updating');
          }
        });
      } else {
        // Navigator.pop(dialogContext);
        await Alert.displayAlertPlain(context,
            title: variable.Error, content: strErrorMsg);
      }
    } else if (widget.arguments!.fromClass == CommonConstants.user_update) {
      //*update the user details

      if (doValidation()) {
        if (addFamilyUserInfoBloc!.profileBanner != null) {
          await PreferenceUtil.saveString(Constants.KEY_PROFILE_BANNER,
              addFamilyUserInfoBloc!.profileBanner!.path);
        }
        CommonUtil.showLoadingDialog(
            dialogContext, _keyLoader, variable.Please_Wait); //

        await addFamilyUserInfoBloc!.updateSelfProfile(false).then((value) {
          if (value != null && value.isSuccess!) {
            if (widget.arguments!.isForFamily != null &&
                widget.arguments!.isForFamily == false) {
              if (widget.arguments!.isFromAppointmentOrSlotPage != true) {
                chatViewModel.upateUserNickname(myProf.result!.id,
                    firstNameController.text + ' ' + lastNameController.text);
                addFamilyUserInfoBloc!.getMyProfileInfo().then((profileValue) {
                  if (profileValue!.result!.firstName != null) {
                    var firstName = profileValue.result!.firstName != null
                        ? profileValue.result!.firstName!.capitalizeFirstofEach
                        : '';
                    var lastName = profileValue.result!.lastName != null
                        ? profileValue.result!.lastName!.capitalizeFirstofEach
                        : '';

                    PreferenceUtil.saveString(Constants.FIRST_NAME, firstName);
                    PreferenceUtil.saveString(Constants.LAST_NAME, lastName);
                    PreferenceUtil.saveProfileData(
                        Constants.KEY_PROFILE_MAIN, profileValue);
                  }

                  var useridMain = (PreferenceUtil.getStringValue(
                          Constants.KEY_USERID_MAIN)) ??
                      '';
                  var userid =
                      (PreferenceUtil.getStringValue(Constants.KEY_USERID)) ??
                          '';

                  if (useridMain == userid) {
                    PreferenceUtil.saveProfileData(
                        Constants.KEY_PROFILE, profileValue);
                  }

                  imageURI = null;
                  Navigator.pop(dialogContext);
                  Navigator.pop(dialogContext, true);
                });
              } else {
                Navigator.pop(dialogContext);
                Navigator.pop(dialogContext, true);
              }
            }
          } else {
            Navigator.pop(dialogContext);
            Alert.displayAlertPlain(context,
                title: variable.Error,
                content: value?.message ?? 'Error while updating');
          }
        });
      } else {
        //Navigator.pop(dialogContext);
        await Alert.displayAlertPlain(context,
            title: variable.Error, content: strErrorMsg);
      }
    } else {
      //*other update
      if (doValidation()) {
        if (addFamilyUserInfoBloc!.profileBanner != null) {
          await PreferenceUtil.saveString(Constants.KEY_PROFILE_BANNER,
              addFamilyUserInfoBloc!.profileBanner!.path);
        }
        CommonUtil.showLoadingDialog(
            dialogContext, _keyLoader, variable.Please_Wait); //

        await addFamilyUserInfoBloc!.updateSelfProfile(false).then((value) {
          if (value != null && value.isSuccess!) {
            chatViewModel.upateUserNickname(myProf.result!.id,
                firstNameController.text + ' ' + lastNameController.text);
            _familyListBloc.getFamilyMembersListNew().then((value) {
              PreferenceUtil.saveFamilyData(
                      Constants.KEY_FAMILYMEMBER, value?.result)
                  .then((value) {
                //saveProfileImage();
                /*  MySliverAppBar.imageURI = null;
                      fetchedProfileData = null;*/
                imageURI = null;
                if (widget.arguments!.isForFamily!) {
                  Navigator.pop(dialogContext);
                  Navigator.pop(dialogContext);
                  Navigator.pop(dialogContext);

                  Navigator.pushNamed(
                    Get.context!,
                    rt_UserAccounts,
                    arguments: UserAccountsArguments(
                      selectedIndex: 1,
                    ),
                  );
                } else {
                  Navigator.pop(dialogContext);
                  Navigator.pop(dialogContext);
                }
              });
            });
          } else {
            Navigator.pop(dialogContext);
            Alert.displayAlertPlain(context,
                title: variable.Error,
                content: value?.message ?? 'Error while updating');
          }
        });
      } else {
        //Navigator.pop(dialogContext);
        await Alert.displayAlertPlain(context,
            title: variable.Error, content: strErrorMsg);
      }
    }
  }

  Future<void> setMyProfilePic(String userId, File image) async {
    var response =
        await _addFamilyUserInfoRepository.updateUserProfilePic(userId, image);
    if (response.isSuccess!) {
      if (!Platform.isIOS) {
        imageCache!.clear();
        imageCache!.clearLiveImages();
      }
      FlutterToast().getToast(response.message!, Colors.green);
    } else {
      FlutterToast().getToast(response.message!, Colors.red);
    }
  }

  Widget showProfileImageNew() {
    if (widget.arguments!.fromClass == CommonConstants.my_family) {
      currentUserID = widget.arguments!.sharedbyme!.child!.id;
      return FutureBuilder<CommonResponse>(
        future: _addFamilyUserInfoRepository
            .getUserProfilePic(widget.arguments!.sharedbyme!.child!.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data?.isSuccess != null &&
                snapshot.data?.result != null) {
              if (snapshot.data!.isSuccess!) {
                return Image(
                  image: NetworkImage(
                    snapshot.data!.result!,
                    headers: {
                      HttpHeaders.authorizationHeader:
                          PreferenceUtil.getStringValue(
                              Constants.KEY_AUTHTOKEN)!,
                      Constants.KEY_OffSet: CommonUtil().setTimeZone()
                    },
                  ),
                  // ignore: always_specify_types
                  key: ValueKey(Random().nextInt(100)),
                  fit: BoxFit.cover,
                  width: 60.0.h,
                  height: 60.0.h,
                );
              } else {
                return Center(
                  child: Text(
                    widget.arguments!.sharedbyme!.child!.firstName != null &&
                            widget.arguments!.sharedbyme!.child!.lastName !=
                                null
                        ? widget.arguments!.sharedbyme!.child!.firstName![0]
                                .toUpperCase() +
                            (widget.arguments!.sharedbyme!.child!.lastName!
                                        .length >
                                    0
                                ? widget
                                    .arguments!.sharedbyme!.child!.lastName![0]
                                    .toUpperCase()
                                : '')
                        : widget.arguments!.sharedbyme!.child!.firstName != null
                            ? widget.arguments!.sharedbyme!.child!.firstName![0]
                                .toUpperCase()
                            : '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50.0.sp,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: Text(
                  widget.arguments!.sharedbyme!.child!.firstName != null &&
                          widget.arguments!.sharedbyme!.child!.lastName != null
                      ? widget.arguments!.sharedbyme!.child!.firstName![0]
                              .toUpperCase() +
                          (widget.arguments!.sharedbyme!.child!.lastName!
                                      .length >
                                  0
                              ? widget
                                  .arguments!.sharedbyme!.child!.lastName![0]
                                  .toUpperCase()
                              : '')
                      : widget.arguments!.sharedbyme!.child!.firstName != null
                          ? widget.arguments!.sharedbyme!.child!.firstName![0]
                              .toUpperCase()
                          : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0.sp,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CommonCircularIndicator();
          } else {
            return Center(
              child: Text(
                widget.arguments!.sharedbyme!.child!.firstName != null &&
                        widget.arguments!.sharedbyme!.child!.lastName != null
                    ? widget.arguments!.sharedbyme!.child!.firstName![0]
                            .toUpperCase() +
                        (widget.arguments!.sharedbyme!.child!.lastName!.length >
                                0
                            ? widget.arguments!.sharedbyme!.child!.lastName![0]
                                .toUpperCase()
                            : '')
                    : widget.arguments!.sharedbyme!.child!.firstName != null
                        ? widget.arguments!.sharedbyme!.child!.firstName![0]
                            .toUpperCase()
                        : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50.0.sp,
                  fontWeight: FontWeight.w200,
                ),
              ),
            );
          }
        },
      );
    } else if (widget.arguments!.fromClass == CommonConstants.user_update) {
      currentUserID = widget.arguments!.myProfileResult!.id;
      return FutureBuilder<CommonResponse>(
        future: _addFamilyUserInfoRepository
            .getUserProfilePic(widget.arguments!.myProfileResult!.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.isSuccess != null &&
                snapshot.data?.result != null) {
              if (snapshot.data!.isSuccess!) {
                return Image.network(
                  snapshot.data!.result!,
                  fit: BoxFit.cover,
                  width: 60.0.h,
                  height: 60.0.h,
                  headers: {
                    HttpHeaders.authorizationHeader:
                        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)!,
                    Constants.KEY_OffSet: CommonUtil().setTimeZone()
                  },
                );
              } else {
                return Center(
                  child: Text(
                    widget.arguments!.myProfileResult!.firstName != null &&
                            widget.arguments!.myProfileResult!.lastName != null
                        ? widget.arguments!.myProfileResult!.firstName![0]
                                .toUpperCase() +
                            (widget.arguments!.myProfileResult!.lastName!
                                        .length >
                                    0
                                ? widget
                                    .arguments!.myProfileResult!.lastName![0]
                                    .toUpperCase()
                                : '')
                        : widget.arguments!.myProfileResult!.firstName != null
                            ? widget.arguments!.myProfileResult!.firstName![0]
                                .toUpperCase()
                            : '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50.0.sp,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: Text(
                  widget.arguments!.myProfileResult!.firstName != null &&
                          widget.arguments!.myProfileResult!.lastName != null
                      ? widget.arguments!.myProfileResult!.firstName![0]
                              .toUpperCase() +
                          (widget.arguments!.myProfileResult!.lastName!.length >
                                  0
                              ? widget.arguments!.myProfileResult!.lastName![0]
                                  .toUpperCase()
                              : '')
                      : widget.arguments!.myProfileResult!.firstName != null
                          ? widget.arguments!.myProfileResult!.firstName![0]
                              .toUpperCase()
                          : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0.sp,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CommonCircularIndicator();
          } else {
            return Center(
              child: Text(
                widget.arguments!.myProfileResult!.firstName != null &&
                        widget.arguments!.myProfileResult!.lastName != null
                    ? widget.arguments!.myProfileResult!.firstName![0]
                            .toUpperCase() +
                        (widget.arguments!.myProfileResult!.lastName!.length > 0
                            ? widget.arguments!.myProfileResult!.lastName![0]
                                .toUpperCase()
                            : '')
                    : widget.arguments!.myProfileResult!.firstName != null
                        ? widget.arguments!.myProfileResult!.firstName![0]
                            .toUpperCase()
                        : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50.0.sp,
                  fontWeight: FontWeight.w200,
                ),
              ),
            );
          }
        },
      );
    } else {
      currentUserID = widget.arguments?.addFamilyUserInfo?.childInfo?.id;
      return FutureBuilder<CommonResponse>(
        future: _addFamilyUserInfoRepository.getUserProfilePic(
            widget.arguments!.addFamilyUserInfo!.childInfo!.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data?.isSuccess != null &&
                snapshot.data?.result != null) {
              if (snapshot.data!.isSuccess!) {
                return Image.network(
                  snapshot.data!.result!,
                  fit: BoxFit.cover,
                  width: 60.0.h,
                  height: 60.0.h,
                  headers: {
                    HttpHeaders.authorizationHeader:
                        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)!,
                    Constants.KEY_OffSet: CommonUtil().setTimeZone()
                  },
                );
              } else {
                return Center(
                  child: Text(
                    widget.arguments!.enteredFirstName != null &&
                            widget.arguments!.enteredLastName != null
                        ? widget.arguments!.enteredFirstName![0].toUpperCase() +
                            widget.arguments!.enteredLastName![0].toUpperCase()
                        : widget.arguments!.enteredFirstName != null
                            ? widget.arguments!.enteredFirstName![0]
                                .toUpperCase()
                            : '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50.0.sp,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: Text(
                  widget.arguments!.enteredFirstName != null &&
                          widget.arguments!.enteredLastName != null
                      ? widget.arguments!.enteredFirstName![0].toUpperCase() +
                          widget.arguments!.enteredLastName![0].toUpperCase()
                      : widget.arguments!.enteredFirstName != null
                          ? widget.arguments!.enteredFirstName![0].toUpperCase()
                          : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0.sp,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CommonCircularIndicator();
          } else {
            return Center(
              child: Text(
                widget.arguments!.enteredFirstName != null &&
                        widget.arguments!.enteredLastName != null
                    ? widget.arguments!.enteredFirstName![0].toUpperCase() +
                        widget.arguments!.enteredLastName![0].toUpperCase()
                    : widget.arguments!.enteredFirstName != null
                        ? widget.arguments!.enteredFirstName![0].toUpperCase()
                        : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50.0.sp,
                  fontWeight: FontWeight.w200,
                ),
              ),
            );
          }
        },
      );
    }
  }

  saveMediaDialog(BuildContext cont) {
    var userId = currentUserID;
    return showDialog(
      context: cont,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              title: Text(
                variable.makeAChoice,
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        PickedFile? image = await ImagePicker.platform
                            .pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          if (Platform.isIOS) {
                            imageURI = File(image.path);
                          } else {
                            imageURI = File(image.path);
                          }

                          if (widget.arguments!.fromClass ==
                              CommonConstants.user_update) {
                            await PreferenceUtil.saveString(
                                Constants.KEY_PROFILE_IMAGE, imageURI!.path);
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        variable.Gallery,
                        style: TextStyle(
                          fontSize: 16.0.sp,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    GestureDetector(
                      onTap: () async {
                        PickedFile? image = await ImagePicker.platform
                            .pickImage(source: ImageSource.camera);
                        if (image != null) {
                          if (Platform.isIOS) {
                            imageURI = File(image.path);
                          } else {
                            imageURI = File(image.path);
                          }
                          Navigator.pop(context);
                          if (widget.arguments!.fromClass ==
                              CommonConstants.user_update) {
                            await PreferenceUtil.saveString(
                                Constants.KEY_PROFILE_IMAGE, imageURI!.path);
                          }
                        }
                      },
                      child: Text(
                        variable.Camera,
                        style: TextStyle(
                          fontSize: 16.0.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
      },
    ).then((value) {
      setState(() {});
      if (imageURI != null) {
        setMyProfilePic(userId!, imageURI!).then((value) async {
          await CommonUtil().getUserProfileData();
        });
      }
    });
  }

  Widget getAllCustomRoles() {
    late Widget familyWidget;

    return StreamBuilder<ApiResponse<RelationShipResponseList>>(
      stream: addFamilyUserInfoBloc!.relationShipStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              break;

            case Status.ERROR:
              familyWidget = Center(
                  child: Text(Constants.STR_ERROR_LOADING_DATA,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0.sp,
                      )));
              break;

            case Status.COMPLETED:
              isCalled = true;
              // relationShipResponseList =
              //     snapshot.data.data.result[0].referenceValueCollection;
              if (widget.arguments!.isForFamilyAddition != true) {
                setState(() {
                  relationShipResponseList =
                      snapshot.data!.data!.result![0].referenceValueCollection;
                });
              } else {
                relationShipResponseList =
                    snapshot.data!.data!.result![0].referenceValueCollection;
              }
              familyWidget = getRelationshipDetails(relationShipResponseList!);

              break;
          }
        } else {
          familyWidget = Container(
            width: 100.0.h,
            height: 100.0.h,
          );
        }

        return familyWidget;
      },
    );
  }

  List<String?> getLanguageList() {
    final List<String?> languageList = [];

    for (var languageResultObj in languageModelList.result!) {
      if (languageResultObj.referenceValueCollection!.isNotEmpty) {
        for (var referenceValueCollection
            in languageResultObj.referenceValueCollection!) {
          if (selectedLanguage == referenceValueCollection.code) {
            languageList.add(referenceValueCollection.id);
          }
        }
      }
    }

    return languageList;
  }

  void setMobileAndEmail() {
    mobileNoController.text =
        myProfile.result!.userContactCollection3![0]!.phoneNumber ?? '';
    emailController.text =
        myProfile.result!.userContactCollection3![0]!.email ?? '';
  }

  Future<String?> setValueLanguages() async {
    // Check if selectedLanguage is already set
    if (selectedLanguage != null && selectedLanguage != '') {
      // Do nothing, as the language is already set
    } else {
      // Retrieve user collection, providing an empty list as default
      final userCollection = addFamilyUserInfoBloc
              ?.myprofileObject?.result?.userProfileSettingCollection3 ??
          [];

      // Check if user collection is not empty
      if (userCollection.isNotEmpty) {
        // Retrieve the profile setting from the first user in the collection
        final profileSetting = userCollection[0].profileSetting;

        // Set selectedLanguage based on preferred_language from profileSetting,
        // using the CommonUtil.langaugeCodes map, or keep the current value
        selectedLanguage =
            CommonUtil.langaugeCodes[profileSetting?.preferred_language] ??
                selectedLanguage;
      }
    }

    // Return the selectedLanguage, which is now set or remains unchanged
    return selectedLanguage;
  }

  void setLanguageToField(String language, String languageCode) {
    var langCode = language.split('-').first;
    var currentLanguage = langCode;

    if (currentLanguage.isNotEmpty) {
      CommonUtil.supportedLanguages.forEach((language, languageCode) {
        if (currentLanguage == languageCode) {
          return;
        }
      });
    }

    PreferenceUtil.saveString(
        SHEELA_LANG, CommonUtil.langaugeCodes[languageCode] ?? strDefaultLanguage);
  }

  void setUserId() {
    if (widget.arguments!.fromClass == CommonConstants.my_family) {
      addFamilyUserInfoBloc!.userId = widget.arguments!.id;
    } else if (widget.arguments!.fromClass == CommonConstants.user_update) {
      addFamilyUserInfoBloc!.userId = widget.arguments!.myProfileResult!.id;
    } else {
      addFamilyUserInfoBloc!.userId =
          widget.arguments!.addFamilyUserInfo!.childInfo!.id;
    }
  }

  getLanguageWidget() {
    return FutureBuilder(
        future: setValueLanguages(),
        builder: (context, snapshot) {
          print('I m here');
          return Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: DropdownButton(
              isExpanded: true,
              hint: Text(
                CommonConstants.preferredLanguage,
                style: TextStyle(
                  fontSize: 15.0.sp,
                ),
              ),
              value: selectedLanguage,
              items: languagesList,
              onChanged: (dynamic newLanguage) {
                setState(() {
                  selectedLanguage = newLanguage;
                });
                addFamilyUserInfoBloc!.preferredLanguage = newLanguage;
              },
            ),
          );
        });
  }

  bool checkIfYearIsGreaterThanCurrentYear(int year) {
    bool condition;

    DateTime current = DateTime.now();
    int currentYear = current.year;

    if (year < 1800) {
      condition = true;
      strErrorMsg = "Year cannot be less than 1800";
    } else if (year > currentYear) {
      condition = true;
      strErrorMsg = "Year cannot be greater than current year";
    } else {
      condition = false;
    }

    return condition;
  }

  void setUnit() async {
    if (widget.arguments!.fromClass == CommonConstants.user_update) {
      var profileSetting;
      try {
        profileSetting = widget.arguments?.myProfileResult
            ?.userProfileSettingCollection3![0].profileSetting;
        if (profileSetting != null) {
          getUnitFromPreferredMeasurement(profileSetting);
        } else {
          var profileModel =
              await PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
          if (profileModel!.result!.userProfileSettingCollection3 != null &&
              profileModel.result!.userProfileSettingCollection3!.length > 0) {
            var profileSetting = profileModel
                .result!.userProfileSettingCollection3![0].profileSetting;
            getUnitFromPreferredMeasurement(profileSetting);
          }
        }
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        var profileModel =
            await PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
        if (profileModel!.result!.userProfileSettingCollection3 != null &&
            profileModel.result!.userProfileSettingCollection3!.length > 0) {
          var profileSetting = profileModel
              .result!.userProfileSettingCollection3![0].profileSetting;
          getUnitFromPreferredMeasurement(profileSetting);
        }
      }
    } else if (widget.arguments!.fromClass == CommonConstants.my_family) {
      if (widget.arguments!.sharedbyme!.child!.isVirtualUser!) {
        var preferredMeasurment = await PreferenceUtil.getPreferredMeasurement(
            Constants.KEY_PREFERREDMEASUREMENT);

        if (preferredMeasurment != null) {
          try {
            heightUnit = preferredMeasurment.height?.unitCode;
            weightUnit = preferredMeasurment.weight?.unitCode;
            setHeightAndWeightUnit();
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
            setUnitBasedOnRegion();
          }
        }
      }
    } else {
      isFeetOrInches = false;
      isKg = true;
    }
  }

  Widget getDropDownWithTagsdrop() {
    return FutureBuilder(
        future: _healthReportListForUserRepository.getTags(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CommonCircularIndicator();
          }
          final List<Tags> tagslist = snapshot.data
              as List<Tags>; // snapshot.data.result to snapshot.data

          mediaResultFiltered = removeUnwantedCategories(tagslist);

          setTheValuesForDropdown(mediaResultFiltered);
          return DropdownWithTags(
            isClickable: true,
            tags: mediaResultFiltered,
            onChecked: (result) {
              addSelectedcategoriesToList(result!);
            },
          );
        });
  }

  Widget getTagsWithButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Text(
            CommonConstants.tags,
            style: TextStyle(fontSize: 14.0.sp, color: Colors.grey),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 5),
            child: IconButton(
              icon: Icon(Icons.add),
              color: mAppThemeProvider.primaryColor,
              onPressed: () {
                showTagDialog(context);
              },
            ))
      ],
    );
  }

  List<Tags> removeUnwantedCategories(List<Tags> tagsList) {
    var tagsListDuplicate = <Tags>[];
    for (var i = 0; i < tagsList.length; i++) {
      if (!tagsListDuplicate.contains(tagsList[i].name)) {
        tagsListDuplicate.add(tagsList[i]);
      }
    }
    return tagsListDuplicate;
  }

  void setTheValuesForDropdown(List<Tags>? result) {
    if (addFamilyUserInfoBloc!.tagsList != null &&
        addFamilyUserInfoBloc!.tagsList!.length > 0 &&
        addFamilyUserInfoBloc!.tagsList!.isNotEmpty) {
      for (var mediaResultObj in mediaResultFiltered) {
        for (var tagsSelected in addFamilyUserInfoBloc!.tagsList!) {
          if (tagsSelected.name!.toUpperCase() ==
              mediaResultObj.name!.toUpperCase()) {
            mediaResultObj.isChecked = true;
          }
        }
      }
    }
  }

  void refreshDropDown(List<Tags> result) {
    if (selectedTags != null && selectedTags!.isNotEmpty) {
      for (var mediaResultObj in mediaResultFiltered) {
        for (var tagsSelected in selectedTags!) {
          if (tagsSelected.name!.toUpperCase() ==
              mediaResultObj.name!.toUpperCase()) {
            mediaResultObj.isChecked = true;
          }
        }
      }
    }
  }

  void addSelectedcategoriesToList(List<Tags> result) {
    selectedTags = [];
    for (final mediaResultObj in result) {
      if (!selectedTags!.contains(mediaResultObj.name) &&
          mediaResultObj.isChecked!) {
        selectedTags!.add(mediaResultObj);
      }
    }
  }

  showTagDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1)),
              content: Container(
                width: 1.sw,
                height: 1.sh / 1.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 24.0.sp,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            DropdownWithTags(
                              isClickable: true,
                              tags: mediaResultFiltered,
                              onChecked: (result) {
                                addSelectedcategoriesToList(result!);
                                refreshDropDown(result);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    _showOKButton()
                  ],
                ),
              ));
        });
      },
    );
  }

  void methodToAddFamilyFromNotification() async {
    FamilyListBloc _familyListBloc = FamilyListBloc();

    var mobileNo = '${mobileNoController.text}';
    var addFamilyMemberRequest = {};
    addFamilyMemberRequest['isVirtualUser'] = false;
    addFamilyMemberRequest['firstName'] = firstNameController.text;
    addFamilyMemberRequest['lastName'] = lastNameController.text;
    addFamilyMemberRequest['dateOfBirth'] = dateOfBirthController.text;
    addFamilyMemberRequest['relationship'] = selectedRelationShip!.id;
    addFamilyMemberRequest['phoneNumber'] =
        mobileNo; //TODO this has be dynamic country code.
    addFamilyMemberRequest['email'] = emailController.text;
    addFamilyMemberRequest['isPrimary'] = true;

    var jsonString = convert.jsonEncode(addFamilyMemberRequest);

    var userId = await PreferenceUtil.getStringValue(KEY_USERID_MAIN);

    _familyListBloc.postUserLinking(jsonString).then((userLinking) {
      if (userLinking!.success!) {
        Navigator.pop(_keyLoader.currentContext!);

        Navigator.push(
          dialogContext,
          MaterialPageRoute(
            builder: (context) => VerifyPatient(
              PhoneNumber: mobileNo,
              from: strFromVerifyFamilyMember,
              fName: firstNameController.text,
              mName: middleNameController.text,
              lName: lastNameController.text,
              relationship: selectedRelationShip,
              isPrimaryNoSelected: false,
              userConfirm: false,
              forFamilyMember: true,
            ),
          ),
        );
      } else {
        if (widget.arguments!.isForFamilyAddition == true) {
          Navigator.pop(_keyLoader.currentContext!);
          Navigator.pop(context);
          MyProfileModel myProfileModel =
              MyProfileModel(isSuccess: true, message: userLinking.message);
          Navigator.of(context)
              .pop({"myProfileData": convert.jsonEncode(myProfileModel)});
        }
      }
    });
  }

  void getDefaultHeightAndWeight() async {
    weightUnit = await PreferenceUtil.getStringValue(Constants.STR_KEY_WEIGHT);
    heightUnit = await PreferenceUtil.getStringValue(Constants.STR_KEY_HEIGHT);
  }

  void setUnitBasedOnRegion() async {
    if (CommonUtil.REGION_CODE == 'IN') {
      isFeetOrInches = true;
      isKg = true;
    } else {
      isFeetOrInches = false;
      isKg = false;
    }
  }

  void setHeightAndWeightUnit() async {
    if (heightUnit == Constants.STR_VAL_HEIGHT_IND ||
        heightUnit == Constants.STR_VAL_HEIGHT_IND_NEW) {
      isFeetOrInches = true;
    } else {
      isFeetOrInches = false;
    }

    if (weightUnit == Constants.STR_VAL_WEIGHT_IND) {
      isKg = true;
    } else {
      isKg = false;
    }
  }

  void getUnitFromPreferredMeasurement(ProfileSetting? profileSetting) async {
    if (profileSetting?.preferredMeasurement != null) {
      try {
        heightUnit =
            await profileSetting?.preferredMeasurement?.height?.unitCode ?? '';
        weightUnit =
            await profileSetting?.preferredMeasurement?.weight?.unitCode ?? '';
        setHeightAndWeightUnit();
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        setUnitBasedOnRegion();
      }
    } else {
      setUnitBasedOnRegion();
    }
  }
}

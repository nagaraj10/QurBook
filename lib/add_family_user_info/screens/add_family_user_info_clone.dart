import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_family_otp/models/add_family_otp_response.dart';
import 'package:myfhb/add_family_user_info/bloc/add_family_user_info_bloc.dart';
import 'package:myfhb/add_family_user_info/models/add_family_user_info_arguments.dart';
import 'package:myfhb/add_family_user_info/models/address_result.dart';
import 'package:myfhb/add_family_user_info/models/update_relatiosnship_model.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/add_family_user_info/viewmodel/doctor_personal_viewmodel.dart';
import 'package:myfhb/add_family_user_info/widget/address_type_widget.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/relationship_response_list.dart';
import 'package:myfhb/my_family/models/relationships.dart';
import 'package:myfhb/src/model/common_response.dart';
import 'package:myfhb/src/model/user/AddressTypeModel.dart';
import 'package:myfhb/src/model/user/City.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/MyProfileResult.dart';
import 'package:myfhb/src/model/user/UserAddressCollection.dart';
import 'package:myfhb/src/model/user/userrelationshipcollection.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/ui/authentication/OtpVerifyScreen.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/alert.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/model/user/State.dart' as stateObj;

class AddFamilyUserInfoScreen extends StatefulWidget {
  AddFamilyUserInfoArguments arguments;
  AddFamilyUserInfoScreen({this.arguments});
  @override
  AddFamilyUserInfoScreenState createState() => AddFamilyUserInfoScreenState();
}

class AddFamilyUserInfoScreenState extends State<AddFamilyUserInfoScreen> {
  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();
  final double circleRadius = 100.0;
  final double circleBorderWidth = 2.0;
  File imageURI;

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

  final weightController = TextEditingController(text: '');
  FocusNode weightFocus = FocusNode();
  AddFamilyUserInfoBloc addFamilyUserInfoBloc;
  AddFamilyUserInfoRepository _addFamilyUserInfoRepository;

  List<RelationsShipModel> relationShipResponseList;
  RelationsShipModel selectedRelationShip;
  bool isCalled = false;

  String selectedGender;

  String currentselectedBloodGroup;
  String currentselectedBloodGroupRange;
  var currentAddressID;

  DateTime dateTime = DateTime.now();
  String dateofBirthStr;

  var cntrlr_addr_one = TextEditingController(text: '');
  var cntrlr_addr_two = TextEditingController(text: '');
  var cntrlr_addr_city = TextEditingController(text: '');
  var cntrlr_addr_state = TextEditingController(text: '');
  var cntrlr_addr_zip = TextEditingController(text: '');
  final _formkey = GlobalKey<FormState>();

  City cityVal = new City();
  stateObj.State stateVal = new stateObj.State();

  AddressResult _addressResult = new AddressResult();
  List<AddressResult> _addressList = List();
  String addressTypeId;

  String city = '';
  String state = '';

  var dialogContext;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  String strErrorMsg = '';
  bool updateProfile = false;
  CommonUtil commonUtil = new CommonUtil();
  DoctorPersonalViewModel doctorPersonalViewModel =
      new DoctorPersonalViewModel();

  String currentUserID;

  @override
  void initState() {
    super.initState();
    addFamilyUserInfoBloc = new AddFamilyUserInfoBloc();
    _addFamilyUserInfoRepository = new AddFamilyUserInfoRepository();
    setValuesInEditText();
  }

  @override
  Widget build(BuildContext context) {
    dialogContext = context;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return Future.value(true);
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )),
          key: scaffold_state,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: circleRadius / 2.0),
                      child: Container(
                        color: Color(new CommonUtil().getMyPrimaryColor()),
                        height: 160.0,
                        child: Stack(
                            fit: StackFit.expand,
                            overflow: Overflow.visible,
                            children: [
                              Container(
                                color: Colors.black.withOpacity(0.2),
                              )
                            ]),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Container(
                          width: circleRadius,
                          height: circleRadius,
                          decoration: ShapeDecoration(
                              shape: CircleBorder(),
                              color:
                                  Color(new CommonUtil().getMyPrimaryColor())),
                          child: Padding(
                            padding: EdgeInsets.all(circleBorderWidth),
                            child: InkWell(
                              child: ClipOval(
                                  child: (imageURI != null && imageURI != '')
                                      ? Image.file(
                                          imageURI,
                                          fit: BoxFit.cover,
                                          width: 60,
                                          height: 60,
                                        )
                                      : showProfileImageNew()),
                              onTap: () {
                                saveMediaDialog(context);
                              },
                            ),
                          ),
                        )),
                  ],
                ),
                _showCommonEditText(
                    mobileNoController,
                    mobileNoFocus,
                    firstNameFocus,
                    CommonConstants.mobile_numberWithStar,
                    CommonConstants.mobile_number,
                    false,
                    isheightOrWeight: false),
                _showCommonEditText(
                    firstNameController,
                    firstNameFocus,
                    middleNameFocus,
                    CommonConstants.firstNameWithStar,
                    CommonConstants.firstName,
                    true,
                    isheightOrWeight: false),
                _showCommonEditText(
                    middleNameController,
                    middleNameFocus,
                    lastNameFocus,
                    CommonConstants.middleName,
                    CommonConstants.middleName,
                    true,
                    isheightOrWeight: false),
                _showCommonEditText(
                    lastNameController,
                    lastNameFocus,
                    relationShipFocus,
                    CommonConstants.lastNameWithStar,
                    CommonConstants.lastName,
                    true,
                    isheightOrWeight: false),
                widget.arguments.fromClass == CommonConstants.my_family
                    ? (relationShipResponseList != null &&
                            relationShipResponseList.length > 0)
                        ? Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Expanded(
                                child: getRelationshipDetails(
                                    relationShipResponseList),
                              )
                            ],
                          )
                        : _showRelationShipTextField()
                    : widget.arguments.fromClass == CommonConstants.user_update
                        ? new Container()
                        : _showRelationShipTextField(),
                _showCommonEditText(
                    emailController,
                    emailFocus,
                    genderFocus,
                    CommonConstants.email_address_optional,
                    CommonConstants.email_address_optional,
                    (widget.arguments.fromClass ==
                                CommonConstants.user_update ||
                            widget.arguments.fromClass ==
                                CommonConstants.add_family)
                        ? true
                        : false,
                    isheightOrWeight: false),
                Row(
                  children: <Widget>[Expanded(child: getGenderDetails())],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: getBloodGroupDetails()),
                    Expanded(child: getBloodRangeDetails())
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: _showCommonEditText(
                            heightController,
                            heightFocus,
                            middleNameFocus,
                            CommonConstants.heightName,
                            CommonConstants.heightName,
                            true,
                            isheightOrWeight: true)),
                    Expanded(
                        child: _showCommonEditText(
                            weightController,
                            weightFocus,
                            middleNameFocus,
                            CommonConstants.weightName,
                            CommonConstants.weightName,
                            true,
                            isheightOrWeight: true))
                  ],
                ),
                _showDateOfBirthTextField(),
                AddressTypeWidget(
                  addressResult: _addressResult,
                  addressList: _addressList,
                  onSelected: (addressResult, addressList) {
                    setState(() {
                      _addressResult = addressResult;
                      addressTypeId = addressResult.id;
                      _addressList = addressList;
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

  Widget getGenderDetails() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(CommonConstants.genderWithStar),
          value: selectedGender != null
              ? toBeginningOfSentenceCase(selectedGender.toLowerCase())
              : selectedGender,
          items: variable.genderArray.map((eachGender) {
            return DropdownMenuItem(
              child: new Text(eachGender,
                  style: new TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: ColorUtils.blackcolor)),
              value: eachGender,
            );
          }).toList(),
          onChanged: (String newSelectedValue) {
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
          padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
          child: TextField(
            cursorColor: Theme.of(context).primaryColor,
            controller: dateOfBirthController,
            maxLines: 1,
            autofocus: false,
            readOnly: true,
            keyboardType: TextInputType.text,
            //          focusNode: dateOfBirthFocus,
            textInputAction: TextInputAction.done,
            onSubmitted: (term) {
              dateOfBirthFocus.unfocus();
            },
            style: new TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: ColorUtils.blackcolor),
            decoration: InputDecoration(
              suffixIcon: new IconButton(
                icon: new Icon(Icons.calendar_today),
                onPressed: () {
                  _selectDate(context);
                },
              ),
              labelText: CommonConstants.date_of_birthWithStar,
              hintText: CommonConstants.date_of_birth,
              labelStyle: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.myFamilyGreyColor),
              hintStyle: TextStyle(
                fontSize: 14.0,
                color: ColorUtils.myFamilyGreyColor,
                fontWeight: FontWeight.w400,
              ),
              border: new UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
            ),
          )),
    );
  }

  void dateOfBirthTapped() {
    _selectDate(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1940, 01),
        lastDate: DateTime.now());

    if (picked != null) {
      setState(() {
        dateTime = picked ?? dateTime;

        dateofBirthStr =
            new FHBUtils().getFormattedDateForUserBirth(dateTime.toString());
        dateOfBirthController.text =
            new FHBUtils().getFormattedDateOnlyNew(dateTime.toString());
      });
    }
  }

  Widget _showCommonEditText(
      TextEditingController textEditingController,
      FocusNode focusNode,
      FocusNode nextFocusNode,
      String labelText,
      String hintText,
      bool isEnabled,
      {bool isheightOrWeight}) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
        child: TextField(
          enabled: isEnabled,
          cursorColor: Theme.of(context).primaryColor,
          controller: textEditingController,
          maxLines: 1,
          enableInteractiveSelection: false,
          keyboardType:
              isheightOrWeight ? TextInputType.number : TextInputType.text,
          focusNode: focusNode,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          },
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            labelStyle: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          ),
          inputFormatters: (textEditingController == firstNameController ||
                  textEditingController == lastNameController ||
                  textEditingController == middleNameController)
              ? [WhitelistingTextInputFormatter(RegExp("[a-zA-Z]"))]
              : [],
        ));
  }

  Widget _userAddressInfo() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              controller: cntrlr_addr_one,
              enabled: true,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 12),
                labelText: CommonConstants.addr_line_1,
              ),
              validator: (res) {
                return (res.isEmpty || res == null)
                    ? 'Address line1 can\'t be empty'
                    : null;
              },
            ),
            TextFormField(
              controller: cntrlr_addr_two,
              enabled: true,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 12),
                labelText: CommonConstants.addr_line_2,
              ),
            ),
            TypeAheadFormField<City>(
              textFieldConfiguration: TextFieldConfiguration(
                  controller: cntrlr_addr_city,
                  decoration: InputDecoration(
                    hintText: "City",
                    labelText: "City",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 14.0),
                  )),
              suggestionsCallback: (pattern) async {
                if (pattern.length >= 3) {
                  return await getCitybasedOnSearch(
                    pattern,
                    'city',
                  );
                }
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(
                    suggestion.name,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                cntrlr_addr_city.text = suggestion.name;
                cityVal = suggestion;
                //stateVal = suggestion.state;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please select a city';
                }
                return null;
              },
              onSaved: (value) => this.city = value,
            ),
            TypeAheadFormField<stateObj.State>(
              textFieldConfiguration: TextFieldConfiguration(
                  controller: cntrlr_addr_state,
                  decoration: InputDecoration(
                    hintText: "State",
                    labelText: 'State',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 14.0),
                  )),
              suggestionsCallback: (pattern) async {
                if (pattern.length >= 3) {
                  return await getStateBasedOnSearch(
                    pattern,
                    'state',
                  );
                }
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.name),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                cntrlr_addr_state.text = suggestion.name;
                stateVal = suggestion;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please select a State';
                }
                return null;
              },
              onSaved: (value) => this.state = value,
            ),
            TextFormField(
              controller: cntrlr_addr_zip,
              enabled: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 12),
                labelText: CommonConstants.addr_zip,
              ),
              validator: (res) {
                return (res.isEmpty || res == null)
                    ? 'Zip can\'t be empty'
                    : null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _showSaveButton() {
    final GestureDetector addButtonWithGesture = new GestureDetector(
      onTap: _saveBtnTappedClone,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            width: 150,
            height: 40.0,
            decoration: new BoxDecoration(
              color: Color(new CommonUtil().getMyPrimaryColor()),
              borderRadius: new BorderRadius.all(Radius.circular(10.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color.fromARGB(15, 0, 0, 0),
                  offset: Offset(0, 2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: new Center(
              child: new Text(
                (widget.arguments.fromClass == CommonConstants.my_family ||
                        widget.arguments.fromClass ==
                            CommonConstants.user_update)
                    ? CommonConstants.update
                    : CommonConstants.save,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: addButtonWithGesture);
  }

  void verifyEmail() {
    addFamilyUserInfoBloc.verifyEmail().then((value) {
      if (value.success &&
          value.message.contains(Constants.MSG_VERIFYEMAIL_VERIFIED)) {
        new FHBBasicWidget().showInSnackBar(value.message, scaffold_state);
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
          Navigator.popUntil(context, (Route<dynamic> route) {
            bool shouldPop = false;
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
    RelationsShipModel currentSelectedUserRole = data[0];
    for (RelationsShipModel model in data) {
      if (model.id == selectedRelationShip.id) {
        currentSelectedUserRole = model;
      }
    }
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
      child: DropdownButton<RelationsShipModel>(
        hint: Text(CommonConstants.relationship),
        isExpanded: true,
        value: currentSelectedUserRole,
        items: data.map((RelationsShipModel val) {
          return DropdownMenuItem<RelationsShipModel>(
            child: Text(val.name),
            value: val,
          );
        }).toList(),
        onChanged: (RelationsShipModel newSelectedValue) {
          setState(() {
            selectedRelationShip = newSelectedValue;
          });
        },
      ),
    );
  }

  Widget _showRelationShipTextField() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
        child: TextField(
          onTap: () {
            widget.arguments.fromClass == CommonConstants.my_family
                ? relationShipResponseList != null
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          getRelationshipDetails(relationShipResponseList)
                        ],
                      )
                    : getAllCustomRoles()
                : widget.arguments.fromClass == CommonConstants.user_update
                    ? new Container()
                    : _showRelationShipTextField();
          },
          cursorColor: Theme.of(context).primaryColor,
          controller: relationShipController,
          maxLines: 1,
          enabled: (widget.arguments.fromClass == CommonConstants.my_family ||
                  widget.arguments.fromClass == CommonConstants.add_family)
              ? true
              : false,
          keyboardType: TextInputType.text,
          //          focusNode: relationShipFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            FocusScope.of(context).requestFocus(emailFocus);
          },
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            labelText: CommonConstants.relationship,
            hintText: CommonConstants.relationship,
            labelStyle: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          ),
        ));
  }

  Widget getBloodGroupDetails() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 40,
        child: DropdownButton<String>(
          hint: Text(CommonConstants.blood_groupWithStar),
          value: currentselectedBloodGroup,
          items: variable.bloodGroupArray.map((eachBloodGroup) {
            return DropdownMenuItem<String>(
              child: new Text(eachBloodGroup,
                  style: new TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: ColorUtils.blackcolor)),
              value: eachBloodGroup,
            );
          }).toList(),
          onChanged: (String newSelectedValue) {
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
      padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 40,
        child: DropdownButton<String>(
          hint: Text(CommonConstants.blood_rangeWithStar),
          isExpanded: true,
          value: currentselectedBloodGroupRange,
          items: variable.bloodRangeArray.map((eachBloodGroup) {
            return DropdownMenuItem<String>(
              child: new Text(eachBloodGroup,
                  style: new TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: ColorUtils.blackcolor)),
              value: eachBloodGroup,
            );
          }).toList(),
          onChanged: (String newSelectedValue) {
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
              width: MediaQuery.of(context).size.width / 2 - 40,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(CommonConstants.blood_rangeWithStar),
                value: selectedBloodRange,
                items: variable.bloodRangeArray.map((eachBloodGroup) {
                  return DropdownMenuItem(
                    child: new Text(eachBloodGroup,
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
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
    new FHBUtils().check().then((intenet) {
      if (intenet != null && intenet) {
        //address fields validation
        if (_formkey.currentState.validate()) {
          FamilyListBloc _familyListBloc = new FamilyListBloc();
          //NOTE this would be called when family member profile update
          if (widget.arguments.fromClass == CommonConstants.my_family) {
            addFamilyUserInfoBloc.userId = widget.arguments.id;
            addFamilyUserInfoBloc.relationship = UpdateRelationshipModel(
                id: widget.arguments.sharedbyme.id,
                relationship: selectedRelationShip);

            setValues();
          } else if (widget.arguments.fromClass ==
              CommonConstants.user_update) {
            addFamilyUserInfoBloc.userId = widget.arguments.myProfileResult.id;

            setValues();
          } else {
            addFamilyUserInfoBloc.userId =
                widget.arguments.addFamilyUserInfo.childInfo.id;

            setValues();
          }
        } else {
          //address validation not valid.
          print('invalid user input');
        }
      } else {
        new FHBBasicWidget()
            .showInSnackBar(Constants.STR_NO_CONNECTIVITY, scaffold_state);
      }
    });
  }

  Future<List<City>> getCitybasedOnSearch(
    String cityname,
    String apibody,
  ) {
    Future<List<City>> citylist;
    citylist = addFamilyUserInfoBloc.getCityDataList(cityname, apibody);
    return citylist;
  }

  Future<List<stateObj.State>> getStateBasedOnSearch(
    String stateName,
    String apibody,
  ) {
    Future<List<stateObj.State>> stateList;
    stateList = addFamilyUserInfoBloc.geStateDataList(stateName, apibody);
    return stateList;
  }

  bool doValidation() {
    bool isValid = false;

    bool emailValid =
        RegExp(variable.EMAIL_REGEXP).hasMatch(emailController.text);

    if (firstNameController.text == '') {
      isValid = false;
      strErrorMsg = variable.enterFirstName;
    } else if (lastNameController.text == '') {
      isValid = false;
      strErrorMsg = variable.enterLastName;
    } else if (selectedGender == null) {
      isValid = false;
      strErrorMsg = variable.selectGender;
    } else if (dateOfBirthController.text.length == 0) {
      isValid = false;
      strErrorMsg = variable.selectDOB;
    } else if (_addressResult == null || _addressResult.id == null) {
      isValid = false;
      strErrorMsg = 'Select Address type';
    } else if (currentselectedBloodGroup == null) {
      if (currentselectedBloodGroupRange == null) {
        isValid = false;
        strErrorMsg = variable.selectRHType;
      } else {
        addFamilyUserInfoBloc.bloodGroup =
            currentselectedBloodGroup + '_' + currentselectedBloodGroupRange;
      }
      isValid = false;
      strErrorMsg = variable.selectBloodGroup;
    } else if (emailController.text == '' || !emailValid) {
      isValid = false;
      strErrorMsg = 'Invalid Email Address';
    } else {
      isValid = true;
    }

    return isValid;
  }

  void setValuesInEditText() async {
    //* set the user data from input
    _addressList = await doctorPersonalViewModel.getAddressTypeList();
    if (widget.arguments.fromClass == CommonConstants.user_update) {
      //* user profile update sections
      addFamilyUserInfoBloc.userId = widget.arguments.myProfileResult.id;
      if (widget.arguments.myProfileResult.userContactCollection3 != null) {
        if (widget.arguments.myProfileResult.userContactCollection3.length >
            0) {
          mobileNoController.text = widget
              .arguments.myProfileResult.userContactCollection3[0].phoneNumber;
          emailController.text =
              widget.arguments.myProfileResult.userContactCollection3[0].email;
        }
      }
      if (widget.arguments.myProfileResult.dateOfBirth != null) {
        dateofBirthStr = new FHBUtils().getFormattedDateForUserBirth(
            widget.arguments.myProfileResult.dateOfBirth);
        dateOfBirthController.text = new FHBUtils().getFormattedDateOnlyNew(
            widget.arguments.myProfileResult.dateOfBirth);
      }

      if (widget.arguments.myProfileResult.userAddressCollection3 != null &&
          widget.arguments.myProfileResult.userAddressCollection3.length > 0) {
        cntrlr_addr_one.text = widget
            .arguments.myProfileResult.userAddressCollection3[0].addressLine1;
        cntrlr_addr_two.text = widget
            .arguments.myProfileResult.userAddressCollection3[0].addressLine2;
        cntrlr_addr_city.text = widget
            .arguments.myProfileResult.userAddressCollection3[0].city?.name;
        cntrlr_addr_state.text = widget
            .arguments.myProfileResult.userAddressCollection3[0].state?.name;
        cntrlr_addr_zip.text =
            widget.arguments.myProfileResult.userAddressCollection3[0].pincode;

        cityVal =
            widget.arguments.myProfileResult.userAddressCollection3[0].city;
        stateVal =
            widget.arguments.myProfileResult.userAddressCollection3[0].state;
        setState(() {
          _addressResult = new AddressResult(
              id: widget.arguments.myProfileResult.userAddressCollection3[0]
                  .addressType.id,
              code: widget.arguments.myProfileResult.userAddressCollection3[0]
                  .addressType.code,
              name: widget.arguments.myProfileResult.userAddressCollection3[0]
                  .addressType.name);
        });
      } else {
        try {
          print('inside try');
          setState(() {
            _addressResult = _addressList[0];
          });
          print('after try');
        } catch (e) {}
      }

      if (widget.arguments.myProfileResult.firstName != null) {
        firstNameController.text =
            widget.arguments.myProfileResult.firstName != null
                ? widget.arguments.myProfileResult.firstName
                : '';
        middleNameController.text =
            widget.arguments.myProfileResult.middleName != null
                ? widget.arguments.myProfileResult.middleName
                : '';
        lastNameController.text =
            widget.arguments.myProfileResult.lastName != null
                ? widget.arguments.myProfileResult.lastName
                : '';
      }

      if (widget.arguments.myProfileResult.additionalInfo != null) {
        heightController.text =
            widget.arguments.myProfileResult.additionalInfo.height != null
                ? widget.arguments.myProfileResult.additionalInfo.height
                : '';
        weightController.text =
            widget.arguments.myProfileResult.additionalInfo.weight != null
                ? widget.arguments.myProfileResult.additionalInfo.weight
                : '';
      }
      if (commonUtil
          .checkIfStringisNull(widget.arguments.myProfileResult.bloodGroup)) {
        currentselectedBloodGroup =
            widget.arguments.myProfileResult.bloodGroup.split(' ')[0];
        currentselectedBloodGroupRange =
            widget.arguments.myProfileResult.bloodGroup.split(' ')[1];
      } else {
        currentselectedBloodGroup = null;
        currentselectedBloodGroupRange = null;
      }

      if (widget.arguments.myProfileResult.gender != null) {
        selectedGender = widget.arguments.myProfileResult.gender;
      }
    } else if (widget.arguments.fromClass == CommonConstants.my_family) {
      //* my-family member details update sections
      addFamilyUserInfoBloc.userId = widget
          .arguments.sharedbyme.id; //widget.arguments.addFamilyUserInfo.id;

      relationShipResponseList = widget.arguments?.defaultrelationShips;

      if (widget?.arguments?.sharedbyme?.relationship?.name != null) {
        selectedRelationShip = widget.arguments.sharedbyme.relationship;
      }

      if (widget.arguments.sharedbyme.child.isVirtualUser != null) {
        try {
          if (widget.arguments.sharedbyme.child.isVirtualUser) {
            MyProfileModel myProf =
                PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
            if (myProf.result.userContactCollection3 != null) {
              if (myProf.result.userContactCollection3.length > 0) {
                mobileNoController.text =
                    myProf.result.userContactCollection3[0].phoneNumber;
                emailController.text =
                    myProf.result.userContactCollection3[0].email;
              }
            }
          } else {
            //! this must be loook
            if (widget?.arguments?.sharedbyme?.child?.userContactCollection3
                    .length >
                0) {
              mobileNoController.text = widget.arguments.sharedbyme.child
                  .userContactCollection3[0].phoneNumber;
              emailController.text = widget
                  .arguments.sharedbyme.child.userContactCollection3[0].email;
            } else {
              mobileNoController.text = '';
              emailController.text = '';
            }
          }
        } catch (e) {
          mobileNoController.text = '';
          emailController.text = '';
        }
      } else {
        if (widget
            ?.arguments?.sharedbyme?.child?.userContactCollection3.isNotEmpty) {
          mobileNoController.text = widget?.arguments?.sharedbyme?.child
              ?.userContactCollection3[0].phoneNumber;
          emailController.text = widget
              ?.arguments?.sharedbyme?.child?.userContactCollection3[0].email;
        }
      }
      if (widget.arguments.sharedbyme != null) {
        if (widget.arguments.sharedbyme.child.firstName != null) {
          firstNameController.text =
              widget.arguments.sharedbyme.child.firstName != null
                  ? widget.arguments.sharedbyme.child.firstName
                  : '';
          middleNameController.text =
              widget.arguments.sharedbyme.child.middleName != null
                  ? widget.arguments.sharedbyme.child.middleName
                  : '';
          lastNameController.text =
              widget.arguments.sharedbyme.child.lastName != null
                  ? widget.arguments.sharedbyme.child.lastName
                  : '';
        } else {
          firstNameController.text = '';
        }

        if (widget.arguments.sharedbyme.child.additionalInfo != null) {
          heightController.text =
              widget.arguments.sharedbyme.child.additionalInfo.height != null
                  ? widget.arguments.sharedbyme.child.additionalInfo.height
                  : '';
          weightController.text =
              widget.arguments.sharedbyme.child.additionalInfo.weight != null
                  ? widget.arguments.sharedbyme.child.additionalInfo.weight
                  : '';
        }
        if (commonUtil.checkIfStringisNull(
            widget.arguments.sharedbyme.child.bloodGroup)) {
          currentselectedBloodGroup =
              widget.arguments.sharedbyme.child.bloodGroup.split(' ')[0];
          currentselectedBloodGroupRange =
              widget.arguments.sharedbyme.child.bloodGroup.split(' ')[1];
        } else {
          currentselectedBloodGroup = null;
          currentselectedBloodGroupRange = null;
        }

        if (widget.arguments.sharedbyme.child.gender != null) {
          selectedGender = widget.arguments.sharedbyme.child.gender;
        }

        if (widget
            ?.arguments?.sharedbyme?.child?.userAddressCollection3.isNotEmpty) {
          UserAddressCollection3 currentAddress =
              widget.arguments.sharedbyme.child.userAddressCollection3[0];
          cntrlr_addr_one.text = currentAddress.addressLine1;
          cntrlr_addr_two.text = currentAddress.addressLine2;
          cntrlr_addr_city.text = currentAddress.city?.name;
          cntrlr_addr_state.text = currentAddress.state?.name;
          cntrlr_addr_zip.text = currentAddress.pincode;
          setState(() {
            _addressResult = AddressResult(
                id: currentAddress.addressType.id,
                code: currentAddress.addressType.code,
                name: currentAddress.addressType.name);
          });

          cityVal = currentAddress.city;
          stateVal = currentAddress.state;
        } else {
          try {
            setState(() {
              _addressResult = _addressList[0];
            });
          } catch (e) {}
        }

        if (widget.arguments.sharedbyme.child.dateOfBirth != null) {
          dateofBirthStr = new FHBUtils().getFormattedDateForUserBirth(
              widget.arguments.sharedbyme.child.dateOfBirth);
          dateOfBirthController.text = new FHBUtils().getFormattedDateOnlyNew(
              widget.arguments.sharedbyme.child.dateOfBirth);
        }
      }
    } else {
      //* primary user adding section
      addFamilyUserInfoBloc.userId =
          widget.arguments.addFamilyUserInfo?.childInfo?.id;
      addFamilyUserInfoBloc.getMyProfileInfo().then((value) {
        if (widget.arguments.isPrimaryNoSelected) {
          MyProfileModel myProf =
              PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
          mobileNoController.text =
              myProf.result.userContactCollection3[0].phoneNumber;
          emailController.text = myProf.result.userContactCollection3[0].email;
        } else {
          mobileNoController.text =
              value.result.userContactCollection3[0].phoneNumber;
          if (value?.result?.userContactCollection3[0].email != null &&
              value?.result?.userContactCollection3[0].email != '') {
            emailController.text = value.result.userContactCollection3[0].email;
          }
        }
        //*user already user exist set the address data if available
        if (value?.result?.userAddressCollection3.length > 0) {
          UserAddressCollection3 currentAddress =
              value?.result?.userAddressCollection3[0];
          cntrlr_addr_one.text = currentAddress.addressLine1;
          cntrlr_addr_two.text = currentAddress.addressLine2;
          cntrlr_addr_city.text = currentAddress.city?.name;
          cntrlr_addr_state.text = currentAddress.state?.name;
          cntrlr_addr_zip.text = currentAddress.pincode;
          setState(() {
            _addressResult = AddressResult(
                id: currentAddress.addressType.id,
                code: currentAddress.addressType.code,
                name: currentAddress.addressType.name);
          });

          cityVal = currentAddress.city;
          stateVal = currentAddress.state;
          currentAddressID = currentAddress.id;
        }

        firstNameController.text = value?.result?.firstName;
        middleNameController.text = value?.result?.middleName;
        lastNameController.text = value?.result?.lastName;
        //? check relatioship id against logged in user
        if (value?.result?.userRelationshipCollection.length > 0) {
          for (UserRelationshipCollection cRelationship
              in value?.result?.userRelationshipCollection) {
            if (cRelationship?.parent?.id ==
                PreferenceUtil.getStringValue(Constants.KEY_USERID)) {
              relationShipController.text = cRelationship?.relationship?.name;
            }
          }
        }
        try {
          setState(() {
            _addressResult = _addressList[0];
          });
        } catch (e) {}
        if (commonUtil.checkIfStringisNull(value.result.bloodGroup)) {
          currentselectedBloodGroup = value.result.bloodGroup.split(' ')[0];
          currentselectedBloodGroupRange =
              value.result.bloodGroup.split(' ')[1];
        } else {
          currentselectedBloodGroup = null;
          currentselectedBloodGroupRange = null;
        }
        selectedGender = value.result.gender == null
            ? null
            : toBeginningOfSentenceCase(value.result.gender.toLowerCase());

        dateofBirthStr = value.result.dateOfBirth != null
            ? new FHBUtils()
                .getFormattedDateForUserBirth(value.result.dateOfBirth)
            : '';
        dateOfBirthController.text = value.result.dateOfBirth != null
            ? new FHBUtils().getFormattedDateOnlyNew(value.result.dateOfBirth)
            : '';
      });
    }
  }

  void setValues() async {
    addFamilyUserInfoBloc.phoneNo = mobileNoController.text;
    MyProfileModel myProf = new MyProfileModel();

    MyProfileResult profileResult = new MyProfileResult();
    profileResult.firstName = firstNameController.text.trim();
    profileResult.middleName = middleNameController.text.trim();
    profileResult.lastName = lastNameController.text.trim();
    profileResult.dateOfBirth = dateofBirthStr;
    profileResult.isIeUser = false;
    profileResult.isCpUser = false;
    profileResult.isSignedIn = false;
    profileResult.isVirtualUser = false;
    profileResult.isActive = true;
    profileResult.gender = selectedGender;
    profileResult.lastModifiedBy = null;
    profileResult.lastModifiedOn = null;
    profileResult.profilePicThumbnailUrl = '';

    AdditionalInfo additionalInfo = new AdditionalInfo();
    additionalInfo.height = heightController.text;
    additionalInfo.weight = weightController.text;

    profileResult.additionalInfo = additionalInfo;

    if (currentselectedBloodGroup != null &&
        currentselectedBloodGroupRange != null) {
      profileResult.bloodGroup =
          currentselectedBloodGroup + ' ' + currentselectedBloodGroupRange;
    }
    UserAddressCollection3 userAddressCollection3 =
        new UserAddressCollection3();
    if (widget.arguments.fromClass == CommonConstants.my_family) {
      addFamilyUserInfoBloc.isUpdate = true;
      profileResult.id = widget.arguments.sharedbyme.id;

      if (widget
          .arguments?.sharedbyme?.child?.userAddressCollection3.isNotEmpty) {
        userAddressCollection3.id =
            widget?.arguments?.sharedbyme?.child?.userAddressCollection3[0].id;
      }
    } else if (widget.arguments.fromClass == CommonConstants.user_update) {
      addFamilyUserInfoBloc.isUpdate = false;
      profileResult.id = widget.arguments.myProfileResult.id;
      if (widget
          .arguments?.myProfileResult?.userAddressCollection3.isNotEmpty) {
        userAddressCollection3.id =
            widget.arguments?.myProfileResult?.userAddressCollection3[0].id;
      }

      //allow only user who logged in to update their email address
      if (widget
          .arguments?.myProfileResult?.userContactCollection3.isNotEmpty) {
        UserContactCollection3 userContact =
            widget.arguments?.myProfileResult?.userContactCollection3[0];
        userContact.email = emailController.text;
        List<UserContactCollection3> userContactCollection3List = new List();
        userContactCollection3List.add(userContact);
        profileResult.userContactCollection3 = userContactCollection3List;
      }
    } else {
      profileResult.id = widget.arguments.addFamilyUserInfo.childInfo.id;
      addFamilyUserInfoBloc.isUpdate = false;
    }
    userAddressCollection3.addressLine1 = cntrlr_addr_one.text.trim();
    userAddressCollection3.addressLine2 = cntrlr_addr_two.text.trim();
    userAddressCollection3.pincode = cntrlr_addr_zip.text.trim();
    userAddressCollection3.city = cityVal;
    userAddressCollection3.state = stateVal;

    userAddressCollection3.isPrimary = true;
    userAddressCollection3.isActive = true;
    userAddressCollection3.createdOn =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    userAddressCollection3.lastModifiedOn = null;
    if (widget.arguments.fromClass == CommonConstants.my_family) {
      userAddressCollection3.createdBy = widget.arguments.id;
    } else if (widget.arguments.fromClass == CommonConstants.user_update) {
      userAddressCollection3.createdBy = widget.arguments.myProfileResult.id;
    } else {
      userAddressCollection3.createdBy =
          await PreferenceUtil.getStringValue(Constants.KEY_USERID);

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
      sortOrder: null,
      isActive: true,
      createdBy: widget.arguments.fromClass == CommonConstants.user_update
          ? PreferenceUtil.getStringValue(Constants.KEY_USERID)
          : widget.arguments.id,
      createdOn: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      lastModifiedOn: null,
    );

    List<UserAddressCollection3> userAddressCollection3List = new List();
    userAddressCollection3List.add(userAddressCollection3);
    profileResult.userAddressCollection3 = userAddressCollection3List;

    myProf.result = profileResult;
    addFamilyUserInfoBloc.myProfileModel = myProf;
    FamilyListBloc _familyListBloc = new FamilyListBloc();
    if (widget.arguments.fromClass == CommonConstants.my_family) {
      //*update the myfamily member details
      if (doValidation()) {
        if (addFamilyUserInfoBloc.profileBanner != null) {
          PreferenceUtil.saveString(Constants.KEY_PROFILE_BANNER,
              addFamilyUserInfoBloc.profileBanner.path);
        }
        CommonUtil.showLoadingDialog(
            dialogContext, _keyLoader, variable.Please_Wait); //

        addFamilyUserInfoBloc.updateSelfProfile(false).then((value) {
          if (value != null && value.isSuccess) {
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
                title: variable.Error, content: value.message);
          }
        });
      } else {
        // Navigator.pop(dialogContext);
        Alert.displayAlertPlain(context,
            title: variable.Error, content: strErrorMsg);
      }
    } else if (widget.arguments.fromClass == CommonConstants.user_update) {
      //*update the user details
      if (doValidation()) {
        if (addFamilyUserInfoBloc.profileBanner != null) {
          PreferenceUtil.saveString(Constants.KEY_PROFILE_BANNER,
              addFamilyUserInfoBloc.profileBanner.path);
        }
        CommonUtil.showLoadingDialog(
            dialogContext, _keyLoader, variable.Please_Wait); //

        addFamilyUserInfoBloc.updateSelfProfile(false).then((value) {
          if (value != null && value.isSuccess) {
            _familyListBloc.getFamilyMembersListNew().then((value) {
              /*MySliverAppBar.imageURI = null;
                    fetchedProfileData = null;*/

              if (widget.arguments.myProfileResult.firstName != null) {
                String firstName =
                    widget.arguments.myProfileResult.firstName != null
                        ? widget.arguments.myProfileResult.firstName
                        : '';
                String lastName =
                    widget.arguments.myProfileResult.lastName != null
                        ? widget.arguments.myProfileResult.lastName
                        : '';

                PreferenceUtil.saveString(Constants.FIRST_NAME, firstName);
                PreferenceUtil.saveString(Constants.LAST_NAME, lastName);
              }

              imageURI = null;
              Navigator.pop(dialogContext);
              Navigator.pop(dialogContext, true);
            });
          } else {
            Navigator.pop(dialogContext);
            Alert.displayAlertPlain(context,
                title: variable.Error, content: value.message);
          }
        });
      } else {
        //Navigator.pop(dialogContext);
        Alert.displayAlertPlain(context,
            title: variable.Error, content: strErrorMsg);
      }
    } else {
      //*other update
      if (doValidation()) {
        if (addFamilyUserInfoBloc.profileBanner != null) {
          PreferenceUtil.saveString(Constants.KEY_PROFILE_BANNER,
              addFamilyUserInfoBloc.profileBanner.path);
        }
        print('*********************');
        CommonUtil.showLoadingDialog(
            dialogContext, _keyLoader, variable.Please_Wait); //

        addFamilyUserInfoBloc.updateSelfProfile(false).then((value) {
          if (value != null && value.isSuccess) {
            _familyListBloc.getFamilyMembersListNew().then((value) {
              PreferenceUtil.saveFamilyData(
                      Constants.KEY_FAMILYMEMBER, value.result)
                  .then((value) {
                //saveProfileImage();
                /*  MySliverAppBar.imageURI = null;
                      fetchedProfileData = null;*/
                imageURI = null;
                Navigator.pop(dialogContext);
                Navigator.pop(dialogContext);
              });
            });
          } else {
            Navigator.pop(dialogContext);
            Alert.displayAlertPlain(context,
                title: variable.Error, content: value.message);
          }
        });
      } else {
        //Navigator.pop(dialogContext);
        Alert.displayAlertPlain(context,
            title: variable.Error, content: strErrorMsg);
      }
    }
  }

  Future<void> setMyProfilePic(String userId, File image) async {
    CommonResponse response =
        await _addFamilyUserInfoRepository.updateUserProfilePic(userId, image);
    if (response.isSuccess) {
      await new CommonUtil().getUserProfileData();
      FlutterToast().getToast('${response.message}', Colors.green);
    } else {
      FlutterToast().getToast('${response.message}', Colors.red);
    }
  }

  Widget showProfileImageNew() {
    if (widget.arguments.fromClass == CommonConstants.my_family) {
      currentUserID = widget.arguments.sharedbyme.child.id;
      return FutureBuilder<CommonResponse>(
        future: _addFamilyUserInfoRepository
            .getUserProfilePic(widget.arguments.sharedbyme.child.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot?.data?.isSuccess != null &&
                snapshot?.data?.result != null) {
              if (snapshot.data.isSuccess) {
                return Image.network(
                  snapshot.data.result,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                  headers: {
                    HttpHeaders.authorizationHeader:
                        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)
                  },
                );
              } else {
                return Center(
                  child: Text(
                    widget.arguments.sharedbyme.child.firstName != null
                        ? widget.arguments.sharedbyme.child.firstName[0]
                            .toUpperCase()
                        : '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60.0,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: Text(
                  widget.arguments.sharedbyme.child.firstName != null
                      ? widget.arguments.sharedbyme.child.firstName[0]
                          .toUpperCase()
                      : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60.0,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          } else {
            return Center(
              child: Text(
                widget.arguments.sharedbyme.child.firstName != null
                    ? widget.arguments.sharedbyme.child.firstName[0]
                        .toUpperCase()
                    : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
            );
          }
        },
      );
    } else if (widget.arguments.fromClass == CommonConstants.user_update) {
      currentUserID = widget.arguments.myProfileResult.id;
      return FutureBuilder<CommonResponse>(
        future: _addFamilyUserInfoRepository
            .getUserProfilePic(widget.arguments.myProfileResult.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot?.data?.isSuccess != null &&
                snapshot?.data?.result != null) {
              if (snapshot.data.isSuccess) {
                return Image.network(
                  snapshot.data.result,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                  headers: {
                    HttpHeaders.authorizationHeader:
                        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)
                  },
                );
              } else {
                return Center(
                  child: Text(
                    widget.arguments.myProfileResult.firstName != null
                        ? widget.arguments.myProfileResult.firstName[0]
                            .toUpperCase()
                        : '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60.0,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: Text(
                  widget.arguments.myProfileResult.firstName != null
                      ? widget.arguments.myProfileResult.firstName[0]
                          .toUpperCase()
                      : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60.0,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          } else {
            return Center(
              child: Text(
                widget.arguments.myProfileResult.firstName != null
                    ? widget.arguments.myProfileResult.firstName[0]
                        .toUpperCase()
                    : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60.0,
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
            widget.arguments?.addFamilyUserInfo?.childInfo?.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot?.data?.isSuccess != null &&
                snapshot?.data?.result != null) {
              if (snapshot.data.isSuccess) {
                return Image.network(
                  snapshot.data.result,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                  headers: {
                    HttpHeaders.authorizationHeader:
                        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)
                  },
                );
              } else {
                return Center(
                  child: Text(
                    widget.arguments.enteredFirstName != null
                        ? widget.arguments.enteredFirstName[0].toUpperCase()
                        : '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60.0,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: Text(
                  widget.arguments.enteredFirstName != null
                      ? widget.arguments.enteredFirstName[0].toUpperCase()
                      : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60.0,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          } else {
            return Center(
              child: Text(
                widget.arguments.enteredFirstName != null
                    ? widget.arguments.enteredFirstName[0].toUpperCase()
                    : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60.0,
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
    String userId = currentUserID;
    return showDialog(
      context: cont,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              title: Text(variable.makeAChoice),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(variable.Gallery),
                      onTap: () async {
                        var image = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          imageURI = image as File;
                          if (widget.arguments.fromClass ==
                              CommonConstants.user_update) {
                            await PreferenceUtil.saveString(
                                Constants.KEY_PROFILE_IMAGE, imageURI.path);
                          }
                          Navigator.pop(context);
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    GestureDetector(
                      child: Text(variable.Camera),
                      onTap: () async {
                        Navigator.pop(context);

                        var image = await ImagePicker.pickImage(
                            source: ImageSource.camera);
                        if (image != null) {
                          imageURI = image as File;
                          Navigator.pop(context);
                          if (widget.arguments.fromClass ==
                              CommonConstants.user_update) {
                            await PreferenceUtil.saveString(
                                Constants.KEY_PROFILE_IMAGE, imageURI.path);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ));
        });
      },
    ).then((value) {
      setState(() {});
      setMyProfilePic(userId, imageURI);
    });
  }

  Widget getAllCustomRoles() {
    Widget familyWidget;

    return StreamBuilder<ApiResponse<RelationShipResponseList>>(
      stream: addFamilyUserInfoBloc.relationShipStream,
      builder: (context,
          AsyncSnapshot<ApiResponse<RelationShipResponseList>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              break;

            case Status.ERROR:
              familyWidget = Center(
                  child: Text(Constants.STR_ERROR_LOADING_DATA,
                      style: TextStyle(color: Colors.red)));
              break;

            case Status.COMPLETED:
              isCalled = true;
              // relationShipResponseList =
              //     snapshot.data.data.result[0].referenceValueCollection;
              setState(() {
                relationShipResponseList =
                    snapshot.data.data.result[0].referenceValueCollection;
              });
              familyWidget = getRelationshipDetails(relationShipResponseList);

              break;
          }
        } else {
          familyWidget = Container(
            width: 100,
            height: 100,
          );
        }

        return familyWidget;
      },
    );
  }
}

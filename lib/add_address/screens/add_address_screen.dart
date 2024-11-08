import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../main.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../models/AddAddressArguments.dart';
import '../models/place.dart';
import '../services/google_map_service.dart';
import '../widgets/add_address_list.dart';

class AddAddressScreen extends StatefulWidget {
  final AddAddressArguments? arguments;

  const AddAddressScreen({this.arguments});

  @override
  State<StatefulWidget> createState() {
    return AddAddressScreenState();
  }
}

class AddAddressScreenState extends State<AddAddressScreen> {
  final searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  late var googleMapServices;
  var sessionToken;
  var uuid = Uuid();
  double tableHeight = 0;

  Future<List<Place>>? places;
  List<Place> placesListArray = <Place>[];

  @override
  void initState() {
    super.initState();
    searchController.addListener(textListener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: 10.0.w,
            right: 10.0.w,
            top: 40.0.h,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorUtils.blackcolor.withOpacity(0.1),
              width: 1.0.w,
            ),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10.0.w,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  ImageUrlUtils.backImg,
                  width: 16.0.h,
                  height: 16.0.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 10.0.w,
              ),
              _ShowSearchTextField(),
            ],
          ),
        ),
        if (placesListArray.length > 0 && placesListArray != null)
          AddAddressList(
              placesListArray: placesListArray,
              providerType: widget.arguments!.providerType)
        else
          Container()
      ],
    ));
  }

  Widget _ShowSearchTextField() {
    return Container(
      width: 1.sw - 70,
      padding: EdgeInsets.fromLTRB(
        10.0.w,
        0.0.h,
        10.0.w,
        0.0.h,
      ),
      child: TextField(
        cursorColor: mAppThemeProvider.primaryColor,
        controller: searchController,
        keyboardType: TextInputType.text,
        focusNode: searchFocus,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        onSubmitted: (term) {
          searchFocus.unfocus();
        },
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor,
        ),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: searchController.clear,
            icon: Icon(
              Icons.clear,
              color: ColorUtils.lightgraycolor,
              size: 24.0.sp,
            ),
          ),
          hintText: CommonConstants.searchPlaces,
          labelStyle: TextStyle(
            fontSize: 16.0.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.greycolor1,
          ),
          hintStyle: TextStyle(
            fontSize: 16.0.sp,
            color: ColorUtils.greycolor1,
            fontWeight: FontWeight.w400,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  textListener() {
    sessionToken ??= uuid.v4();

    googleMapServices = GoogleMapServices(sessionToken: sessionToken);
    places = googleMapServices.getSuggestions(searchController.text);

    places!.then((value) {
      setState(() {
        placesListArray = value;
      });
    });
  }
}

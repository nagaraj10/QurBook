import 'package:flutter/material.dart';
import 'package:myfhb/add_address/models/AddAddressArguments.dart';
import 'package:myfhb/add_address/models/place.dart';
import 'package:myfhb/add_address/services/google_map_service.dart';
import 'package:myfhb/add_address/widgets/add_address_list.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:uuid/uuid.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class AddAddressScreen extends StatefulWidget {
  final AddAddressArguments arguments;

  AddAddressScreen({this.arguments});

  @override
  State<StatefulWidget> createState() {
    return AddAddressScreenState();
  }
}

class AddAddressScreenState extends State<AddAddressScreen> {
  final searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  var googleMapServices;
  var sessionToken;
  var uuid = Uuid();
  double tableHeight = 0.0;

  Future<List<Place>> places;
  List<Place> placesListArray = List<Place>();

  @override
  void initState() {
    super.initState();
    mInitialTime = DateTime.now();
    searchController.addListener(textListener);
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Add address Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
            mainAxisAlignment: MainAxisAlignment.start,
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
        placesListArray.length > 0 && placesListArray != null
            ? AddAddressList(
                placesListArray: placesListArray,
                providerType: widget.arguments.providerType)
            : Container()
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
      child: new TextField(
        cursorColor: Color(new CommonUtil().getMyPrimaryColor()),
        controller: searchController,
        maxLines: 1,
        keyboardType: TextInputType.text,
        focusNode: searchFocus,
        textInputAction: TextInputAction.done,
        onSubmitted: (term) {
          searchFocus.unfocus();
        },
        style: new TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor,
        ),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () => searchController.clear(),
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
          border: new UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  textListener() {
    if (sessionToken == null) {
      sessionToken = uuid.v4();
    }

    googleMapServices = GoogleMapServices(sessionToken: sessionToken);
    places = googleMapServices.getSuggestions(searchController.text);

    places.then((value) {
      setState(() {
        placesListArray = value;
      });
    });
  }
}

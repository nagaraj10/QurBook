import 'package:flutter/material.dart';
import 'package:myfhb/add_address/models/AddAddressArguments.dart';
import 'package:myfhb/add_address/models/place.dart';
import 'package:myfhb/add_address/services/google_map_service.dart';
import 'package:myfhb/add_address/widgets/add_address_list.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:uuid/uuid.dart';
import 'package:myfhb/common/CommonUtil.dart';

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

    searchController.addListener(textListener);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 40),
          decoration: BoxDecoration(
              border: Border.all(
            color: ColorUtils.blackcolor.withOpacity(0.1),
            width: 1,
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(ImageUrlUtils.backImg,
                      width: 16, height: 16, fit: BoxFit.cover)),
              SizedBox(width: 10),
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
      width: MediaQuery.of(context).size.width - 70,
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
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
            fontSize: 16.0,
            color: ColorUtils.blackcolor),
        decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () => searchController.clear(),
              icon: Icon(Icons.clear, color: ColorUtils.lightgraycolor),
            ),
            hintText: CommonConstants.searchPlaces,
            labelStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.greycolor1),
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: ColorUtils.greycolor1,
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(borderSide: BorderSide.none)),
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

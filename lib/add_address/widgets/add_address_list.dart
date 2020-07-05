import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/add_address/models/place.dart';
import 'package:myfhb/add_address/services/google_map_service.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/confirm_location/models/confirm_location_arguments.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:uuid/uuid.dart';

class AddAddressList extends StatefulWidget {
  List<Place> placesListArray;
  String providerType;

  AddAddressList({this.placesListArray, this.providerType});

  @override
  State<StatefulWidget> createState() {
    return AddAddressListState();
  }
}

class AddAddressListState extends State<AddAddressList> {
  bool keyboardIsOpen = false;
  var googleMapServices;
  var sessionToken;
  var uuid = Uuid();

  Future<PlaceDetail> futurePlaceDetail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(child: Container(child: buildGooglePlacesList()));
  }

  Widget buildGooglePlacesList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, index) {
        Place eachPlaceModel = widget.placesListArray[index];
        return InkWell(
          onTap: () {
            if (sessionToken == null) {
              sessionToken = uuid.v4();
            }
            googleMapServices = GoogleMapServices(sessionToken: sessionToken);
            futurePlaceDetail = googleMapServices.getPlaceDetail(
              eachPlaceModel.placeId,
              sessionToken,
            );

            futurePlaceDetail.then((value) {

              Navigator.pushNamed(
                context,
                '/confirm-location',
                arguments: ConfirmLocationArguments(
                    place: eachPlaceModel,
                    placeDetail: value,
                    providerType: widget.providerType),
              );
            });

            sessionToken = null;
          },
          child: Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10),
              Image.asset(ImageUrlUtils.locationImg, width: 20, height: 20),
              SizedBox(width: 10),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  AutoSizeText(
                    eachPlaceModel.title,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.blackcolor),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 3),
                  AutoSizeText(
                    eachPlaceModel.description,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.adddescripcolor),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5),
                  Divider(
                    height: 2.0,
                    color: ColorUtils.adddescripcolor,
                  ),
                ],
              )),
            ],
          )),
        );
      },
      itemCount: widget.placesListArray.length,
    );
  }
}

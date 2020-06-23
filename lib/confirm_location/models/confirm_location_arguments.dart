import 'package:myfhb/add_address/models/place.dart';

class ConfirmLocationArguments {
  Place place;
  PlaceDetail placeDetail;
  String providerType;

  ConfirmLocationArguments({this.place, this.placeDetail, this.providerType});
}

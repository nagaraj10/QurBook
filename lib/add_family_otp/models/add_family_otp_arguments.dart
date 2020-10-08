import 'package:myfhb/my_family/models/relationships.dart';

class AddFamilyOTPArguments {
  String enteredFirstName;
  String enteredMiddleName;
  String enteredLastName;
  String enteredMobNumber;
  String selectedCountryCode;
  RelationsShipModel relationShip;
  bool isPrimaryNoSelected;

  AddFamilyOTPArguments(
      {this.enteredFirstName,
      this.enteredMiddleName,
      this.enteredLastName,
      this.enteredMobNumber,
      this.selectedCountryCode,
      this.relationShip,
      this.isPrimaryNoSelected});
}

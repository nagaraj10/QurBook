import 'package:myfhb/my_family/models/RelationShip.dart';
import 'package:myfhb/my_family/models/relationship_response_list.dart';

class AddFamilyOTPArguments {
  String enteredFirstName;
  String enteredMiddleName;
  String enteredLastName;
  String enteredMobNumber;
  String selectedCountryCode;
  RelationShip relationShip;
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

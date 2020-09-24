import 'package:myfhb/add_family_otp/models/add_family_otp_response.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/my_family/models/RelationShip.dart';

class AddFamilyUserInfoArguments {
  AddFamilyUserInfo addFamilyUserInfo;
  String enteredFirstName;
  String enteredMiddleName;
  String enteredLastName;
  RelationShip relationShip;
  String id;
  bool isPrimaryNoSelected;
  SharedByUsers sharedbyme;
  String fromClass;

  AddFamilyUserInfoArguments(
      {this.addFamilyUserInfo,
      this.enteredFirstName,
      this.enteredMiddleName,
      this.enteredLastName,
      this.relationShip,
      this.id,
      this.isPrimaryNoSelected,
      this.sharedbyme,
      this.fromClass});
}

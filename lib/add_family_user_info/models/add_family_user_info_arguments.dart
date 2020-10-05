import 'package:myfhb/add_family_otp/models/add_family_otp_response.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/my_family/models/relationships.dart';
import 'package:myfhb/src/model/user/MyProfileResult.dart';

class AddFamilyUserInfoArguments {
  Result addFamilyUserInfo;
  String enteredFirstName;
  String enteredMiddleName;
  String enteredLastName;
  RelationsShipCollection relationShip;
  String id;
  bool isPrimaryNoSelected;
  SharedByUsers sharedbyme;
  String fromClass;
  MyProfileResult myProfileResult;

  AddFamilyUserInfoArguments(
      {this.addFamilyUserInfo,
      this.enteredFirstName,
      this.enteredMiddleName,
      this.enteredLastName,
      this.relationShip,
      this.id,
      this.isPrimaryNoSelected,
      this.sharedbyme,
      this.fromClass,this.myProfileResult});
}

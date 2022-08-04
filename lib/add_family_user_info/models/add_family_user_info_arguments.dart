import '../../add_family_otp/models/add_family_otp_response.dart';
import '../../my_family/models/FamilyMembersRes.dart';
import '../../my_family/models/relationships.dart';
import '../../src/model/user/MyProfileResult.dart';

class AddFamilyUserInfoArguments {
  Result addFamilyUserInfo;
  String enteredFirstName;
  String enteredMiddleName;
  String enteredLastName;
  RelationsShipModel relationShip;
  List<RelationsShipModel> defaultrelationShips;
  String id;
  bool isPrimaryNoSelected;
  SharedByUsers sharedbyme;
  String fromClass;
  MyProfileResult myProfileResult;
  bool isFromCSIR;
  String packageId;
  String isSubscribed;
  String providerId;
  Function() refresh;
  bool feeZero;
  bool isFromCartPage;
  bool isFromAppointmentOrSlotPage = false;
  bool isForFamilyAddition = false;
  bool isForFamily = false;

  AddFamilyUserInfoArguments(
      {this.addFamilyUserInfo,
      this.enteredFirstName,
      this.enteredMiddleName,
      this.enteredLastName,
      this.relationShip,
      this.defaultrelationShips,
      this.id,
      this.isPrimaryNoSelected,
      this.sharedbyme,
      this.fromClass,
      this.myProfileResult,
      this.isFromCSIR = false,
      this.packageId,
      this.isSubscribed,
      this.providerId,
      this.refresh,
      this.feeZero,
      this.isFromCartPage,
      this.isFromAppointmentOrSlotPage,
      this.isForFamilyAddition,
      this.isForFamily});
}

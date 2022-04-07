import '../../my_family/models/FamilyMembersRes.dart';
import '../../src/model/user/MyProfileModel.dart';

class MyFamilyDetailArguments {
  List<SharedByUsers> profilesSharedByMe;
  MyProfileModel myProfile;
  int currentPage;
  String caregiverRequestor;
  MyFamilyDetailArguments(
      {this.profilesSharedByMe, this.currentPage, this.myProfile,this.caregiverRequestor});
}

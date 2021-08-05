import '../../my_family/models/FamilyMembersRes.dart';
import '../../src/model/user/MyProfileModel.dart';

class MyFamilyDetailArguments {
  List<SharedByUsers> profilesSharedByMe;
  MyProfileModel myProfile;
  int currentPage;

  MyFamilyDetailArguments(
      {this.profilesSharedByMe, this.currentPage, this.myProfile});
}

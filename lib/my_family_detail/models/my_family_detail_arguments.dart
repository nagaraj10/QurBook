import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';

class MyFamilyDetailArguments {
  List<SharedByUsers> profilesSharedByMe;
  MyProfileModel myProfile;
  int currentPage;

  MyFamilyDetailArguments(
      {this.profilesSharedByMe, this.currentPage, this.myProfile});
}

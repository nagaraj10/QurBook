import 'package:myfhb/my_family/models/FamilyMembersRes.dart';

class MyFamilyDetailArguments {
  List<SharedByUsers> profilesSharedByMe = new List();
  int currentPage;

  MyFamilyDetailArguments({this.profilesSharedByMe, this.currentPage});
}

import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';

class MyFamilyDetailArguments {
  List<Sharedbyme> profilesSharedByMe = new List();
  int currentPage;

  MyFamilyDetailArguments({this.profilesSharedByMe, this.currentPage});
}

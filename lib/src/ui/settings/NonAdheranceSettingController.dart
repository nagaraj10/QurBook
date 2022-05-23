import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/my_family/services/FamilyMemberListRepository.dart';

class NonAdheranceSettingController extends GetxController {
  var loadingData = false.obs;
  final familyRepository = FamilyMemberListRepository();

  FamilyMembers familyResponseList;


  getFamilyMemberList() async {
    try {
      loadingData.value = true;
      // familyResponseList = await familyRepository.getFamilyMembersListNew();
      familyResponseList = await familyRepository.getFamilyMembersListNew();
      loadingData.value = false;
      update(["newUpdate"]);
    } catch (e) {
    print(e.toString());
    loadingData.value = false;
    }
  }

}

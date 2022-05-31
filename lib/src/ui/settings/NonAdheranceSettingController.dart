import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/my_family/services/FamilyMemberListRepository.dart';
import 'package:myfhb/src/model/NonAdheranceList/NonAdheranceResponseModel.dart';
import 'package:myfhb/src/model/remainderfor_model/RemainderForModel.dart';
import 'package:myfhb/src/resources/repository/NonAdheranceRepository.dart';

class NonAdheranceSettingController extends GetxController {
  var loadingData = false.obs;
  final familyRepository = FamilyMemberListRepository();
  final nonAdheranceRepository = NonAdheranceRepository();
  RemainderForModel remainderForModel;
  FamilyMembers familyResponseList;
  NonAdheranceResponseModel nonAdheranceResponseModel;
  List<String> remainderFor=[];

  getFamilyMemberList() async {
    try {
      loadingData.value = true;
      remainderForModel = await nonAdheranceRepository.getRemainderForList();
      remainderFor.clear();
      remainderForModel.result.forEach((element) {
        remainderFor.add(element.name);
      });
      nonAdheranceResponseModel = await nonAdheranceRepository.getNonAdheranceList();
      familyResponseList = await familyRepository.getFamilyMembersListNew();
      familyResponseList.result.sharedToUsers.removeWhere((element) => !element.isCaregiver);
      familyResponseList.result.sharedToUsers.forEach((element) {
        element.remainderFor=remainderFor[0];
        element.remainderForId=remainderForModel.result[0].id;
        element.remainderMins="15 Mins";
      });
      familyResponseList.result.sharedToUsers.forEach((element) {
        nonAdheranceResponseModel.result.forEach((elementNon) {
          if(elementNon.patient.id==element.parent.id){
            element.isNewUser=false;
            element.nonAdheranceId=elementNon.id;
            element.remainderMins=elementNon.remindAfterMins.toString()+' Mins';
            element.remainderForId=elementNon.reminderFor.id;
            element.remainderFor=elementNon.reminderFor.name;
          }
        });
      });
      loadingData.value = false;
      update(["newUpdate"]);
    } catch (e) {
    print(e.toString());
    loadingData.value = false;
    }
  }

  saveNonAdherance(String mins,String patientId,String reminderFor) async {

    try {
      loadingData.value = true;
      nonAdheranceResponseModel = await nonAdheranceRepository.saveNonAdherance(mins,patientId,reminderFor);
      loadingData.value = false;
      getFamilyMemberList();
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }

  editNonAdherance(String id,String mins,String patientId,String reminderFor) async {

    try {
      loadingData.value = true;
      nonAdheranceResponseModel = await nonAdheranceRepository.editNonAdherance(id,mins,patientId,reminderFor);
      loadingData.value = false;
      getFamilyMemberList();
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }

}

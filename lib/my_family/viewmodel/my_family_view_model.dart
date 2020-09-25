import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/constants/webservice_call.dart';
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/my_family/models/relationship_response_list.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class MyFamilyViewModel with ChangeNotifier {
  // Api Base Helper
  ApiBaseHelper _helper = ApiBaseHelper();
  WebserviceCall webserviceCall = new WebserviceCall();

  // 1
  // Get the family members list
  FamilyMembersList familyMembersList;

  // 2
  // Get the relationship list
  RelationShipResponseList relationShipResponseList;

  // 1
  // Get Family Members
  Future<FamilyMembersList> getFamilyMembersInfo() async {
    try {
      final response = await _helper
          .getFamilyMembersList(webserviceCall.getQueryForFamilyMemberList());
      familyMembersList = FamilyMembersList.fromJson(response);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  // 2
  // Get Roles
  Future<RelationShipResponseList> getCustomRoles() async {
    try {
      final response =
          await _helper.getCustomRoles(query.qr_customRole + query.qr_sort);
      ;
      relationShipResponseList = RelationShipResponseList.fromJson(response);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:myfhb/add_family_user_info/models/address_result.dart';
import 'package:myfhb/add_family_user_info/models/address_type_list.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/common/CommonConstants.dart';


class DoctorPersonalViewModel {
  
  Future<List<AddressResult>> getAddressTypeList() async {
    AddressTypeResult addressTypeResult;
    var addressQuery = [CommonConstants.strCodePhone];
    AddFamilyUserInfoRepository resposiory = AddFamilyUserInfoRepository();
    addressTypeResult = await resposiory
        .getAddressTypeResult(addressQuery.toString());
    return addressTypeResult.result;
  }
}

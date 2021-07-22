import 'dart:convert';
import 'dart:io';

import '../models/address_result.dart';
import '../models/address_type_list.dart';
import '../services/add_family_user_info_repository.dart';
import '../../common/CommonConstants.dart';

class DoctorPersonalViewModel {
  Future<List<AddressResult>> getAddressTypeList() async {
    AddressTypeResult addressTypeResult;
    final addressQuery = [CommonConstants.strCodePhone];
    final resposiory = AddFamilyUserInfoRepository();
    addressTypeResult =
        await resposiory.getAddressTypeResult(addressQuery.toString());
    return addressTypeResult.result;
  }
}

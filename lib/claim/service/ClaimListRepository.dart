import 'package:myfhb/claim/model/claimexpiry/ClaimExpiryResponse.dart';
import 'package:myfhb/claim/model/claimmodel/ClaimListResponse.dart';
import 'package:myfhb/claim/model/claimmodel/ClaimRecordDetail.dart';
import 'package:myfhb/claim/model/credit/CreditBalance.dart';
import 'package:myfhb/claim/model/members/MembershipDetails.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/chat/model/GetRecordIdsFilter.dart';
import '../../constants/fhb_query.dart' as variable;
import '../../constants/fhb_constants.dart' as Constants;

class ClaimListRepository{
  final ApiBaseHelper _helper = ApiBaseHelper();


  Future<MemberShipDetails> getMemberShip() async {
    String userId = await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    final responseQuery =
        '${variable.qr_membership}$userId';
    var  response = await _helper.getMemberShipDetails(responseQuery);

    return MemberShipDetails.fromJson(response);
  }
  Future<CreditBalance> getCreditBalance() async {
    String userId = await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    final responseQuery =
        '${variable.qr_user}${variable.getCreditBalnce}$userId';
    final  response =
    await _helper.getCredit(responseQuery);

    return CreditBalance.fromJson(response);
  }
  Future<ClaimListResponse> getClaimList() async {
    String userId = await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    final responseQuery =
        '${variable.getClaimWithQues}$userId';
    final  response =
    await _helper.getClaimList(responseQuery);

    return ClaimListResponse.fromJson(response);
  }
  Future<GetRecordIdsFilter> getHealthRecordDetailViaId(String healthRecordID) async {
    List<String> recordId=new List();
    recordId.add(healthRecordID);
    String userId = await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    final  response =
    await _helper.getMetaIdURL(recordId,userId);

    return GetRecordIdsFilter.fromJson(response);
  }

  Future<ClaimRecordDetails> getClaimRecordDetails(String claimID) async {
    final responseQuery =
        '${variable.qr_claim_with_slash}$claimID';
    final  response =
    await _helper.getClaimListDetails(responseQuery);

    return ClaimRecordDetails.fromJson(response);
  }

  Future<ClaimExpiryResponse> getClaimExpiryResponseList() async {
    String userId = await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    final responseQuery =
        '${variable.qr_expiry_claim_list}$userId';
    final  response =
    await _helper.getClaimExpiryResponseList(responseQuery);

    return ClaimExpiryResponse.fromJson(response);
  }


}

import 'dart:async';
import 'package:myfhb/common/CommonUtil.dart';

import '../Authentication/LoginBloc.dart';
import '../../model/user/MyProfileModel.dart';
import '../../model/user/ProfileCompletedata.dart';
import '../../resources/network/ApiResponse.dart';
import '../../resources/repository/User/MyProfileRepository.dart';

import '../../../constants/variable_constant.dart' as variable;

class MyProfileBloc implements BaseBloc {
  late MyProfileRepository _myProfileRepository;
  StreamController? _myProfileController;
  StreamController? _myCompleteProfileController;

  StreamSink<ApiResponse<MyProfileModel>> get myProfileInfoSink =>
      _myProfileController!.sink as StreamSink<ApiResponse<MyProfileModel>>;
  Stream<ApiResponse<MyProfileModel>> get myProfileInfoStream =>
      _myProfileController!.stream as Stream<ApiResponse<MyProfileModel>>;

  StreamSink<ApiResponse<ProfileCompleteData>> get myCompleteProfileInfoSink =>
      _myCompleteProfileController!.sink as StreamSink<ApiResponse<ProfileCompleteData>>;
  Stream<ApiResponse<ProfileCompleteData>> get myCompleteProfileInfoStream =>
      _myCompleteProfileController!.stream as Stream<ApiResponse<ProfileCompleteData>>;

  @override
  void dispose() {
    _myProfileController?.close();
    _myCompleteProfileController?.close();
  }

  MyProfileBloc() {
    _myProfileController = StreamController<ApiResponse<MyProfileModel>>();
    _myProfileRepository = MyProfileRepository();
    _myCompleteProfileController =
        StreamController<ApiResponse<ProfileCompleteData>>();
  }

 Future<MyProfileModel?> getMyProfileData(String profileKey) async {
    myProfileInfoSink.add(ApiResponse.loading(variable.strGetProfileData));
    MyProfileModel? profileResponse;
    try {
      profileResponse = await _myProfileRepository.getMyProfileInfo(profileKey);
      myProfileInfoSink.add(ApiResponse.completed(profileResponse));
    } catch (e) {
                  CommonUtil().appLogs(message: e.toString());

      myProfileInfoSink.add(ApiResponse.error(e.toString()));
    }
    return profileResponse;
  }


  Future<ProfileCompleteData?> getCompleteProfileData(String profileKey) async {
    myCompleteProfileInfoSink.add(ApiResponse.loading(variable.strGetProfileData));
    ProfileCompleteData? profileCompleteData;
    try {
      profileCompleteData =
          await _myProfileRepository.getCompleteMyProfileInfo(profileKey);
      myCompleteProfileInfoSink.add(ApiResponse.completed(profileCompleteData));
    } catch (e) {
                  CommonUtil().appLogs(message: e.toString());

      myCompleteProfileInfoSink.add(ApiResponse.error(e.toString()));
      
    }
    return profileCompleteData;
  }
}

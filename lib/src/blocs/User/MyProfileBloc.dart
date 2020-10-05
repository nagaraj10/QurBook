import 'dart:async';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/ProfileCompletedata.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/resources/repository/User/MyProfileRepository.dart';

import 'package:myfhb/constants/variable_constant.dart' as variable;

class MyProfileBloc implements BaseBloc {
  MyProfileRepository _myProfileRepository;
  StreamController _myProfileController;
  StreamController _myCompleteProfileController;

  StreamSink<ApiResponse<MyProfileModel>> get myProfileInfoSink =>
      _myProfileController.sink;
  Stream<ApiResponse<MyProfileModel>> get myProfileInfoStream =>
      _myProfileController.stream;

  StreamSink<ApiResponse<ProfileCompleteData>> get myCompleteProfileInfoSink =>
      _myCompleteProfileController.sink;
  Stream<ApiResponse<ProfileCompleteData>> get myCompleteProfileInfoStream =>
      _myCompleteProfileController.stream;

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

 Future<MyProfileModel> getMyProfileData(String profileKey) async {
    myProfileInfoSink.add(ApiResponse.loading(variable.strGetProfileData));
    MyProfileModel profileResponse;
    try {
      profileResponse = await _myProfileRepository.getMyProfileInfo(profileKey);
      myProfileInfoSink.add(ApiResponse.completed(profileResponse));
    } catch (e) {
      myProfileInfoSink.add(ApiResponse.error(e.toString()));
    }
    return profileResponse;
  }


  Future<ProfileCompleteData> getCompleteProfileData(String profileKey) async {
    myCompleteProfileInfoSink.add(ApiResponse.loading(variable.strGetProfileData));
    ProfileCompleteData profileCompleteData;
    try {
      profileCompleteData =
          await _myProfileRepository.getCompleteMyProfileInfo(profileKey);
      myCompleteProfileInfoSink.add(ApiResponse.completed(profileCompleteData));
    } catch (e) {
      myCompleteProfileInfoSink.add(ApiResponse.error(e.toString()));
      
    }
    return profileCompleteData;
  }
}

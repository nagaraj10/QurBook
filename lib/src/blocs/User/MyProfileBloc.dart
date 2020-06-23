import 'dart:async';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/model/user/ProfileCompletedata.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/resources/repository/User/MyProfileRepository.dart';

class MyProfileBloc implements BaseBloc {
  MyProfileRepository _myProfileRepository;
  StreamController _myProfileController;
  StreamController _myCompleteProfileController;

  StreamSink<ApiResponse<MyProfile>> get myProfileInfoSink =>
      _myProfileController.sink;
  Stream<ApiResponse<MyProfile>> get myProfileInfoStream =>
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
    _myProfileController = StreamController<ApiResponse<MyProfile>>();
    _myProfileRepository = MyProfileRepository();
    _myCompleteProfileController =
        StreamController<ApiResponse<ProfileCompleteData>>();
  }

 Future<MyProfile> getMyProfileData(String profileKey) async {
    myProfileInfoSink.add(ApiResponse.loading('Signing in user'));
    MyProfile profileResponse;
    try {
      profileResponse = await _myProfileRepository.getMyProfileInfo(profileKey);
      myProfileInfoSink.add(ApiResponse.completed(profileResponse));
    } catch (e) {
      myProfileInfoSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
    return profileResponse;
  }


  Future<ProfileCompleteData> getCompleteProfileData(String profileKey) async {
    myCompleteProfileInfoSink.add(ApiResponse.loading('Signing in user'));
    ProfileCompleteData profileCompleteData;
    try {
      profileCompleteData =
          await _myProfileRepository.getCompleteMyProfileInfo(profileKey);
      myCompleteProfileInfoSink.add(ApiResponse.completed(profileCompleteData));
    } catch (e) {
      myCompleteProfileInfoSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
    return profileCompleteData;
  }
}

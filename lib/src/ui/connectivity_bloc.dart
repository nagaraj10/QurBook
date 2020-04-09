import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';


class ConnectivityBloc extends ChangeNotifier {
  
  ConnectivityBloc() {
    init();
  }

  bool _isNetworkAvailable = false;

  bool get connectionStatus => _isNetworkAvailable;

  // set connectionStatus(bool val) {
  //   _isNetworkAvailable = val;
  //   notifyListeners();
  // }

  Future<void> init() async {
    var connStatus = await Connectivity().checkConnectivity();
    if(connStatus == ConnectivityResult.mobile || connStatus == ConnectivityResult.wifi){
       _isNetworkAvailable = true;
    }else{
      _isNetworkAvailable = false;
    }
    notifyListeners();
  }
}

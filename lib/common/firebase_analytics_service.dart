import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAnalyticsService {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);



  Future<void> setUserProperties(String name, String value) async {
    try{
      await analytics.setUserProperty(name: name, value: value);
      print("user prop analytics");
    }catch(e){
      print(e);
    }
  }

  FirebaseAnalyticsObserver getObserver() {
    return observer;
  }

  Future<void> setUserId(String uId) async {
    await analytics.setUserId(uId);
  }

  Future<void> trackEvent(
      String eventName, Map<String, dynamic> parameters) async {

    print('Event : ' + eventName + ', Parameters : ' + parameters.toString());
    await analytics
        .logEvent(name: eventName, parameters: parameters)
        .whenComplete(() => print('logEvent succeeded'));
  }

  Future<void> trackCurrentScreen(
      String currentScreen, String classOverrides) async {
    try{
      await analytics.setCurrentScreen(
          screenName: currentScreen, screenClassOverride: classOverrides);
      print("user prop analytics");
    }catch(e){
      print("error: "+e);
    }

  }

  Future<void> clearUserProperties() async {
    await analytics.resetAnalyticsData();
  }
}

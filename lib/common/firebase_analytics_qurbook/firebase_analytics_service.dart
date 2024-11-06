// ignore_for_file: public_member_api_docs

import 'package:firebase_analytics/firebase_analytics.dart';

final FABService = FirebaseAnalyticsService();

class FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Set user properties for analytics tracking.
  Future<void> setUserProperties({
    String? name,
    String? value,
  }) async {
    await _analytics.setUserProperty(
      name: name ?? 'Qurbook',
      value: value,
    );
  }

  /// Get the Firebase Analytics observer for integration with Navigator.
  FirebaseAnalyticsObserver getObserver() => FirebaseAnalyticsObserver(
        analytics: _analytics,
      );

  /// Set a user ID for analytics tracking.
  Future<void> setUserId(String? uId) async {
    await _analytics.setUserId(id: uId);
  }

  /// Track a custom event with optional parameters.
  Future<void> trackEvent({
    String eventName = '',
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  /// Track the current screen viewed by the user.
  Future<void> trackCurrentScreen(
    String currentScreen, {
    String? classOverrides,
  }) async {
    await _analytics.logEvent(
      name: 'qurbook_screen_view',
      parameters: {
        'page_visit': currentScreen,
      },
    );
  }

  /// Clear all user properties and reset analytics data.
  Future<void> clearUserProperties() async {
    await _analytics.resetAnalyticsData();
  }
}

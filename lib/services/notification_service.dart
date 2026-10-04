import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  static StreamSubscription<String>? _tokenRefreshSubscription;

  static Future<void> initialize() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        debugPrint(
          'NOTIFICATIONS: No authenticated Supabase user.',
        );
        return;
      }

      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus ==
              AuthorizationStatus.denied ||
          settings.authorizationStatus ==
              AuthorizationStatus.notDetermined) {
        debugPrint(
          'NOTIFICATIONS: Permission not granted.',
        );
        return;
      }

      String? token;

      if (kIsWeb) {
        debugPrint(
          'NOTIFICATIONS: Web token registration skipped for now.',
        );
        return;
      } else {
        token = await _messaging.getToken();
      }

      if (token == null || token.isEmpty) {
        debugPrint(
          'NOTIFICATIONS: No FCM token received.',
        );
        return;
      }

      await _saveToken(
        token: token,
        authUserId: user.id,
      );

      await _tokenRefreshSubscription?.cancel();

      _tokenRefreshSubscription =
          _messaging.onTokenRefresh.listen(
        (newToken) async {
          final currentUser =
              Supabase.instance.client.auth.currentUser;

          if (currentUser == null) {
            return;
          }

          await _saveToken(
            token: newToken,
            authUserId: currentUser.id,
          );
        },
      );

      debugPrint(
        'NOTIFICATIONS: Registration complete.',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'NOTIFICATIONS ERROR: $error',
      );
      debugPrint(
        '$stackTrace',
      );
    }
  }

  static Future<void> _saveToken({
    required String token,
    required String authUserId,
  }) async {
    final supabase = Supabase.instance.client;

    await supabase
        .from('notification_tokens')
        .upsert(
      {
        'auth_user_id': authUserId,
        'token': token,
        'platform': _platformName(),
        'updated_at':
            DateTime.now().toUtc().toIso8601String(),
      },
      onConflict: 'token',
    );

    debugPrint(
      'NOTIFICATIONS: FCM token saved.',
    );
  }

  static String _platformName() {
    if (kIsWeb) {
      return 'web';
    }

    if (Platform.isIOS) {
      return 'ios';
    }

    if (Platform.isAndroid) {
      return 'android';
    }

    if (Platform.isMacOS) {
      return 'macos';
    }

    if (Platform.isWindows) {
      return 'windows';
    }

    return 'unknown';
  }

  static Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
  }
}
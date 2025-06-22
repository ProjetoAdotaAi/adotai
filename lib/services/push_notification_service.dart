import 'dart:io';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    if (!Platform.isAndroid) return;

    await Firebase.initializeApp();

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      final token = await _messaging.getToken();

      if (token != null) {
        await _saveAndSendToken(token);
      }
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      await _saveAndSendToken(newToken);
    });
  }

  Future<void> _saveAndSendToken(String token) async {
    await saveToken(token);
    await sendTokenNotifications(token);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firebase_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('firebase_token');
  }

  Future<void> sendTokenNotifications(String token) async {
    final uri = Uri.parse('');
    final client = HttpClient();

    try {
      final request = await client.postUrl(uri);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.add(utf8.encode(json.encode({'token': token})));

      final response = await request.close();

      if (response.statusCode == 200) {
      } else {
      }
    } catch (e) {
    } finally {
      client.close();
    }
  }
}

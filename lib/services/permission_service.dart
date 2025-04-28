import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestLocationPermission() async {
    if (Platform.isAndroid) {
      return await Permission.location.request().isGranted;
    } else if (Platform.isIOS) {
      return await Permission.locationWhenInUse.request().isGranted;
    }
    return false;
  }

  static Future<bool> requestBackgroundLocationPermission() async {
    if (Platform.isAndroid) {
      return await Permission.locationAlways.request().isGranted;
    } else if (Platform.isIOS) {
      return await Permission.locationAlways.request().isGranted;
    }
    return false;
  }
}

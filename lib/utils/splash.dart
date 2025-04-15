import 'package:flutter/material.dart';
import '../services/permission_service.dart';

class SplashUtils {
  final BuildContext context;
  final Function(String) onPermissionDenied;

  SplashUtils({required this.onPermissionDenied, required this.context});

  Future<void> checkPermissions() async {
    List<String> deniedPermissions = [];

    bool locationPermissionGranted = await PermissionService.requestLocationPermission();
    if (!locationPermissionGranted) {
      deniedPermissions.add('Localização');
    }

    bool backgroundLocationPermissionGranted = await PermissionService.requestBackgroundLocationPermission();
    if (!backgroundLocationPermissionGranted) {
      deniedPermissions.add('Localização em segundo plano');
    }

    if (deniedPermissions.isNotEmpty) {
      onPermissionDenied(deniedPermissions.join(', '));
    }
  }
}

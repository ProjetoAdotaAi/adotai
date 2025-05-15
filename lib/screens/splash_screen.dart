import 'dart:async';
import 'package:adotai/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../theme/app_theme.dart';
import '../services/permission_service.dart';

class SplashScreen extends StatefulWidget {
  final bool fromLogin;
  const SplashScreen({super.key, this.fromLogin = false});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  String _deniedPermission = '';
  bool _isPermissionChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  void navigateToHome() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Future<void> _initialize() async {
    if (widget.fromLogin) {
      // Mostra splash por 2 segundos antes de ir pra HomeScreen
      await Future.delayed(const Duration(seconds: 2));
      navigateToHome();
      return;
    }

    bool locationPermissionGranted =
        await PermissionService.requestLocationPermission();
    Timer(Duration(seconds: 5), () {
      if (!_isPermissionChecked) {
        _navigateToLogin();
      }
    });

    if (locationPermissionGranted) {
      setState(() {
        _isPermissionChecked = true;
      });
      _navigateToLogin();
    } else {
      setState(() {
        _isPermissionChecked = true;
        _deniedPermission = 'Localização';
      });
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasDenied = _deniedPermission.isNotEmpty;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/images/logo.png'),
                width: 150,
              ),
              const SizedBox(height: 30),
              hasDenied
                  ? Column(
                    children: [
                      Text(
                        'Permissão negada para: $_deniedPermission',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () async {
                          setState(() {
                            _deniedPermission = '';
                          });
                          await _initialize();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                        child: const Text(
                          'Tentar Novamente',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  )
                  : const SizedBox(
                    width: 150,
                    child: LinearProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.white54,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

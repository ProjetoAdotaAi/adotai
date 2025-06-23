import 'dart:io';
import 'package:adotai/providers/forgotPassword_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as local;
import '../providers/user_provider.dart';
import '../providers/pet_provider.dart';
import 'providers/interaction_provider.dart';
import 'screens/splash_screen.dart';
import '../theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/push_notification_service.dart';
import 'utils/api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  if (Platform.isAndroid) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    final pushService = PushNotificationService();
    await pushService.initialize();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = Api();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OtpProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => InteractionProvider()),
        ChangeNotifierProxyProvider<UserProvider, local.AuthProvider>(
          create: (context) => local.AuthProvider(
            authService: AuthService(api: api),
            userProvider: Provider.of<UserProvider>(context, listen: false),
          ),
          update: (context, userProvider, previousAuth) => local.AuthProvider(
            authService: previousAuth?.authService ?? AuthService(api: api),
            userProvider: userProvider,
          ),
        ),
        ChangeNotifierProvider(create: (_) => PetProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppTheme.primaryColor,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppTheme.primaryColor,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

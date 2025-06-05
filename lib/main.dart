import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../providers/auth_provider.dart' as local;
import '../providers/user_provider.dart';
import '../providers/pet_provider.dart';
import '../services/auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import '../theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (_) => local.AuthProvider(authService: AuthService()),
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
        home: HomeScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/auth/auth_controller.dart';
import 'src/auth/auth_service.dart'; // Gerçek servis

import 'src/ui/main_shell.dart';
import 'src/ui/screens/onboarding_screen.dart';
import 'src/ui/screens/login_screen.dart';
import 'src/ui/screens/register_screen.dart';
import 'src/theme/app_colors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Basitçe AuthController'ı sağlıyoruz
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // ... Geri kalan build metodunuz aynı kalabilir ...
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zeytin Hastalık Tespit',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          background: AppColors.background,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
        ),
      ),
      initialRoute: OnboardingScreen.route,
      routes: {
        OnboardingScreen.route: (_) => const OnboardingScreen(),
        LoginScreen.route: (_) => const LoginScreen(),
        RegisterScreen.route: (_) => const RegisterScreen(),
        '/main': (_) => const MainShell(),
      },
    );
  }
}
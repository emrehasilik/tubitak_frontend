import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/auth/auth_controller.dart';
import 'src/auth/mock_auth_service.dart';
import 'src/ui/screens/onboarding_screen.dart';
import 'src/ui/screens/login_screen.dart';
import 'src/ui/screens/register_screen.dart';
import 'src/ui/screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => MockAuthService()),
        ChangeNotifierProxyProvider<MockAuthService, AuthController>(
          create: (context) => AuthController(context.read<MockAuthService>()),
          update: (context, service, controller) => controller!..service = service,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFFF5A1F); // turuncu
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zeytin Hastalık Tespit',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF4F4F4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      initialRoute: OnboardingScreen.route,
      routes: {
        OnboardingScreen.route: (_) => const OnboardingScreen(),
        LoginScreen.route: (_) => const LoginScreen(),
        RegisterScreen.route: (_) => const RegisterScreen(),
        HomeScreen.route: (_) => const HomeScreen(),
      },
    );
  }
}

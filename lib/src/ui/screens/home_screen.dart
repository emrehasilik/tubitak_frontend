import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/auth_controller.dart';
import 'onboarding_screen.dart';


class HomeScreen extends StatelessWidget {
  static const route = "/home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ana Sayfa"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthController>().logout();
              Navigator.pushNamedAndRemoveUntil(context, OnboardingScreen.route, (_) => false);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text(
          "Giriş başarılı ✅\n\nEmail: ${user?.email}\nRole: ${user?.role}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

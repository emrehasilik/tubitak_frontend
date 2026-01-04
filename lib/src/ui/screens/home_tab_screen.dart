import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../auth/auth_controller.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import '../widgets/auth_card.dart';
import '../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  static const route = "/login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: "user@test.com");
  final _pass = TextEditingController(text: "123456");
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthController>();
    final ok = await auth.login(_email.text, _pass.text);

    if (!mounted) return;

    if (ok) {
     Navigator.pushNamedAndRemoveUntil(
  context,
  '/main',
  (_) => false,
);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? "Giriş başarısız")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: AuthCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),

                      const Text(
                        "Giriş Yap",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Hoş geldiniz",
                        style: TextStyle(color: AppColors.textDark),
                      ),

                      const SizedBox(height: 18),

                      // E-posta
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "E-posta",
                        ),
                        validator: (v) {
                          final s = (v ?? "").trim();
                          if (s.isEmpty) return "E-posta gerekli";
                          if (!s.contains("@")) {
                            return "Geçerli bir e-posta giriniz";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Şifre
                      TextFormField(
                        controller: _pass,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: "Şifre",
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (v) =>
                            (v ?? "").length < 6
                                ? "Şifre en az 6 karakter olmalıdır"
                                : null,
                      ),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Deneme sürümünde şifre sıfırlama kapalıdır",
                                ),
                              ),
                            );
                          },
                          child: const Text("Şifremi unuttum"),
                        ),
                      ),

                      const SizedBox(height: 6),

                      PrimaryButton(
                        text: "Giriş Yap",
                        isLoading: auth.isLoading,
                        onPressed: _submit,
                      ),

                      const SizedBox(height: 10),

                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          RegisterScreen.route,
                        ),
                        child: const Text("Yeni hesap oluştur"),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "Demo: user@test.com / 123456",
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

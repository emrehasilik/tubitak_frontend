import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../auth/auth_controller.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import '../widgets/auth_card.dart';
import '../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  static const route = "/register";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _pass2 = TextEditingController();

  final _dob = TextEditingController();
  DateTime? _dobValue;

  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    _pass2.dispose();
    _dob.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: "Doğum Tarihini Seç",
      cancelText: "İptal",
      confirmText: "Seç",
    );

    if (picked != null) {
      _dobValue = picked;
      _dob.text =
          "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthController>();
    final ok = await auth.register(_email.text, _pass.text);

    if (!mounted) return;

    if (ok) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomeScreen.route,
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? "Kayıt başarısız")),
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
                        "Hesap Oluştur",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Uygulamayı kullanmak için hesap oluşturunuz.",
                        style: TextStyle(color: AppColors.textDark),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),

                      // E-posta
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(hintText: "E-posta"),
                        validator: (v) {
                          final s = (v ?? "").trim();
                          if (s.isEmpty) return "E-posta gerekli";
                          if (!s.contains("@")) return "Geçerli bir e-posta giriniz";
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Doğum Tarihi
                      TextFormField(
                        controller: _dob,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: "Doğum Tarihi",
                          suffixIcon: Icon(Icons.calendar_month),
                        ),
                        onTap: _pickDob,
                        validator: (_) =>
                            _dobValue == null ? "Doğum tarihi gerekli" : null,
                      ),
                      const SizedBox(height: 12),

                      // Şifre
                      TextFormField(
                        controller: _pass,
                        obscureText: _obscure,
                        decoration: const InputDecoration(hintText: "Şifre"),
                        validator: (v) => (v ?? "").length < 6
                            ? "Şifre en az 6 karakter olmalıdır"
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // Şifre tekrar
                      TextFormField(
                        controller: _pass2,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: "Şifre Tekrar",
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
                            v != _pass.text ? "Şifreler aynı değil" : null,
                      ),
                      const SizedBox(height: 18),

                      PrimaryButton(
                        text: "Kayıt Ol",
                        isLoading: auth.isLoading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 10),

                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          LoginScreen.route,
                        ),
                        child: const Text(
                          "Zaten hesabınız var mı?",
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 6),

                      const Text(
                        "Not: Rol otomatik olarak 'kullanıcı' atanır.",
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
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

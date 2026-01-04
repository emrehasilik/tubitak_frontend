import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  String? userId; // Kullanıcı ID'sini tutmak için

  // --- LOGIN (GİRİŞ) FONKSİYONU ---
  Future<bool> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    const url = "http://10.0.2.2:5188/api/UserControllers/login";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['isSuccess'] == true) {
          userId = data['result']['id']; // ID'yi hafızaya al
          
          // ID'yi telefona kalıcı kaydet
          final prefs = await SharedPreferences.getInstance();
          if (userId != null) {
            await prefs.setString('userId', userId!);
          }
          
          isLoading = false;
          notifyListeners();
          return true;
        } else {
          error = data['errorMessages']?.first ?? "Giriş başarısız";
        }
      } else {
        error = "Sunucu hatası: ${response.statusCode}";
      }
    } catch (e) {
      error = "Bağlantı hatası: $e";
    }

    isLoading = false;
    notifyListeners();
    return false;
  }

  // --- REGISTER (KAYIT OL) FONKSİYONU (Bunu eklememiştik) ---
  Future<bool> register({
    required String name,
    required String surname,
    required String email,
    required String password,
    required DateTime birthDate,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    // API Adresini kontrol et (Backend'deki endpoint ile aynı olmalı)
    const url = "http://10.0.2.2:5188/api/UserControllers/register";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "surname": surname,
          "email": email,
          "password": password,
          "birthDate": birthDate.toIso8601String(), // Tarihi string formatına çevir
        }),
      );

      // Başarılı olursa (200 OK)
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Backend yapına göre isSuccess kontrolü
        // Genelde kayıt sonrası true döner veya direkt login sayfasına atarız
        isLoading = false;
        notifyListeners();
        return true; 
      } else {
        // Hata mesajını yakala
        try {
           final data = jsonDecode(response.body);
           error = data['errorMessages']?.first ?? "Kayıt başarısız";
        } catch (_) {
           error = "Kayıt başarısız: ${response.statusCode}";
        }
      }
    } catch (e) {
      error = "Bağlantı hatası: $e";
    }

    isLoading = false;
    notifyListeners();
    return false;
  }
}
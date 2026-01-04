import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Android Emulator için: 10.0.2.2
  // iOS Simulator için: 127.0.0.1
  // Fiziksel Cihaz için: Bilgisayarınızın IP adresi (örn: 192.168.1.35)
  static const String _baseUrl = "http://10.0.2.2:5188/api/UserControllers";

  Future<bool> login({required String email, required String password}) async {
    final url = Uri.parse("$_baseUrl/login");
    
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // Başarılı giriş. 
        // Burada token dönüyorsa onu kaydedebilirsiniz.
        return true; 
      } else {
        throw Exception("Giriş başarısız: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Bağlantı hatası: $e");
    }
  }

  Future<bool> register({
    required String name,
    required String surname,
    required String email,
    required String password,
    required DateTime birthDate,
  }) async {
    final url = Uri.parse("$_baseUrl/create");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "surname": surname,
          "email": email,
          "password": password,
          // Backend ISO formatı (2026-01-03T...) bekliyor
          "birthDate": birthDate.toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        // Hata mesajını body'den okumayı deneyebiliriz
        throw Exception("Kayıt başarısız: ${response.body}");
      }
    } catch (e) {
      throw Exception("Kayıt hatası: $e");
    }
  }
}
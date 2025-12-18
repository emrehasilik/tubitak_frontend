class MockUser {
  final String id;
  final String email;
  final String role; // "user" | "admin"

  MockUser({required this.id, required this.email, required this.role});
}

class MockAuthService {
  // demo kullanıcı
  final Map<String, String> _passwordsByEmail = {
    "user@test.com": "123456",
  };

  final Map<String, MockUser> _usersByEmail = {
    "user@test.com": MockUser(id: "1", email: "user@test.com", role: "user"),
  };

  Future<MockUser> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final pass = _passwordsByEmail[email.trim().toLowerCase()];
    if (pass == null) {
      throw Exception("Kullanıcı bulunamadı");
    }
    if (pass != password) {
      throw Exception("Şifre yanlış");
    }
    return _usersByEmail[email.trim().toLowerCase()]!;
  }

  Future<MockUser> register({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final key = email.trim().toLowerCase();
    if (_usersByEmail.containsKey(key)) {
      throw Exception("Bu e-posta zaten kayıtlı");
    }

    final newUser = MockUser(id: DateTime.now().millisecondsSinceEpoch.toString(), email: key, role: "user");
    _usersByEmail[key] = newUser;
    _passwordsByEmail[key] = password;
    return newUser;
  }
}

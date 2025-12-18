import 'package:flutter/foundation.dart';
import 'mock_auth_service.dart';

class AuthController extends ChangeNotifier {
  MockAuthService service;
  AuthController(this.service);

  MockUser? currentUser;
  bool isLoading = false;
  String? error;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      currentUser = await service.login(email: email, password: password);
      return true;
    } catch (e) {
      error = e.toString().replaceFirst("Exception: ", "");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      currentUser = await service.register(email: email, password: password);
      return true;
    } catch (e) {
      error = e.toString().replaceFirst("Exception: ", "");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }
}

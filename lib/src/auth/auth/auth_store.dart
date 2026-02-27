import 'package:flutter/foundation.dart';
import 'package:my_library/src/auth/auth/auth_service.dart';

class AuthStore extends ChangeNotifier {
  final _authService = AuthService();
  bool loading = false;
  LoginStatus? loginStatus;

  Future<void> loginWithGoogle() async {
    loading = true;
    notifyListeners();

    loginStatus = await _authService.signInWithGoogle();

    loading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
    notifyListeners();
  }
}

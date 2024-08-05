import 'package:flutter/cupertino.dart';

import 'auth_service.dart';

class AuthStore extends ChangeNotifier {
  final _authService = AuthService();
  AuthStatus authStatus = AuthStatus.unLogged;

  Future login() async {
    await _authService.signInWithGoogle().then((user) {
      if (user != null) {
        authStatus = AuthStatus.logged;
        notifyListeners();
      } else {
        authStatus = AuthStatus.unLogged;
        notifyListeners();
      }
    });
  }
}

enum AuthStatus { logged, unLogged }

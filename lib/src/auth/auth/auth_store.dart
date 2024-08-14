import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_library/src/database_ops/db_operations.dart';
import 'package:my_library/src/models/user_model.dart';

import 'auth_service.dart';

class AuthStore extends ChangeNotifier {
  final _authService = AuthService();
  UserModel? currentUser;
  final db = DataBaseOperations();
  CreationAccountStatus? creationAccountStatus;
  LoginStatus? loginStatus;
  bool loading = false;

  Future createUser() async {
    loading = true;
    notifyListeners();
    creationAccountStatus = await _authService.createAccount(
      email: emailController.text,
      password: passwordController.text,
    );
    loading = false;
    notifyListeners();
  }

  Future login() async {
    loading = true;
    notifyListeners();
    loginStatus = await _authService.login(
      email: emailController.text,
      password: passwordController.text,
    );
    loading = false;
    notifyListeners();
  }

  Future resetPassword() async {
    await _authService.resetPassword(email: emailController.text);
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final retypePasswordController = TextEditingController();
}

enum AuthStatus { logged, unLogged }

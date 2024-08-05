import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_library/src/database_ops/db_operations.dart';
import 'package:my_library/src/models/user_model.dart';
import 'package:my_library/src/utils/app_strings.dart';

import 'auth_service.dart';

class AuthStore extends ChangeNotifier {
  final _authService = AuthService();
  AuthStatus authStatus = AuthStatus.unLogged;
  UserModel? currentUser;
  final db = DataBaseOperations();

  Future login() async {
    await _authService.signInWithGoogle().then((user) {
      getProfile(user.user!);
    });
  }

  Future getProfile(User user) async {
    final result = await db.getOneData(AppStrings.userTable, user.uid);
    if (result != null) {
      currentUser = UserModel.fromJson(result);
      authStatus = AuthStatus.logged;
      notifyListeners();
    } else {
      await saveProfile(user);
    }
  }

  Future saveProfile(User user) async {
    currentUser = UserModel(
      id: user.uid,
      name: user.displayName ?? "",
      photo: user.photoURL ?? "",
    );
    await db.insertData(currentUser!, AppStrings.userTable);
    authStatus = AuthStatus.logged;
    notifyListeners();
  }
}

enum AuthStatus { logged, unLogged }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_library/src/database_ops/db_operations.dart';
import 'package:my_library/src/models/user_model.dart';
import 'package:my_library/src/utils/app_strings.dart';

class AuthService {
  Future<CreationAccountStatus> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseAuth.instance.setLanguageCode("pt-BR");
      await credential.user?.sendEmailVerification();

      final db = DataBaseOperations();

      await db.insertData(
        UserModel(
          id: credential.user!.uid,
          name: credential.user!.displayName ?? "",
          photo: credential.user!.photoURL ?? "",
        ),
        AppStrings.userTable,
      );

      final savedUser = await db.getOneData(
        AppStrings.userTable,
        credential.user!.uid,
      );

      if (savedUser != null) {
        await db.updateData(
          UserModel(
            id: credential.user!.uid,
            name: credential.user!.displayName ?? "",
            photo: credential.user!.photoURL ?? "",
          ),
          AppStrings.userTable,
          credential.user!.uid,
        );
      } else {
        await db.insertData(
          UserModel(
            id: credential.user!.uid,
            name: credential.user!.displayName ?? "",
            photo: credential.user!.photoURL ?? "",
          ),
          AppStrings.userTable,
        );
      }

      return CreationAccountStatus.created;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return CreationAccountStatus.passwordWeak;
      } else if (e.code == 'email-already-in-use') {
        return CreationAccountStatus.alreadyExists;
      }
    } catch (e) {
      return CreationAccountStatus.genericError;
    }
    return CreationAccountStatus.genericError;
  }

  Future<LoginStatus> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final db = DataBaseOperations();

      final savedUser = await db.getOneData(
        AppStrings.userTable,
        credential.user!.uid,
      );

      if (savedUser != null) {
        await db.updateData(
          UserModel(
            id: credential.user!.uid,
            name: credential.user!.displayName ?? "",
            photo: credential.user!.photoURL ?? "",
          ),
          AppStrings.userTable,
          credential.user!.uid,
        );
      } else {
        await db.insertData(
          UserModel(
            id: credential.user!.uid,
            name: credential.user!.displayName ?? "",
            photo: credential.user!.photoURL ?? "",
          ),
          AppStrings.userTable,
        );
      }

      return LoginStatus.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return LoginStatus.userNotFound;
      } else if (e.code == 'wrong-password') {
        return LoginStatus.wrongPassword;
      }
    }
    return LoginStatus.genericError;
  }

  Future resetPassword({required String email}) async {
    await FirebaseAuth.instance.setLanguageCode("pt-BR");
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
  }

  Future deleteUser({
    required String email,
    required String password,
  }) async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.delete();
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

enum CreationAccountStatus {
  created,
  passwordWeak,
  alreadyExists,
  genericError,
}

enum LoginStatus {
  success,
  userNotFound,
  wrongPassword,
  genericError,
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hasura_connect/hasura_connect.dart';

class AuthService {
  bool isAuthorized = false;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final hasuraConnect = HasuraConnect(
      'https://ethical-sculpin-58.hasura.app/v1/graphql',
      headers: {
        'Authorization': 'Bearer ${googleAuth!.accessToken}',
      },
    );

    print(hasuraConnect.isConnected);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

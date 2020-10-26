import 'package:firebase_auth/firebase_auth.dart';

class FlutterFireAuthService {
  final FirebaseAuth _firebaseAuth;
  TwitterAuthProvider twitterProvider = TwitterAuthProvider();

  FlutterFireAuthService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential> twitterSignIn() async {
    return await FirebaseAuth.instance.signInWithPopup(twitterProvider);
  }
}

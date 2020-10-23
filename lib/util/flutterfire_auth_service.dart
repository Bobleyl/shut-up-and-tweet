import 'package:firebase_auth/firebase_auth.dart';

class FlutterFireAuthService {
  final FirebaseAuth _firebaseAuth;
  TwitterAuthProvider twitterProvider = TwitterAuthProvider();

  FlutterFireAuthService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  /// This won't pop routes so you could do something like
  /// Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  /// after you called this method if you want to pop all routes.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential> twitterSignIn() async {
    return await FirebaseAuth.instance.signInWithPopup(twitterProvider);
  }
}

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<bool> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    notifyListeners();
  }

  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Google login error: $e');
      return false;
    }
  }

  Future<bool> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        await _firebaseAuth.signInWithCredential(credential);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Facebook login error: $e');
      return false;
    }
  }

  // Optional: registration
  Future<bool> register(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Registration error: $e');
      return false;
    }
  }

  // Password reset
  Future<void> sendPasswordReset(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      debugPrint('Password reset error: $e');
    }
  }
}

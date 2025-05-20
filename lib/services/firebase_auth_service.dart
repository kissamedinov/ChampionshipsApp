import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:io' show Platform;

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Email & Password Login
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print('Email sign-in error: $e');
      return null;
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: Platform.isAndroid || Platform.isIOS
            ? null
            : 'project-489851484529.apps.googleusercontent.com', // Используй Web Client ID
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      print('Google sign-in error: $e');
      return null;
    }
  }

  // Facebook Login
  Future<User?> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) return null;

      final credential = FacebookAuthProvider.credential(result.accessToken!.token);
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Facebook sign-in error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  User? get currentUser => _auth.currentUser;
}

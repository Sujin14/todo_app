import 'package:firebase_auth/firebase_auth.dart';

// Service class for handling authentication with Firebase.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream of user authentication state changes.
  Stream<User?> get user => _auth.authStateChanges();

  // Signs in user with email and password.
  Future<User?> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user;
    } catch (e) {
      throw Exception('Sign-in failed: ${e.toString()}');
    }
  }

  // Registers a new user with email and password.
  Future<User?> register(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user;
    } catch (e) {
      throw Exception('Sign-in failed: ${e.toString()}');
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  // Sends password reset email.
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  // Signs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
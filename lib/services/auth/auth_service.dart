import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // get instance of firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // sign in
  Future<UserCredential> signIn(String email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleSignInError(e.code);
      return Future.error(errorMessage);
    }
  }

  // sign up
  Future<UserCredential> signUp(String email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleSignInError(e.code);
      return Future.error(errorMessage);
    }
  }

  // sign out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<void> updateEmail(String email) async {
    return await _firebaseAuth.currentUser!.verifyBeforeUpdateEmail(email);
  }

  Future<void> updatePassword(String password) async {
    return await _firebaseAuth.currentUser!.updatePassword(password);
  }

  Future<void> deleteUser() async {
    await _firebaseAuth.currentUser!.delete();
  }

  String _handleSignInError(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'User account has been disabled.';
      case 'user-not-found':
        return 'User not found.';
      case 'wrong-password':
        return 'Invalid password.';
      default:
        return 'Sign in failed. Please try again later.';
    }
  }
}

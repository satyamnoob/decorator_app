import 'package:firebase_auth/firebase_auth.dart';

import '../models/my_user.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  //Stream to notify changes about user login, register or signout
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //Converting firebase user to custom user
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // Register User With Email and Password
  Future<dynamic> registerUser(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  // Sign In User With Email and Password
  Future<dynamic> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
  }

  //Sign Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("Something Went Wrong");
      return null;
    }
  }
}

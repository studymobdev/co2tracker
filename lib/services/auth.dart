import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/myuser.dart';
import 'package:flutter_application_1/services/database.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User1? _userFromFirebase(User? user1) {
    return user1 != null ? User1(uid: user1.uid) : null;
  }

  Stream<User1?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebase(user));
  }

  Future signInAnon() async {
    try {
      UserCredential userCredentials = await _auth.signInAnonymously();
      User user = userCredentials.user!;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;

      await Database(uid: user.uid).updUsersData('', email, 100, '',
          0.0, '', [0.68, 0.68, 0.70, 0.75], [], ['', '', ''], '', 0, []);

      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}

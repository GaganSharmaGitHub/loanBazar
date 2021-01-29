import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loan_bazaar/firebase/user.dart';
import 'package:loan_bazaar/models/MyExUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef StrFunc(String params);

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth get auth => _auth;
//extract uid
  MyUser _getUser(User user) {
    return user == null ? null : MyUser(uid: user.uid);
  }

  //user stream
  Stream<MyUser> get user {
    return _auth.authStateChanges().map((event) => _getUser(event));
  }

  //delete user
  Future deleteUser() async {
    try {
      User user = _auth.currentUser;
      await _getUser(user).deleteUserData();
      await user.delete();
    } catch (e) {
      return e.message;
    }
  }

  //changepwd
  Future changepwd({String newPassword}) async {
    try {
      User user = _auth.currentUser;
      await user.updatePassword(newPassword);
    } catch (e) {
      return e.message;
    }
  }

  //change mail
  Future changeEmail({String newEmail}) async {
    try {
      User user = _auth.currentUser;
      await user.updateEmail(newEmail);
    } catch (e) {
      return e.message;
    }
  }

//return basic
  User retUser() {
    User user = _auth.currentUser;
    return user;
  }

  Future setSp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('userLoggedIn', true);
  }

  //Sign out
  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  authCredsFromAuto(PhoneAuthCredential creds) => PhoneAuthProvider.credential(
      verificationId: creds.verificationId, smsCode: creds.smsCode);
  authCredsManual({String verif, String sms}) =>
      PhoneAuthProvider.credential(verificationId: verif, smsCode: sms);

//google sign in
  Future googleSignIN() async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      if (account == null) return;
      GoogleSignInAuthentication authenticatio = await account.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: authenticatio.accessToken,
          idToken: authenticatio.idToken);
      UserCredential user = await _auth.signInWithCredential(credential);
      await setSp();
      return _getUser(user.user);
    } catch (e) {
      if (e is String) {
        return '$e';
      }

      if (e is FirebaseException) {
        return '${e.message}';
      }
      return '$e';
    }
  }

  //SIGN IN
  Future signInEmailPass({String email, String password}) async {
    try {
      if (email == null || email == '') {
        throw 'Enter email';
      }
      if (password == '' || password == null) {
        throw 'Enter password';
      }

      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await setSp();
      return _getUser(user);
    } catch (e) {
      if (e is String) {
        return '$e';
      }

      if (e is FirebaseException) {
        return '${e.message}';
      }
      return '$e';
    }
  }

  //forgot password
  Future forgotPassword(String email) async {
    try {
      var res = await _auth.sendPasswordResetEmail(email: email);
      return res;
    } catch (e) {
      return e.message;
    }
  }

  //new user
  Future newUserCreate({email, password, ExUser info}) async {
    try {
      if (email == null || email == '') {
        throw 'Enter email';
      }
      if (password == '' || password == null) {
        throw 'Enter password';
      }
      if (info?.name == '' || info?.name == null) {
        throw 'Enter name';
      }
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      MyUser myUser = _getUser(user);
      await myUser.createUserData(info);
      await setSp();
      return myUser;
    } catch (e) {
      if (e is String) {
        return '$e';
      }

      if (e is FirebaseException) {
        return '${e.message}';
      }
      return '$e';
    }
  }
}

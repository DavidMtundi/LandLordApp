import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landlord/screens/dashboard/dashboard_screen.dart';

import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sighn in anonymously
  Future signinAnon() async {
    try {
      // AuthResult result = await _auth.signInAnonymously();
      // FirebaseUser user = result.user;
      // return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text.toString()));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  //phone number authentication related thing

  Future<void> verifyPhoneNumber(
      BuildContext context, String phoneNumber, Function setData) async {
    // ignore: prefer_function_declarations_over_variables
    PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };
    // ignore: prefer_function_declarations_over_variables
    PhoneVerificationFailed verificationFailed = (Exception exception) {
      showSnackBar(context, exception.toString());
    };
    // ignore: prefer_function_declarations_over_variables
    void Function(String verificationId, [int? foreceResendingToken]) codeSent =
        (String verificationId, [int? forceResendingToken]) {
      showSnackBar(context, "verification code sent on the phone number");
      setData(verificationId);
    };
    // ignore: prefer_function_declarations_over_variables
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      showSnackBar(context, "timeout");
    };
    //try {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    //} catch (e) {
    //  showSnackBar(context, e.toString());
    //}
  }

  Future signinEmailPass(String email, String password) async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> signinwithphoneNumber(String countrycode, String phone,
      String verificationId, String smscode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smscode);
      UserCredential user = await _auth.signInWithCredential(credential);
      // setState(() {
      // pr.hide();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
        //     );
        //}
      );
    } catch (e) {
      showSnackBar(context,
          "Unknown Error, Please Try checking Your Internet Connection");
    }
  }
}

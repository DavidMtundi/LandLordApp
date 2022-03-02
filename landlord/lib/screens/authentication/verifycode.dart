import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landlord/screens/dashboard/dashboard_screen.dart';
import 'package:landlord/services/auth.dart';
import 'package:landlord/utils/Codeinput.dart';
import 'package:landlord/utils/progressdialog.dart';

class Verifycode extends StatefulWidget {
  final String phone;
  final String countryCode;
  final int screen;
  const Verifycode(
      {Key? key,
      required this.phone,
      required this.screen,
      required this.countryCode})
      : super(key: key);

  @override
  _VerifycodeState createState() => _VerifycodeState();
}

class _VerifycodeState extends State<Verifycode> {
  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPController = new TextEditingController();
  String verificationid = "";
  String smscode = "";
  String verificationcode = "";
  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    authService.verifyPhoneNumber(
        context, widget.countryCode + widget.phone, setData);

    // verifyPhone();
    // startTimer();
  }

  verifyPhone() async {
    print("phone sent");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.countryCode + widget.phone,
        verificationCompleted: (credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) {
            if (value.user != null) {
              //   pr.show();

              //save the person to the database
              Future.delayed(const Duration(milliseconds: 1500), () {
                // if (widget.screen.toInt() == 1) {
                Route route =
                    MaterialPageRoute(builder: (c) => DashboardScreen());
                Navigator.pushReplacement(context, route);
              });
            }
          });
        },
        verificationFailed: (Exception e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 3),
          ));
        },
        codeSent: (String vID, int? value) {
          setState(() {
            verificationcode = vID;
          });
          startTimer();
        },
        codeAutoRetrievalTimeout: (String vID) {
          setState(() {
            verificationcode = vID;
            verificationid = vID;
          });
        },
        timeout: const Duration(seconds: 60));
  }

  int start = 30;
  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => verifyPhone()),
          );
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  void setData(verificationidFinal) {
    setState(() {
      verificationid = verificationidFinal;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage('Verifying account...');
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 96.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text("Phone Verification",
                      style: Theme.of(context).textTheme.headline6),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text("To Number  +254${widget.phone.toString()}",
                      style: Theme.of(context).textTheme.headline6),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 48.0),
                  child: Text(
                    "Enter your code here",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 64.0),
                  child: CodeInput(
                    inputFormatters: [],
                    focusNode: FocusNode(),
                    onChanged: onchanged,
                    length: 6,
                    keyboardType: TextInputType.number,
                    builder: CodeInputBuilders.darkCircle(
                        totalRadius: 30, emptyRadius: 20, filledRadius: 26),
                    onFilled: (value) async {
                      print('Your input is $value.');
                      setState(() {
                        smscode = value;
                      });
                      try {
                        authService.signinwithphoneNumber(widget.countryCode,
                            widget.phone, verificationid, smscode, context);
                      } catch (e) {
                        // CodeInput.
                      }
/*
                      //verify the value
                      try {
                        await FirebaseAuth.instance
                            .signInWithCredential(
                                PhoneAuthProvider.getCredential(
                                    verificationId: verificationcode,
                                    smsCode: value))
                            .then((value) {
                          if (value.user != null) {
                            pr.show();

                            //save the person to the database
                           
                          }
                        });
                      } catch (e) {
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Invalid OTP"),
                          duration: Duration(seconds: 3),
                        ));
                      }*/
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text("Fill the OTP in $start seconds",
                      style: Theme.of(context).textTheme.subtitle2),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "Didn't  receive any code?",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    authService.verifyPhoneNumber(
                        context, widget.countryCode + widget.phone, setData)
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "Resend new code",
                      style: TextStyle(
                        fontSize: 19,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onchanged(String value) {}
}

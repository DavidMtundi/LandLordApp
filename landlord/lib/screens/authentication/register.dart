import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landlord/properties/Landlordapp.dart';
import 'package:landlord/screens/authentication/login.dart';
import 'package:landlord/screens/dashboard/dashboard_screen.dart';
import 'package:landlord/utils/progressdialog.dart';
import 'package:landlord/widgets/editText.dart';
import 'package:landlord/widgets/submitbutton.dart';

import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String errortext = "";

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    TextEditingController _controllername = TextEditingController();
    TextEditingController _controllersurname = TextEditingController();
    TextEditingController _controllerphone = TextEditingController();

    TextEditingController _controlleremail = TextEditingController();

    TextEditingController _controllerpassword = TextEditingController();

    TextEditingController _controllerconfirmpassword = TextEditingController();
    final progressDialog = ProgressDialog(context, ProgressDialogType.Normal);
    progressDialog.setMessage('Checking details.');

    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    Future saveUserInfotoFirestore(User fuser) async {
      FirebaseFirestore.instance.collection("users").doc(fuser.uid).set({
        "uid": fuser.uid,
        "email": fuser.email,
        LandlordApp.userPhotoUrl: "",
        LandlordApp.usercartList: [""],
        LandlordApp.userphone: _controllerphone.value.text.trim(),
        "name": _controllername.value.text.trim(),
      });
      await LandlordApp.preferences!.setString(LandlordApp.userUID, fuser.uid);
      //  await LandlordApp.preferences!.setString(LandlordApp.isuser, "1");

      await LandlordApp.preferences!
          .setString(LandlordApp.userEmail, fuser.email!);
      await LandlordApp.preferences!
          .setString(LandlordApp.userName, _controllername.text.trim());
      await LandlordApp.preferences!.setString(LandlordApp.userPhotoUrl, "");
      await LandlordApp.preferences!
          .setString(LandlordApp.userphone, _controllerphone.value.text.trim());
      await LandlordApp.preferences!
          .setStringList(LandlordApp.usercartList, ["garbageValue"]);
      await LandlordApp.preferences!
          .setStringList(LandlordApp.usercartList, [""]);
    }

    Future<void> _registeruser() async {
      String email = _controlleremail.value.text.trim();

      String password = _controllerpassword.value.text.trim();
      String confirmpassword = _controllerconfirmpassword.text.trim();

      if (password != confirmpassword) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Password Mismatch")));

        //tell the user to please enter the correct passwrods, passwords that are same

      } else {
        setState(() {
          progressDialog.show();
        });
        User? user;
        try {
          await _auth
              .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
              .then((auth) {
            user = _auth.currentUser!;
          });
          //user = _auth.currentUser;
        } on FirebaseAuthException catch (error) {
          setState(() {
            progressDialog.hide();
            errortext = error.message!;
          });
          errortext = error.message!;
        }
        //

        if (user != null) {
          progressDialog.hide();
          saveUserInfotoFirestore(user!).then((value) {
            Navigator.pop(context);
            Route route = MaterialPageRoute(builder: (c) => DashboardScreen());
            Navigator.pushReplacement(context, route);
            // Route route = MaterialPageRoute(
            //     builder: (_) => VerifyScreeen(
            //           screen: 2,
            //           phoneNumber: _controllerphone.text.trim(),
            //         ));
            Navigator.pushReplacement(context, route);
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: FractionalOffset(0, 0),
              end: FractionalOffset(1, 0),
              stops: [0, 1],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text("Registration Page"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Welcome",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                    child: Divider(
                      thickness: 4,
                      color: Colors.greenAccent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Text(
                      "Register account",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  errortext != ""
                      ? Padding(
                          padding:
                              const EdgeInsets.only(left: 20, bottom: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  errortext,
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  EditText(
                    title: "User Name",
                    textEditingController: _controllername,
                  ),
                  EditText(
                    inputType: TextInputType.number,
                    title: "phone",
                    formvalidator: validatephone,
                    textEditingController: _controllerphone,
                  ),
                  EditText(
                    title: "Email",
                    inputType: TextInputType.emailAddress,
                    textEditingController: _controlleremail,
                    formvalidator: validateemail,
                  ),
                  EditText(
                    title: "Password",
                    isPassword: true,
                    formvalidator: validatepassword,
                    textEditingController: _controllerpassword,
                  ),
                  EditText(
                    title: "Confirm Password",
                    isPassword: true,
                    textEditingController: _controllerconfirmpassword,
                  ),
                  SubmitButton(
                    title: "Register",
                    act: () async {
                      // await _registeruser();
                      if (_formkey.currentState!.validate()) {
                        _registeruser();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 60,
                    child: Divider(
                      thickness: 4,
                      color: Colors.greenAccent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Already exist account? ",
                          style: TextStyle(fontSize: 17),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminLoginScreen()),
                            );
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // }
}

String? validateemail(String? email) {
  if ((email == null) || (email == "")) return "E-mail Address is required";
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  if (!emailValid) return "Invalid email Format";

  return null;
}

String? validatepassword(String? password) {
  if ((password == null) || (password == "")) return "Password is required";

  if (password.length < 6) return "Password Length Must be >6";

  return null;
}

String? validatephone(String? phone) {
  if ((phone == null) || (phone == "")) return "Phone is required";

  if (phone.length < 10) return "Phone Length Must be >9";

  return null;
}

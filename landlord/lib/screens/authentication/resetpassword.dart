import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landlord/constants.dart';
import 'package:landlord/screens/authentication/register.dart';
import 'package:landlord/utils/progressdialog.dart';
import 'package:landlord/widgets/editText.dart';
import 'package:landlord/widgets/submitbutton.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ResetPassword> {
  final TextEditingController _controllerusername = TextEditingController();e
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String buttontext = "Reset Password";
  final TextEditingController _controllerpassword = TextEditingController();
  String errortext = "";
  // final AuthentificationService _authservice = AuthentificationService();
  @override
  Widget build(BuildContext context) {
    final progressDialog = ProgressDialog(context, ProgressDialogType.Normal);
    progressDialog.setMessage('Resetting ...');

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
        title: const Text("Reset Password Screen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text("Welcome", style: Theme.of(context).textTheme.headline5),
              const SizedBox(
                height: 60,
                child: Divider(
                  thickness: 4,
                  color: Colors.greenAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text("Reset Email Password",
                    style: Theme.of(context).textTheme.subtitle1),
              ),
              errortext != ""
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.red,
                          ),
                          Flexible(
                            child: Text(errortext,
                                style: TextStyle(
                                    color: Theme.of(context).errorColor)),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              EditText(
                title: "Enter your Email",
                formvalidator: validateemail,
                inputType: TextInputType.emailAddress,
                textEditingController: _controllerusername,
              ),
              SubmitButton(
                title: buttontext,
                act: () async {
                  bool validate = true;
                  if (validate) {
                    try {
                      await _auth.sendPasswordResetEmail(
                          email: _controllerusername.value.text.trim());
                      Navigator.of(context);
                    } on FirebaseException catch (e) {
                      setState(() {
                        errortext = e.message.toString();
                      });
                    }
                  }
                },
              ),
              Column(
                children: [
                  SizedBox(
                    height: CustomHeight(context, 30),
                  ),
                  SizedBox(
                    height: CustomHeight(context, 60),
                    child: Divider(
                      thickness: 4,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  sendpasswordreset() async {}
}

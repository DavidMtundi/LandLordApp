import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landlord/properties/Landlordapp.dart';
import 'package:landlord/screens/authentication/register.dart';
import 'package:landlord/screens/authentication/resetpassword.dart';
import 'package:landlord/screens/dashboard/dashboard_screen.dart';
import 'package:landlord/utils/progressdialog.dart';
import 'package:landlord/widgets/editText.dart';
import 'package:landlord/widgets/submitbutton.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _controllerusername = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _controllerpassword = TextEditingController();
  // final AuthentificationService _authservice = AuthentificationService();
  bool emailvalid = false;

  Future readAdminData(User firebaseuser) async {
    FirebaseFirestore.instance
        .collection("admins")
        .doc(firebaseuser.uid)
        .get()
        .then((datasnapshot) async {
      // await LandlordApp.preferences!.setString(LandlordApp.isuser, '2');

      await LandlordApp.preferences!.setString(
          LandlordApp.userUID, datasnapshot.data()![LandlordApp.userUID]);
      await LandlordApp.preferences!.setString(
          LandlordApp.userphone, datasnapshot.data()![LandlordApp.userphone]);
      await LandlordApp.preferences!.setString(
          LandlordApp.userEmail, datasnapshot.data()![LandlordApp.userEmail]);
      await LandlordApp.preferences!.setString(
          LandlordApp.userName, datasnapshot.data()![LandlordApp.userName]);

      List<String> cartList =
          datasnapshot.data()![LandlordApp.usercartList].cast<String>();
      await LandlordApp.preferences!
          .setStringList(LandlordApp.usercartList, cartList);
    });
  }

  String errortext = "";

  @override
  Widget build(BuildContext context) {
    final progressDialog = ProgressDialog(context, ProgressDialogType.Normal);
    progressDialog.setMessage('Logging in...');

    FirebaseAuth auth = FirebaseAuth.instance;
    late User user;
    Future<bool> validateAdmin(String userid, String checkemail) async {
      try {
        // Get reference to Firestore collection
        var collectionRef = FirebaseFirestore.instance.collection('admins');

        var doc = await collectionRef.doc(userid).get();
        emailvalid = doc.exists;
        return doc.exists;
      } catch (e) {
        emailvalid = false;
        setState(() {
          errortext =
              "Incorrect username and Password, if the problem persists, try logging in as a user";
        });
        throw e;
        //return false;
      }
    }

    Future<void> allowadminlogin(String email, String password) async {
      try {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((authUser) {
          user = authUser.user!;
        }).then((value) =>
                validateAdmin(user.uid, _controllerusername.value.text.trim()));
      } on FirebaseAuthException catch (error) {
        setState(() {
          progressDialog.hide();
          errortext = error.message!;
        });
        errortext = error.message!;
      }

      if (emailvalid) {
        readAdminData(user).then((value) {
          progressDialog.hide();
          Route route =
              MaterialPageRoute(builder: (context) => DashboardScreen());
          Navigator.pushReplacement(context, route);
        });
      } else {
        progressDialog.hide();
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
        title: Text("Seller Login Screen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Text("Welcome Dear Seller",
                style: Theme.of(context).textTheme.headline5),
            const SizedBox(
              height: 60,
              child: Divider(
                thickness: 4,
                color: Colors.greenAccent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(" Login to your account",
                  style: Theme.of(context).textTheme.subtitle1),
            ),
            errortext != ""
                ? Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 20.0),
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
                            style:
                                TextStyle(color: Theme.of(context).errorColor),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            EditText(
              title: "email address",
              formvalidator: validateemail,
              inputType: TextInputType.emailAddress,
              textEditingController: _controllerusername,
            ),
            EditText(
              title: "Password",
              isPassword: true,
              textEditingController: _controllerpassword,
            ),
            SubmitButton(
              title: "Seller Login",
              act: () async {
                bool validate = true;
                if (validate) {
                  progressDialog.show();
                  //check to find if the user is in the database and log in
                  // ignore: await_only_futures
                  await allowadminlogin(_controllerusername.value.text.trim(),
                      _controllerpassword.value.text.trim());
                }
              },
            ),
            Padding(
              padding: EdgeInsets.all(32.0),
              child: InkWell(
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => ResetPassword());
                    Navigator.push(context, route);
                  },
                  child: Text("Forgot your password?")),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Don't have an account?  ",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 17),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ]),
        ),
      ),
    );
  }
}

import 'package:chat_app/service/firebase.dart';
import 'package:chat_app/views/login/login_view.dart';
import 'package:chat_app/views/widget/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/textstyles.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  var emailcontroller = TextEditingController();
  var pwdcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          //to avoid scrollable action
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Text("Signup Page", style: MyTextThemes.textHeading),
                const SizedBox(
                  height: 15,
                ),
                Text("Register", style: MyTextThemes.bodyTextStyle),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: emailcontroller,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_outlined),
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    hintText: 'Enter your email here',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: pwdcontroller,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password_outlined),
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: 'Enter your password here',
                    helperText:
                        'Password must contain upper and lowercase letters',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                MaterialButton(
                  onPressed: () async {
                    try {
                      //Firebase signup
                      UserCredential? userCredential = await FirebaseFunctions()
                          .signUpUser(
                              email: emailcontroller.text,
                              pwd: pwdcontroller.text);
                      print('${FirebaseAuth.instance.currentUser?.email}');
                      final user=userCredential?.user;
                      if (user != null) {
                        var userid=user.uid;
                        //Adding to database
                        FirebaseFunctions().fireUserAdd(id: userid,email: user.email!);
                        msgSnackbar(context, 'Registered');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginView()),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      msgSnackbar(context, e.message!);
                      print(e);
                    }msgSnackbar(context, 'try again');
                  },
                  color: MyColors.buttonColors,
                  minWidth: 200,
                  shape: const StadiumBorder(),
                  child: const Text("Signup"),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: "have an account",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginView()));
                          },
                        text: " login",
                        style: MyTextThemes.bodyTextStyle,
                      )
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                // Adding space at the bottom (20% of screen height)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

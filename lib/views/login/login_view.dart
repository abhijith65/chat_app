import 'package:chat_app/service/firebase.dart';
import 'package:chat_app/views/home/home_view.dart';
import 'package:chat_app/views/signup/signup_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/textstyles.dart';
import '../widget/snackbar.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var emailcontroller = TextEditingController();
  var pwdcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
    pwdcontroller.dispose();
  }

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
                const SizedBox(height: 50), // Adding space at the top
                Text("Login Page", style: MyTextThemes.textHeading),
                const SizedBox(
                  height: 15,
                ),
                Text("Login To Your Account",
                    style: MyTextThemes.bodyTextStyle),
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
                  obscureText: true,
                  obscuringCharacter: '*',
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
                      //Firebase login
                      var logged = await FirebaseFunctions().logInUser(email: emailcontroller.text, pwd: pwdcontroller.text);
                      String? id=FirebaseAuth.instance.currentUser?.uid;
                      print('uid is ${id}');

                      if (logged == null) {
                        msgSnackbar(context, 'loggedIn');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeView(id)),
                        );
                      }else{
                        msgSnackbar(context, '$logged');
                      }
                    } on FirebaseAuthException catch (e) {
                      msgSnackbar(context, e.message!);
                      print(e);
                    }
                  },
                  color: MyColors.buttonColors,
                  minWidth: 200,
                  shape: const StadiumBorder(),
                  child: const Text("Login"),
                ),
                const SizedBox(height: 20), // Adjusted spacer
                RichText(
                  text: TextSpan(
                    text: "Not a User?",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SignupView()));
                          },
                        text: " SignUp",
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

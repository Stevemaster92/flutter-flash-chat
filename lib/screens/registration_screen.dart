import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/components/rounded_text_field.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String ROUTE = "/register";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email, password;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;

  void submit() async {
    setState(() {
      _loading = true;
    });

    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user != null) {
        Navigator.pushNamed(context, ChatScreen.ROUTE);
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: kTagLogo,
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(height: 48.0),
              RoundedTextField(
                keyboardType: TextInputType.emailAddress,
                hintText: "Enter your email",
                borderColor: Colors.blueAccent,
                onChanged: (value) => email = value,
              ),
              SizedBox(height: 8.0),
              RoundedTextField(
                obscureText: true,
                hintText: "Enter your password",
                borderColor: Colors.blueAccent,
                onChanged: (value) => password = value,
                onSubmitted: (value) => submit(),
              ),
              SizedBox(height: 24.0),
              RoundedButton(
                color: Colors.blueAccent,
                title: "Register",
                onPressed: submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

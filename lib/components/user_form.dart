import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/components/rounded_text_field.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class UserForm extends StatefulWidget {
  final bool isLogin;

  UserForm({@required this.isLogin});

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email, password, _errorMessage = "";
  bool _loading = false;

  getErrorMessage(String code) {
    switch (code) {
      case "email-already-in-use":
        return "The given email address is already in use.";
      case "weak-password":
        return "The password must be at least 6 characters long.";
      case "invalid-email":
        return "The given email address is invalid.";
      case "user-not-found":
        return "No user corresponding to the given email address found.";
      case "wrong-password":
        return "The given password is invalid.";
      case "operation-not-allowed":
        return "Email/password accounts are currently not enabled for this app.";
      default:
        return "${widget.isLogin ? "Login" : "Registration"} failed. Please try again.";
    }
  }

  void submit() async {
    setState(() {
      _loading = true;
      _errorMessage = "";
    });

    try {
      UserCredential user;
      // Login user.
      if (widget.isLogin) {
        user = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // Register new user.
        user = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      // Redirect user to the chat screen.
      if (user != null) {
        Navigator.pushNamed(context, ChatScreen.ROUTE);
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = getErrorMessage(e.code);
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
                borderColor:
                    widget.isLogin ? Colors.lightBlueAccent : Colors.blueAccent,
                onChanged: (value) => email = value,
              ),
              SizedBox(height: 8.0),
              RoundedTextField(
                obscureText: true,
                hintText: "Enter your password",
                borderColor:
                    widget.isLogin ? Colors.lightBlueAccent : Colors.blueAccent,
                onChanged: (value) => password = value,
                onSubmitted: (value) => submit(),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
              ),
              SizedBox(height: 24.0),
              RoundedButton(
                color:
                    widget.isLogin ? Colors.lightBlueAccent : Colors.blueAccent,
                title: widget.isLogin ? "Login" : "Register",
                onPressed: submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

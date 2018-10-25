import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  FirebaseAuth firebaseAuth;
  GoogleSignIn googleSignIn;
  LoginScreen(this.firebaseAuth,this.googleSignIn);

  @override
  LoginScreenState createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatApp login'),
      ),
      body: login(),
    );
  }

  Widget login() {
    return Container(
      child: Center(
        child: RaisedButton(
          child: Text('Login'),
          onPressed: signIn,
        ),
      ),
    );
  }

  void signIn() async {
    GoogleSignInAccount googleSignInAccount = await widget.googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;
    FirebaseUser user = await widget.firebaseAuth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
  }
}

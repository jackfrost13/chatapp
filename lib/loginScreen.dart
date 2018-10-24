import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class loginScreen extends StatefulWidget {
  FirebaseAuth firebaseAuth;
  loginScreen(this.firebaseAuth);

  @override
  loginScreenState createState() {
    return new loginScreenState(firebaseAuth);
  }
}

class loginScreenState extends State<loginScreen> {
  FirebaseAuth firebaseAuth;
  loginScreenState(this.firebaseAuth);
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
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;
    FirebaseUser user = await firebaseAuth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
  }
}

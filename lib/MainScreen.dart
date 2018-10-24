import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class mainScreen extends StatefulWidget {
  @override
  _mainScreenState createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  void googleAuthentication() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    FirebaseUser firebaseUser = await firebaseAuth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

  }
  @override
  Widget build(BuildContext context) {
    googleAuthentication();
    return Scaffold(body: Text("Main screen"),);
  }
}

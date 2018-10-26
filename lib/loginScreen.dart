import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  FirebaseAuth firebaseAuth;
  GoogleSignIn googleSignIn;

  LoginScreen(this.firebaseAuth, this.googleSignIn);

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.lightBlue,
                Colors.white,
                Colors.yellow,
                Colors.orange,
                Colors.deepOrangeAccent
              ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
              stops: [0.166, 0.33,0.50,0.667,0.84, 1.0],),
        ),
        child: Stack(
          children: <Widget>[
            login(),
          ],
        ),
      ),
    );
  }

  Widget login() {
    return Container(
      child: Center(
        child: RaisedButton(
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Text('Login'),
          color: Colors.lightBlue,
          onPressed: signIn,
        ),
      ),
    );
  }

  void signIn() async {
    GoogleSignInAccount googleSignInAccount =
        await widget.googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    FirebaseUser user = await widget.firebaseAuth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
  }
}

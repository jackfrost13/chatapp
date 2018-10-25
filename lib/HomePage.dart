import 'package:chatapp_firebase/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String toast;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser firebaseUser;


  void showToast(BuildContext context, String text) async {
    setState(() {
      toast=text;
    });
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) {
          return Positioned(
//            top: 5.0,
//            height: 20.0,
            bottom: 35.0,
            left: 100.0,
//            right: 60.0,
            child: Container(
//              width: 200.0,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.cyan),
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: Text(toast),
                ),
              ),
            ),
          );
        });

    overlayState.insert(overlayEntry);
    await Future.delayed(Duration(seconds: 1));
    overlayEntry.remove();
  }


  void signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;
    FirebaseUser user = await firebaseAuth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    firebaseUser = user;
  }

  void signOut() {
    googleSignIn.signOut();
    firebaseAuth.signOut();
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    googleSignIn.signOut();
    toast="";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () async {
                (await googleSignIn.isSignedIn() )
                    ? showToast(context, "Already Signed in")
                    : signIn();
              },
              child: Text('Sign In'),
            ),
            RaisedButton(
              onPressed: () async {
                (await googleSignIn.isSignedIn())
                    ? signOut()
                    : showToast(context, "Already Signed Out");
              },
              child: Text('Sign out'),
            ),
            RaisedButton(
              onPressed: () async {
                if (await googleSignIn.isSignedIn())
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(firebaseUser,googleSignIn)));
                else {
                  showToast(context, "Please Sign in to continue");
                }
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

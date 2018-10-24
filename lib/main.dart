import 'package:flutter/material.dart';
//import 'loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ChatApp',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _handle(),
      debugShowCheckedModeBanner: false,
    );
  }


  Widget _handle() {
    return StreamBuilder<FirebaseUser>(
      stream: widget.firebaseAuth.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return widgetLoading();
        else {
          if (snapshot.hasData) {
            print(snapshot.data);
            return mainScreen();
          } else
            return login();
        }
      },
    );
  }

  Widget widgetLoading() {
//    waiting();
    return Scaffold(
      body: Center(
        child: Text('waitingLoading'),
      ),
    );
  }

  Widget mainScreen() {
    return Scaffold(
      body: Center(
        child: Text('mainScrren'),
      ),
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
    if(googleSignInAccount != null) {
      print("null obtained");
      GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      if (await googleSignIn.isSignedIn())
        print("sign in google");
      FirebaseUser user = await widget.firebaseAuth.signInWithGoogle(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
    }
  }
}

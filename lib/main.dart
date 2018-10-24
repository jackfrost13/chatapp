import 'package:flutter/material.dart';
//import 'loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
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
      stream: firebaseAuth.onAuthStateChanged,
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
        child: Column(
          children: <Widget>[
            Text('mainScrren'),
            RaisedButton(
              child: Text('Signout'),
              onPressed: () {
                googleSignIn.signOut();
                firebaseAuth.signOut();
              },
            ),
          ],
        ),
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
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      if (await googleSignIn.isSignedIn())
        print("sign in google");
      FirebaseUser user = await firebaseAuth.signInWithGoogle(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp_firebase/ChatScreen.dart';
import 'package:chatapp_firebase/loginScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      home: _handleAuth(),
      debugShowCheckedModeBanner: false,
    );
  }
}

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
GoogleSignIn googleSignIn = GoogleSignIn();

Widget _handleAuth() {
  return StreamBuilder<FirebaseUser>(
    stream: firebaseAuth.onAuthStateChanged,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.none)
        return loadingWidget();
      else if (snapshot.hasData) {
        return ChatScreen(snapshot.data, googleSignIn);
      } else {
        return LoginScreen(firebaseAuth, googleSignIn);
      }
    },
  );
}

Widget loadingWidget() {
  waiting();
  return Scaffold(
    body: Center(
      child: RefreshProgressIndicator(),
    ),
  );
}

Future<Null> waiting() async {
  await Future.delayed(Duration(seconds: 3));
}

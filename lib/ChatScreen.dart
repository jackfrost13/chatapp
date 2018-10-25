import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
class ChatScreen extends StatefulWidget {
  FirebaseUser firebaseUser;
  GoogleSignIn googleSignIn;
  ChatScreen(this.firebaseUser, this.googleSignIn);
  @override
  _ChatScreenState createState() => _ChatScreenState(firebaseUser);
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseUser firebaseUser;

  _ChatScreenState(this.firebaseUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatscreen'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              widget.googleSignIn.disconnect();
              FirebaseAuth.instance.signOut();
            },
            tooltip: 'SignOut',
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            showChat(context),
            Divider(
              height: 20.0,
            ),
            keyboardInput(context),
            Text('ChatScreen'),
          ],
        ),
      ),
    );
  }

  var  reference = Firestore.instance
      .collection("messages")
      .orderBy('timestamp', descending: true);
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> chatInstance;
  @override
  void initState() {
    super.initState();
    subscription = reference.snapshots().listen((datasnapshot) {
      setState(() {
        chatInstance = datasnapshot.documents;
      });
    });
  }
  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  Widget showChat(BuildContext context) {
    chatInstance.forEach((DocumentSnapshot snapshot) {
      return Card(
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                  snapshot.data['photoUrl']),
            ),
            Column(
              children: <Widget>[
                Text(snapshot.data['email']),
                snapshot.data['uploadUrl'] != null
                    ? Image(image: NetworkImage(snapshot.data['uploadUrl']),
                  fit: BoxFit.contain,)
                    : Container(),
                snapshot.data['text'] != null
                    ? Text(snapshot.data['text'])
                    : Container(),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget keyboardInput(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            child: IconButton(
                icon: Icon(Icons.camera_enhance),
                onPressed: () async {
                  File imageFile =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  int time = DateTime.now().millisecondsSinceEpoch;
                  StorageReference storage =
                      FirebaseStorage.instance.ref().child("img$time.jpg");
                  StorageUploadTask uploadTask = storage.putFile(imageFile);
                  StorageTaskSnapshot t = await uploadTask.onComplete;
                  String url = t.ref.getDownloadURL().toString();
                  storeMessage(null, url);
                }),
          ),
          Flexible(
            child: TextField(
              textInputAction: TextInputAction.newline,
              controller: textEditingController,
              decoration:
                  new InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          Container(
            child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  String msg = textEditingController.text.trim();
                  if (msg.length > 0) {
                    storeMessage(msg, null);
                    textEditingController.clear();
                  }
                }),
          ),
        ],
      ),
    );
  }

  void storeMessage(String text, String url) {
    print("inside store");
    int time = DateTime.now().millisecondsSinceEpoch;

    print("time = $time");
    Firestore.instance.collection('messages').document().setData({
      'name': firebaseUser.displayName,
      'userid': firebaseUser.uid,
      'text': text,
      'timestamp': time,
      'photoUrl': firebaseUser.photoUrl,
      'email': firebaseUser.email,
      'uploadUrl': url,
    });
  }
}

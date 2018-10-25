import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final GoogleSignIn googleSignIn;

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

  final reference = Firestore.instance
      .collection("messages")
      .orderBy('timestamp', descending: true);

  Widget showChat(BuildContext context) {
    return Flexible(
      child: StreamBuilder(
          stream: reference.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return snapshot.hasData
                ? Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.lightBlue,
                              Colors.white,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomRight,
                            stops: [0.2, 0.3, 1.0],
                          ),
                        ),
                        child: Center(
                          child: Column(),
                        ),
                      ),
                      ListView(
                        reverse: true,
                        children: snapshot.data.documents
                            .map((DocumentSnapshot docSnapshot) =>
                                messageCard(docSnapshot.data))
                            .toList(),
                      ),
                    ],
                  )
                : Container();
          }),
    );
  }

  Widget messageCard(Map message) => Container(
        margin: EdgeInsets.only(top: 20.0, bottom: 30.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(message['photoUrl']),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(message['email']),
                    message['text'] != null
                        ? Text(message['text'])
                        : Container(),
                    message['uploadUrl'] != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              message['uploadUrl'],
                              height: 100.0,
                              width: 100.0,
                              semanticLabel: 'xyzzz',
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

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
                  String url = await t.ref.getDownloadURL();
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

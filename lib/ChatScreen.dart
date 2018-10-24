import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  FirebaseUser firebaseUser;
  ChatScreen(this.firebaseUser);
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
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            showChat(context),
            Divider(
              height: 2.0,
            ),
            keyboardInput(context),
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
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (
                      context,
                      int index,
                    ) =>
                        Card(
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 25.0,
                                backgroundImage: NetworkImage(
                                    snapshot.data.documents[index]['photoUrl']),
                              ),
                              Column(
                                children: <Widget>[
                                  Text(snapshot.data.documents[index]['email']),
                                  Text(snapshot.data.documents[index]['text']),
                                ],
                              ),
                            ],
                          ),
                        ),
                  )
                : Container();
          }),
    );
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
                  File imageFile =await ImagePicker.pickImage(source: ImageSource.gallery);
                  int time = DateTime.now().millisecondsSinceEpoch;
                  StorageReference storage  = FirebaseStorage.instance.ref().child("img${time}.jpg");
                  StorageUploadTask uploadTask = storage.putFile(imageFile);
                  String url = await storage.getDownloadURL();
                  var t =uploadTask.onComplete;
                  print("t = $t");
                  setState(() {
                    print("Url is $url at time ${DateTime.now()}");
                  });


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
                  if(msg.length >0) {
                    storeMessage(msg);
                    textEditingController.clear();
                  }

                }),
          ),
        ],
      ),
    );
  }

  void storeMessage(String text) {
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
    });
  }
}

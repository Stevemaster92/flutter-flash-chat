import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  static const String ROUTE = "/chat";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  User currentUser;
  String messageText;

  @override
  void initState() {
    super.initState();

    currentUser = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context);
            },
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          )
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (value) => messageText = value,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: MaterialButton(
                      color: Colors.lightBlueAccent,
                      onPressed: () async {
                        try {
                          await _firestore.collection("messages").add({
                            "text": messageText,
                            "sender": currentUser.email,
                          });
                          controller.clear();
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text('Send', style: kSendButtonTextStyle),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("messages").snapshots(),
      builder: (context, snapshot) {
        // If we have no data yet, sho the progress indicator.
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        // Create the list of message widgets.
        List<Widget> widgets = [];
        for (var m in snapshot.data.docs) {
          final data = m.data();
          widgets.add(MessageBubble(
            text: data["text"],
            sender: data["sender"],
          ));
        }

        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            children: widgets,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key key,
    @required this.text,
    @required this.sender,
  }) : super(key: key);

  final String text, sender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            sender,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 12.0,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

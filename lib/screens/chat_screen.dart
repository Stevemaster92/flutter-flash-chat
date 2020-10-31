import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
User currentUser;

class ChatScreen extends StatefulWidget {
  static const String ROUTE = "/chat";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;

  void send() async {
    try {
      await _firestore.collection("messages").add({
        "text": messageText,
        "sender": currentUser?.email,
        "timestamp": Timestamp.now(),
      });
      controller.clear();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    currentUser = _auth.currentUser;
  }

  @override
  void dispose() async {
    super.dispose();

    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          )
        ],
        title: Text("⚡️Chat"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => send(),
                      controller: controller,
                      onChanged: (value) => messageText = value,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                        hintText: 'Type your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: send,
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
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
      stream: _firestore
          .collection("messages")
          // Sort the messages by timestamp DESC because we want the newest messages on bottom.
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // If we do not have data yet, show a progress indicator.
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        // Create the list of message widgets.
        List<Widget> widgets = snapshot.data.docs.map<Widget>((m) {
          final data = m.data();
          final String text = data["text"];
          final String sender = data["sender"];
          final Timestamp timestamp = data["timestamp"];

          return MessageBubble(
            text: text,
            sender: sender,
            timestamp: timestamp,
            isMe: sender == currentUser.email,
          );
        }).toList();

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
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
    @required this.timestamp,
    this.isMe,
  }) : super(key: key);

  final String text, sender;
  final bool isMe;
  final Timestamp timestamp;

  @override
  Widget build(BuildContext context) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text("$sender, ${DateFormat("dd.MM.yyyy").format(dateTime)}",
              style: kMessageSubTextStyle),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(
              topLeft: isMe ? Radius.circular(20.0) : Radius.zero,
              topRight: isMe ? Radius.zero : Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(color: isMe ? Colors.white : Colors.black),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    DateFormat("HH:mm").format(dateTime),
                    textAlign: TextAlign.right,
                    style: kMessageSubTextStyle.copyWith(
                      color: isMe ? Colors.white54 : Colors.black45,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

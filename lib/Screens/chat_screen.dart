import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../Widgets/bottom_row_widget.dart';
import '../Widgets/message_bubble.dart';
import '../Widgets/chat_screen_app_bar.dart';

class ChatScreen extends StatelessWidget {
  static const id = 'ChatScreen';

  final Map<String, dynamic> userInfo;
  ChatScreen({Key? key, required this.userInfo}) : super(key: key);
  final ScrollController controller = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _authUser = FirebaseAuth.instance.currentUser!;
  final _textController = TextEditingController();
  Future<void> sendMessage(String text, BuildContext context) async {
    _firestore.collection("${_authUser.uid}/${userInfo['uid']}/messages").add({
      'text': text,
      'createdAt': Timestamp.now(),
      'uid': _authUser.uid,
    });
    _firestore.collection("${userInfo['uid']}/${_authUser.uid}/messages").add({
      'text': text,
      'createdAt': Timestamp.now(),
      'uid': _authUser.uid,
    });
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.red));
    return Scaffold(
      appBar: ChatScreenAppBar(
        userInfo: userInfo,
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: StreamBuilder(
          stream: _firestore
              .collection('${_authUser.uid}/${userInfo['uid']}/messages')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            } else {
              final messageData = snapshot.data!.docs;
              return messageData.isEmpty
                  ? Column(
                      children: [
                        const Expanded(
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                'You can add a new chat by pressing the red button',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                        BottomTextRow(
                          textController: _textController,
                          sendMessage: sendMessage,
                        ),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            reverse: true,
                            itemBuilder: (context, index) {
                              return MessageBubble(
                                message: messageData[index]['text'],
                                userName:
                                    messageData[index]['uid'] == _authUser.uid
                                        ? _authUser.displayName!
                                        : userInfo['username'],
                                isMe:
                                    messageData[index]['uid'] == _authUser.uid,
                                imageUrl:
                                    messageData[index]['uid'] == _authUser.uid
                                        ? _authUser.photoURL
                                        : userInfo['imageUrl'],
                              );
                            },
                            itemCount: messageData.length,
                          ),
                        ),
                        BottomTextRow(
                          textController: _textController,
                          sendMessage: sendMessage,
                        ),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    );
            }
          },
        ),
      ),
    );
  }
}

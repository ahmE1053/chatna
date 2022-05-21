import 'dart:async';

import 'package:chatna/Screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../Models/auth_provider.dart';
import '../Models/theme_provider.dart';
import '../Widgets/adding_chat.dart';

class SelectChatScreen extends StatefulWidget {
  const SelectChatScreen({Key? key}) : super(key: key);
  static const id = 'SelectChatScreen';
  @override
  State<SelectChatScreen> createState() => _SelectChatScreenState();
}

class _SelectChatScreenState extends State<SelectChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
  }

  Timer? timer;
  void updateLastseen() {
    timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (_auth.currentUser == null) {
        timer.cancel();
      }
      await _firestore
          .collection('/users/')
          .doc(_auth.currentUser!.uid)
          .update({'lastSeen': DateTime.now()});
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeProvider>(context);
    final _authenticationData = Provider.of<Authentication>(context);
    updateLastseen();
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(80),
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.red),
                    child: const FittedBox(
                      child: Text(
                        'Chatna',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  Positioned(
                      right: 20,
                      top: 50,
                      child: IconButton(
                          onPressed: () {
                            themeData.changeTheme();
                          },
                          icon: themeData.lightOrDark
                              ? const Icon(
                                  Icons.dark_mode,
                                  color: Colors.black,
                                  size: 50,
                                )
                              : const Icon(
                                  Icons.light_mode,
                                  color: Colors.white,
                                  size: 50,
                                )))
                ],
              ),
              GestureDetector(
                onTap: () {
                  _authenticationData.signOut(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(21),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.all(40),
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return const AddingNewChat();
                });
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('hello'),
        ),
        body: StreamBuilder(
          stream: _firestore
              .collection(_auth.currentUser!.uid.toString())
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: SpinKitWave(
                color: Colors.red,
              ));
            } else {
              return snapshot.data?.size == 0
                  ? const Center(
                      child: Text(
                        'You can add a new chat by pressing the red button',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 60,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                            future: _firestore
                                .collection('users')
                                .doc('${snapshot.data?.docs[index]['uid']}')
                                .get(),
                            builder: (context,
                                AsyncSnapshot<
                                        DocumentSnapshot<Map<String, dynamic>>>
                                    futureSnapshot) {
                              if (futureSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: Container(
                                  margin: const EdgeInsets.all(20),
                                  child: const SpinKitWave(
                                    color: Colors.red,
                                  ),
                                ));
                              } else {
                                return Container(
                                  margin: const EdgeInsets.all(20),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(20),
                                    style: ListTileStyle.list,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    tileColor: Colors.red.withOpacity(0.7),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ChatScreen(
                                              userInfo: (futureSnapshot.data
                                                  ?.data())!,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    title: Text(
                                      futureSnapshot.data?.data()!['username'],
                                      style: const TextStyle(
                                        fontSize: 30,
                                      ),
                                    ),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(500),
                                      child: CachedNetworkImage(
                                        imageUrl: futureSnapshot.data
                                            ?.data()!['imageUrl'],
                                        width: 75,
                                        height: 100,
                                        fit: BoxFit.fill,
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            });
                      },
                    );
            }
          },
        ));
  }
}

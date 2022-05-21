import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class ChatScreenAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Map<String, dynamic> userInfo;
  const ChatScreenAppBar({
    Key? key,
    required this.userInfo,
  }) : super(key: key);
  @override
  State<ChatScreenAppBar> createState() => _ChatScreenAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ChatScreenAppBarState extends State<ChatScreenAppBar> {
  bool firstTime = true;
  void lastSeenCheckerFirstTime() {
    if (firstTime) {
      Timestamp timeStamp;
      DateTime dateTime;
      Duration checker;
      DateFormat format;
      String dateString;
      timeStamp = widget.userInfo['lastSeen'];
      dateTime = timeStamp.toDate();
      checker = DateTime.now().difference(dateTime);
      format = DateFormat.Hm();
      dateString = format.format(dateTime);
      if (checker.inSeconds > 50 && checker.inDays < 1) {
        setState(() {
          format = DateFormat.Hm();
          dateString = format.format(dateTime);
          lastSeen = 'Last seen $dateString';
        });
      } else if (checker.inDays == 1) {
        setState(() {
          format = DateFormat.Hm();
          dateString = format.format(dateTime);
          lastSeen = 'Last seen yesterday at $dateString';
        });
      } else if (checker.inDays > 1) {
        format = DateFormat.MMMMd();
        dateString = format.format(dateTime);
        lastSeen = 'Last seen at $dateString';
      } else {
        setState(() {
          lastSeen = 'Online';
        });
      }
    }
    firstTime = false;
    lastSeenChecker();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lastSeenCheckerFirstTime();
  }

  void lastSeenChecker() {
    Timestamp timeStamp;
    DateTime dateTime;
    Duration checker;
    DateFormat format;
    String dateString;
    timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (_auth.currentUser == null) {
        timer.cancel();
        return;
      }
      final userInfo = (await _firestore
              .collection('/users/')
              .doc(widget.userInfo['uid'])
              .get())
          .data();
      timeStamp = userInfo!['lastSeen'];
      dateTime = timeStamp.toDate();
      checker = DateTime.now().difference(dateTime);
      format = DateFormat.Hm();
      dateString = format.format(dateTime);
      if (checker.inSeconds > 50 && checker.inDays < 1) {
        setState(() {
          format = DateFormat.Hm();
          dateString = format.format(dateTime);
          lastSeen = 'Last seen $dateString';
        });
      } else if (checker.inDays == 1) {
        setState(() {
          format = DateFormat.Hm();
          dateString = format.format(dateTime);
          lastSeen = 'Last seen yesterday at $dateString';
        });
      } else if (checker.inDays > 1) {
        format = DateFormat.MMMMd();
        dateString = format.format(dateTime);
        lastSeen = 'Last seen at $dateString';
      } else {
        setState(() {
          lastSeen = 'Online';
        });
      }
    });
  }

  String lastSeen = '';
  Timer? timer;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.userInfo['username']),
          const SizedBox(
            height: 5,
          ),
          Text(lastSeen)
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
  }
}

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  static handler(String errorCode, BuildContext context) {
    if (errorCode == 'email-already-in-use') {
      Alert(
        context: context,
        title: 'Error',
        desc: 'The email address is already in use by another account',
        style: const AlertStyle(
          backgroundColor: Colors.white,
          titleStyle: TextStyle(color: Colors.black),
        ),
        buttons: [
          DialogButton(
            color: Colors.red,
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ).show();
    }
    if (errorCode == 'wrong-password') {
      Alert(
        style: const AlertStyle(
          backgroundColor: Colors.white,
          titleStyle: TextStyle(color: Colors.black),
        ),
        context: context,
        title: 'Error',
        desc: 'The password is invalid.',
        buttons: [
          DialogButton(
            color: Colors.red,
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ).show();
    }
    if (errorCode == 'network-request-failed') {
      Alert(
        style: const AlertStyle(
          backgroundColor: Colors.white,
          titleStyle: TextStyle(color: Colors.black),
        ),
        context: context,
        title: 'Error',
        desc: 'There is a problem with your connection. Please try again later',
        buttons: [
          DialogButton(
            color: Colors.red,
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ).show();
    }
    if (errorCode == 'too-many-requests') {
      Alert(
        style: const AlertStyle(
          backgroundColor: Colors.white,
          titleStyle: TextStyle(color: Colors.black),
        ),
        context: context,
        title: 'Error',
        desc:
            'We have blocked all requests from this device due to unusual activity. Try again later.',
        buttons: [
          DialogButton(
            color: Colors.red,
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ).show();
    }
    if (errorCode == 'user-not-found') {
      Alert(
        style: const AlertStyle(
          backgroundColor: Colors.white,
          titleStyle: TextStyle(color: Colors.black),
        ),
        context: context,
        title: 'Error',
        desc: 'There is no user registered with the email address you provided',
        buttons: [
          DialogButton(
            color: Colors.red,
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ).show();
    }
  }
}

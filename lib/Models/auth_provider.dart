import 'dart:io';

import 'package:chatna/Screens/select_chat_screen.dart';
import 'package:chatna/Screens/sign_in_or_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../Widgets/error_handler.dart';

class Authentication with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _firebaseStorageRoot = FirebaseStorage.instance.ref();
  int index = 0;
  bool isLoading = false;
  String email = '', password = '', username = '', number = '', _imageUrl = '';
  File? _imageFile;

  Future<String?> selectAnImage(BuildContext context) async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? _image;
      await Alert(
          context: context,
          title: 'Select a photo or take a picture',
          style: const AlertStyle(
            backgroundColor: Colors.white,
            titleStyle: TextStyle(color: Colors.black),
          ),
          buttons: [
            DialogButton(
              child: const Text('Camera'),
              radius: BorderRadius.circular(20),
              color: Colors.red,
              onPressed: () async {
                _image = await _picker.pickImage(
                    source: ImageSource.camera, imageQuality: 10);
                Navigator.pop(context);
              },
            ),
            DialogButton(
              child: const Text('Galley'),
              radius: BorderRadius.circular(20),
              color: Colors.red,
              onPressed: () async {
                _image = await _picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 10);
                // print(_image?.path);

                Navigator.pop(context);
              },
            )
          ]).show();

      if (_image != XFile('') && _image != null) {
        _imageFile = File(_image!.path);
        return _imageFile!.path;
      } else {
        await Alert(
                context: context,
                style: const AlertStyle(
                  backgroundColor: Colors.white,
                  titleStyle: TextStyle(color: Colors.black),
                ),
                buttons: [
                  DialogButton(
                      child: const Text('Ok'),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
                title: 'Error',
                desc: 'You didn\'t pick any image')
            .show();
      }
    } catch (error) {}
  }

  Future<void> signUpOrIn(bool logInOrNot, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      if (logInOrNot) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        Navigator.pushReplacementNamed(context, SelectChatScreen.id);
      } else {
        if (_imageFile == null) {
          isLoading = false;
          await Alert(
                  context: context,
                  style: const AlertStyle(
                    backgroundColor: Colors.white,
                    titleStyle: TextStyle(color: Colors.black),
                  ),
                  buttons: [
                    DialogButton(
                        child: const Text('Ok'),
                        color: Colors.red,
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                  title: 'Error',
                  desc: 'Please select a profile picture')
              .show();

          return;
        }
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final imageRef =
            _firebaseStorageRoot.child('images/${_auth.currentUser?.uid}.jpg');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Uploading image'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ));
        imageRef.putFile(_imageFile!).snapshotEvents.listen((event) async {
          switch (event.state) {
            case (TaskState.running):
              {}
              break;
            case (TaskState.success):
              {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Image uploaded'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ));
                _imageUrl = await imageRef.getDownloadURL();
                await _auth.currentUser?.updatePhotoURL(_imageUrl);
                await _auth.currentUser?.updateDisplayName(username);
                await _firestore
                    .collection('users')
                    .doc(_auth.currentUser?.uid)
                    .set({
                  'username': username,
                  'phoneNumber': number,
                  'uid': _auth.currentUser?.uid,
                  'imageUrl': _imageUrl,
                  'lastSeen': DateTime.now(),
                });
                isLoading = false;
                Navigator.pushReplacementNamed(context, SelectChatScreen.id);
              }
              break;
            default:
            // print('default');
          }
        });
      }
    } on FirebaseAuthException catch (error) {
      ErrorHandler.handler(error.code, context);
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, AuthScreen.id);
    _imageFile = null;
  }
}

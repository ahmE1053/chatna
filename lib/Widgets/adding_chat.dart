import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cross_connectivity/cross_connectivity.dart' as connect;

class AddingNewChat extends StatefulWidget {
  const AddingNewChat({Key? key}) : super(key: key);
  @override
  State<AddingNewChat> createState() => _AddingNewChatState();
}

class _AddingNewChatState extends State<AddingNewChat> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String phoneNumber = '';
  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30),
        margin: EdgeInsets.only(bottom: mediaQ.viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == '') {
                    return 'This field can\'t be empty';
                  }
                  if (!RegExp(r'^[0-9]{11}$').hasMatch(value!)) {
                    return 'Invalid phone number';
                  }
                  return null;
                },
                cursorColor: Colors.red,
                decoration: InputDecoration(
                  labelText: 'Number',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 3,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 3,
                    ),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              connect.ConnectivityBuilder(
                  builder: (context, isConnected, status) {
                return ElevatedButton(
                  onPressed: isConnected == false ||
                          status == connect.ConnectivityStatus.unknown
                      ? () async {
                          await Alert(
                            context: context,
                            desc: 'Please connect to a network',
                            style: const AlertStyle(
                              backgroundColor: Colors.white,
                              titleStyle: TextStyle(color: Colors.black),
                            ),
                            buttons: [
                              DialogButton(
                                  child: const Text(
                                    'Ok',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  color: Colors.red,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ],
                          ).show();
                        }
                      : () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          bool userChecker = false;
                          final mapOfUsers =
                              await _firestore.collection('users').get();
                          final listOfUser = mapOfUsers.docs;
                          for (var i in listOfUser) {
                            if (i['phoneNumber'] == phoneNumber) {
                              userChecker = false;
                              if (i['uid'] == _auth.currentUser?.uid) {
                                await Alert(
                                        context: context,
                                        style: const AlertStyle(
                                          backgroundColor: Colors.white,
                                          titleStyle:
                                              TextStyle(color: Colors.black),
                                        ),
                                        buttons: [
                                          DialogButton(
                                              child: const Text(
                                                'Ok',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                              color: Colors.red,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              })
                                        ],
                                        title: 'You can\'t add yourself')
                                    .show();
                                return;
                              }
                              await _firestore
                                  .collection('${_auth.currentUser?.uid}')
                                  .doc("${i['uid']}")
                                  .set({
                                'imageUrl': i['imageUrl'],
                                'phoneNumber': i['phoneNumber'],
                                'uid': i['uid'],
                                'username': i['username'],
                              }, SetOptions(merge: true));
                              await _firestore
                                  .collection('${i['uid']}')
                                  .doc("${_auth.currentUser?.uid}")
                                  .set({
                                'imageUrl': _auth.currentUser?.photoURL,
                                'phoneNumber': mapOfUsers.docs.firstWhere(
                                    (element) =>
                                        element['uid'] ==
                                        _auth.currentUser?.uid)['phoneNumber'],
                                'uid': _auth.currentUser?.uid,
                                'username': _auth.currentUser?.displayName,
                              });
                              break;
                            } else {
                              userChecker = true;
                            }
                          }
                          if (userChecker) {
                            await Alert(
                                    context: context,
                                    title: 'Error',
                                    style: const AlertStyle(
                                      backgroundColor: Colors.white,
                                      titleStyle:
                                          TextStyle(color: Colors.black),
                                    ),
                                    buttons: [
                                      DialogButton(
                                          child: const Text(
                                            'Ok',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          color: Colors.red,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          })
                                    ],
                                    desc:
                                        'There is no user registered with this number')
                                .show();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                  child: Text(
                    'add',
                    style: TextStyle(
                        fontSize: 30,
                        color: isConnected == false ||
                                status == connect.ConnectivityStatus.unknown
                            ? Colors.black
                            : Colors.white),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                    backgroundColor: MaterialStateProperty.all(
                        isConnected == false ||
                                status == connect.ConnectivityStatus.unknown
                            ? Colors.grey
                            : Colors.red),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:chatna/Widgets/log_in_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';
import '../Models/auth_provider.dart';
import '../Widgets/pickingImage.dart';

enum mode { signUp, logIn }

class AuthScreen extends StatefulWidget {
  static const id = 'AuthScreen';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  mode currentMode = mode.logIn;
  late AnimationController _cotroller;
  late Animation<double> _animation;
  double heightText = 50;
  @override
  void initState() {
    // TODO: implement initState
    _cotroller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _cotroller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _authenticationData = Provider.of<Authentication>(context);
    final mediaQ = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: Colors.red,
        body: SafeArea(
          child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Center(
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const FittedBox(
                        child: Text(
                          'Chatna',
                          style: TextStyle(
                              fontSize: 100,
                              color: Colors.white,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                        margin: mediaQ.orientation == Orientation.portrait
                            ? const EdgeInsets.all(30)
                            : EdgeInsets.symmetric(
                                vertical: 30,
                                horizontal: mediaQ.size.width * 0.25,
                              ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(15),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                        child: Form(
                            key: _formKey,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    curve: Curves.fastOutSlowIn,
                                    height: currentMode == mode.logIn ? 0 : 120,
                                    child: FadeTransition(
                                      opacity: _cotroller,
                                      child: const PickingImageWidget(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      labelStyle: const TextStyle(
                                        fontSize: 30,
                                        color: Colors.purple,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.purple,
                                          width: 3,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      label: const Text('Email'),
                                      errorStyle: const TextStyle(
                                        // fontWeight: FontWeight.w900,
                                        fontSize: 15,
                                        color: Colors.red,
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == '') {
                                        return 'This field can\'t be empty';
                                      }
                                      if (!RegExp(
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                          .hasMatch(value!)) {
                                        return 'Invalid email address';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    onSaved: (value) {
                                      _authenticationData.email = value!;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      labelStyle: const TextStyle(
                                        fontSize: 30,
                                        color: Colors.purple,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.purple,
                                          width: 3,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      label: const Text('Password'),
                                      errorStyle: const TextStyle(
                                        // fontWeight: FontWeight.w900,
                                        fontSize: 15,
                                        color: Colors.red,
                                      ),
                                    ),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == '') {
                                        return 'This field can\'t be empty';
                                      }
                                      if (value!.length <= 7) {
                                        return 'Password can\'t be smaller than 8 characters';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.done,
                                    onSaved: (value) {
                                      _authenticationData.password = value!;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.fastOutSlowIn,
                                    height: currentMode == mode.logIn
                                        ? 0
                                        : heightText,
                                    child: FadeTransition(
                                      opacity: _animation,
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelStyle: const TextStyle(
                                            fontSize: 30,
                                            color: Colors.purple,
                                            fontWeight: FontWeight.w900,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.purple,
                                              width: 3,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          label: const Text('Username'),
                                          errorStyle: const TextStyle(
                                            // fontWeight: FontWeight.w900,
                                            fontSize: 15,
                                            color: Colors.red,
                                          ),
                                        ),
                                        validator: currentMode == mode.logIn
                                            ? (value) {
                                                return null;
                                              }
                                            : (value) {
                                                if (value == '') {
                                                  return 'This field can\'t be empty';
                                                }
                                                if (value!.length <= 5) {
                                                  return 'Username can\'t be smaller than 6 characters';
                                                }
                                                return null;
                                              },
                                        textInputAction: TextInputAction.next,
                                        onSaved: (value) {
                                          _authenticationData.username = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.fastOutSlowIn,
                                    height: currentMode == mode.logIn
                                        ? 0
                                        : heightText,
                                    child: FadeTransition(
                                      opacity: _animation,
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        keyboardType: const TextInputType
                                                .numberWithOptions(
                                            decimal: false, signed: false),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelStyle: const TextStyle(
                                            fontSize: 30,
                                            color: Colors.purple,
                                            fontWeight: FontWeight.w900,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.purple,
                                              width: 3,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          label: const Text('Number'),
                                          errorStyle: const TextStyle(
                                            // fontWeight: FontWeight.w900,
                                            fontSize: 15,
                                            color: Colors.red,
                                          ),
                                        ),
                                        validator: currentMode == mode.logIn
                                            ? (value) {
                                                return null;
                                              }
                                            : (value) {
                                                if (value == '') {
                                                  return 'This field can\'t be empty';
                                                }
                                                if (!RegExp(r'^[0-9]{11}$')
                                                    .hasMatch(value!)) {
                                                  return 'Invalid phone number';
                                                }
                                                return null;
                                              },
                                        textInputAction: TextInputAction.next,
                                        onSaved: (value) {
                                          _authenticationData.number = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  _authenticationData.isLoading
                                      ? const SpinKitWave(
                                          color: Colors.red,
                                        )
                                      : LogInButton(function: () {
                                          if (!_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              heightText = 80;
                                            });
                                            return;
                                          }
                                          _formKey.currentState!.save();
                                          _authenticationData.signUpOrIn(
                                              currentMode == mode.logIn,
                                              context);
                                        }),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextButton(
                                    style: const ButtonStyle(),
                                    onPressed: () {
                                      switchMode();
                                    },
                                    child: Text(
                                      currentMode == mode.logIn
                                          ? 'Create a new account'
                                          : 'Log in',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ])))
                  ])))),
        ));
  }

  void switchMode() {
    if (currentMode == mode.logIn) {
      setState(() {
        setState(() {
          heightText = 50;
        });
        _formKey.currentState?.reset();
        currentMode = mode.signUp;
        _cotroller.forward();
      });
    } else {
      setState(() {
        setState(() {
          heightText = 50;
        });
        _formKey.currentState?.reset();
        currentMode = mode.logIn;
        _cotroller.reverse();
      });
    }
  }
}

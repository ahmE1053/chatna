import 'package:chatna/Screens/chat_screen.dart';
import 'package:chatna/Screens/sign_in_or_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Models/auth_provider.dart';
import 'Models/theme_provider.dart';
import 'Screens/select_chat_screen.dart';
import 'package:provider/provider.dart';

// TODO: make adding a chat a listview
// TODO: say uploading image
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Authentication()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MaterialWidget(),
    );
  }
}

class MaterialWidget extends StatelessWidget {
  const MaterialWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeProvider>(context);
    return Builder(
      builder: (context) {
        final FirebaseAuth snapshot = FirebaseAuth.instance;
        return MaterialApp(
          theme: themeData.data,
          home: snapshot.currentUser == null
              ? const AuthScreen()
              : const SelectChatScreen(),
          routes: {
            SelectChatScreen.id: (context) => const SelectChatScreen(),
            AuthScreen.id: (context) => const AuthScreen(),
          },
        );
      },
    );
  }
}

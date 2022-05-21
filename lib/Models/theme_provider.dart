import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool lightOrDark = true;
  ThemeData data = ThemeData.light();
  void changeTheme() {
    if (lightOrDark) {
      data = ThemeData.dark().copyWith(textTheme: Typography.whiteRedmond);
      lightOrDark = false;
    } else {
      data = ThemeData.light();
      lightOrDark = true;
    }
    notifyListeners();
  }
}

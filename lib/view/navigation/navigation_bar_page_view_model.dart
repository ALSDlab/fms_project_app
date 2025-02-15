import 'package:flutter/material.dart';

class NavigationBarPageViewModel with ChangeNotifier {
  bool badgeValue = false;

  void resetNavigation(bool newValue) {
    badgeValue = newValue;
    notifyListeners();
  }

  Future<void> generateDocId() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final savedDocId = prefs.getString('my_docId');

    // if (savedDocId == null) {
    //   String letters =
    //       'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    //   Random random = Random();
    //   for (int i = 0; i < 15; i++) {
    //     Globals.docId += letters[random.nextInt(62)];
    //   }
    // } else {
    //   Globals.docId = savedDocId;
    // }
    // await prefs.setString('my_docId', Globals.docId);
    notifyListeners();
  }
}

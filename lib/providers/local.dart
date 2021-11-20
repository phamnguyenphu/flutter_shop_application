import 'package:flutter/material.dart';

class Local with ChangeNotifier {
  bool _isEnglish = true;

  bool get isEnglish {
    return _isEnglish;
  }

  void changeLanguage(){
    _isEnglish = !_isEnglish;
    notifyListeners();
  }
}


import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/view/pages/setting_page/setting_page_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPageViewModel with ChangeNotifier {
  SettingPageViewModel() {
    languageNames = languages.map((lang) => lang['name']!).toList();
    targetLanguageNames = languages.map((lang) => lang['name']!).toList();
  }

  final List<Map<String, String>> languages = [
    {'code': 'en', 'country': 'US', 'name': 'English'},
    {'code': 'es', 'country': 'ES', 'name': 'Spanish'},
    {'code': 'fr', 'country': 'FR', 'name': 'French'},
    {'code': 'de', 'country': 'DE', 'name': 'German'},
    {'code': 'it', 'country': 'IT', 'name': 'Italian'},
  ];

  late List<String> languageNames;
  late List<String> targetLanguageNames;

  SingleSelectController<String?> languageController =
      SingleSelectController(null);
  SingleSelectController<String?> targetLanguageController =
      SingleSelectController(null);

  SettingPageState _state = const SettingPageState();

  SettingPageState get state => _state;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    languageController.dispose();
    targetLanguageController.dispose();
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }



  void selectLevel(String selectedLevel) {
    _state = state.copyWith(selectedLevel: selectedLevel);
    notifyListeners();
  }

}

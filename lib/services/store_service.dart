import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snde/services/api_service.dart';

import 'package:devicelocale/devicelocale.dart';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String langKey = '_snde_app_lang';

class StoreService extends ChangeNotifier {
  String _language = 'ar';
  late SharedPreferences _prefs;

  static StoreService of(BuildContext context) =>
      Provider.of<StoreService>(context, listen: false);

  Future<void> initLanguage() async {
    _prefs = await SharedPreferences.getInstance();

    String? lng = _prefs.getString(langKey);

    if (lng == null) {
      try {
        String? locale = await Devicelocale.currentLocale;
        setLanguage = locale;
        // await FlutterI18n.refresh(context, Locale(_language));
      } catch (err) {
        _language = 'ar';
      }
    } else {
      _language = lng;
    }
    changeLanguage(_language);
  }

  String get language => _language;
  set setLanguage(String? lang) => _language = lang!.contains('ar')
      ? 'ar'
      : (lang.contains('en') ? 'en' : (lang.contains('fr') ? 'fr' : _language));

  void changeLanguage(String lang) async {
    _language = lang;
    _prefs.setString(langKey, lang);

    ApiService.setLanguage(lang);

    notifyListeners();
  }
}

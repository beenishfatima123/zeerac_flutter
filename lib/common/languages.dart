import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

enum AppLanguages { english, arabic, hindi, turkish, french }

class Languages extends Translations {
  static final languages = [
    AppLanguages.english.name,
    AppLanguages.arabic.name,
    AppLanguages.turkish.name,
    AppLanguages.hindi.name,
    AppLanguages.french.name
  ];

  static updateLocale(String language) async {
    var locale = const Locale('en');
    switch (language) {
      case 'english':
        locale = const Locale('en');
        break;
      case 'arabic':
        locale = const Locale('ar');

        break;
      case 'hindi':
        locale = const Locale('hi');

        break;
      case 'turkish':
        locale = const Locale('tr');

        break;
      case 'french':
        locale = const Locale('fr');
        break;
    }
    await Get.updateLocale(locale);
    UserDefaults.setLanguage(language);

  }

  static String getCurrentLanguageName() {
    return UserDefaults.getLanguage() ?? 'english';
  }

  static Locale getCurrentLocale() {
    String language = UserDefaults.getLanguage() ?? 'english';
    printWrapped(language);
    var locale = const Locale('en');

    switch (language) {
      case 'english':
        locale = const Locale('en');
        break;
      case 'arabic':
        locale = const Locale('ar');

        break;
      case 'hindi':
        locale = const Locale('hi');

        break;
      case 'turkish':
        locale = const Locale('tr');

        break;
      case 'french':
        locale = const Locale('fr');
        break;
    }
    return locale;
  }

  @override
  Map<String, Map<String, String>> get keys => {
        ///......................english......................///
        'en_US': {
          'login': 'Login',
        },

        ///......................turkish...................///
        'tr': {
          'login': 'giriş yapmak',
        },

        ///......................french......................///
        'fr': {
          'login': 'connexion',
        },

        ///......................arabic......................////
        'ar': {
          'login': 'تسجيل الدخول',
        },

        ///......................hindi......................////
        'hi': {
          'login': 'लॉग इन करें',
        },
      };
}

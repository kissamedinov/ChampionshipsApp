// lib/providers/locale_provider.dart
import 'package:flutter/widgets.dart';

class LocaleProvider with ChangeNotifier {
  // Initial locale: English
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  /// Set a specific locale if supported (en, ru, kk)
  void setLocale(Locale locale) {
    if (!['en', 'ru', 'kk'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }

  /// Cycle through supported locales: en -> ru -> kk -> en
  void toggleLocale() {
    switch (_locale.languageCode) {
      case 'en':
        setLocale(const Locale('ru'));
        break;
      case 'ru':
        setLocale(const Locale('kk'));
        break;
      default:
        setLocale(const Locale('en'));
    }
  }
}

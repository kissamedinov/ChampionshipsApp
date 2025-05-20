// lib/l10n/app_localizations.dart
import 'dart:ui';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Supported locales: English, Russian, Kazakh
  static const supportedLocales = [Locale('en'), Locale('ru'), Locale('kk')];

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // Translation map
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Common
      'appTitle': 'Football Championships',
      'settings': 'Settings',
      'logout': 'Logout',
      // Navigation
      'championships': 'Championships',
      'leagues': 'Leagues',
      'favorites': 'Favorites',
      'cart': 'Cart',
      'map': 'Map',
      'myMatches': 'My Matches',
      'matches': 'Matches',
      'unknownSection': 'Unknown section',
      // Auth
      'loginTitle': 'Login',
      'registerTitle': 'Register',
      'emailHint': 'Email',
      'passwordHint': 'Password',
      'confirmPasswordHint': 'Confirm Password',
      'loginButton': 'Login',
      'registerButton': 'Register',
      'invalidEmail': 'Enter a valid email',
      'passwordTooShort': 'Password too short',
      // Match CRUD
      'createMatch': 'Create Match',
      'editMatch': 'Edit Match',
      'homeTeam': 'Home Team',
      'awayTeam': 'Away Team',
      'stadium': 'Stadium',
      'pickDateTime': 'Pick Date & Time',
      'save': 'Save',
      'update': 'Update',
      'delete': 'Delete',
      'noMatchesFound': 'No matches found.',
      // Filtering
      'filter': 'Filter',
      'fromDate': 'From Date',
      'toDate': 'To Date',
      'clearFilter': 'Clear Filter',
      // Prediction & Favorites
      'predict': 'Predict',
      'addToFavorites': 'Add to Favorites',
      'removeFromFavorites': 'Remove from Favorites',
      // Profile
      'profileSettings': 'Profile Settings',
      'username': 'Username',
      'changeLanguage': 'Change Language',
      // New keys
      'sendVerificationEmail': 'Send verification email',
      'favoriteTeam': 'Favorite Team',
      'bioLogout': 'Bio Logout',
      'addToCart': 'Add to Cart',
      'goToFavorites': 'Go to Favorites',
    },
    'ru': {
      // Common
      'appTitle': 'Чемпионаты по футболу',
      'settings': 'Настройки',
      'logout': 'Выйти',
      // Navigation
      'championships': 'Чемпионаты',
      'leagues': 'Лиги',
      'favorites': 'Избранное',
      'cart': 'Корзина',
      'map': 'Карта',
      'myMatches': 'Мои матчи',
      'matches': 'Матчи',
      'unknownSection': 'Неизвестный раздел',
      // Auth
      'loginTitle': 'Вход',
      'registerTitle': 'Регистрация',
      'emailHint': 'Электронная почта',
      'passwordHint': 'Пароль',
      'confirmPasswordHint': 'Подтвердите пароль',
      'loginButton': 'Войти',
      'registerButton': 'Зарегистрироваться',
      'invalidEmail': 'Введите корректный email',
      'passwordTooShort': 'Пароль слишком короткий',
      // Match CRUD
      'createMatch': 'Создать матч',
      'editMatch': 'Редактировать матч',
      'homeTeam': 'Хозяева',
      'awayTeam': 'Гости',
      'stadium': 'Стадион',
      'pickDateTime': 'Выбрать дату и время',
      'save': 'Сохранить',
      'update': 'Обновить',
      'delete': 'Удалить',
      'noMatchesFound': 'Матчи не найдены.',
      // Filtering
      'filter': 'Фильтр',
      'fromDate': 'С даты',
      'toDate': 'По дату',
      'clearFilter': 'Сбросить фильтр',
      // Prediction & Favorites
      'predict': 'Предсказать',
      'addToFavorites': 'В избранное',
      'removeFromFavorites': 'Удалить из избранного',
      // Profile
      'profileSettings': 'Настройки профиля',
      'username': 'Имя пользователя',
      'changeLanguage': 'Сменить язык',
      // New keys
      'sendVerificationEmail': 'Отправить письмо для подтверждения',
      'favoriteTeam': 'Любимая команда',
      'bioLogout': 'Выход из био',
      'addToCart': 'Добавить в корзину',
      'goToFavorites': 'Перейти в избранное',
    },
    'kk': {
      // Common
      'appTitle': 'Футбол чемпионаттары',
      'settings': 'Параметрлер',
      'logout': 'Шығу',
      // Navigation
      'championships': 'Чемпионаттар',
      'leagues': 'Лигалар',
      'favorites': 'Таңдаулы',
      'cart': 'Себет',
      'map': 'Карта',
      'myMatches': 'Менің матчтарым',
      'matches': 'Ойындар',
      'unknownSection': 'Белгісіз бөлім',
      // Auth
      'loginTitle': 'Кіру',
      'registerTitle': 'Тіркелу',
      'emailHint': 'Электрондық пошта',
      'passwordHint': 'Құпия сөз',
      'confirmPasswordHint': 'Құпия сөзді растау',
      'loginButton': 'Кіру',
      'registerButton': 'Тіркелу',
      'invalidEmail': 'Дұрыс email енгізіңіз',
      'passwordTooShort': 'Құпия сөз қысқа',
      // Match CRUD
      'createMatch': 'Матч құру',
      'editMatch': 'Матчты өңдеу',
      'homeTeam': 'Үй командасы',
      'awayTeam': 'Қонақ командасы',
      'stadium': 'Стадион',
      'pickDateTime': 'Күн мен уақытты таңдаңыз',
      'save': 'Сақтау',
      'update': 'Жаңарту',
      'delete': 'Өшіру',
      'noMatchesFound': 'Матчтар табылмады.',
      // Filtering
      'filter': 'Сүзгіні қолдану',
      'fromDate': 'Бастап',
      'toDate': 'Дейін',
      'clearFilter': 'Сүзгіні өшіру',
      // Prediction & Favorites
      'predict': 'Болжау',
      'addToFavorites': 'Таңдаулыға қосу',
      'removeFromFavorites': 'Таңдаулыдан өшіру',
      // Profile
      'profileSettings': 'Профиль параметрлері',
      'username': 'Пайдаланушы аты',
      'changeLanguage': 'Тілді өзгерту',
      // New keys
      'sendVerificationEmail': 'Растау электрондық поштаны жіберу',
      'favoriteTeam': 'Ұнатқан команда',
      'bioLogout': 'Bio-дан шығу',
      'addToCart': 'Себетке қосу',
      'goToFavorites': 'Таңдаулыға өту',
    },
  };

  // Getters
  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get championships => _localizedValues[locale.languageCode]!['championships']!;
  String get leagues => _localizedValues[locale.languageCode]!['leagues']!;
  String get favorites => _localizedValues[locale.languageCode]!['favorites']!;
  String get cart => _localizedValues[locale.languageCode]!['cart']!;
  String get map => _localizedValues[locale.languageCode]!['map']!;
  String get myMatches => _localizedValues[locale.languageCode]!['myMatches']!;
  String get matches => _localizedValues[locale.languageCode]!['matches']!;
  String get unknownSection => _localizedValues[locale.languageCode]!['unknownSection']!;
  
  String get loginTitle => _localizedValues[locale.languageCode]!['loginTitle']!;
  String get registerTitle => _localizedValues[locale.languageCode]!['registerTitle']!;
  String get emailHint => _localizedValues[locale.languageCode]!['emailHint']!;
  String get passwordHint => _localizedValues[locale.languageCode]!['passwordHint']!;
  String get confirmPasswordHint => _localizedValues[locale.languageCode]!['confirmPasswordHint']!;
  String get loginButton => _localizedValues[locale.languageCode]!['loginButton']!;
  String get registerButton => _localizedValues[locale.languageCode]!['registerButton']!;
  String get invalidEmail => _localizedValues[locale.languageCode]!['invalidEmail']!;
  String get passwordTooShort => _localizedValues[locale.languageCode]!['passwordTooShort']!;

  String get createMatch => _localizedValues[locale.languageCode]!['createMatch']!;
  String get editMatch => _localizedValues[locale.languageCode]!['editMatch']!;
  String get homeTeam => _localizedValues[locale.languageCode]!['homeTeam']!;
  String get awayTeam => _localizedValues[locale.languageCode]!['awayTeam']!;
  String get stadium => _localizedValues[locale.languageCode]!['stadium']!;
  String get pickDateTime => _localizedValues[locale.languageCode]!['pickDateTime']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get update => _localizedValues[locale.languageCode]!['update']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get noMatchesFound => _localizedValues[locale.languageCode]!['noMatchesFound']!;
  
  String get filter => _localizedValues[locale.languageCode]!['filter']!;
  String get fromDate => _localizedValues[locale.languageCode]!['fromDate']!;
  String get toDate => _localizedValues[locale.languageCode]!['toDate']!;
  String get clearFilter => _localizedValues[locale.languageCode]!['clearFilter']!;

  String get predict => _localizedValues[locale.languageCode]!['predict']!;
  String get addToFavorites => _localizedValues[locale.languageCode]!['addToFavorites']!;
  String get removeFromFavorites => _localizedValues[locale.languageCode]!['removeFromFavorites']!;

  String get profileSettings => _localizedValues[locale.languageCode]!['profileSettings']!;
  String get username => _localizedValues[locale.languageCode]!['username']!;
  String get changeLanguage => _localizedValues[locale.languageCode]!['changeLanguage']!;

  // New getters
  String get sendVerificationEmail => _localizedValues[locale.languageCode]!['sendVerificationEmail']!;
  String get favoriteTeam => _localizedValues[locale.languageCode]!['favoriteTeam']!;
  String get bioLogout => _localizedValues[locale.languageCode]!['bioLogout']!;
  String get addToCart => _localizedValues[locale.languageCode]!['addToCart']!;
  String get goToFavorites => _localizedValues[locale.languageCode]!['goToFavorites']!;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales
      .map((e) => e.languageCode)
      .contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => Future.value(AppLocalizations(locale));

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

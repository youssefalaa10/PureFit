import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  AppLocalizations({this.locale});
  final Locale? locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<void> loadJsonLanguage() async {
    try {
      final String jsonString = await rootBundle
          .loadString('assets/lang/${locale!.languageCode}.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing JSON for locale ${locale!.languageCode}: $e');
      }
      // Optionally, handle the error or rethrow it
      rethrow; // You can choose to rethrow or handle it accordingly
    }
  }

  String translate(String key) {
    try {
      return _localizedStrings[key] ?? key;
    } catch (e) {
      return key;
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final AppLocalizations localizations = AppLocalizations(locale: locale);
    await localizations.loadJsonLanguage();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

extension TranslateX on String {
  String tr(BuildContext context) {
    try {
      final localizations = AppLocalizations.of(context);
      if (localizations != null) {
        return localizations.translate(this);
      } else {
        return this;
      }
    } catch (e) {
      return this;
    }
  }
}

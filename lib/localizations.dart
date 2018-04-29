import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:word_study/i18n/messages_all.dart';

class WordStudyLocalizations {
  static Future<WordStudyLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return new WordStudyLocalizations();
    });
  }

  static WordStudyLocalizations of(BuildContext context) {
    return Localizations.of<WordStudyLocalizations>(context, WordStudyLocalizations);
  }

  String get title {
    return Intl.message(
      'Word Study1',
      name: 'title',
      desc: 'Title for Word Study application',
    );
  }
}

class WordStudyLocalizationsDelegate extends LocalizationsDelegate<WordStudyLocalizations> {
  const WordStudyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'el'].contains(locale.languageCode);

  @override
  Future<WordStudyLocalizations> load(Locale locale) => WordStudyLocalizations.load(locale);

  @override
  bool shouldReload(WordStudyLocalizationsDelegate old) => false;
}

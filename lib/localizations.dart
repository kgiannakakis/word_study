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
      'Word Study',
      name: 'title',
      desc: 'Title for Word Study application',
    );
  }

  String get failedToStartQuiz {
    return Intl.message(
      'Failed to start quiz',
      name: 'failedToStartQuiz',
      desc: 'Message, when a quiz fails to start',
    );
  }

  String get undo {
    return Intl.message(
      'Undo',
      name: 'undo',
      desc: 'Undo label',
    );
  }

  String dismissed(String item) {
    return Intl.message(
      '$item dismissed',
      name: 'dismissed',
      args: [item],
      desc: 'Message, when an item is dismissed',
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

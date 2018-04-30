import 'dart:async';

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:word_study/i18n/messages_all.dart';

class WordStudyLocalizations {
  WordStudyLocalizations(this.locale);

  final Locale locale;

  static Future<WordStudyLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return new WordStudyLocalizations(locale);
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

  String get quizSettings {
    return Intl.message(
      'Quiz Settings',
      name: 'quizSettings',
      desc: 'Quiz Settings label',
    );
  }

  String get files {
    return Intl.message(
      'Files',
      name: 'files',
      desc: 'Files label',
    );
  }

  String get pleaseSelectAFile {
    return Intl.message(
      'Please select a file',
      name: 'pleaseSelectAFile',
      desc: 'Select file validation message',
    );
  }

  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: 'Name label',
    );
  }

  String get pleaseEnterTheNameOfTheQuiz {
    return Intl.message(
      'Please enter the name of the quiz',
      name: 'pleaseEnterTheNameOfTheQuiz',
      desc: 'Enter quiz name validation message',
    );
  }

  String get wordsCount {
    return Intl.message(
      'Words Count',
      name: 'wordsCount',
      desc: 'Words Count label',
    );
  }

  String get optionsCount {
    return Intl.message(
      'Options Count',
      name: 'optionsCount',
      desc: 'Options Count label',
    );
  }

  String get pleaseEnterANumber {
    return Intl.message(
      'Please enter a number',
      name: 'pleaseEnterANumber',
      desc: 'Enter a number validation message',
    );
  }

  String get pleaseEnterANumberGreaterThan0 {
    return Intl.message(
      'Please enter a number greater than 0',
      name: 'pleaseEnterANumberGreaterThan0',
      desc: 'Enter a number greater than validation message',
    );
  }

  String pleaseEnterANumberLessThan(int number) {
    return Intl.message(
      'Please enter a number less than $number',
      name: 'pleaseEnterANumberLessThan',
      args: [number],
      desc: 'Enter a number less than validation message',
    );
  }

  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: 'Create label',
    );
  }

  String get optionsCountMustBeLessThanWordsCount {
    return Intl.message(
      'Options count must be less than words count',
      name: 'optionsCountMustBeLessThanWordsCount',
      desc: 'Options count must be less than words count validation message',
    );
  }

  String get aQuizWithThisNameAlreadyExists {
    return Intl.message(
      'A quiz with this name already exists!',
      name: 'aQuizWithThisNameAlreadyExists',
      desc: 'A quiz with this name already exists validation message',
    );
  }
}

class WordStudyLocalizationsDelegate extends LocalizationsDelegate<WordStudyLocalizations> {
  const WordStudyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'el'].contains(locale.languageCode);

//  @override
//  Future<WordStudyLocalizations> load(Locale locale) => WordStudyLocalizations.load(locale);

  @override
  Future<WordStudyLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return new SynchronousFuture<WordStudyLocalizations>(new WordStudyLocalizations(locale));
  }

  @override
  bool shouldReload(WordStudyLocalizationsDelegate old) => false;
}

class FallbackMaterialLocalisationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) => DefaultMaterialLocalizations.load(locale);

  @override
  bool shouldReload(FallbackMaterialLocalisationsDelegate old) => false;
}
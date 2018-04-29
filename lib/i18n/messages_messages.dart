// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'messages';

  static m0(item) => "${item} dismissed";

  static m1(number) => "Please enter a number less than ${number}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "aQuizWithThisNameAlreadyExists" : MessageLookupByLibrary.simpleMessage("A quiz with this name already exists!"),
    "create" : MessageLookupByLibrary.simpleMessage("Create"),
    "dismissed" : m0,
    "failedToStartQuiz" : MessageLookupByLibrary.simpleMessage("Failed to start quiz"),
    "files" : MessageLookupByLibrary.simpleMessage("Files"),
    "name" : MessageLookupByLibrary.simpleMessage("Name"),
    "optionsCount" : MessageLookupByLibrary.simpleMessage("Options Count"),
    "optionsCountMustBeLessThanWordsCount" : MessageLookupByLibrary.simpleMessage("Options count must be less than words count"),
    "pleaseEnterANumber" : MessageLookupByLibrary.simpleMessage("Please enter a number"),
    "pleaseEnterANumberGreaterThan0" : MessageLookupByLibrary.simpleMessage("Please enter a number greater than 0"),
    "pleaseEnterANumberLessThan" : m1,
    "pleaseEnterTheNameOfTheQuiz" : MessageLookupByLibrary.simpleMessage("Please enter the name of the quiz"),
    "pleaseSelectAFile" : MessageLookupByLibrary.simpleMessage("Please select a file"),
    "quizSettings" : MessageLookupByLibrary.simpleMessage("Quiz Settings"),
    "title" : MessageLookupByLibrary.simpleMessage("Word Study"),
    "undo" : MessageLookupByLibrary.simpleMessage("Undo"),
    "wordsCount" : MessageLookupByLibrary.simpleMessage("Words Count")
  };
}

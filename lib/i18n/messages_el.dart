// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a el locale. All the
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
  get localeName => 'el';

  static m0(item) => "${item} διαγράφηκε";

  static m1(number) => "Εισάγετε έναν αριθμό μικρότερο από ${number}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "aQuizWithThisNameAlreadyExists" : MessageLookupByLibrary.simpleMessage("Το όνομα αυτό χρησιμοποιείται ήδη!"),
    "create" : MessageLookupByLibrary.simpleMessage("Δημιουργία"),
    "dismissed" : m0,
    "failedToStartQuiz" : MessageLookupByLibrary.simpleMessage("Δεν μπορεί να ξεκινήσει το τεστ"),
    "files" : MessageLookupByLibrary.simpleMessage("Αρχεία"),
    "name" : MessageLookupByLibrary.simpleMessage("\'Ονομα"),
    "optionsCount" : MessageLookupByLibrary.simpleMessage("Αριθμός επιλογών"),
    "optionsCountMustBeLessThanWordsCount" : MessageLookupByLibrary.simpleMessage("Ο αριθμός των επιλογών πρέπει να είναι μικρότερος από τον αριθμό των λέξεων"),
    "pleaseEnterANumber" : MessageLookupByLibrary.simpleMessage("Εισάγετε έναν αριθμό"),
    "pleaseEnterANumberGreaterThan0" : MessageLookupByLibrary.simpleMessage("Εισάγετε έναν αριθμό μεγαλύτερο από 0"),
    "pleaseEnterANumberLessThan" : m1,
    "pleaseEnterTheNameOfTheQuiz" : MessageLookupByLibrary.simpleMessage("Επιλέξτε το όνομα του τεστ"),
    "pleaseSelectAFile" : MessageLookupByLibrary.simpleMessage("Επιλέξτε ένα αρχείο"),
    "quizSettings" : MessageLookupByLibrary.simpleMessage("Ρυθμίσεις τεστ"),
    "title" : MessageLookupByLibrary.simpleMessage("Μάθε τις λέξεις"),
    "undo" : MessageLookupByLibrary.simpleMessage("Αναίρεση"),
    "wordsCount" : MessageLookupByLibrary.simpleMessage("Αριθμός λέξεων")
  };
}

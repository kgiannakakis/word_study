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

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "dismissed" : m0,
    "failedToStartQuiz" : MessageLookupByLibrary.simpleMessage("Δεν μπορεί να ξεκινήσει το τεστ"),
    "title" : MessageLookupByLibrary.simpleMessage("Μάθε τις λέξεις"),
    "undo" : MessageLookupByLibrary.simpleMessage("Αναίρεση")
  };
}

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

  static m1(folder) => "Ο φάκελος \'${folder}\' βρέθηκε";

  static m2(folder) => "Ο φάκελος \'${folder}\' δε βρέθηκε!";

  static m3(folder) => "Κατεβάστε αρχεία λέξεων από το Google Drive. Δημιουργήστε ένα φάκελο με το όνομα \'${folder}\' και ανεβάστε εκεί τα αρχεία σας για να τα ανακαλύψει η εφαρμογή.";

  static m4(number) => "Εισάγετε έναν αριθμό μικρότερο από ${number}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "aQuizWithThisNameAlreadyExists" : MessageLookupByLibrary.simpleMessage("Το όνομα αυτό χρησιμοποιείται ήδη!"),
    "cantDownloadFile" : MessageLookupByLibrary.simpleMessage("Η λήψη είναι αδύνατη"),
    "create" : MessageLookupByLibrary.simpleMessage("Δημιουργία"),
    "dismissed" : m0,
    "download" : MessageLookupByLibrary.simpleMessage("Λήψη"),
    "failedToConnectToGoogleDrive" : MessageLookupByLibrary.simpleMessage("Αδυναμία σύνδεσης στο Google Drive"),
    "failedToStartQuiz" : MessageLookupByLibrary.simpleMessage("Δεν μπορεί να ξεκινήσει το τεστ"),
    "fileDownload" : MessageLookupByLibrary.simpleMessage("Λήψη αρχείου"),
    "files" : MessageLookupByLibrary.simpleMessage("Αρχεία"),
    "folderFound" : m1,
    "folderIsEmpty" : MessageLookupByLibrary.simpleMessage("Ο φάκελος είναι άδειος"),
    "folderNotFound" : m2,
    "googleDriveError" : MessageLookupByLibrary.simpleMessage("Αποτυχία σύνδεσης στο Google Drive"),
    "googleDriveInstructions" : m3,
    "loadingFiles" : MessageLookupByLibrary.simpleMessage("Φόρτωση αρχείων..."),
    "name" : MessageLookupByLibrary.simpleMessage("\'Ονομα"),
    "optionsCount" : MessageLookupByLibrary.simpleMessage("Αριθμός επιλογών"),
    "optionsCountMustBeLessThanWordsCount" : MessageLookupByLibrary.simpleMessage("Ο αριθμός των επιλογών πρέπει να είναι μικρότερος από τον αριθμό των λέξεων"),
    "pleaseEnterANumber" : MessageLookupByLibrary.simpleMessage("Εισάγετε έναν αριθμό"),
    "pleaseEnterANumberGreaterThan0" : MessageLookupByLibrary.simpleMessage("Εισάγετε έναν αριθμό μεγαλύτερο από 0"),
    "pleaseEnterANumberLessThan" : m4,
    "pleaseEnterAValidUrl" : MessageLookupByLibrary.simpleMessage("Εισάγετε ένα έγκυρο url"),
    "pleaseEnterTheFileUrl" : MessageLookupByLibrary.simpleMessage("Εισάγετε το url"),
    "pleaseEnterTheNameOfTheFile" : MessageLookupByLibrary.simpleMessage("Εισάγετε το όνομα του αρχείου"),
    "pleaseEnterTheNameOfTheQuiz" : MessageLookupByLibrary.simpleMessage("Επιλέξτε το όνομα του τεστ"),
    "pleaseSelectAFile" : MessageLookupByLibrary.simpleMessage("Επιλέξτε ένα αρχείο"),
    "quizSettings" : MessageLookupByLibrary.simpleMessage("Ρυθμίσεις τεστ"),
    "refresh" : MessageLookupByLibrary.simpleMessage("Ανανέωση"),
    "savedFiles" : MessageLookupByLibrary.simpleMessage("Αποθηκευμένα Αρχεία"),
    "signIn" : MessageLookupByLibrary.simpleMessage("Σύνδεση"),
    "signOut" : MessageLookupByLibrary.simpleMessage("Αποσύνδεση"),
    "signedInSuccessfully" : MessageLookupByLibrary.simpleMessage("Σύνδεση επιτυχής."),
    "title" : MessageLookupByLibrary.simpleMessage("Μάθε τις λέξεις"),
    "undo" : MessageLookupByLibrary.simpleMessage("Αναίρεση"),
    "url" : MessageLookupByLibrary.simpleMessage("Url"),
    "wordsCount" : MessageLookupByLibrary.simpleMessage("Αριθμός λέξεων"),
    "youAreNotCurrentlySignedIn" : MessageLookupByLibrary.simpleMessage("Δεν είστε συνδεδεμένοι.")
  };
}

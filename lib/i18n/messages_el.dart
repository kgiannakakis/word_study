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

  static m1(folder) => "Κατεβάστε αρχεία λέξεων από το  Dropbox. Δώστε άδεια στην εφαρμογή και μετά ανεβάστε τα αρχεία σας στο φάκελο \'${folder}\' για να τα ανακαλύψετε.";

  static m2(folder) => "Ο φάκελος \'${folder}\' βρέθηκε";

  static m3(folder) => "Ο φάκελος \'${folder}\' δε βρέθηκε!";

  static m4(folder) => "Κατεβάστε αρχεία λέξεων από το Google Drive. Δημιουργήστε ένα φάκελο με το όνομα \'${folder}\' και ανεβάστε εκεί τα αρχεία σας για να τα ανακαλύψει η εφαρμογή.";

  static m5(number) => "Εισάγετε έναν αριθμό μικρότερο από ${number}";

  static m6(question, total) => "Ερώτηση ${question} από ${total}";

  static m7(correct, total) => "Βρήκατε ${correct} από τα ${total}!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "aQuizWithThisNameAlreadyExists" : MessageLookupByLibrary.simpleMessage("Το όνομα αυτό χρησιμοποιείται ήδη!"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Ακύρωση"),
    "cantDownloadFile" : MessageLookupByLibrary.simpleMessage("Η λήψη είναι αδύνατη"),
    "create" : MessageLookupByLibrary.simpleMessage("Δημιουργία"),
    "dismissed" : m0,
    "download" : MessageLookupByLibrary.simpleMessage("Λήψη"),
    "dropboxError" : MessageLookupByLibrary.simpleMessage("Αποτυχία σύνδεσης στο Dropbox"),
    "dropboxInstructions" : m1,
    "edit" : MessageLookupByLibrary.simpleMessage("Επεξεργασία"),
    "exit" : MessageLookupByLibrary.simpleMessage("Έξοδος"),
    "exitQuiz" : MessageLookupByLibrary.simpleMessage("Έξοδος"),
    "exitQuizWarning" : MessageLookupByLibrary.simpleMessage("Είστε σίγουροι ότι θέλετε να τερματίσετε το τεστ;"),
    "failedToConnectToDropbox" : MessageLookupByLibrary.simpleMessage("Αδυναμία σύνδεσης στο Dropbox"),
    "failedToConnectToGoogleDrive" : MessageLookupByLibrary.simpleMessage("Αδυναμία σύνδεσης στο Google Drive"),
    "failedToStartQuiz" : MessageLookupByLibrary.simpleMessage("Δεν μπορεί να ξεκινήσει το τεστ"),
    "fileDownload" : MessageLookupByLibrary.simpleMessage("Λήψη αρχείου"),
    "fileInUse" : MessageLookupByLibrary.simpleMessage("Το αρχείο χρησιμοποιείται και δεν μπορεί να διαγραφεί"),
    "files" : MessageLookupByLibrary.simpleMessage("Αρχεία"),
    "folderFound" : m2,
    "folderIsEmpty" : MessageLookupByLibrary.simpleMessage("Ο φάκελος είναι άδειος"),
    "folderNotFound" : m3,
    "googleDriveError" : MessageLookupByLibrary.simpleMessage("Αποτυχία σύνδεσης στο Google Drive"),
    "googleDriveInstructions" : m4,
    "inverse" : MessageLookupByLibrary.simpleMessage("Αντίστροφα"),
    "loadingFiles" : MessageLookupByLibrary.simpleMessage("Φόρτωση αρχείων..."),
    "name" : MessageLookupByLibrary.simpleMessage("\'Ονομα"),
    "next" : MessageLookupByLibrary.simpleMessage("Επόμενο"),
    "noFilesMessage" : MessageLookupByLibrary.simpleMessage("Δεν υπάρχουν διαθέσιμα αρχεία. Πατήστε το + για να συνδεθείτε στα αποθετήριά σας στο cloud και να προσθέσετε αρχεία."),
    "optionsCount" : MessageLookupByLibrary.simpleMessage("Αριθμός επιλογών"),
    "optionsCountMustBeLessThanWordsCount" : MessageLookupByLibrary.simpleMessage("Ο αριθμός των επιλογών πρέπει να είναι μικρότερος από τον αριθμό των λέξεων"),
    "pleaseEnterANumber" : MessageLookupByLibrary.simpleMessage("Εισάγετε έναν αριθμό"),
    "pleaseEnterANumberGreaterThan0" : MessageLookupByLibrary.simpleMessage("Εισάγετε έναν αριθμό μεγαλύτερο από 0"),
    "pleaseEnterANumberLessThan" : m5,
    "pleaseEnterAValidUrl" : MessageLookupByLibrary.simpleMessage("Εισάγετε ένα έγκυρο url"),
    "pleaseEnterTheFileUrl" : MessageLookupByLibrary.simpleMessage("Εισάγετε το url"),
    "pleaseEnterTheNameOfTheFile" : MessageLookupByLibrary.simpleMessage("Εισάγετε το όνομα του αρχείου"),
    "pleaseEnterTheNameOfTheQuiz" : MessageLookupByLibrary.simpleMessage("Επιλέξτε το όνομα του τεστ"),
    "pleaseSelectAFile" : MessageLookupByLibrary.simpleMessage("Επιλέξτε ένα αρχείο"),
    "previous" : MessageLookupByLibrary.simpleMessage("Προηγούμενο"),
    "questionNumber" : m6,
    "quizSettings" : MessageLookupByLibrary.simpleMessage("Ρυθμίσεις τεστ"),
    "refresh" : MessageLookupByLibrary.simpleMessage("Ανανέωση"),
    "results" : MessageLookupByLibrary.simpleMessage("Αποτελέσματα"),
    "resultsMessage" : m7,
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

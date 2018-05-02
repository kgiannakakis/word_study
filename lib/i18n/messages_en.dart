// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  get localeName => 'en';

  static m0(item) => "${item} dismissed";

  static m1(folder) => "\'${folder}\' folder found!";

  static m2(folder) => "\'${folder}\' folder not found!";

  static m3(folder) => "Download files from your Google Drive. Create a folder named \'${folder}\' and upload your word files there to discover them.";

  static m4(number) => "Please enter a number less than ${number}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "aQuizWithThisNameAlreadyExists" : MessageLookupByLibrary.simpleMessage("A quiz with this name already exists!"),
    "cantDownloadFile" : MessageLookupByLibrary.simpleMessage("Can\'t download file"),
    "create" : MessageLookupByLibrary.simpleMessage("Create"),
    "dismissed" : m0,
    "download" : MessageLookupByLibrary.simpleMessage("Download"),
    "failedToConnectToGoogleDrive" : MessageLookupByLibrary.simpleMessage("Failed to connect to Google Drive"),
    "failedToStartQuiz" : MessageLookupByLibrary.simpleMessage("Failed to start quiz"),
    "fileDownload" : MessageLookupByLibrary.simpleMessage("File Download"),
    "files" : MessageLookupByLibrary.simpleMessage("Files"),
    "folderFound" : m1,
    "folderIsEmpty" : MessageLookupByLibrary.simpleMessage("Folder is empty"),
    "folderNotFound" : m2,
    "googleDriveInstructions" : m3,
    "loadingFiles" : MessageLookupByLibrary.simpleMessage("Loading files..."),
    "name" : MessageLookupByLibrary.simpleMessage("Name"),
    "optionsCount" : MessageLookupByLibrary.simpleMessage("Options Count"),
    "optionsCountMustBeLessThanWordsCount" : MessageLookupByLibrary.simpleMessage("Options count must be less than words count"),
    "pleaseEnterANumber" : MessageLookupByLibrary.simpleMessage("Please enter a number"),
    "pleaseEnterANumberGreaterThan0" : MessageLookupByLibrary.simpleMessage("Please enter a number greater than 0"),
    "pleaseEnterANumberLessThan" : m4,
    "pleaseEnterAValidUrl" : MessageLookupByLibrary.simpleMessage("Please enter a valid url"),
    "pleaseEnterTheFileUrl" : MessageLookupByLibrary.simpleMessage("Please enter the file url"),
    "pleaseEnterTheNameOfTheFile" : MessageLookupByLibrary.simpleMessage("Please enter the file name"),
    "pleaseEnterTheNameOfTheQuiz" : MessageLookupByLibrary.simpleMessage("Please enter the name of the quiz"),
    "pleaseSelectAFile" : MessageLookupByLibrary.simpleMessage("Please select a file"),
    "quizSettings" : MessageLookupByLibrary.simpleMessage("Quiz Settings"),
    "refresh" : MessageLookupByLibrary.simpleMessage("Refresh"),
    "savedFiles" : MessageLookupByLibrary.simpleMessage("Saved files"),
    "signIn" : MessageLookupByLibrary.simpleMessage("Sign in"),
    "signOut" : MessageLookupByLibrary.simpleMessage("Sign out"),
    "signedInSuccessfully" : MessageLookupByLibrary.simpleMessage("Signed in successfully."),
    "title" : MessageLookupByLibrary.simpleMessage("Word Study"),
    "undo" : MessageLookupByLibrary.simpleMessage("Undo"),
    "url" : MessageLookupByLibrary.simpleMessage("Url"),
    "wordsCount" : MessageLookupByLibrary.simpleMessage("Words Count"),
    "youAreNotCurrentlySignedIn" : MessageLookupByLibrary.simpleMessage("You are not currently signed in.")
  };
}

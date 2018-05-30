import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:word_study/models/quiz_option.dart';
import 'package:word_study/models/quiz_word.dart';
import 'package:word_study/models/word.dart';
import 'package:word_study/services/file_service.dart';

class WordProvider {
  var _random = new Random(new DateTime.now().millisecondsSinceEpoch);
  final FileService _fileService = new FileService();

  List<Word> _words = [new Word('Shangri-la','a faraway haven or hideaway of idyllic beauty and tranquility'),
               new Word('mythoclast','a destroyer or debunker of myths'),
               new Word('inscape','the unique essence or inner nature of a person, place, thing, or event, especially depicted in poetry or a work of art'),
               new Word('kismet','fate; destiny'),
               new Word('ariose','characterized by melody; songlike'),
               new Word('deracinate','to isolate or alienate (a person) from a native or customary culture or environment'),
               new Word('pullulate','to increase rapidly; multiply'),
               new Word('dornick','a small stone that is easy to throw'),
               new Word('craic','mischievous fun; laughs'),
               new Word('bunglesome','clumsy or awkward'),
               new Word('paseo','a slow, idle, or leisurely walk or stroll'),
               new Word('krummholz','a forest of stunted trees near the timber line on a mountain'),
               new Word('ergophobia','an abnormal fear of work; an aversion to work'),
               new Word('peculate','to steal or take dishonestly (money, especially public funds, or property entrusted to one\'s care)'),
               new Word('aberration','the act of departing from the right, normal, or usual course')];

  Future<bool> init() async {
    return true;
  }

  QuizWord getWordFromList(List<Word> words, int optionsCount, bool inverse) {

    if (optionsCount > words.length) {
      throw new ArgumentError("Available words less than options count");
    }

    int w = _random.nextInt(words.length);
    int correct = _random.nextInt(optionsCount);

    List<QuizOption> quizOptions = new List<QuizOption>();
    List<int> optionIndices = new List<int>();

    for(int i=0; i<optionsCount; i++) {
      if (i == correct) {
        String text = inverse ? words[w].word : words[w].meaning;
        quizOptions.add(new QuizOption(text, true));
      }
      else {
        int o = _random.nextInt(words.length);
        while (o == w || optionIndices.contains(o)) {
          o = _random.nextInt(words.length);
        }
        optionIndices.add(o);
        String text = inverse ? words[o].word : words[o].meaning;
        quizOptions.add(new QuizOption(text, false));
      }
    }
    String word = inverse ? words[w].meaning : words[w].word;
    return new QuizWord(word, quizOptions);
  }

  QuizWord getWord(int optionsCount, bool inverse) {
    return getWordFromList(_words, optionsCount, inverse);
  }

  List<QuizWord> getWords(int wordsCount, int optionsCount, bool inverse) {
    return getWordsFromList(_words, wordsCount, optionsCount, inverse);
  }

  List<QuizWord> getWordsFromList(List<Word> words, int wordsCount, int optionsCount, bool inverse) {
    if (wordsCount > words.length) {
      throw new ArgumentError("Available words less than words count");
    }
    List<QuizWord> quizWords = [];
    List<String> wordsLabels = [];
    for(int i=0; i<wordsCount; i++) {
      QuizWord quizWord = getWord(optionsCount, inverse);
      while(wordsLabels.contains(quizWord.word)) {
        quizWord = getWord(optionsCount, inverse);
      }
      wordsLabels.add(quizWord.word);
      quizWords.add(quizWord);
    }

    return quizWords;
  }

  int get length {
    return _words.length;
  }

  Future<void> storeWords (List<Word> words, String filename) async {
    final path = await _fileService.localPath;
    File file =  new File('$path/$filename');

    print('Storing $path/$filename');

    String content = '';
    words.forEach((word) {
      String line = '${word.word}\t${word.meaning}\n';
      content = content + line;
    });
    await file.writeAsString(content.trim());
  }

  Future<void> store (String filename) async {
    storeWords(_words, filename);
  }

}
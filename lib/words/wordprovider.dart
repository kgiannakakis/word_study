import 'dart:math';
import 'dart:async';
import 'package:word_study/words/word.dart';
import 'package:word_study/words/quizword.dart';
import 'package:word_study/words/quizoption.dart';

class WordProvider {
  var _random = new Random(new DateTime.now().millisecondsSinceEpoch);

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

  QuizWord getWordFromList(List<Word> words, int optionsCount) {

    if (optionsCount > words.length) {
      throw new ArgumentError("Available words less than options count");
    }

    int w = _random.nextInt(words.length);
    int correct = _random.nextInt(optionsCount);

    List<QuizOption> quizOptions = new List<QuizOption>();
    List<int> optionIndices = new List<int>();

    for(int i=0; i<optionsCount; i++) {
      if (i == correct) {
        quizOptions.add(new QuizOption(words[w].meaning, true));
      }
      else {
        int o = _random.nextInt(words.length);
        while (o == w || optionIndices.contains(o)) {
          o = _random.nextInt(words.length);
        }
        optionIndices.add(o);
        quizOptions.add(new QuizOption(words[o].meaning, false));
      }
    }

    return new QuizWord(words[w].word, quizOptions);
  }

  QuizWord getWord(int optionsCount) {
    return getWordFromList(_words, optionsCount);
  }



}
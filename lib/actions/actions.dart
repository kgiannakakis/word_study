import 'package:word_study/words/quiz.dart';

class LoadQuizzesAction {}

class QuizzesNotLoadedAction {}

class QuizzesLoadedAction {
  final List<Quiz> quizzes;

  QuizzesLoadedAction(this.quizzes);
}

class AddQuizAction {
  final Quiz quiz;

  AddQuizAction(this.quiz);
}
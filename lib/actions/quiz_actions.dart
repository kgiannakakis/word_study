import 'package:word_study/models/quiz.dart';

class LoadQuizzesAction {}

class QuizzesNotLoadedAction {}

class QuizzesLoadedAction {
  final List<Quiz> quizzes;

  QuizzesLoadedAction(this.quizzes);
}

class DeleteQuizAction {
  final String name;

  DeleteQuizAction(this.name);
}

class AddQuizAction {
  final Quiz quiz;

  AddQuizAction(this.quiz);
}
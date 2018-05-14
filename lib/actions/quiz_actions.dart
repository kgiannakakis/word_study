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

class SelectQuizAction {
  final int quizIndex;

  SelectQuizAction(this.quizIndex);
}

class SetAddedQuizId {
  final int id;

  SetAddedQuizId(this.id);
}

class UpdateQuiz {
  final int id;
  final Quiz quiz;

  UpdateQuiz(this.id, this.quiz);
}
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

class SetAddedQuizIdAction {
  final int id;

  SetAddedQuizIdAction(this.id);
}

class UpdateQuizAction {
  final Quiz quiz;

  UpdateQuizAction(this.quiz);
}
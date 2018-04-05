class QuizOption {
  final String meaning;
  final bool isCorrect;
  bool isSelected;

  QuizOption(this.meaning, this.isCorrect) {
    if (meaning == null) {
      throw new ArgumentError("Meaning cannot be null. "
          "Received: '$meaning'");
    }
    isSelected = false;
  }
}
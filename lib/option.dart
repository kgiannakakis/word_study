class Option {
  final String meaning;
  final bool isCorrect;

  Option(this.meaning, this.isCorrect) {
    if (meaning == null) {
      throw new ArgumentError("Meaning cannot be null. "
          "Received: '$meaning'");
    }
  }
}
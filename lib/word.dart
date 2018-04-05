class Word {
  final String word;
  final String meaning;

  Word(this.word, this.meaning) {
    if (word == null) {
      throw new ArgumentError("Word cannot be null. "
          "Received: '$word'");
    }
    if (meaning == null) {
      throw new ArgumentError("Meaning cannot be null. "
          "Received: '$meaning'");
    }
  }
}
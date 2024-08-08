class TemplateFlashcardModel  {
  final int id;
  final String question;
  final String answer;
  final int? deckId;

  TemplateFlashcardModel ({
    required this.id,
    required this.question,
    required this.answer,
    this.deckId,
  });

  TemplateFlashcardModel  copyWith({
    int? id,
    String? question,
    String? answer,
    int? deckId,
  }) {
    return TemplateFlashcardModel (
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      deckId: deckId ?? this.deckId,
    );
  }
}

class FlashcardModel  {
  final int id;
  final String question;
  final String answer;
  final int weight; // вес карточки
  final int? deckId;
  final String? lastReviewedAt;
  final int? lastAnswerWeight;

  FlashcardModel ({
    required this.id,
    required this.question,
    required this.answer,
    this.weight = 0, // начальный вес
    this.deckId,
    this.lastReviewedAt,
    this.lastAnswerWeight,
  });

  FlashcardModel  copyWith({
    int? id,
    String? question,
    String? answer,
    int? weight,
    int? deckId,
    String? lastReviewedAt,
    int? lastAnswerWeight,
  }) {
    return FlashcardModel (
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      weight: weight ?? this.weight,
      deckId: deckId ?? this.deckId,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      lastAnswerWeight: lastAnswerWeight ?? this.lastAnswerWeight,
    );
  }
}

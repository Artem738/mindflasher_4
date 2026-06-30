class FlashcardModel  {
  final int id;
  final String question;
  final String answer;
  final int weight; // вес карточки
  final int? deckId;
  final String? lastReviewedAt;
  final int? lastAnswerWeight;
  final double easeFactor;
  final int intervalDays;
  final String? nextReviewAt;

  FlashcardModel ({
    required this.id,
    required this.question,
    required this.answer,
    this.weight = 0, // начальный вес
    this.deckId,
    this.lastReviewedAt,
    this.lastAnswerWeight,
    this.easeFactor = 2.50,
    this.intervalDays = 0,
    this.nextReviewAt,
  });

  factory FlashcardModel.fromJson(Map<String, dynamic> json) {
    return FlashcardModel(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      weight: json['weight'] ?? 0,
      deckId: json['deck_id'],
      lastReviewedAt: json['last_reviewed_at'],
      lastAnswerWeight: json['last_answer_weight'],
      easeFactor: json['ease_factor'] != null 
          ? double.parse(json['ease_factor'].toString()) 
          : 2.50,
      intervalDays: json['interval_days'] ?? 0,
      nextReviewAt: json['next_review_at'],
    );
  }

  FlashcardModel  copyWith({
    int? id,
    String? question,
    String? answer,
    int? weight,
    int? deckId,
    String? lastReviewedAt,
    int? lastAnswerWeight,
    double? easeFactor,
    int? intervalDays,
    String? nextReviewAt,
  }) {
    return FlashcardModel (
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      weight: weight ?? this.weight,
      deckId: deckId ?? this.deckId,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      lastAnswerWeight: lastAnswerWeight ?? this.lastAnswerWeight,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
    );
  }
}

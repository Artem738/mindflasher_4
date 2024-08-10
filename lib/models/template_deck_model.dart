class TemplateDeckModel {
  final int id;
  final String name;
  final String description;
  final String? deck_lang;
  final String? question_lang;
  final String? answer_lang;

  TemplateDeckModel({
    required this.id,
    required this.name,
    required this.description,
    this.deck_lang,
    this.question_lang,
    this.answer_lang,
  });

  String log() {
    return 'DeckModel - id: $id, name: $name, description: $description, deck_lang: $deck_lang, question_lang: $question_lang, answer_lang: $answer_lang';
  }
}

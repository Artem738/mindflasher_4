class DeckModel {
  final int id;
  final String name;
  final String description;
  final int? templateDeckId;
  final int totalCards;
  final int grayCards;
  final int redCards;
  final int yellowCards;
  final int greenCards;

  DeckModel({
    required this.id,
    required this.name,
    required this.description,
    this.templateDeckId,
    this.totalCards = 0,
    this.grayCards = 0,
    this.redCards = 0,
    this.yellowCards = 0,
    this.greenCards = 0,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      templateDeckId: json['template_deck_id'],
      totalCards: json['total_cards'] ?? 0,
      grayCards: json['gray_cards'] ?? 0,
      redCards: json['red_cards'] ?? 0,
      yellowCards: json['yellow_cards'] ?? 0,
      greenCards: json['green_cards'] ?? 0,
    );
  }
}
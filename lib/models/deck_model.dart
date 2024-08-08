class DeckModel {
  final int id;

  final String name;
  final String description;

  DeckModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      id: json['id'],
     // userId: json['user_id'],
      name: json['name'],
      description: json['description'],
    );
  }

}
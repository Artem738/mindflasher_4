class TemplateDeckModel {
  final int id;
  final String name;
  final String description;

  TemplateDeckModel({
    required this.id,
    required this.name,
    required this.description,
  });

  String log() {
    return 'DeckModel - id: $id, name: $name, description: $description';
  }
}

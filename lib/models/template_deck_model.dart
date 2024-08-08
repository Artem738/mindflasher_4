class DeckModel {
  final int id;
  final String name;
  final String description;

  DeckModel({
    required this.id,
    required this.name,
    required this.description,
  });

  String log() {
    return 'DeckModel - id: $id, name: $name, description: $description';
  }
}

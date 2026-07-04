import 'template_deck_model.dart';

class TemplateCategoryModel {
  final int id;
  final String name;
  final int? parentId;
  final String lang;
  final List<TemplateCategoryModel> children;
  final List<TemplateDeckModel> decks;

  TemplateCategoryModel({
    required this.id,
    required this.name,
    this.parentId,
    required this.lang,
    required this.children,
    required this.decks,
  });

  factory TemplateCategoryModel.fromJson(Map<String, dynamic> json) {
    var childrenJson = json['children'] as List? ?? [];
    var decksJson = json['decks'] as List? ?? [];

    return TemplateCategoryModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'],
      lang: json['lang'] ?? 'ru',
      children: childrenJson
          .map((item) => TemplateCategoryModel.fromJson(item))
          .toList(),
      decks: decksJson
          .map((item) => TemplateDeckModel.fromJson(item))
          .toList(),
    );
  }

  String log() {
    return 'TemplateCategoryModel - id: $id, name: $name, parentId: $parentId, lang: $lang, '
        'childrenCount: ${children.length}, decksCount: ${decks.length}';
  }
}

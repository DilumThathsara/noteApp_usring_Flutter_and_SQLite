class NoteModel {
  final int? id;
  String title;
  String description;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
  });

  static NoteModel fromJson(Map<String, dynamic> json) => NoteModel(
        id: json["id"] as int,
        title: json["title"] as String,
        description: json["description"] as String,
      );
}

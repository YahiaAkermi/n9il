class Note {
  final int id;
  final String title;
  final String description;
  final String date;

  Note({required this.id, required this.title, required this.description, required this.date});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
    };
  }
}
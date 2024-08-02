class Note {
  int? id;
  String title;
  String content;
  NoteType type;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type.toString().split('.').last,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      type: NoteType.values.firstWhere(
            (e) => e.toString() == 'NoteType.${map['type']}',
      ),
    );
  }
}

enum NoteType { standard, checklist }

class ChecklistItem {
  String title;
  bool isDone;

  ChecklistItem({required this.title, this.isDone = false});
}

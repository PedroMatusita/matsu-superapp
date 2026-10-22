class Note {
  final String id;
  final String title;
  final String content;
  final DateTime editedAt;


  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.editedAt,
  });

  //create note
  factory Note.create({
    required String id,
    String title = '',
    String content = '',
  }) {
    return Note(
      id: id,
      title: title,
      content: content,
      editedAt:  DateTime.now(),
    );
  }

  //edit note (it copies)

  Note copyWith({
    String? title,
    String? content,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      editedAt: DateTime.now()
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'editedAt': editedAt.toIso8601String(),
    };
  }

  //fromJson
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      editedAt: DateTime.parse(json['editedAt']),
    );
  }
  }
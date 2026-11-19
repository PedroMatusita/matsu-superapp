abstract class NoteBlock {
  const NoteBlock();

  Map<String, dynamic> toJson();

  factory NoteBlock.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'checklist':
        return ChecklistBlock(
          text: json['text'] as String? ?? '',
          isChecked: json['isChecked'] as bool? ?? false,
        );
      case 'text':
      default:
        return TextBlock(text: json['text'] as String? ?? '');
    }
  }
}

class TextBlock extends NoteBlock {
  final String text;

  const TextBlock({required this.text});

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'text', 'text': text};
  }
}

class ChecklistBlock extends NoteBlock {
  final String text;
  final bool isChecked;

  const ChecklistBlock({required this.text, this.isChecked = false});

  ChecklistBlock copyWith({String? text, bool? isChecked}) {
    return ChecklistBlock(
      text: text ?? this.text,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'checklist', 'text': text, 'isChecked': isChecked};
  }
}

class Note {
  final String id;
  final String title;
  final List<NoteBlock> blocks;
  final DateTime editedAt;

  Note({
    required this.id,
    required this.title,
    required List<NoteBlock> blocks,
    required this.editedAt,
  }) : blocks = List.unmodifiable(blocks);

  String get content {
    return blocks
        .whereType<TextBlock>()
        .map((block) => block.text)
        .where((text) => text.isNotEmpty)
        .join('\n');
  }

  factory Note.create({
    required String id,
    String title = '',
    String content = '',
    List<NoteBlock>? blocks,
  }) {
    return Note(
      id: id,
      title: title,
      blocks: blocks ?? [TextBlock(text: content)],
      editedAt: DateTime.now(),
    );
  }

  Note copyWith({String? title, String? content, List<NoteBlock>? blocks}) {
    return Note(
      id: id,
      title: title ?? this.title,
      blocks:
          blocks ??
          (content == null ? this.blocks : [TextBlock(text: content)]),
      editedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'blocks': blocks.map((block) => block.toJson()).toList(),
      'editedAt': editedAt.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    final rawBlocks = json['blocks'];
    final blocks = rawBlocks is List
        ? rawBlocks
              .whereType<Map<String, dynamic>>()
              .map(NoteBlock.fromJson)
              .toList()
        : <NoteBlock>[TextBlock(text: json['content'] as String? ?? '')];

    return Note(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      blocks: blocks,
      editedAt: DateTime.parse(json['editedAt'] as String),
    );
  }
}

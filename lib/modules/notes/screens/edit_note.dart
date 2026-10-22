import 'package:flutter/material.dart';
import '../note.dart';
import '../note_repo.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? noteToEdit;
  final NotesRepository notesRepository;

  const AddEditNoteScreen({
    super.key,
    this.noteToEdit,
    required this.notesRepository,
  });

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    // Check if we are in edit mode or create mode
    _titleController = TextEditingController(text: widget.noteToEdit?.title ?? '');
    _contentController = TextEditingController(text: widget.noteToEdit?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) return;

    if (widget.noteToEdit == null) {
      widget.notesRepository.addNote(
        title: title,
        content: content,
      );
    } else {
      final updatedNote = widget.noteToEdit!.copyWith(
        title: title,
        content: content,
      );
      widget.notesRepository.updateNote(updatedNote);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.noteToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Nota' : 'Nova Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Conteúdo'),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: Text(isEditing ? 'Salvar Alterações' : 'Criar Nota'),
            ),
          ],
        ),
      ),
    );
  }
}
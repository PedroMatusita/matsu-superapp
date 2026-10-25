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

    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }

    if (widget.noteToEdit == null) {
      widget.notesRepository.addNote(
        title: title.isEmpty ? 'Nota sem título' : title,
        content: content,
      );
    } else {
      final updatedNote = widget.noteToEdit!.copyWith(
        title: title.isEmpty ? 'Nota sem título' : title,
        content: content,
      );
      widget.notesRepository.updateNote(updatedNote);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.amber),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              'Pronto',
              style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              maxLines: null,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              decoration: const InputDecoration(
                hintText: 'Título',
                hintStyle: TextStyle(color: Colors.black26),
                // border: InputBorder.none(),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null, 
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                decoration: const InputDecoration(
                  hintText: 'Comece a digitar...',
                  hintStyle: TextStyle(color: Colors.black26),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
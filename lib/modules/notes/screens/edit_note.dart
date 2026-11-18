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

class _AddEditNoteScreenState extends State<AddEditNoteScreen>
    with WidgetsBindingObserver {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  Note? _workingNote;
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _workingNote = widget.noteToEdit;
    _titleController = TextEditingController(
      text: widget.noteToEdit?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.noteToEdit?.content ?? '',
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _persistCurrentNote();
    }
  }

  Future<void> _persistCurrentNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) return;

    final finalTitle = title.isEmpty ? 'Nota sem título' : title;

    if (_workingNote == null) {
      _workingNote = await widget.notesRepository.addNote(
        title: finalTitle,
        content: content,
      );
    } else {
      final updatedNote = _workingNote!.copyWith(
        title: finalTitle,
        content: content,
      );
      await widget.notesRepository.updateNote(updatedNote);
      _workingNote = updatedNote;
    }
  }

  Future<void> _save() async {
    final navigator = Navigator.of(context);
    await _persistCurrentNote();
    if (!mounted) return;
    setState(() => _allowPop = true);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        await _persistCurrentNote();
        if (!mounted) return;
        setState(() => _allowPop = true);
        navigator.pop();
      },
      child: Scaffold(
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
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
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
      ),
    );
  }
}

  import 'package:flutter/material.dart';
  import '../note.dart';
  import '../note_repo.dart';
  import 'edit_note.dart';

  class ListNotes extends StatefulWidget {
  const ListNotes({super.key});

  @override
  State<ListNotes> createState() => _ListNotesState();
}

  class _ListNotesState extends State<ListNotes> {
  List<Note> _notes = [];
  final NotesRepository _notesRepository = NotesRepository();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    setState(() {
      _notes = _notesRepository.getNotes();
    });
  }

  // Change screens
  void _openAddEditScreen({Note? noteToEdit}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditNoteScreen(
          noteToEdit: noteToEdit,
          notesRepository: _notesRepository,
        ),
      ),
    );

    _loadNotes();
  }

  void _deleteNote(String id) {
    _notesRepository.deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Notas')),
      body: _notes.isEmpty
          ? const Center(child: Text('Nenhuma nota encontrada.'))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final currentNote = _notes[index];
                return ListTile(
                  title: Text(currentNote.title),
                  subtitle: Text(currentNote.content),
                  onTap: () => _openAddEditScreen(noteToEdit: currentNote),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteNote(currentNote.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddEditScreen(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
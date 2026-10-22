import 'note.dart';

class NotesRepository {
  final List<Note> _notes = [];

  List<Note> getNotes() {
    return List.unmodifiable(_notes);
  }

  void addNote({required String title, required String content}) {
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      editedAt: DateTime.now(),
    );
    _notes.add(newNote);
  }

  void updateNote(Note updatedNote) {
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
  }
}
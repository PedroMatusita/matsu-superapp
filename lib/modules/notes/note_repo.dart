import 'note.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotesRepository {
  static const String _notesKey = 'notes_key';

Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString(_notesKey);
    
    if (notesString == null) return [];

    List<dynamic> decodedList = jsonDecode(notesString);
    return decodedList.map((item) => Note.fromJson(item)).toList();
  }

  Future<void> _saveToStorage(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    String encodedList = jsonEncode(notes.map((note) => note.toJson()).toList());
    await prefs.setString(_notesKey, encodedList);
  }

  Future<void> addNote({required String title, required String content}) async {
    final currentNotes = await getNotes();
    
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      editedAt: DateTime.now(),
    );

    currentNotes.add(newNote);
    await _saveToStorage(currentNotes);
  }

  Future<void> updateNote(Note updatedNote) async {
    final currentNotes = await getNotes();
    final index = currentNotes.indexWhere((note) => note.id == updatedNote.id);
    
    if (index != -1) {
      currentNotes[index] = updatedNote;
      await _saveToStorage(currentNotes);
    }
  }

  Future<void> deleteNote(String id) async {
    final currentNotes = await getNotes();
    currentNotes.removeWhere((note) => note.id == id);
    await _saveToStorage(currentNotes);
  }
}
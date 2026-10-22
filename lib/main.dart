import 'package:flutter/material.dart';
import './modules/notes/screens/list_note.dart';

void main() {
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Notas',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ListNotes(),
    );
  }
}
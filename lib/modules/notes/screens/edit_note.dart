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
  final List<NoteBlock> _blocks = [];
  final List<TextEditingController> _blockControllers = [];
  Note? _workingNote;
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _titleController = TextEditingController(
      text: widget.noteToEdit?.title ?? '',
    );
    _workingNote = widget.noteToEdit;
    _blocks.addAll(widget.noteToEdit?.blocks ?? []);
    _blockControllers.addAll(
      _blocks.map((block) => TextEditingController(text: _blockText(block))),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _titleController.dispose();
    for (final controller in _blockControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String _blockText(NoteBlock block) {
    if (block is ChecklistBlock) return block.text;
    return (block as TextBlock).text;
  }

  void _addTextBlock() {
    setState(() {
      _blocks.add(const TextBlock(text: ''));
      _blockControllers.add(TextEditingController());
    });
  }

  void _addChecklistBlock() {
    setState(() {
      _blocks.add(const ChecklistBlock(text: ''));
      _blockControllers.add(TextEditingController());
    });
  }

  void _removeBlock(int index) {
    final controller = _blockControllers.removeAt(index);
    controller.dispose();
    setState(() => _blocks.removeAt(index));
  }

  List<NoteBlock> _currentBlocks() {
    return List.generate(_blocks.length, (index) {
      final block = _blocks[index];
      final text = _blockControllers[index].text;
      if (block is ChecklistBlock) {
        return ChecklistBlock(text: text, isChecked: block.isChecked);
      }
      return TextBlock(text: text);
    });
  }

  void _toggleChecklist(int index, bool value) {
    final block = _blocks[index] as ChecklistBlock;
    setState(() {
      _blocks[index] = block.copyWith(isChecked: value);
    });
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
    final blocks = _currentBlocks();
    final hasContent =
        title.isNotEmpty ||
        blocks.any((block) => _blockText(block).trim().isNotEmpty);

    if (!hasContent) return;

    final finalTitle = title.isEmpty ? 'Nota sem título' : title;
    if (_workingNote == null) {
      _workingNote = await widget.notesRepository.addNote(
        title: finalTitle,
        content: '',
        blocks: blocks,
      );
    } else {
      _workingNote = _workingNote!.copyWith(title: finalTitle, blocks: blocks);
      await widget.notesRepository.updateNote(_workingNote!);
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
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              decoration: const InputDecoration(
                hintText: 'Título',
                hintStyle: TextStyle(color: Colors.black26),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(_blocks.length, _buildBlock),
            const SizedBox(height: 80),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Adicionar texto',
                  onPressed: _addTextBlock,
                  icon: const Icon(Icons.text_fields),
                ),
                IconButton(
                  tooltip: 'Adicionar checklist',
                  onPressed: _addChecklistBlock,
                  icon: const Icon(Icons.check_box_outlined),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlock(int index) {
    final block = _blocks[index];
    if (block is ChecklistBlock) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: block.isChecked,
            activeColor: Colors.amber,
            onChanged: (value) => _toggleChecklist(index, value ?? false),
          ),
          Expanded(
            child: TextField(
              controller: _blockControllers[index],
              minLines: 1,
              maxLines: null,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                decoration: block.isChecked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
              decoration: const InputDecoration(
                hintText: 'Item da checklist',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Remover item',
            onPressed: () => _removeBlock(index),
            icon: const Icon(Icons.close, color: Colors.black38),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _blockControllers[index],
            minLines: 1,
            maxLines: null,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            decoration: const InputDecoration(
              hintText: 'Comece a digitar...',
              border: InputBorder.none,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Remover texto',
          onPressed: () => _removeBlock(index),
          icon: const Icon(Icons.close, color: Colors.black38),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../model/model.dart';

class NoteEditPage extends StatefulWidget {
  final Note note;

  NoteEditPage({required this.note});

  @override
  _NoteEditPageState createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notu Düzenle"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              widget.note.title = _titleController.text;
              widget.note.content = _contentController.text;
              Navigator.pop(context, widget.note);
            },
          ),
        ],
        backgroundColor: Colors.grey[850],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Başlık',
                labelStyle: TextStyle(color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'İçerik',
                labelStyle: TextStyle(color: Colors.grey[600]),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
    );
  }
}

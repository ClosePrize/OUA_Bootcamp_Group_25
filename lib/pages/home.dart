import 'package:flutter/material.dart';
import '../database/database_settings.dart';
import '../model/model.dart';
import 'checklist.dart';
import 'note_edit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final loadedNotes = await _dbHelper.getNotes();
    setState(() {
      notes = loadedNotes;
    });
  }

  void _addNewNote() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Not türünü seçin!'),
        content: Text('Lütfen oluşturmak istediğiniz not türünü seçiniz!'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              final newNote = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditPage(note: Note(title: '', content: '', type: NoteType.standard)),
                ),
              );

              if (newNote != null) {
                await _dbHelper.insertNote(newNote);
                _loadNotes();
              }
            },
            child: Text('Standart Not'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              final newNote = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChecklistEditPage(),
                ),
              );

              if (newNote != null) {
                await _dbHelper.insertNote(newNote);
                _loadNotes();
              }
            },
            child: Text('Checklist Not'),
          ),
        ],
      ),
    );
  }

  void _editNote(Note note) async {
    final updatedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (note.type == NoteType.standard) {
            return NoteEditPage(note: note);
          } else {
            return ChecklistEditPage(checklistNote: note);
          }
        },
      ),
    );

    if (updatedNote != null) {
      await _dbHelper.updateNote(updatedNote);
      _loadNotes();
    }
  }

  void _deleteNote(Note note) async {
    await _dbHelper.deleteNote(note.id!);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Notlarım",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[850],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              color: Colors.grey[200],
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    notes[index].title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                ),
                onTap: () => _editNote(notes[index]),
                subtitle: Text(
                  notes[index].type == NoteType.checklist
                      ? 'Checklist Not'
                      : 'Standard Not',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteNote(notes[index]),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.grey[800]),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: Colors.grey[850],
        onPressed: _addNewNote,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Not Ekle',
      ),
    );
  }
}

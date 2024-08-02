import 'package:flutter/material.dart';
import '../model/model.dart';

class ChecklistEditPage extends StatefulWidget {
  final Note? checklistNote;

  ChecklistEditPage({this.checklistNote});

  @override
  _ChecklistEditPageState createState() => _ChecklistEditPageState();
}

class _ChecklistEditPageState extends State<ChecklistEditPage> {
  List<ChecklistItem> _items = [];
  final TextEditingController _newItemController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.checklistNote != null) {
      _initializeFromExistingNote();
    }
  }

  void _initializeFromExistingNote() {
    final lines = widget.checklistNote!.content.split('\n');
    for (var line in lines) {
      final isDone = line.startsWith('[x]');
      final title = line.replaceFirst(isDone ? '[x] ' : '[ ] ', '');
      _items.add(ChecklistItem(title: title, isDone: isDone));
    }
    _titleController.text = widget.checklistNote!.title;
  }

  void _addItem() {
    if (_newItemController.text.isNotEmpty) {
      setState(() {
        _items.add(ChecklistItem(title: _newItemController.text));
        _newItemController.clear();
      });
    }
  }

  void _saveChecklist() {
    final checklistNote = Note(
      id: widget.checklistNote?.id,
      title: _titleController.text.isNotEmpty ? _titleController.text : 'Checklist',
      content: _items.map((item) => '${item.isDone ? '[x]' : '[ ]'} ${item.title}').join('\n'),
      type: NoteType.checklist,
    );
    Navigator.pop(context, checklistNote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checklist Düzenle'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveChecklist,
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
            TextField(
              controller: _newItemController,
              decoration: InputDecoration(
                labelText: 'Yeni madde',
                labelStyle: TextStyle(color: Colors.grey[600]),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add, color: Colors.grey[600]),
                  onPressed: _addItem,
                ),
              ),
              onSubmitted: (value) => _addItem(),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(
                      _items[index].title,
                      style: TextStyle(
                        decoration: _items[index].isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: Colors.grey[800],
                      ),
                    ),
                    value: _items[index].isDone,
                    onChanged: (value) {
                      setState(() {
                        _items[index].isDone = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

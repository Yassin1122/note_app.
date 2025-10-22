import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main.dart';
import 'note.dart';

class UpdatePage extends StatefulWidget {
  UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}
class _UpdatePageState extends State<UpdatePage> {
  late Note note;

  late final titleController = TextEditingController();

  late final contentController = TextEditingController();
  @override
  void initState(){
    super.initState();
    note = Get.arguments as Note;

  }

  @override
  Widget build(BuildContext context) {


    print("Note before update/delete: ${note.id}, ${note.title}");
    titleController.text = note.title;
    contentController.text = note.content;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update / Delete Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: "Content"),
            ),
            const SizedBox(height: 20),

            // زرار التحديث
            ElevatedButton(
              onPressed: () async {
                final updatedNote = Note(
                  id: note.id, // مهم جدًا علشان الـ update
                  title: titleController.text,
                  content: contentController.text,
                  date: DateTime.now().toString(),
                  lat: note.lat,
                  lng: note.lng,
                );

                await database.noteDao.updateNote(updatedNote);

                setState(() {

                });
                Get.back();
              },
              child: const Text("Update"),
            ),
            const SizedBox(height: 10),

            // زرار الحذف
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await database.noteDao.deleteNote(note);
                setState(() {

                });

                Get.back();
              },
              child: const Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadNote() async {
    var result = await database.noteDao.getAllNotes();
  }
}

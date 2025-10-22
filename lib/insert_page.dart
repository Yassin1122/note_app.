import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import 'main.dart';
import 'note.dart';

class InsertPage extends StatelessWidget {
  InsertPage({super.key});

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final useLocation = false.obs;
  final lat = RxnDouble();
  final lng = RxnDouble();


  final title = "".obs;
  final content = "".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              onChanged: (val) => title.value = val,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: contentController,
              onChanged: (val) => content.value = val,
              decoration: const InputDecoration(labelText: "Content"),
            ),
            Obx(() => Row(
              children: [
                Checkbox(
                  value: useLocation.value,
                  onChanged: (a) async {
                    useLocation.value = a ?? false;

                  },
                ),
                const Text("Use my location"),
              ],
            )),
            const SizedBox(height: 20),
            Obx(() => ElevatedButton(
              onPressed: (title.isNotEmpty && content.isNotEmpty)
                  ? () async { if (useLocation.value) {
                Position pos =
                await Geolocator.getCurrentPosition();
                lat.value = pos.latitude;
                lng.value = pos.longitude;

              }
              final newNote = Note(
                title: titleController.text,
                content: contentController.text,
                date: DateTime.now().toString(),
                lat: lat.value,
                lng: lng.value,
              );

              await database.noteDao.insertNote(newNote);

              titleController.clear();
              contentController.clear();
              title.value = "";
              content.value = "";
              useLocation.value = false;
              lat.value = null;
              lng.value = null;

              Get.back();
              }
                  : null,
              child: const Text("Save"),
            ))
            ,
          ],
        ),
      ),
    );
  }
}

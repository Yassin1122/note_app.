import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'note.dart';
import 'main.dart';
import 'notes_dao.dart';
import 'note_database.dart';
import 'insert_page.dart';
import 'updatePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final allNotes = <Note>[].obs;
  double lastShakeTime = 0;

  @override
  void initState() {
    super.initState();
    loadNote();
    setupShakeListener();
  }

  Future<void> loadNote() async {
    var result = await database.noteDao.getAllNotes();
    print("📋 Loaded notes:");
    for (var n in result) {
      print("${n.id}: ${n.title} -> ${n.lat}, ${n.lng}");
    }
    allNotes.assignAll(result);
  }

  void setupShakeListener() {
    accelerometerEvents.listen((event) async {
      double gX = event.x / 9.8;
      double gY = event.y / 9.8;
      double gZ = event.z / 9.8;
      double gForce =
      (gX * gX + gY * gY + gZ * gZ).clamp(0, double.infinity).toDouble();

      // حساسية الاهتزاز
      if (gForce > 3) {
        double now = DateTime
            .now()
            .millisecondsSinceEpoch
            .toDouble();

        // علشان ما يمسحش أكتر من مرة متتالية بسرعة
        if (now - lastShakeTime > 1500) {
          lastShakeTime = now;
          await database.noteDao.deleteAllNotes();
          allNotes.clear();
          Get.snackbar("تم", "تم مسح جميع الملاحظات بالهز!",
              snackPosition: SnackPosition.BOTTOM);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: const Text(
        "Note App",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
    ),
      body: SafeArea(
        child: Obx(() {
          return ListView.builder(
            itemCount: allNotes.length,
            itemBuilder: (context, index) {
              final note = allNotes[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 2,
                child: ListTile(
                  onTap: () async {
                    await Get.to(() => UpdatePage(), arguments: note);
                    await loadNote();
                  },
                  title: Text(
                    note.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(note.content),
                      const SizedBox(height: 5),
                      Text(
                        note.date,
                        style:
                        const TextStyle(fontSize: 12, color: Colors.grey),
                      ),


                      if ((note.lat ?? 0) != 0 && (note.lng ?? 0) != 0)

                        Text(
                          "Lat: ${note.lat ?? 0}, Lng: ${note.lng ?? 0}",
                          style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                        ),

                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Get.to(() => InsertPage());
          loadNote();

        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("إضافة ملاحظة"),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

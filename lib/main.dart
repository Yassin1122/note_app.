import 'dart:io';
import 'package:get/get.dart';
import 'package:note_app/home_page.dart';

import 'note.dart';
import 'note_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
Future<void> copyDatabase() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path,'notes.db');

  // لو الملف موجود خلاص اخرج
  if (await File(path).exists()) return;

  // لو مش موجود انسخه من assets
  ByteData data = await rootBundle.load("assets/databases/notes.db");
  List<int> bytes =
  data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  await File(path).writeAsBytes(bytes, flush: true);
}Future<void> initDatabase() async {
  await copyDatabase();

  //connect to database
  final dir = await getApplicationDocumentsDirectory();
  final dbPath = join(dir.path, 'notes.db');

  database = await $FloorNoteDatabase.databaseBuilder(dbPath).build();
  var data = await database.noteDao.getAllNotes();
  print('---------------------------------------------');
  print("-----------$data");
  // await database.noteDao.insertNote(
  //  Note(title: 'Test Note', content: 'Hello from Floor!', date: '2025-10-04'),
  // );

  // جلب كل الـ Notes للتأكد
  final notes = await database.noteDao.getAllNotes();
  print('All Notes: $notes');

  for (var note in notes) {
    print('Title: ${note.title}, Content: ${note.content}, Date: ${note.date}');
  }
}
late final NoteDatabase database;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner:false,home:HomePage(),);}}

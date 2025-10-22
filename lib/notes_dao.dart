import 'package:floor/floor.dart';
import 'note.dart';


@dao
abstract class NoteDao {
  @Query('SELECT * FROM notes')
  Future<List<Note>> getAllNotes();

  @insert
  Future<void> insertNote(Note note);

  @update
  Future<void> updateNote(Note note);

  @delete
  Future<void> deleteNote(Note note);

  @Query('DELETE FROM notes')
  Future<void> deleteAllNotes();
}

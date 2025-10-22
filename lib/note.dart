import 'package:floor/floor.dart';

@Entity(tableName: 'notes')
class Note {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String title;
  final String content;
  final String date;
  final double? lat;
  final double? lng;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    this.lat,
    this.lng,
  });
}

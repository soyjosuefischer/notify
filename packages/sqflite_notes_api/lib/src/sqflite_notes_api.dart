import 'package:notes_api/notes_api.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteNotesApi implements NotesApi {
  const SqfliteNotesApi({
    required Database database,
    required String table,
  })  : _db = database,
        _table = table;

  final Database _db;
  final String _table;

  @override
  Future<void> createNote(Note note) async {
    await _db.insert(
      _table,
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateNote(Note note) async {
    await _db.update(
      _table,
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  @override
  Future<void> deleteNote(String id) async {
    await _db.delete(
      _table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Note>> getAllNotes() async {
    final result = await _db.query(
      _table,
      orderBy: 'date DESC',
    );
    if (result.isEmpty) return [];
    return result.map<Note>((map) => Note.fromJson(map)).toList();
  }

  @override
  Future<Note?> getNote(String id) async {
    final result = await _db.query(
      _table,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return Note.fromJson(result.first);
  }
}

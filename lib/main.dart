import 'package:flutter/material.dart';
import 'package:notify/app/app.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite_notes_api/sqflite_notes_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await openDatabase(
    join(await getDatabasesPath(), 'notes.db'),
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE notes(id TEXT PRIMARY KEY,title TEXT,content TEXT,date TEXT)',
      );
    },
  );
  final sqfliteNotesApi = SqfliteNotesApi(database: database, table: 'notes');
  final notesRepository = NotesRepository(notesApi: sqfliteNotesApi);

  runApp(
    App(notesRepository: notesRepository),
  );
}

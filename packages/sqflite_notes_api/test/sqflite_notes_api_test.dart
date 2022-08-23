import 'package:mocktail/mocktail.dart';
import 'package:notes_api/notes_api.dart';
import 'package:sqflite_notes_api/sqflite_notes_api.dart';
import 'package:test/test.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  group('SqfliteNotesApi', () {
    late Database db;

    final note =
        Note(id: 'id1', title: 'title1', content: 'content1', date: '2022');
    final note2 =
        Note(id: 'id2', title: 'title2', content: 'content2', date: '2022');

    SqfliteNotesApi createApi() =>
        SqfliteNotesApi(database: db, table: 'notes');

    setUp(() {
      db = MockDatabase();
      when(() => db.insert(
            any(),
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          )).thenAnswer((_) async => 1);
      when(() => db.update(
            any(),
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          )).thenAnswer((_) async => 1);
      when(() => db.delete(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          )).thenAnswer((_) async => 1);
    });

    group('constructor', () {
      test('works properly', () {
        expect(
          () => createApi(),
          returnsNormally,
        );
      });
    });

    group('addNote', () {
      test('inserts note into database', () async {
        final sut = createApi();
        await expectLater(sut.createNote(note), completes);

        verify(() => db.insert(
              'notes',
              note.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            )).called(1);
      });
    });

    group('updateNote', () {
      test('updates note in database', () async {
        final sut = createApi();
        await expectLater(sut.updateNote(note), completes);

        verify(() => db.update(
              'notes',
              note.toJson(),
              where: 'id = ?',
              whereArgs: [note.id],
            )).called(1);
      });
    });

    group('deleteNote', () {
      test('deletes note from database', () async {
        final sut = createApi();
        await expectLater(sut.deleteNote(note.id), completes);

        verify(() => db.delete(
              'notes',
              where: 'id = ?',
              whereArgs: [note.id],
            )).called(1);
      });
    });

    group('getAllNotes', () {
      test('returns all notes from database', () async {
        when(() => db.query(any(), orderBy: any(named: 'orderBy')))
            .thenAnswer((_) async => [note.toJson(), note2.toJson()]);

        final sut = createApi();
        final result = await sut.getAllNotes();
        expect(result, equals([note, note2]));

        verify(() => db.query(
              'notes',
              orderBy: 'date DESC',
            )).called(1);
      });

      test('returns empty list when no notes found', () async {
        when(() => db.query(any(), orderBy: any(named: 'orderBy')))
            .thenAnswer((_) async => []);

        final sut = createApi();
        final result = await sut.getAllNotes();
        expect(result.isEmpty, true);

        verify(() => db.query(
              'notes',
              orderBy: 'date DESC',
            )).called(1);
      });
    });

    group('getNote', () {
      test('returns note when found', () async {
        when(() => db.query(
              any(),
              where: any(named: 'where'),
              whereArgs: any(named: 'whereArgs'),
            )).thenAnswer((_) async => [note.toJson()]);

        final sut = createApi();
        final result = await sut.getNote(note.id);
        expect(result, equals(note));

        verify(() => db.query(
              'notes',
              where: 'id = ?',
              whereArgs: [note.id],
            )).called(1);
      });

      test('returns null when note not found', () async {
        when(() => db.query(
              any(),
              where: any(named: 'where'),
              whereArgs: any(named: 'whereArgs'),
            )).thenAnswer((_) async => []);

        final sut = createApi();
        final result = await sut.getNote(note.id);
        expect(result, isNull);

        verify(() => db.query(
              'notes',
              where: 'id = ?',
              whereArgs: [note.id],
            )).called(1);
      });
    });
  });
}

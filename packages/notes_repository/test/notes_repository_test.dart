import 'package:mocktail/mocktail.dart';
import 'package:notes_api/notes_api.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:test/test.dart';

class MockNotesApi extends Mock implements NotesApi {}

class FakeNote extends Fake implements Note {}

void main() {
  group('NotesRepository', () {
    late NotesApi notesApi;

    final note = Note(title: 'title');

    NotesRepository createRepository() => NotesRepository(notesApi: notesApi);

    setUp(() {
      notesApi = MockNotesApi();

      when(() => notesApi.createNote(any())).thenAnswer((_) async {});
      when(() => notesApi.updateNote(any())).thenAnswer((_) async {});
      when(() => notesApi.deleteNote(any())).thenAnswer((_) async {});
      when(() => notesApi.getAllNotes()).thenAnswer((_) async => [note]);
      when(() => notesApi.getNote(any())).thenAnswer((_) async => note);
    });

    setUpAll(() {
      registerFallbackValue(FakeNote());
    });

    group('constructor', () {
      test('works properly', () {
        expect(
          () => createRepository(),
          returnsNormally,
        );
      });
    });

    group('addNote', () {
      test('saves note using api', () {
        final sut = createRepository();

        expect(sut.createNote(note), completes);
        verify(() => notesApi.createNote(note)).called(1);
      });
    });

    group('updateNote', () {
      test('updates note using api', () {
        final sut = createRepository();

        expect(sut.updateNote(note), completes);
        verify(() => notesApi.updateNote(note)).called(1);
      });
    });

    group('deleteNote', () {
      test('deletes note using api', () {
        final sut = createRepository();

        expect(sut.deleteNote(note.id), completes);
        verify(() => notesApi.deleteNote(note.id)).called(1);
      });
    });

    group('getAllNotes', () {
      test('gets all notes using api', () async {
        final sut = createRepository();

        expect(
          await sut.getAllNotes(),
          equals([note]),
        );
        verify(() => notesApi.getAllNotes()).called(1);
      });
    });

    group('getNote', () {
      test('gets note by id using api', () async {
        final sut = createRepository();

        expect(
          await sut.getNote(note.id),
          equals(note),
        );
        verify(() => notesApi.getNote(note.id)).called(1);
      });
    });
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notify/note/note.dart';
import 'package:notes_repository/notes_repository.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  group('NoteCubit', () {
    late NotesRepository notesRepository;

    setUp(() {
      notesRepository = MockNotesRepository();
    });

    NoteCubit createCubit() => NoteCubit(notesRepository);

    group('constructor', () {
      test('works properly', () {
        expect(() => createCubit(), returnsNormally);
      });

      test('initial state is correct', () {
        expect(createCubit().state, equals(const NoteState()));
      });
    });

    group('getNote', () {
      final note = Note(id: 'id', title: 'title');

      blocTest<NoteCubit, NoteState>(
        'emits state with success status and note',
        setUp: () {
          when(() => notesRepository.getNote(any()))
              .thenAnswer((_) async => note);
        },
        build: () => createCubit(),
        act: (cubit) => cubit.getNote('id'),
        expect: () => [
          const NoteState(status: NoteStatus.loading),
          NoteState(status: NoteStatus.success, note: note),
        ],
        verify: (_) {
          verify(() => notesRepository.getNote('id')).called(1);
        },
      );

      blocTest<NoteCubit, NoteState>(
        'emits state with not found status',
        setUp: () {
          when(() => notesRepository.getNote(any()))
              .thenAnswer((_) async => null);
        },
        build: () => createCubit(),
        act: (cubit) => cubit.getNote('id'),
        expect: () => [
          const NoteState(status: NoteStatus.loading),
          const NoteState(status: NoteStatus.notFound),
        ],
        verify: (_) {
          verify(() => notesRepository.getNote('id')).called(1);
        },
      );

      blocTest<NoteCubit, NoteState>(
        'emits state with failure status and error message',
        setUp: () {
          when(() => notesRepository.getNote(any()))
              .thenThrow(Exception('failure'));
        },
        build: () => createCubit(),
        act: (cubit) => cubit.getNote('id'),
        expect: () => [
          const NoteState(status: NoteStatus.loading),
          const NoteState(
            status: NoteStatus.failure,
            errorMessage: 'Exception: failure',
          ),
        ],
        verify: (_) {
          verify(() => notesRepository.getNote('id')).called(1);
        },
      );
    });
  });
}

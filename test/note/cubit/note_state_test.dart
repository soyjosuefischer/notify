import 'package:flutter_test/flutter_test.dart';
import 'package:notify/note/note.dart';
import 'package:notes_repository/notes_repository.dart';

void main() {
  group('NoteState', () {
    NoteState createState() => const NoteState();

    test('constructor works properly', () {
      expect(() => createState(), returnsNormally);
    });

    test('supports value equality', () {
      expect(createState(), equals(createState()));
    });

    test('props are correct', () {
      expect(
        createState().props,
        equals([NoteStatus.loading, null, '']),
      );
    });

    group('copyWith', () {
      final note = Note(title: 'title');

      test('returns the same object if no arguments are provided', () {
        expect(
          createState().copyWith(),
          equals(createState()),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          createState().copyWith(status: null, note: null, errorMessage: null),
          equals(createState()),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          createState().copyWith(
            status: NoteStatus.failure,
            note: note,
            errorMessage: 'failure',
          ),
          equals(
            NoteState(
              status: NoteStatus.failure,
              note: note,
              errorMessage: 'failure',
            ),
          ),
        );
      });
    });
  });
}

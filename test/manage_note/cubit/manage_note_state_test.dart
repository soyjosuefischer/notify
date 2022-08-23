import 'package:flutter_test/flutter_test.dart';
import 'package:notify/manage_note/cubit/manage_note_cubit.dart';
import 'package:notes_repository/notes_repository.dart';

void main() {
  group('ManageNoteState', () {
    final note = Note(title: 'title');
    ManageNoteState createState({Note? note}) => ManageNoteState(note: note);

    test('constructor works properly', () {
      expect(() => createState(), returnsNormally);
    });

    test('supports value equality', () {
      expect(createState(note: note), equals(createState(note: note)));
    });

    test('props are correct', () {
      expect(
        createState(note: note).props,
        equals([ManageNoteStatus.initial, ManageNoteMode.update, note, '']),
      );
    });

    test('creates new note when note is not provided', () {
      expect(createState().note, isA<Note>());
    });

    test('sets create mode when note is not provided', () {
      expect(createState().mode, equals(ManageNoteMode.create));
    });

    test('sets update mode when note is provided', () {
      expect(createState(note: note).mode, equals(ManageNoteMode.update));
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createState(note: note).copyWith(),
          equals(createState(note: note)),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          createState(note: note).copyWith(
            status: null,
            mode: null,
            note: null,
            errorMessage: null,
          ),
          equals(createState(note: note)),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          createState().copyWith(
            status: ManageNoteStatus.failure,
            mode: ManageNoteMode.update,
            note: note,
            errorMessage: 'failure',
          ),
          equals(
            ManageNoteState(
              status: ManageNoteStatus.failure,
              mode: ManageNoteMode.update,
              note: note,
              errorMessage: 'failure',
            ),
          ),
        );
      });
    });
  });
}

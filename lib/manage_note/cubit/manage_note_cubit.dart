import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_repository/notes_repository.dart';

part 'manage_note_state.dart';

class ManageNoteCubit extends Cubit<ManageNoteState> {
  ManageNoteCubit({
    required NotesRepository notesRepository,
    Note? note,
  })  : _notesRepository = notesRepository,
        super(ManageNoteState(note: note));

  final NotesRepository _notesRepository;

  void onTitleChanged(String title) {
    final note = state.note.copyWith(title: title);
    emit(
      state.copyWith(
        note: note,
        status: ManageNoteStatus.initial,
      ),
    );
  }

  void onContentChanged(String content) {
    final note = state.note.copyWith(content: content);
    emit(
      state.copyWith(
        note: note,
        status: ManageNoteStatus.initial,
      ),
    );
  }

  void createNote() async {
    if (state.note.title.isEmpty) {
      emit(state.copyWith(status: ManageNoteStatus.empty));
      return;
    }
    emit(state.copyWith(status: ManageNoteStatus.loading));
    try {
      await _notesRepository.createNote(state.note);
      emit(state.copyWith(status: ManageNoteStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ManageNoteStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void updateNote() async {
    if (state.note.title.isEmpty) {
      emit(state.copyWith(status: ManageNoteStatus.empty));
      return;
    }
    emit(state.copyWith(status: ManageNoteStatus.loading));
    try {
      await _notesRepository.updateNote(state.note);
      emit(state.copyWith(status: ManageNoteStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ManageNoteStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}

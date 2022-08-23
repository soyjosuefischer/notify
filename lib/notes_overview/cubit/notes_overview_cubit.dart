import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_repository/notes_repository.dart';

part 'notes_overview_state.dart';

class NotesOverviewCubit extends Cubit<NotesOverviewState> {
  NotesOverviewCubit(this._notesRepository) : super(const NotesOverviewState());

  final NotesRepository _notesRepository;

  void getNotes() async {
    emit(state.copyWith(status: NotesOverviewStatus.loading));
    try {
      final notes = await _notesRepository.getAllNotes();
      emit(
        state.copyWith(
          status: NotesOverviewStatus.success,
          notes: notes,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotesOverviewStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void deleteNote(String id) async {
    emit(state.copyWith(status: NotesOverviewStatus.loading));
    try {
      await _notesRepository.deleteNote(id);
      emit(
        state.copyWith(status: NotesOverviewStatus.success),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotesOverviewStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void turnOnSearch() {
    emit(
      state.copyWith(
        status: NotesOverviewStatus.search,
        filteredNotes: const [],
      ),
    );
  }

  void turnOffSearch() {
    emit(
      state.copyWith(
        status: NotesOverviewStatus.success,
      ),
    );
  }

  void search(String pattern) {
    if (pattern.isEmpty) {
      emit(state.copyWith(filteredNotes: const []));
      return;
    }
    final filteredList = state.notes
        .where(
            (note) => note.title.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
    emit(state.copyWith(filteredNotes: filteredList));
  }

  void clearSearch() {
    emit(state.copyWith(filteredNotes: const []));
  }
}

part of 'notes_overview_cubit.dart';

enum NotesOverviewStatus { loading, success, failure, search }

class NotesOverviewState extends Equatable {
  const NotesOverviewState({
    this.status = NotesOverviewStatus.loading,
    this.notes = const [],
    this.filteredNotes = const [],
    this.errorMessage = '',
  });

  final NotesOverviewStatus status;
  final List<Note> notes;
  final List<Note> filteredNotes;
  final String errorMessage;

  @override
  List<Object> get props => [status, notes, filteredNotes, errorMessage];

  NotesOverviewState copyWith({
    NotesOverviewStatus? status,
    List<Note>? notes,
    List<Note>? filteredNotes,
    String? errorMessage,
  }) {
    return NotesOverviewState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

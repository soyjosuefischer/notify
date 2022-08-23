import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/common/common.dart';
import 'package:notes_app/manage_note/manage_note.dart';
import 'package:notes_app/note/note.dart';
import 'package:notes_app/notes_overview/cubit/notes_overview_cubit.dart';
import 'package:notes_repository/notes_repository.dart';

class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesOverviewCubit(
        context.read<NotesRepository>(),
      )..getNotes(),
      child: const NotesOverviewView(),
    );
  }
}

class NotesOverviewView extends StatelessWidget {
  const NotesOverviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _SearchAppBar(),
      floatingActionButton: const _FloatingActionButton(),
      body: BlocConsumer<NotesOverviewCubit, NotesOverviewState>(
        listener: (context, state) {
          if (state.status == NotesOverviewStatus.failure) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: SnackBarMessage(message: state.errorMessage),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.status == NotesOverviewStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          if (state.status == NotesOverviewStatus.success) {
            return _MasonryGridView(notes: state.notes);
          }
          if (state.status == NotesOverviewStatus.search) {
            return _MasonryGridView(notes: state.filteredNotes);
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesOverviewCubit, NotesOverviewState>(
      builder: (context, state) {
        if (state.status == NotesOverviewStatus.search) {
          return const SizedBox();
        }
        return FloatingActionButton(
          child: const Icon(Icons.add_rounded, size: 30),
          onPressed: () {
            Navigator.of(context)
                .push<void>(ManageNotePage.route())
                .then((_) => context.read<NotesOverviewCubit>().getNotes());
          },
        );
      },
    );
  }
}

class _SearchAppBar extends StatelessWidget with PreferredSizeWidget {
  const _SearchAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return BlocBuilder<NotesOverviewCubit, NotesOverviewState>(
      builder: (context, state) {
        if (state.status == NotesOverviewStatus.search) {
          return AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 30),
              onPressed: () {
                searchController.clear();
                context.read<NotesOverviewCubit>().turnOffSearch();
              },
            ),
            centerTitle: true,
            title: SizedBox(
              width: double.infinity,
              child: TextField(
                controller: searchController,
                onChanged: ((text) {
                  context.read<NotesOverviewCubit>().search(text);
                }),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.grey),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, size: 30),
                    onPressed: () {
                      searchController.clear();
                      context.read<NotesOverviewCubit>().clearSearch();
                    },
                  ),
                  hintText: AppLocalizations.of(context)!.searchNotesHintText,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          );
        }
        searchController.clear();
        return AppBar(
          title: Text(AppLocalizations.of(context)!.notesAppBarTitle),
          actions: [
            CustomElevatedButton(
              widget: const Icon(Icons.search, size: 30),
              onPressed: () {
                context.read<NotesOverviewCubit>().turnOnSearch();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, kAppBarHeight);
}

class _MasonryGridView extends StatelessWidget {
  const _MasonryGridView({
    Key? key,
    required this.notes,
  }) : super(key: key);

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      itemCount: notes.length,
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.symmetric(horizontal: kSidePadding),
      itemBuilder: (context, index) {
        return _NoteCard(
          note: notes[index],
          color: colorPalette[Random().nextInt(colorPalette.length)],
          onTap: () {
            Navigator.of(context)
                .push<void>(NotePage.route(id: notes[index].id))
                .then((_) => context.read<NotesOverviewCubit>().getNotes());
          },
          onLongPress: () {
            showDialog(
                    context: context,
                    builder: (_) =>
                        _DeleteDialog(context: context, id: notes[index].id))
                .then((_) => context.read<NotesOverviewCubit>().getNotes());
          },
        );
      },
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;
  final Color color;
  final Function() onTap;
  final Function() onLongPress;

  const _NoteCard({
    required this.note,
    required this.color,
    required this.onTap,
    required this.onLongPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 10.0),
                Text(
                  DateFormat('MMM dd, yyyy',
                          AppLocalizations.of(context)!.localeName)
                      .format(DateTime.parse(note.date)),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog({
    Key? key,
    required this.context,
    required this.id,
  }) : super(key: key);

  final BuildContext context;
  final String id;

  @override
  Widget build(BuildContext ctx) {
    return SimpleDialog(
      backgroundColor: kButtonColor,
      contentPadding: const EdgeInsets.all(8),
      children: [
        SimpleDialogOption(
          onPressed: () {
            context.read<NotesOverviewCubit>().deleteNote(id);
            Navigator.of(context).pop<void>();
          },
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.delete,
            size: 30.0,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

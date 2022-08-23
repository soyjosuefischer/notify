import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:notify/common/common.dart';
import 'package:notify/manage_note/manage_note.dart';
import 'package:notify/note/note.dart';
import 'package:notes_repository/notes_repository.dart';

class NotePage extends StatelessWidget {
  const NotePage({Key? key}) : super(key: key);

  static Route route({required String id}) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) =>
              NoteCubit(context.read<NotesRepository>())..getNote(id),
          child: const NotePage(),
        );
      },
      settings: const RouteSettings(name: '/note'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: kLeadingWidth,
        leading: CustomElevatedButton(
          widget: const Icon(Icons.arrow_back_ios, size: 30),
          onPressed: () => Navigator.of(context).pop<void>(),
        ),
        actions: [
          CustomElevatedButton(
            widget: const Icon(Icons.edit, size: 30),
            onPressed: () {
              if (context.read<NoteCubit>().state.note != null) {
                Navigator.of(context)
                    .push<void>(ManageNotePage.route(
                        note: context.read<NoteCubit>().state.note))
                    .then((_) => context
                        .read<NoteCubit>()
                        .getNote(context.read<NoteCubit>().state.note!.id));
              }
            },
          ),
        ],
      ),
      body: BlocConsumer<NoteCubit, NoteState>(
        listener: (context, state) {
          if (state.status == NoteStatus.failure) {
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
          if (state.status == NoteStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          if (state.status == NoteStatus.notFound) {
            return const Center(
              child: Icon(Icons.warning),
            );
          }
          if (state.status == NoteStatus.success) {
            return _NotePreview(note: state.note!);
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _NotePreview extends StatelessWidget {
  const _NotePreview({Key? key, required this.note}) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: kSidePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          Text(
            note.title,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.white,
                  height: 1.2,
                ),
          ),
          const SizedBox(height: 16.0),
          Text(
            DateFormat('MMM dd, yyyy', AppLocalizations.of(context)!.localeName)
                .format(DateTime.parse(note.date)),
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 16.0),
          Text(
            note.content,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notes_app/common/common.dart';
import 'package:notes_app/notes_overview/notes_overview.dart';
import 'package:notes_repository/notes_repository.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.notesRepository,
  }) : super(key: key);

  final NotesRepository notesRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: notesRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notify',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.grey.shade900,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          toolbarHeight: kAppBarHeight,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(color: Colors.white),
        ),
        scaffoldBackgroundColor: Colors.grey.shade900,
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: kButtonColor),
      ),
      home: const NotesOverviewPage(),
    );
  }
}

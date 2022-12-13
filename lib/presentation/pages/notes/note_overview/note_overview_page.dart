import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_ddd/application/auth/auth_bloc.dart';
import 'package:my_flutter_ddd/application/notes/note_actor/note_actor_bloc.dart';
import 'package:my_flutter_ddd/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:my_flutter_ddd/injection.dart';
import 'package:my_flutter_ddd/presentation/pages/notes/note_overview/widgets/notes_overview_body_widget.dart';
import 'package:my_flutter_ddd/presentation/pages/notes/note_overview/widgets/uncompleted_switch.dart';
import 'package:my_flutter_ddd/presentation/pages/routes/router.gr.dart';

class NotesOverviewPage extends HookWidget implements AutoRouteWrapper {
  const NotesOverviewPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteWatcherBloc>(
          create: (context) => getIt<NoteWatcherBloc>()
            ..add(const NoteWatcherEvent.watchAllStarted()),
        ),
        BlocProvider<NoteActorBloc>(
          create: (context) => getIt<NoteActorBloc>(),
        ),
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            state.maybeMap(
              unauthenticated: (_) {
                // todo(thanh): navigate to signInPage
                // Router.navigator.pushReplacementNamed(Router.signInPage),
                context.replaceRoute(const SignInRoute());
              },
              orElse: () {},
            );
          },
        ),
        BlocListener<NoteActorBloc, NoteActorState>(
          listener: (context, state) {
            state.maybeMap(
              deleteFailure: (state) {
                FlushbarHelper.createError(
                  duration: const Duration(seconds: 5),
                  message: state.noteFailure.map(
                      // Use localized strings here in your apps
                      insufficientPermissions: (_) =>
                          'Insufficient permissions ❌',
                      unableToUpdate: (_) => 'Impossible error',
                      unexpected: (_) =>
                          'Unexpected error occured while deleting, please contact support.'),
                ).show(context);
              },
              orElse: () {},
            );
          },
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEvent.signedOut());
            },
          ),
          actions: const [
            UncompletedSwitch(),
          ],
        ),
        body: const NotesOverviewBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // todo(thanh): push to form page
            // Router.navigator.pushNamed(
            //   Router.noteFormPage,
            //   arguments: NoteFormPageArguments(editedNote: null),
            // );
            // context.pushRoute(NoteFormRoute(editedNote: null));
            context.router.push(NoteFormRoute(editedNote: null));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

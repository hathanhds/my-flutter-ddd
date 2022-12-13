import 'package:auto_route/auto_route.dart';
import 'package:my_flutter_ddd/presentation/pages/notes/note_form/note_form_page.dart';
import 'package:my_flutter_ddd/presentation/pages/notes/note_overview/note_overview_page.dart';
import 'package:my_flutter_ddd/presentation/pages/sign_in/sign_in_page.dart';
import 'package:my_flutter_ddd/presentation/pages/splash/splash_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: SignInPage),
    MaterialRoute(page: NotesOverviewPage),
    MaterialRoute(page: NoteFormPage, fullscreenDialog: true),
  ],
)
class $AppRouter {}

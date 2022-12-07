import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_ddd/application/auth/auth_bloc.dart';
import 'package:my_flutter_ddd/injection.dart';
import 'package:my_flutter_ddd/presentation/pages/routes/router.gr.dart';

final appRouter = AppRouter();

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AuthBloc>()..add(const AuthEvent.authCheckRequested()),
      child: MaterialApp.router(
        title: 'Workout Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.green[800],
          appBarTheme: ThemeData.light().appBarTheme.copyWith(
                color: Colors.green[800],
                iconTheme: ThemeData.dark().iconTheme,
              ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue[900],
            foregroundColor: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser(),
      ),
    );
  }
}

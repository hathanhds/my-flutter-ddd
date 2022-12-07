import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:my_flutter_ddd/domain/auth/i_auth_facade.dart';
import 'package:my_flutter_ddd/domain/auth/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;

  AuthBloc(this._authFacade) : super(const AuthState.initial()) {
    on<AuthEvent>(_onEvent);
  }

  Future<void> _onEvent(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    await event.map(authCheckRequested: (e) async {
      final userOption = await _authFacade.getSignedInUser();
      userOption.fold(
        () => emit(const AuthState.unauthenticated()),
        (user) => emit(AuthState.authenticated(user)),
      );
    }, signedOut: (e) async {
      await _authFacade.signOut();
      emit(const AuthState.unauthenticated());
    });
  }
}

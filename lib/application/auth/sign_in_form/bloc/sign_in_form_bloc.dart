import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:my_flutter_ddd/domain/auth/auth_failure.dart';
import 'package:my_flutter_ddd/domain/auth/i_auth_facade.dart';
import 'package:my_flutter_ddd/domain/auth/value_object.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<SignInFormEvent>(_onEvent);
  }

  Future<void> _onEvent(
      SignInFormEvent event, Emitter<SignInFormState> emit) async {
    event.map(emailChanged: (e) async {
      emit(state.copyWith(
          emailAddress: EmailAddress(e.emailStr),
          authFailureOrSuccessOption: none()));
    }, passwordChanged: (e) async {
      emit(state.copyWith(
          password: Password(e.passwordStr),
          authFailureOrSuccessOption: none()));
    }, registerWithEmailAndPasswordPressed: (e) async {
      _performActionOnAuthFacadeWithEmailAndPassword(
          _authFacade.registerWithEmailAndPassword, emit);
    }, signInWithEmailAndPasswordPressed: (e) async {
      _performActionOnAuthFacadeWithEmailAndPassword(
          _authFacade.signInWithEmailAndPassword, emit);
    }, signInWithGooglePressed: (e) async {
      emit(state.copyWith(
          isSubmitting: true, authFailureOrSuccessOption: none()));
      final failureOrSuccess = await _authFacade.signInWithGoogle();
      emit(state.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: some(failureOrSuccess)));
    });
  }

  Future<void> _performActionOnAuthFacadeWithEmailAndPassword(
    Future<Either<AuthFailure, Unit>> Function({
      required EmailAddress emailAddress,
      required Password password,
    })
        forwardedCall,
    Emitter<SignInFormState> emit,
  ) async {
    Either<AuthFailure, Unit>? failureOrSuccess;

    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      ));

      failureOrSuccess = await forwardedCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }
    emit(state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }
}

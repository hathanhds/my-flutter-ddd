import 'dart:async';

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
    await event.map(emailChanged: (e) {
      emit(state.copyWith(
          emailAddress: EmailAddress(e.emailStr),
          authFailureOrSuccessOption: none()));
    }, passwordChanged: (e) {
      emit(state.copyWith(
          password: Password(e.passwordStr),
          authFailureOrSuccessOption: none()));
    }, registerWithEmailAndPasswordPressed: (e) async {
      await _performActionOnAuthFacadeWithEmailAndPassword(
          emit, _authFacade.registerWithEmailAndPassword);
    }, signInWithEmailAndPasswordPressed: (e) async {
      await _performActionOnAuthFacadeWithEmailAndPassword(
          emit, _authFacade.signInWithEmailAndPassword);
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
      Emitter<SignInFormState> emit,
      Future<Either<AuthFailure, Unit>> Function({
    required EmailAddress emailAddress,
    required Password password,
  })
          forwardedCalled) async {
    Either<AuthFailure, Unit>? failureOrSuccess;

    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      ));

      failureOrSuccess = await forwardedCalled(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }

    emit(state.copyWith(
        isSubmitting: false,
        authFailureOrSuccessOption: optionOf(failureOrSuccess)));
  }
}

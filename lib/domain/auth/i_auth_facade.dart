import 'package:dartz/dartz.dart';
import 'package:my_flutter_ddd/domain/auth/auth_failure.dart';
import 'package:my_flutter_ddd/domain/auth/value_object.dart';

abstract class IAuthFacade {
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    EmailAddress emailAddress,
    Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    EmailAddress emailAddress,
    Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithGoogle();
}

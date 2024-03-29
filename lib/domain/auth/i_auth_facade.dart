import 'package:dartz/dartz.dart';
import 'package:my_flutter_ddd/domain/auth/auth_failure.dart';
import 'package:my_flutter_ddd/domain/auth/user.dart';
import 'package:my_flutter_ddd/domain/auth/value_object.dart';

abstract class IAuthFacade {
  /// jump to implementation method
  /// shortcut: cmd + fn + f12s
  Future<Option<CurrentUser>> getSignedInUser();

  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithGoogle();

  Future<void> signOut();
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_flutter_ddd/domain/auth/user.dart';
import 'package:my_flutter_ddd/domain/core/value_object.dart';

extension FirebaseUserDomainX on User {
  CurrentUser toDomain() {
    return CurrentUser(
      id: UniqueId.fromUniqueString(uid),
    );
  }
}

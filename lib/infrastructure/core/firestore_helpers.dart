import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_ddd/domain/auth/i_auth_facade.dart';
import 'package:my_flutter_ddd/domain/core/erorrs.dart';
import 'package:my_flutter_ddd/injection.dart';

extension FirebaseFirestoreX on FirebaseFirestore {
  /// The user must be already authenticated when calling this method.
  /// Otherwise, throws [NotAuthenticatedError].
  Future<DocumentReference> userDocument() async {
    final userOption = await getIt<IAuthFacade>().getSignedInUser();
    final user = userOption.getOrElse(() => throw NotAuthenticatedError());
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id.getOrCrash());
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get userCollection => collection('users');

  CollectionReference get noteCollection => collection('notes');

  /// Nested subcollection under a [noteCollection]'s document.
  CollectionReference get todoCollection => collection('todos');
}

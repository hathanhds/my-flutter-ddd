import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_flutter_ddd/domain/core/value_object.dart';

part 'user.freezed.dart';

@freezed
abstract class CurrentUser with _$CurrentUser {
  const factory CurrentUser({
    required UniqueId id,
  }) = _CurrentUser;
}

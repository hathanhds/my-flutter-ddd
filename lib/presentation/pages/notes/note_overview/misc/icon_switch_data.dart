import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'icon_switch_data.freezed.dart';

@freezed
abstract class IconSwitchData implements _$IconSwitchData {
  const factory IconSwitchData({required bool toggle, required Icon icon}) =
      _IconSwitchData;
}

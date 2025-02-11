// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SettingPageState _$SettingPageStateFromJson(Map<String, dynamic> json) {
  return _SettingPageState.fromJson(json);
}

/// @nodoc
mixin _$SettingPageState {
  bool get tapped => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Serializes this SettingPageState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SettingPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingPageStateCopyWith<SettingPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingPageStateCopyWith<$Res> {
  factory $SettingPageStateCopyWith(
          SettingPageState value, $Res Function(SettingPageState) then) =
      _$SettingPageStateCopyWithImpl<$Res, SettingPageState>;
  @useResult
  $Res call({bool tapped, bool isLoading});
}

/// @nodoc
class _$SettingPageStateCopyWithImpl<$Res, $Val extends SettingPageState>
    implements $SettingPageStateCopyWith<$Res> {
  _$SettingPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tapped = null,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      tapped: null == tapped
          ? _value.tapped
          : tapped // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingPageStateImplCopyWith<$Res>
    implements $SettingPageStateCopyWith<$Res> {
  factory _$$SettingPageStateImplCopyWith(_$SettingPageStateImpl value,
          $Res Function(_$SettingPageStateImpl) then) =
      __$$SettingPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool tapped, bool isLoading});
}

/// @nodoc
class __$$SettingPageStateImplCopyWithImpl<$Res>
    extends _$SettingPageStateCopyWithImpl<$Res, _$SettingPageStateImpl>
    implements _$$SettingPageStateImplCopyWith<$Res> {
  __$$SettingPageStateImplCopyWithImpl(_$SettingPageStateImpl _value,
      $Res Function(_$SettingPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SettingPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tapped = null,
    Object? isLoading = null,
  }) {
    return _then(_$SettingPageStateImpl(
      tapped: null == tapped
          ? _value.tapped
          : tapped // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SettingPageStateImpl implements _SettingPageState {
  const _$SettingPageStateImpl({this.tapped = false, this.isLoading = false});

  factory _$SettingPageStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingPageStateImplFromJson(json);

  @override
  @JsonKey()
  final bool tapped;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'SettingPageState(tapped: $tapped, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingPageStateImpl &&
            (identical(other.tapped, tapped) || other.tapped == tapped) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tapped, isLoading);

  /// Create a copy of SettingPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingPageStateImplCopyWith<_$SettingPageStateImpl> get copyWith =>
      __$$SettingPageStateImplCopyWithImpl<_$SettingPageStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingPageStateImplToJson(
      this,
    );
  }
}

abstract class _SettingPageState implements SettingPageState {
  const factory _SettingPageState({final bool tapped, final bool isLoading}) =
      _$SettingPageStateImpl;

  factory _SettingPageState.fromJson(Map<String, dynamic> json) =
      _$SettingPageStateImpl.fromJson;

  @override
  bool get tapped;
  @override
  bool get isLoading;

  /// Create a copy of SettingPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingPageStateImplCopyWith<_$SettingPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

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
  String get currentUser => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get thumbnailUrl => throw _privateConstructorUsedError;
  String get fullImageUrl => throw _privateConstructorUsedError;

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
  $Res call(
      {bool tapped,
      bool isLoading,
      String currentUser,
      String userName,
      String thumbnailUrl,
      String fullImageUrl});
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
    Object? currentUser = null,
    Object? userName = null,
    Object? thumbnailUrl = null,
    Object? fullImageUrl = null,
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
      currentUser: null == currentUser
          ? _value.currentUser
          : currentUser // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: null == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fullImageUrl: null == fullImageUrl
          ? _value.fullImageUrl
          : fullImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
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
  $Res call(
      {bool tapped,
      bool isLoading,
      String currentUser,
      String userName,
      String thumbnailUrl,
      String fullImageUrl});
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
    Object? currentUser = null,
    Object? userName = null,
    Object? thumbnailUrl = null,
    Object? fullImageUrl = null,
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
      currentUser: null == currentUser
          ? _value.currentUser
          : currentUser // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: null == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fullImageUrl: null == fullImageUrl
          ? _value.fullImageUrl
          : fullImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SettingPageStateImpl implements _SettingPageState {
  const _$SettingPageStateImpl(
      {this.tapped = false,
      this.isLoading = false,
      this.currentUser = '',
      this.userName = '',
      this.thumbnailUrl = '',
      this.fullImageUrl = ''});

  factory _$SettingPageStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingPageStateImplFromJson(json);

  @override
  @JsonKey()
  final bool tapped;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String currentUser;
  @override
  @JsonKey()
  final String userName;
  @override
  @JsonKey()
  final String thumbnailUrl;
  @override
  @JsonKey()
  final String fullImageUrl;

  @override
  String toString() {
    return 'SettingPageState(tapped: $tapped, isLoading: $isLoading, currentUser: $currentUser, userName: $userName, thumbnailUrl: $thumbnailUrl, fullImageUrl: $fullImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingPageStateImpl &&
            (identical(other.tapped, tapped) || other.tapped == tapped) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.currentUser, currentUser) ||
                other.currentUser == currentUser) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.fullImageUrl, fullImageUrl) ||
                other.fullImageUrl == fullImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tapped, isLoading, currentUser,
      userName, thumbnailUrl, fullImageUrl);

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
  const factory _SettingPageState(
      {final bool tapped,
      final bool isLoading,
      final String currentUser,
      final String userName,
      final String thumbnailUrl,
      final String fullImageUrl}) = _$SettingPageStateImpl;

  factory _SettingPageState.fromJson(Map<String, dynamic> json) =
      _$SettingPageStateImpl.fromJson;

  @override
  bool get tapped;
  @override
  bool get isLoading;
  @override
  String get currentUser;
  @override
  String get userName;
  @override
  String get thumbnailUrl;
  @override
  String get fullImageUrl;

  /// Create a copy of SettingPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingPageStateImplCopyWith<_$SettingPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

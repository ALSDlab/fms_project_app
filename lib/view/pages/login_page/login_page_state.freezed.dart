// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoginPageState _$LoginPageStateFromJson(Map<String, dynamic> json) {
  return _LoginPageState.fromJson(json);
}

/// @nodoc
mixin _$LoginPageState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get loginCheck => throw _privateConstructorUsedError;
  String get errorEmailText => throw _privateConstructorUsedError;
  String get errorPasswordText => throw _privateConstructorUsedError;

  /// Serializes this LoginPageState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginPageStateCopyWith<LoginPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginPageStateCopyWith<$Res> {
  factory $LoginPageStateCopyWith(
          LoginPageState value, $Res Function(LoginPageState) then) =
      _$LoginPageStateCopyWithImpl<$Res, LoginPageState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool loginCheck,
      String errorEmailText,
      String errorPasswordText});
}

/// @nodoc
class _$LoginPageStateCopyWithImpl<$Res, $Val extends LoginPageState>
    implements $LoginPageStateCopyWith<$Res> {
  _$LoginPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? loginCheck = null,
    Object? errorEmailText = null,
    Object? errorPasswordText = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      loginCheck: null == loginCheck
          ? _value.loginCheck
          : loginCheck // ignore: cast_nullable_to_non_nullable
              as bool,
      errorEmailText: null == errorEmailText
          ? _value.errorEmailText
          : errorEmailText // ignore: cast_nullable_to_non_nullable
              as String,
      errorPasswordText: null == errorPasswordText
          ? _value.errorPasswordText
          : errorPasswordText // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginPageStateImplCopyWith<$Res>
    implements $LoginPageStateCopyWith<$Res> {
  factory _$$LoginPageStateImplCopyWith(_$LoginPageStateImpl value,
          $Res Function(_$LoginPageStateImpl) then) =
      __$$LoginPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool loginCheck,
      String errorEmailText,
      String errorPasswordText});
}

/// @nodoc
class __$$LoginPageStateImplCopyWithImpl<$Res>
    extends _$LoginPageStateCopyWithImpl<$Res, _$LoginPageStateImpl>
    implements _$$LoginPageStateImplCopyWith<$Res> {
  __$$LoginPageStateImplCopyWithImpl(
      _$LoginPageStateImpl _value, $Res Function(_$LoginPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? loginCheck = null,
    Object? errorEmailText = null,
    Object? errorPasswordText = null,
  }) {
    return _then(_$LoginPageStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      loginCheck: null == loginCheck
          ? _value.loginCheck
          : loginCheck // ignore: cast_nullable_to_non_nullable
              as bool,
      errorEmailText: null == errorEmailText
          ? _value.errorEmailText
          : errorEmailText // ignore: cast_nullable_to_non_nullable
              as String,
      errorPasswordText: null == errorPasswordText
          ? _value.errorPasswordText
          : errorPasswordText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginPageStateImpl implements _LoginPageState {
  const _$LoginPageStateImpl(
      {this.isLoading = false,
      this.loginCheck = false,
      this.errorEmailText = '',
      this.errorPasswordText = ''});

  factory _$LoginPageStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginPageStateImplFromJson(json);

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool loginCheck;
  @override
  @JsonKey()
  final String errorEmailText;
  @override
  @JsonKey()
  final String errorPasswordText;

  @override
  String toString() {
    return 'LoginPageState(isLoading: $isLoading, loginCheck: $loginCheck, errorEmailText: $errorEmailText, errorPasswordText: $errorPasswordText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginPageStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.loginCheck, loginCheck) ||
                other.loginCheck == loginCheck) &&
            (identical(other.errorEmailText, errorEmailText) ||
                other.errorEmailText == errorEmailText) &&
            (identical(other.errorPasswordText, errorPasswordText) ||
                other.errorPasswordText == errorPasswordText));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, isLoading, loginCheck, errorEmailText, errorPasswordText);

  /// Create a copy of LoginPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginPageStateImplCopyWith<_$LoginPageStateImpl> get copyWith =>
      __$$LoginPageStateImplCopyWithImpl<_$LoginPageStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginPageStateImplToJson(
      this,
    );
  }
}

abstract class _LoginPageState implements LoginPageState {
  const factory _LoginPageState(
      {final bool isLoading,
      final bool loginCheck,
      final String errorEmailText,
      final String errorPasswordText}) = _$LoginPageStateImpl;

  factory _LoginPageState.fromJson(Map<String, dynamic> json) =
      _$LoginPageStateImpl.fromJson;

  @override
  bool get isLoading;
  @override
  bool get loginCheck;
  @override
  String get errorEmailText;
  @override
  String get errorPasswordText;

  /// Create a copy of LoginPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginPageStateImplCopyWith<_$LoginPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

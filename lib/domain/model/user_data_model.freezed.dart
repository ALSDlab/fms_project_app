// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserDataModel _$UserDataModelFromJson(Map<String, dynamic> json) {
  return _UserDataModel.fromJson(json);
}

/// @nodoc
mixin _$UserDataModel {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'signUpDate')
  String get signUpDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'email')
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'isSignOut')
  bool get isSignOut => throw _privateConstructorUsedError;
  @JsonKey(name: 'signOutDate')
  String get signOutDate => throw _privateConstructorUsedError;

  /// Serializes this UserDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDataModelCopyWith<UserDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDataModelCopyWith<$Res> {
  factory $UserDataModelCopyWith(
          UserDataModel value, $Res Function(UserDataModel) then) =
      _$UserDataModelCopyWithImpl<$Res, UserDataModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'signUpDate') String signUpDate,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'isSignOut') bool isSignOut,
      @JsonKey(name: 'signOutDate') String signOutDate});
}

/// @nodoc
class _$UserDataModelCopyWithImpl<$Res, $Val extends UserDataModel>
    implements $UserDataModelCopyWith<$Res> {
  _$UserDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? signUpDate = null,
    Object? email = null,
    Object? isSignOut = null,
    Object? signOutDate = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      signUpDate: null == signUpDate
          ? _value.signUpDate
          : signUpDate // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      isSignOut: null == isSignOut
          ? _value.isSignOut
          : isSignOut // ignore: cast_nullable_to_non_nullable
              as bool,
      signOutDate: null == signOutDate
          ? _value.signOutDate
          : signOutDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserDataModelImplCopyWith<$Res>
    implements $UserDataModelCopyWith<$Res> {
  factory _$$UserDataModelImplCopyWith(
          _$UserDataModelImpl value, $Res Function(_$UserDataModelImpl) then) =
      __$$UserDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'signUpDate') String signUpDate,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'isSignOut') bool isSignOut,
      @JsonKey(name: 'signOutDate') String signOutDate});
}

/// @nodoc
class __$$UserDataModelImplCopyWithImpl<$Res>
    extends _$UserDataModelCopyWithImpl<$Res, _$UserDataModelImpl>
    implements _$$UserDataModelImplCopyWith<$Res> {
  __$$UserDataModelImplCopyWithImpl(
      _$UserDataModelImpl _value, $Res Function(_$UserDataModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? signUpDate = null,
    Object? email = null,
    Object? isSignOut = null,
    Object? signOutDate = null,
  }) {
    return _then(_$UserDataModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      signUpDate: null == signUpDate
          ? _value.signUpDate
          : signUpDate // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      isSignOut: null == isSignOut
          ? _value.isSignOut
          : isSignOut // ignore: cast_nullable_to_non_nullable
              as bool,
      signOutDate: null == signOutDate
          ? _value.signOutDate
          : signOutDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDataModelImpl implements _UserDataModel {
  const _$UserDataModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'signUpDate') required this.signUpDate,
      @JsonKey(name: 'email') required this.email,
      @JsonKey(name: 'isSignOut') required this.isSignOut,
      @JsonKey(name: 'signOutDate') required this.signOutDate});

  factory _$UserDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDataModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'signUpDate')
  final String signUpDate;
  @override
  @JsonKey(name: 'email')
  final String email;
  @override
  @JsonKey(name: 'isSignOut')
  final bool isSignOut;
  @override
  @JsonKey(name: 'signOutDate')
  final String signOutDate;

  @override
  String toString() {
    return 'UserDataModel(id: $id, signUpDate: $signUpDate, email: $email, isSignOut: $isSignOut, signOutDate: $signOutDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDataModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.signUpDate, signUpDate) ||
                other.signUpDate == signUpDate) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isSignOut, isSignOut) ||
                other.isSignOut == isSignOut) &&
            (identical(other.signOutDate, signOutDate) ||
                other.signOutDate == signOutDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, signUpDate, email, isSignOut, signOutDate);

  /// Create a copy of UserDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDataModelImplCopyWith<_$UserDataModelImpl> get copyWith =>
      __$$UserDataModelImplCopyWithImpl<_$UserDataModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDataModelImplToJson(
      this,
    );
  }
}

abstract class _UserDataModel implements UserDataModel {
  const factory _UserDataModel(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'signUpDate') required final String signUpDate,
          @JsonKey(name: 'email') required final String email,
          @JsonKey(name: 'isSignOut') required final bool isSignOut,
          @JsonKey(name: 'signOutDate') required final String signOutDate}) =
      _$UserDataModelImpl;

  factory _UserDataModel.fromJson(Map<String, dynamic> json) =
      _$UserDataModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'signUpDate')
  String get signUpDate;
  @override
  @JsonKey(name: 'email')
  String get email;
  @override
  @JsonKey(name: 'isSignOut')
  bool get isSignOut;
  @override
  @JsonKey(name: 'signOutDate')
  String get signOutDate;

  /// Create a copy of UserDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDataModelImplCopyWith<_$UserDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

class UserDataDto {
  final int? id;
  final String? signUpDate;
  final String? email;
  final bool? isSignOut;
  final String? signOutDate;

//<editor-fold desc="Data Methods">
  const UserDataDto({
    this.id,
    this.signUpDate,
    this.email,
    this.isSignOut,
    this.signOutDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserDataDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          signUpDate == other.signUpDate &&
          email == other.email &&
          isSignOut == other.isSignOut &&
          signOutDate == other.signOutDate);

  @override
  int get hashCode =>
      id.hashCode ^
      signUpDate.hashCode ^
      email.hashCode ^
      isSignOut.hashCode ^
      signOutDate.hashCode;

  @override
  String toString() {
    return 'UserDataDto{ id: $id, signUpDate: $signUpDate, email: $email, deleted: $isSignOut, signOutDate: $signOutDate,}';
  }

  UserDataDto copyWith({
    int? id,
    String? signUpDate,
    String? email,
    bool? isSignOut,
    String? signOutDate,
  }) {
    return UserDataDto(
      id: id ?? this.id,
      signUpDate: signUpDate ?? this.signUpDate,
      email: email ?? this.email,
      isSignOut: isSignOut ?? this.isSignOut,
      signOutDate: signOutDate ?? this.signOutDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'signUpDate': signUpDate,
      'email': email,
      'isSignOut': isSignOut,
      'signOutDate': signOutDate,
    };
  }

  factory UserDataDto.fromJson(Map<String, dynamic> map) {
    return UserDataDto(
      id: map['id'] as int,
      signUpDate: map['signUpDate'] as String,
      email: map['email'] as String,
      isSignOut: map['isSignOut'] as bool,
      signOutDate: map['signOutDate'] as String,
    );
  }

//</editor-fold>
}

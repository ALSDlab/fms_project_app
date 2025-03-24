class UserDataDto {
  final int? id;
  final String? signUpDate;
  final String? email;
  final String? name;
  final String? comment;
  final String? thumbnail;
  final String? imageUrl;
  final bool? isSignOut;
  final String? signOutDate;

//<editor-fold desc="Data Methods">
  const UserDataDto({
    this.id,
    this.signUpDate,
    this.email,
    this.name,
    this.comment,
    this.thumbnail,
    this.imageUrl,
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
          name == other.name &&
          comment == other.comment &&
          thumbnail == other.thumbnail &&
          imageUrl == other.imageUrl &&
          isSignOut == other.isSignOut &&
          signOutDate == other.signOutDate);

  @override
  int get hashCode =>
      id.hashCode ^
      signUpDate.hashCode ^
      email.hashCode ^
      name.hashCode ^
      comment.hashCode ^
      thumbnail.hashCode ^
      imageUrl.hashCode ^
      isSignOut.hashCode ^
      signOutDate.hashCode;

  @override
  String toString() {
    return 'UserDataDto{ id: $id, signUpDate: $signUpDate, email: $email, name: $name, comment: $comment, thumbnail: $thumbnail, imageUrl: $imageUrl, isSignOut: $isSignOut, signOutDate: $signOutDate,}';
  }

  UserDataDto copyWith({
    int? id,
    String? signUpDate,
    String? email,
    String? name,
    String? comment,
    String? thumbnail,
    String? imageUrl,
    bool? isSignOut,
    String? signOutDate,
  }) {
    return UserDataDto(
      id: id ?? this.id,
      signUpDate: signUpDate ?? this.signUpDate,
      email: email ?? this.email,
      name: name ?? this.name,
      comment: comment ?? this.comment,
      thumbnail: thumbnail ?? this.thumbnail,
      imageUrl: imageUrl ?? this.imageUrl,
      isSignOut: isSignOut ?? this.isSignOut,
      signOutDate: signOutDate ?? this.signOutDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'signUpDate': signUpDate,
      'email': email,
      'name': name,
      'comment': comment,
      'thumbnail': thumbnail,
      'imageUrl': imageUrl,
      'isSignOut': isSignOut,
      'signOutDate': signOutDate,
    };
  }

  factory UserDataDto.fromJson(Map<String, dynamic> map) {
    return UserDataDto(
      id: map['id'] as int,
      signUpDate: map['signUpDate'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      comment: map['comment'] as String,
      thumbnail: map['thumbnail'] as String,
      imageUrl: map['imageUrl'] as String,
      isSignOut: map['isSignOut'] as bool,
      signOutDate: map['signOutDate'] as String,
    );
  }

//</editor-fold>
}

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fmsproject/data/dtos/user_data_dto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/simple_logger.dart';
import '../core/result.dart';

class FirebaseAuthUserData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late User? user;

  // 회원가입 및 로그인 관련 메서드
  // 이메일 중복 검사
  Future<Result<bool>> checkIfEmailInUse(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('user_data')
          .where('email', isEqualTo: email)
          .get();

      if (query.docs.isNotEmpty) {
        DateTime now = DateTime.now();
        String? isSignOut = query.docs.first.data()['signOutDate'];
        if (isSignOut != null && isSignOut != '') {
          DateTime savedDateTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').parse(isSignOut);

          // 두 날짜의 차이 계산
          Duration difference = now.difference(savedDateTime);
          if (difference.inDays <= 7) {
            return const Result.success(false); // 최근(7일 이내) 탈퇴한 유저: false
          } else {
            String? userId = _auth.currentUser?.uid;
            await _firestore.collection('user_data').doc(userId).delete();
            return const Result.error('you can signIn');
          }
        } else if (isSignOut == '') {
          return const Result.success(true); // 이미 사용 중: true
        }
      }
      return const Result.error('you can signIn');
    } catch (e) {
      logger.info('에러: $e');
      return Result.error(e.toString());
    }
  }

  // 이메일 회원가입
  Future<Result<UserDataDto>> signUpByEmail(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 이메일 인증 메일 발송

      await userCredential.user!.sendEmailVerification();
      final docId = userCredential.user!.uid;

      // 유저데이터 id 체크
      QuerySnapshot querySnapshot =
          await _firestore.collection('user_data').get();

      List<int> idList = querySnapshot.docs
          .map((doc) => doc['id'] as int) // id를 int로 캐스팅
          .toList();
      int maxId =
          idList.isNotEmpty ? idList.reduce((a, b) => a > b ? a : b) : 0;

      // 현재 날짜와 시간
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      await _firestore.collection('user_data').doc(docId).set({
        'id': maxId + 1,
        'signUpDate': formattedDate,
        'email': email,
        'name': '',
        'comment': '',
        'thumbnail': '',
        'imageUrl': '',
        'isSignOut': false,
        'signOutDate': '',
      });

      DocumentSnapshot docSnapshot =
          await _firestore.collection('user_data').doc(docId).get();

      final UserDataDto newUserData =
          UserDataDto.fromJson(docSnapshot.data() as Map<String, dynamic>);

      return Result.success(newUserData);
    } catch (e) {
      logger.info('Firestore 이메일 회원가입 에러 => $e');
      return Result.error(e.toString());
    }
  }

  // 이메일 인증확인
  Future<Result<bool>> checkEmailVerified() async {
    try {
      final Completer<bool> completer = Completer<bool>();
      const Duration checkInterval = Duration(seconds: 3);
      const int maxAttempts = 60; // 최대 3분 (60회 시도)

      int attemptCount = 0;

      Timer.periodic(checkInterval, (timer) async {
        User? user = _auth.currentUser;
        await user?.reload(); // Firebase 정보 갱신

        if (user != null && user.emailVerified) {
          timer.cancel(); // 타이머 중지
          if (!completer.isCompleted) {
            completer.complete(true); // 이메일 인증됨
          }
        } else if (attemptCount >= maxAttempts) {
          timer.cancel(); // 타임아웃
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        }
        attemptCount++;
      });

      bool isVerified = await completer.future;
      return Result.success(isVerified);
    } catch (e) {
      logger.info('Firestore 이메일 인증확인 에러 => $e');
      return Result.error(e.toString());
    }
  }

  // 이메일 로그인
  Future<Result<UserDataDto>> loginByEmail(
      String email, String password) async {
    try {
      // 이메일 존재 여부 먼저 확인
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('user_data')
          .where('email', isEqualTo: email)
          .where('signOutDate', isEqualTo: '')
          .get();

      if (query.docs.isEmpty) {
        return const Result.error('no email');
      }
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final docId = authResult.user!.uid;
      DocumentSnapshot docSnapshot =
          await _firestore.collection('user_data').doc(docId).get();

      final UserDataDto userData =
          UserDataDto.fromJson(docSnapshot.data() as Map<String, dynamic>);

      // 이메일 인증 여부에 따라 Result 반환
      return authResult.user!.emailVerified
          ? Result.success(userData)
          : const Result.error('not verified');
    } on FirebaseAuthException catch (e) {
      //로그인 예외처리
      if (e.code == 'invalid-credential') {
        return Result.error(e.code);
      } else {
        logger.info('Firestore 이메일 로그인 에러 => $e');
        return Result.error(e.toString());
      }
    }
  }

  // 구글로 회원가입
  Future<Result<UserDataDto>> signUpWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Firebase에 로그인
      final UserCredential userCredential =
          await _auth.signInWithCredential(googleCredential);

      final User? user = userCredential.user;
      final docId = user!.uid;

      // 유저데이터 id 체크
      QuerySnapshot querySnapshot =
          await _firestore.collection('user_data').get();
      bool userExists = querySnapshot.docs.any((doc) => doc.id == docId);

      List<int> idList = querySnapshot.docs
          .map((doc) => doc['id'] as int) // id를 int로 캐스팅
          .toList();
      int maxId =
          idList.isNotEmpty ? idList.reduce((a, b) => a > b ? a : b) : 0;

      // 현재 날짜와 시간
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      // 썸네일 URL 초기값
      String thumbnailUrl = '';
      // 원본 이미지는 구글에서 제공하는 URL 사용
      String imageUrl = googleUser?.photoUrl ?? '';

      // Authentication 사용자 프로필 업데이트
      if (imageUrl.isNotEmpty) {
        await user.updateProfile(
            displayName: googleUser?.displayName,
            photoURL: imageUrl // 구글 제공 원본 이미지 URL 저장
            );
      }

      // 구글 프로필 이미지로부터 썸네일만 생성하여 Firebase Storage에 저장
      if (imageUrl.isNotEmpty) {
        try {
          // 1. 구글 프로필 이미지 다운로드
          final http.Response response = await http.get(Uri.parse(imageUrl));

          if (response.statusCode == 200) {
            // 2. 썸네일 생성
            final img.Image? originalImage =
                img.decodeImage(response.bodyBytes);
            if (originalImage != null) {
              // 썸네일 크기 설정 (150x150)
              final img.Image thumbnailImage = img.copyResize(
                originalImage,
                width: 150,
                height: 150,
              );

              // 임시 디렉토리 가져오기
              final Directory tempDir = await getTemporaryDirectory();
              final String tempPath = tempDir.path;

              // 썸네일 파일 저장
              final String thumbnailFileName =
                  'thumbnail_${docId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
              final File thumbnailFile = File('$tempPath/$thumbnailFileName');
              await thumbnailFile
                  .writeAsBytes(img.encodeJpg(thumbnailImage, quality: 85));

              // 3. Firebase Storage에 썸네일만 업로드
              final Reference thumbnailRef = _storage
                  .ref()
                  .child('users')
                  .child(docId)
                  .child('thumbnails')
                  .child(thumbnailFileName);

              final UploadTask thumbnailUploadTask =
                  thumbnailRef.putFile(thumbnailFile);
              final TaskSnapshot thumbnailSnapshot = await thumbnailUploadTask;
              thumbnailUrl = await thumbnailSnapshot.ref.getDownloadURL();

              // 임시 파일 삭제
              await thumbnailFile.delete();
            }
          }
        } catch (e) {
          logger.info('구글 프로필 이미지 썸네일 처리 에러 => $e');
          // 이미지 처리 실패시에도 회원가입은 계속 진행
        }
      }

      if (!userExists) {
        await _firestore.collection('user_data').doc(docId).set({
          'id': maxId + 1,
          'signUpDate': formattedDate,
          'email': googleUser?.email,
          'name': googleUser?.displayName,
          'comment': '',
          'thumbnail': thumbnailUrl,
          'imageUrl': imageUrl,
          'isSignOut': false,
          'signOutDate': '',
        });
      }

      DocumentSnapshot docSnapshot =
          await _firestore.collection('user_data').doc(docId).get();

      final UserDataDto newUserData =
          UserDataDto.fromJson(docSnapshot.data() as Map<String, dynamic>);

      return Result.success(newUserData);
    } catch (e) {
      logger.info('Firestore 구글로 회원가입 에러 => $e');
      return Result.error(e.toString());
    }
  }

  // 페이스북으로 회원가입
  Future<Result<UserDataDto>> signUpWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance
            .getUserData(fields: 'name, email, picture');
        final email = userData['email'];
        final name = userData['name'];
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);

        // Firebase에 로그인
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;
        final docId = user!.uid;

        // 유저데이터 id 체크
        QuerySnapshot querySnapshot =
            await _firestore.collection('user_data').get();
        bool userExists = querySnapshot.docs.any((doc) => doc.id == docId);

        List<int> idList =
            querySnapshot.docs.map((doc) => doc['id'] as int).toList();
        int maxId =
            idList.isNotEmpty ? idList.reduce((a, b) => a > b ? a : b) : 0;

        // 현재 날짜와 시간
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

        // 이미지 URL 초기값
        String thumbnailUrl = '';
        String imageUrl = '';

        // 페이스북 프로필 이미지 처리
        try {
          // Facebook의 picture 데이터 구조는 data.url 형태로 되어있음
          final picData = userData['picture'];
          if (picData != null &&
              picData['data'] != null &&
              picData['data']['url'] != null) {
            final String photoUrl = picData['data']['url'];

            // Facebook에서 제공하는 원본 URL 사용
            imageUrl = photoUrl;

            // 이메일과 프로필 정보 Firebase Authentication에 업데이트
            if (email != null) {
              await user.verifyBeforeUpdateEmail(email);
            }

            await user.updateProfile(displayName: name, photoURL: imageUrl);

            // 썸네일만 생성하여 저장
            final http.Response response = await http.get(Uri.parse(photoUrl));

            if (response.statusCode == 200) {
              // 썸네일 생성
              final img.Image? originalImage =
                  img.decodeImage(response.bodyBytes);
              if (originalImage != null) {
                // 썸네일 크기 설정 (150x150)
                final img.Image thumbnailImage = img.copyResize(
                  originalImage,
                  width: 150,
                  height: 150,
                );

                // 임시 디렉토리에 썸네일 저장
                final Directory tempDir = await getTemporaryDirectory();
                final String tempPath = tempDir.path;
                final String thumbnailFileName =
                    'thumbnail_${docId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
                final File thumbnailFile = File('$tempPath/$thumbnailFileName');
                await thumbnailFile
                    .writeAsBytes(img.encodeJpg(thumbnailImage, quality: 85));

                // Firebase Storage에 썸네일만 업로드
                final Reference thumbnailRef = _storage
                    .ref()
                    .child('users')
                    .child(docId)
                    .child('thumbnails')
                    .child(thumbnailFileName);

                final UploadTask thumbnailUploadTask =
                    thumbnailRef.putFile(thumbnailFile);
                final TaskSnapshot thumbnailSnapshot =
                    await thumbnailUploadTask;
                thumbnailUrl = await thumbnailSnapshot.ref.getDownloadURL();

                // 임시 파일 삭제
                await thumbnailFile.delete();
              }
            }
          }
        } catch (e) {
          logger.info('페이스북 프로필 이미지 처리 에러 => $e');
          // 이미지 처리 실패시에도 회원가입은 계속 진행
        }

        if (!userExists) {
          await _firestore.collection('user_data').doc(docId).set({
            'id': maxId + 1,
            'signUpDate': formattedDate,
            'email': email ?? '',
            'name': name ?? '',
            'comment': '',
            'thumbnail': thumbnailUrl,
            'imageUrl': imageUrl,
            'isSignOut': false,
            'signOutDate': '',
          });
        }

        DocumentSnapshot docSnapshot =
            await _firestore.collection('user_data').doc(docId).get();

        final UserDataDto newUserData =
            UserDataDto.fromJson(docSnapshot.data() as Map<String, dynamic>);

        return Result.success(newUserData);
      } else {
        return Result.error('Facebook login failed: ${result.message}');
      }
    } catch (e) {
      logger.info('Firestore 페이스북으로 회원가입 에러 => $e');
      return Result.error(e.toString());
    }
  }

  // 애플로 회원가입
  Future<Result<UserDataDto>> signUpWithApple() async {
    try {
      late final UserCredential userCredential;

      final appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      appleProvider.addScope('fullName');

      // Firebase에 로그인
      if (kIsWeb) {
        userCredential = await _auth.signInWithPopup(appleProvider);
      } else {
        userCredential = await _auth.signInWithProvider(appleProvider);
      }

      final User? user = userCredential.user;
      final docId = user!.uid;

      // 유저데이터 id 체크
      QuerySnapshot querySnapshot =
          await _firestore.collection('user_data').get();
      bool userExists = querySnapshot.docs.any((doc) => doc.id == docId);

      List<int> idList =
          querySnapshot.docs.map((doc) => doc['id'] as int).toList();
      int maxId =
          idList.isNotEmpty ? idList.reduce((a, b) => a > b ? a : b) : 0;

      // 현재 날짜와 시간
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      // 이미지 URL 초기값
      String thumbnailUrl = '';
      String imageUrl = user.photoURL ?? '';

      // 애플 로그인 사용자의 프로필 이미지 처리
      try {
        if (imageUrl.isNotEmpty) {
          // 썸네일 생성 및 저장
          final http.Response response = await http.get(Uri.parse(imageUrl));

          if (response.statusCode == 200) {
            // 썸네일 생성
            final img.Image? originalImage =
                img.decodeImage(response.bodyBytes);
            if (originalImage != null) {
              // 썸네일 크기 설정 (150x150)
              final img.Image thumbnailImage = img.copyResize(
                originalImage,
                width: 150,
                height: 150,
              );

              // 임시 디렉토리에 썸네일 저장
              final Directory tempDir = await getTemporaryDirectory();
              final String tempPath = tempDir.path;
              final String thumbnailFileName =
                  'thumbnail_${docId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
              final File thumbnailFile = File('$tempPath/$thumbnailFileName');
              await thumbnailFile
                  .writeAsBytes(img.encodeJpg(thumbnailImage, quality: 85));

              // Firebase Storage에 썸네일만 업로드
              final Reference thumbnailRef = FirebaseStorage.instance
                  .ref()
                  .child('users')
                  .child(docId)
                  .child('thumbnails')
                  .child(thumbnailFileName);

              final UploadTask thumbnailUploadTask =
                  thumbnailRef.putFile(thumbnailFile);
              final TaskSnapshot thumbnailSnapshot = await thumbnailUploadTask;
              thumbnailUrl = await thumbnailSnapshot.ref.getDownloadURL();

              // 임시 파일 삭제
              await thumbnailFile.delete();
            }
          }
        }
      } catch (e) {
        logger.info('애플 프로필 이미지 처리 에러 => $e');
        // 이미지 처리 실패시에도 회원가입은 계속 진행
      }

      // 사용자 정보가 누락되었다면 Authentication에서 이름이나 이메일 업데이트
      if (user.displayName == null || user.displayName!.isEmpty) {
        await user.updateProfile(displayName: user.displayName ?? "Apple User");
      }

      if (!userExists) {
        await _firestore.collection('user_data').doc(docId).set({
          'id': maxId + 1,
          'signUpDate': formattedDate,
          'email': user.email ?? '',
          'name': user.displayName ?? 'Apple User',
          'comment': '',
          'thumbnail': thumbnailUrl,
          'imageUrl': imageUrl,
          'isSignOut': false,
          'signOutDate': '',
        });
      }

      DocumentSnapshot docSnapshot =
          await _firestore.collection('user_data').doc(docId).get();

      final UserDataDto newUserData =
          UserDataDto.fromJson(docSnapshot.data() as Map<String, dynamic>);
      return Result.success(newUserData);
    } catch (e) {
      logger.info('Firestore 애플로 회원가입 에러 => $e');
      return Result.error(e.toString());
    }
  }

  // 프로필정보 로드 및 수정관련 메서드
  // 현재 유저정보 get
  Result<User> getCurrentUser() {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        return Result.success(currentUser);
      } else {
        return const Result.error('No user');
      }
    } catch (e) {
      logger.info('Firestore 유저정보 get 에러 => $e');
      return Result.error(e.toString());
    }
  }

  // 현재 유저썸네일 get
  Future<String?> getThumbnailUrl(String userId) async {
    try {
      final Reference thumbnailRef =
          _storage.ref().child('users').child(userId).child('thumbnails');

      final ListResult result = await thumbnailRef.listAll();

      if (result.items.isEmpty) {
        return null;
      }

      final String thumbnailUrl = await result.items.first.getDownloadURL();

      return thumbnailUrl;
    } catch (e) {
      logger.info('썸네일 URL 가져오기 오류: $e');
      return null; // 오류 발생 시 null 반환
    }
  }

  // 현재 Full이미지 get
  Future<String?> getFullImageUrl(String userId) async {
    try {
      // Firestore에서 users 컬렉션의 해당 userId 문서 참조
      final DocumentSnapshot userDoc =
          await _firestore.collection('user_data').doc(userId).get();

      // 문서가 존재하고 imageUrl 필드가 있는지 확인
      if (userDoc.exists && userDoc.data() != null) {
        final userData = userDoc.data() as Map<String, dynamic>;

        if (userData.containsKey('imageUrl')) {
          return userData['imageUrl'] as String?;
        }
      }

      return null;
    } catch (e) {
      logger.info('Full image URL 가져오기 오류: $e');
      return null; // 오류 발생 시 null 반환
    }
  }

  // 프로필 정보 get
  Future<Result<UserDataDto>> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('user_data').doc(userId).get();
      final UserDataDto userData =
          UserDataDto.fromJson(doc.data() as Map<String, dynamic>);
      return Result.success(userData);
    } catch (e) {
      logger.info('Firestore 유저프로필 get 에러 => $e');
      return Result.error(e.toString());
    }
  }

  //프로필 이미지 업데이트
  Future<Result<void>> updateProfileImage(String userId, File imageFile) async {
    String fileName = "profile_$userId.png";
    String thumbnailFileName =
        'thumbnail_$userId.png';
    Reference storageReference =
        _storage.ref().child('users/$userId/$fileName');
    final Reference thumbnailRef =
        _storage.ref().child('users/$userId/thumbnails/$thumbnailFileName');

    try {
      try {
        await storageReference.delete();
        await thumbnailRef.delete();
        logger.info("기존 파일 삭제 완료");
      } catch (e) {
        logger.info("삭제할 기존 파일이 없음: $e");
      }

      // 새 파일 업로드
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      img.Image? originalImage = img.decodeImage(await imageFile.readAsBytes());
      if (originalImage != null) {
        img.Image thumbnail =
            img.copyResize(originalImage, width: 150, height: 150);
        Uint8List thumbnailData =
            Uint8List.fromList(img.encodeJpg(thumbnail, quality: 85));

        // 썸네일 업로드
        UploadTask thumbUploadTask = thumbnailRef.putData(thumbnailData);
        TaskSnapshot thumbTaskSnapshot = await thumbUploadTask;
        String thumbnailUrl = await thumbTaskSnapshot.ref.getDownloadURL();

        // Firestore에 원본 및 썸네일 URL 저장
        await FirebaseFirestore.instance.collection('user_data ').doc(userId).set({
          'imageUrl': imageUrl,
          'thumbnail': thumbnailUrl,
        }, SetOptions(merge: true));
      }
      logger.info("새로운 파일 업로드 및 URL 저장 완료: $imageUrl");
      return const Result.success(null);
    } catch (e) {
      logger.info('프로필 이미지 업데이트 오류: $e');
      return Result.error(e.toString());
    }
  }

  // 필드 업데이트
  Future<Result<bool>> updateField(String field, dynamic value) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return const Result.success(false);

      await _firestore
          .collection('user_data')
          .doc(userId)
          .update({field: value});
      return const Result.success(true);
    } catch (e) {
      logger.info('필드 업데이트 오류: $e');
      return Result.error(e.toString());
    }
  }

  // 이메일 비밀번호변경
  Future<Result<bool>> resetPasswordByEmail(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('profile')
          .where('email', isEqualTo: email)
          .get();
      if (query.docs.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: email);
        return const Result.success(true);
      } else {
        return const Result.success(false);
      }
    } catch (e) {
      logger.info('Firestore 이메일 로그인 에러 => $e');
      return Result.error(e.toString());
    }
  }

  // 로그아웃 및 탈퇴 메서드
  // 로그아웃
  Future<Result<void>> firebaseLogout() async {
    try {
      await _auth.signOut();
      return const Result.success(null);
    } catch (e) {
      logger.info('Firestore 로그아웃 에러 => $e');
      return Result.error(e.toString());
    }
  }

  // 회원탈퇴
  Future<Result<void>> firebaseSignOut() async {
    try {
      User? currentUser = _auth.currentUser;
      DateTime now = DateTime.now(); // 현재 날짜와 시간
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      if (currentUser != null) {
        await currentUser.delete();
      }
      await _firestore.collection('user_data').doc(currentUser?.uid).update({
        'isSignOut': true,
        'signOutDate': formattedDate,
      });
      return const Result.success(null);
    } catch (e) {
      logger.info('Firestore 회원탈퇴 에러 => $e');
      return Result.error(e.toString());
    }
  }

  // 회원정보 삭제
  Future<Result<void>> firebaseDeleteData() async {
    try {
      User? currentUser = _auth.currentUser;
      DateTime now = DateTime.now(); // 현재 날짜와 시간
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      await currentUser!.delete();

      await _firestore.collection('user_data').doc(currentUser.uid).update({
        'isSignOut': true,
        'signOutDate': formattedDate,
      });
      return const Result.success(null);
    } catch (e) {
      logger.info('Firestore 회원탈퇴 에러 => $e');
      return Result.error(e.toString());
    }
  }
}

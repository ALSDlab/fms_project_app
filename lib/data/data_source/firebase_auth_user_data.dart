import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fmsproject/data/dtos/user_data_dto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import '../../utils/simple_logger.dart';
import '../core/result.dart';

class FirebaseAuthUserData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? user;

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

      final email = googleUser?.email;

      // Firebase에 로그인
      final UserCredential userCredential =
          await _auth.signInWithCredential(googleCredential);

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
        'isSignOut': false,
        'signOutDate': '',
      });

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
      // by default we request the email and the public profile
      // or FacebookAuth.i.login()
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance
            .getUserData(fields: 'name, email, picture');
        final email = userData['email'];
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);

        // Firebase에 로그인
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        final User? user = userCredential.user;

        // 이메일 정보가 있다면 Firebase User 프로필 업데이트
        if (email != null && user != null) {
          await user.verifyBeforeUpdateEmail(
              email); // Firebase Authentication에 이메일 업데이트
        }

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
          'email': email ?? '',
          'isSignOut': false,
          'signOutDate': '',
        });

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
      late final UserCredential userCredential; // late 키워드로 선언

      // //TODO: 애플로 로그인 구현
      final appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      appleProvider.addScope('fullName');

      // Firebase에 로그인
      if (kIsWeb) {
        userCredential = await _auth.signInWithPopup(appleProvider);
      } else {
        userCredential = await _auth.signInWithProvider(appleProvider);
      }

      // await SignInWithApple.getAppleIDCredential(
      //   scopes: [
      //     AppleIDAuthorizationScopes.email,
      //     AppleIDAuthorizationScopes.fullName,
      //   ],
      // ).then((AuthorizationCredentialAppleID appleCredential) async {
      //   final OAuthCredential credential =
      //       OAuthProvider('apple.com').credential(
      //     idToken: appleCredential.identityToken,
      //     accessToken: appleCredential.authorizationCode,
      //   );
      //   print(appleCredential.email);
      //
      //   userCredential =
      //       await FirebaseAuth.instance.signInWithCredential(credential);
      // });

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

      // Firebase User 정보 가져오기
      final User? user = userCredential.user;

      await _firestore.collection('user_data').doc(docId).set({
        'id': maxId + 1,
        'signUpDate': formattedDate,
        'email': user?.email ?? '',
        'isSignOut': false,
        'signOutDate': '',
      });

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
        'isSignOut': false,
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
        'isSignOut': false,
        'signOutDate': formattedDate,
      });
      return const Result.success(null);
    } catch (e) {
      logger.info('Firestore 회원탈퇴 에러 => $e');
      return Result.error(e.toString());
    }
  }
}

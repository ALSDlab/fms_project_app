import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fmsproject/data/dtos/user_data_dto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import '../../utils/simple_logger.dart';
import '../core/result.dart';

class FirebaseAuthUserData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 이메일 중복 검사
  Future<bool> checkIfEmailInUse(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection('user_data')
          .where('email', isEqualTo: email)
          .get();
      return query.docs.isNotEmpty; // 이미 사용 중
    } catch (e) {
      // ignore: avoid_print
      print('에러: $e');
      return false;
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

  // 이메일 로그인
  Future<Result<void>> loginByEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return const Result.success(null);
    } catch (e) {
      logger.info('Firestore 이메일 로그인 에러 => $e');
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

      // Firebase User 정보 가져오기
      final User? user = userCredential.user;

      await _firestore.collection('user_data').doc(docId).set({
        'id': maxId + 1,
        'signUpDate': formattedDate,
        'email': user?.email,
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
  Future<Result<void>> signUpWithFacebook() async {
    try {
      return const Result.success(null);
    } catch (e) {
      logger.info('Firestore 페이스북으로 회원가입 에러 => $e');
      return Result.error(e.toString());
    }
  }

  // 애플로 회원가입
  Future<Result<void>> signUpWithApple() async {
    try {
      return const Result.success(null);
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

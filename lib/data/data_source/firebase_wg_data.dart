import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fmsproject/data/dtos/wg_data_dto.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:image/image.dart' as img;

import '../../utils/simple_logger.dart';
import '../core/result.dart';

class FirebaseWgData {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> createWgId() async {
    // WGDATA id 체크
    QuerySnapshot querySnapshot = await _firestore.collection('wg_data').get();

    if (querySnapshot.docs.isNotEmpty) {
      List<int> idList = querySnapshot.docs
          .map((doc) => doc['wgId'] as int) // id를 int로 캐스팅
          .toList();
      int maxId =
          idList.isNotEmpty ? idList.reduce((a, b) => a > b ? a : b) : 0;
      return maxId + 1;
    } else {
      return -1;
    }
  }

  // WG Upload 메서드
  Future<Result<void>> uploadWgData(String wgId, WgDataDto wgData) async {
    try {
      Map<String, dynamic> saveWgData = wgData.toJson();

      // WG 데이터 저장
      await _firestore.collection('wg_data').doc(wgId).set(saveWgData);

      return const Result.success(null);
    } catch (e) {
      logger.info('Firestore upload wg data error => $e');
      return Result.error(e.toString());
    }
  }

  Future<Result<void>> uploadWgImages(
      String wgId, List<File> imageFiles) async {
    final List<String> imageUrls = [];
    final List<String> thumbnailUrls = [];
    final docRef = _firestore.collection('wg_data').doc(wgId);

    try {
      for (int i = 0; i < imageFiles.length; i++) {
        final imageFile = imageFiles[i];
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = "wg_${wgId}_${timestamp}_$i.png";
        final thumbnailFileName = 'thumbnail_$fileName';

        final storageRef = _storage.ref().child('wg_images/$wgId/$fileName');
        final thumbnailRef = _storage
            .ref()
            .child('wg_images/$wgId/thumbnails/$thumbnailFileName');

        // 1. 이미지 업로드
        final uploadTask = storageRef.putFile(imageFile);
        final snapshot = await uploadTask;
        final imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);

        // 2. 썸네일 생성 및 업로드
        final originalImage = img.decodeImage(await imageFile.readAsBytes());
        if (originalImage == null) {
          return const Result.error('썸네일 생성 실패: 유효하지 않은 이미지입니다.');
        }

        final thumbnail =
            img.copyResize(originalImage, width: 150, height: 150);
        final thumbnailData =
            Uint8List.fromList(img.encodeJpg(thumbnail, quality: 85));

        final thumbUploadTask = thumbnailRef.putData(thumbnailData);
        final thumbSnapshot = await thumbUploadTask;
        final thumbnailUrl = await thumbSnapshot.ref.getDownloadURL();
        thumbnailUrls.add(thumbnailUrl);
      }

      // 3. Firestore에 저장
      await docRef.set({
        'imageUrls': FieldValue.arrayUnion(imageUrls),
        'thumbnailUrls': FieldValue.arrayUnion(thumbnailUrls),
      }, SetOptions(merge: true));

      logger.info("WG 이미지 및 썸네일 Firestore 저장 완료: ${imageUrls.length}개");
      return const Result.success(null);
    } catch (e) {
      logger.info('WG 이미지 업로드 및 Firestore 저장 오류: $e');
      return Result.error(e.toString());
    }
  }

  //WG 리스트 로드(실시간 로드)
  Stream<List<WgDataDto>> getWgListStream(
      double longitude, double latitude, int distance) {
    try {
      final geoCollectionRef = _firestore.collection('wg_data');

      return GeoCollectionReference(geoCollectionRef)
          .subscribeWithin(
        center: GeoFirePoint(GeoPoint(latitude, longitude)),
        radiusInKm: distance.toDouble(),
        field: 'location',
        geopointFrom: (data) => data['location'] as GeoPoint,
        strictMode: true,
      )
          .map<List<WgDataDto>>((snapshots) {
        final List<WgDataDto> wgDataList =
            snapshots.map((doc) => WgDataDto.fromJson(doc.data()!)).toList();
        return wgDataList;
      });
    } catch (e) {
      logger.info(
          'Firestore Stream getting user-specific chat room data error => $e');
      return Stream.value([]); // 오류 발생 시 빈 리스트 반환
    }
  }

  // 특정 WG 데이터 불러오기
  Future<Result<WgDataDto>> getWgData(String wgId) async {
    try {
      DocumentSnapshot wgDoc =
          await _firestore.collection('wg_data').doc(wgId).get();

      if (wgDoc.exists) {
        WgDataDto wgData =
            WgDataDto.fromJson(wgDoc.data() as Map<String, dynamic>);
        return Result.success(wgData);
      } else {
        return const Result.error('Chat room not found');
      }
    } catch (e) {
      logger.info('Firestore getting chat room error => $e');
      return Result.error(e.toString());
    }
  }

  // 필드 업데이트
  Future<Result<bool>> updateField(
      String wgId, String field, dynamic value) async {
    try {
      await _firestore.collection('wg_data').doc(wgId).update({field: value});
      return const Result.success(true);
    } catch (e) {
      logger.info('필드 업데이트 오류: $e');
      return Result.error(e.toString());
    }
  }

  // WG 이미지 업데이트
  Future<Result<void>> updateWgImage(
      String wgId, List<String> oldImageUrls, List<File> newImageFiles) async {
    try {
      // 1. Firestore 문서 참조 가져오기
      final docRef = _firestore.collection('wg_data').doc(wgId);
      final docSnapshot = await docRef.get();

      // 2. 현재 저장된 이미지 URL 목록 가져오기
      final currentImageUrls =
          List<String>.from(docSnapshot.data()?['imageUrls'] ?? []);
      final currentThumbnailUrls =
          List<String>.from(docSnapshot.data()?['thumbnailUrls'] ?? []);

      // 3. 기존 이미지 URL 삭제 작업
      for (var oldImageUrl in oldImageUrls) {
        try {
          // 3-1. 원본 이미지 파일명 추출 및 참조 생성
          final fileName = oldImageUrl.split('/').last;
          final storageRef = _storage.ref().child('wg_images/$wgId/$fileName');

          // 3-2. 썸네일 파일명 및 참조 생성
          final thumbnailFileName = 'thumbnail_$fileName';
          final thumbnailRef = _storage
              .ref()
              .child('wg_images/$wgId/thumbnails/$thumbnailFileName');

          // 3-3. Storage에서 파일 삭제
          await storageRef.delete();
          await thumbnailRef.delete();

          // 3-4. URL 목록에서 해당 URL 삭제
          currentImageUrls.removeWhere((url) => url.contains(fileName));
          currentThumbnailUrls
              .removeWhere((url) => url.contains(thumbnailFileName));

          logger.info("파일 삭제 완료: $fileName");
        } catch (e) {
          logger.info("파일 삭제 중 오류 발생 (계속 진행): $e");
          // 삭제 실패해도 계속 진행
        }
      }

      // 4. 새 이미지 및 썸네일 업로드
      for (int i = 0; i < newImageFiles.length; i++) {
        final imageFile = newImageFiles[i];
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'wg_${wgId}_${timestamp}_$i.jpg';
        final ref = _storage.ref().child('wg_images/$wgId/$fileName');

        // 이미지 업로드
        final uploadTask = ref.putFile(imageFile);
        final snapshot = await uploadTask;
        final imageUrl = await snapshot.ref.getDownloadURL();
        currentImageUrls.add(imageUrl);

        // 썸네일 생성 및 업로드
        final originalImage = img.decodeImage(await imageFile.readAsBytes());
        if (originalImage != null) {
          final thumbnail =
              img.copyResize(originalImage, width: 150, height: 150);
          final thumbnailData =
              Uint8List.fromList(img.encodeJpg(thumbnail, quality: 85));
          final thumbFileName = 'thumbnail_$fileName';
          final thumbRef =
              _storage.ref().child('wg_images/$wgId/thumbnails/$thumbFileName');

          final thumbUploadTask = thumbRef.putData(thumbnailData);
          final thumbSnapshot = await thumbUploadTask;
          final thumbnailUrl = await thumbSnapshot.ref.getDownloadURL();
          currentThumbnailUrls.add(thumbnailUrl);
        }
      }

      // Firestore에 원본 및 썸네일 URL 저장
      await docRef.set({
        'imageUrls': currentImageUrls,
        'thumbnailUrls': currentThumbnailUrls,
      }, SetOptions(merge: true));

      logger.info("이미지 업데이트 완료: ${currentImageUrls.length}개 추가됨");
      return const Result.success(null);
    } catch (e) {
      logger.info('프로필 이미지 업데이트 오류: $e');
      return Result.error(e.toString());
    }
  }

  // WG 데이터 삭제
  Future<Result<void>> deleteWgData(String wgId) async {
    try {
      // WG데이터 삭제
      await _firestore.collection('wg_data').doc(wgId).delete();

      return const Result.success(null);
    } catch (e) {
      logger.info('Firestore upload wg data error => $e');
      return Result.error(e.toString());
    }
  }
}

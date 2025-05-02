import 'dart:io';

import 'package:fmsproject/data/core/result.dart';
import 'package:fmsproject/data/data_source/firebase_wg_data.dart';
import 'package:fmsproject/data/mappers/wg_data_mapper.dart';
import 'package:fmsproject/domain/model/wg_data_model.dart';
import 'package:fmsproject/domain/repository/wg_data_repository.dart';

class WgDataRepositoryImpl implements WgDataRepository {
  @override
  Future<Result<void>> uploadWgData(String wgId, WgDataModel wgData) async {
    final result =
        await FirebaseWgData().uploadWgData(wgId, WgDataMapper.toDTO(wgData));
    return result.when(
      success: (data) {
        try {
          return Result.success(data);
        } catch (e) {
          return Result.error('uploadWgDataRepositoryImpl $e');
        }
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<void>> uploadWgImages(
      String wgId, List<File> imageFiles) async {
    final result = await FirebaseWgData().uploadWgImages(wgId, imageFiles);
    return result.when(
      success: (data) {
        try {
          return Result.success(data);
        } catch (e) {
          return Result.error('uploadWgImagesRepositoryImpl $e');
        }
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<WgDataModel>> getWgData(String wgId) async {
    final result = await FirebaseWgData().getWgData(wgId);
    return result.when(
      success: (data) {
        WgDataModel result = WgDataMapper.fromDTO(data);
        return Result.success(result);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Stream<List<WgDataModel>> getWgList(
      double longitude, double latitude, int distance) {
    return FirebaseWgData().getWgListStream(longitude, latitude, distance).map((wgList) =>
        wgList.map((wgData) => WgDataMapper.fromDTO(wgData)).toList());
  }

  @override
  Future<Result<bool>> updateField(String wgId, String field, value) async {
    final result = await FirebaseWgData().updateField(wgId, field, value);
    return result.when(
      success: (data) {
        try {
          return Result.success(data);
        } catch (e) {
          return Result.error('updateFieldRepositoryImpl $e');
        }
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<void>> updateWgImages(
      String wgId, List<String> oldImageUrls, List<File> newImageFiles) async {
    final result =
        await FirebaseWgData().updateWgImage(wgId, oldImageUrls, newImageFiles);
    return result.when(
      success: (data) {
        try {
          return Result.success(data);
        } catch (e) {
          return Result.error('updateWgImagesRepositoryImpl $e');
        }
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<void>> deleteWgData(String wgId) async {
    final result = await FirebaseWgData().deleteWgData(wgId);
    return result.when(
      success: (data) {
        try {
          return Result.success(data);
        } catch (e) {
          return Result.error('deleteWgDataRepositoryImpl $e');
        }
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}

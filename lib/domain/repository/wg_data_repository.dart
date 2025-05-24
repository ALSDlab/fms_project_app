import 'dart:io';

import 'package:fmsproject/domain/model/wg_data_model.dart';

import '../../data/core/result.dart';

abstract interface class WgDataRepository {
  Future<int> createWgId();

  Future<Result<void>> uploadWgData(String wgId, WgDataModel wgData);

  Stream<List<WgDataModel>> getWgList(
      double longitude, double latitude, int distance);

  Future<Result<WgDataModel>> getWgData(String wgId);

  Future<Result<bool>> updateField(String wgId, String field, dynamic value);

  Future<Result<void>> deleteWgData(String wgId);

  Future<Result<void>> uploadWgImages(String wgId, List<File> imageFiles);

  Future<Result<void>> updateWgImages(
      String wgId, List<String> oldImageUrls, List<File> newImageFiles);
}

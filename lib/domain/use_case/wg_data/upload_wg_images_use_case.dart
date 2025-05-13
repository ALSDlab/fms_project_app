import 'dart:io';

import '../../../data/core/result.dart';
import '../../repository/wg_data_repository.dart';

class UploadWgImagesUseCase {
  UploadWgImagesUseCase({required WgDataRepository wgDataRepository})
      : _wgDataRepository = wgDataRepository;

  final WgDataRepository _wgDataRepository;

  Future<Result<void>> execute(String wgId, List<File> imageFiles) async {
    final result = await _wgDataRepository.uploadWgImages(wgId, imageFiles);
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}

import 'package:fmsproject/domain/model/wg_data_model.dart';

import '../../../data/core/result.dart';
import '../../repository/wg_data_repository.dart';

class GetWgDataUseCase {
  GetWgDataUseCase({required WgDataRepository wgDataRepository})
      : _wgDataRepository = wgDataRepository;

  final WgDataRepository _wgDataRepository;

  Future<Result<WgDataModel>> execute(String wgId, WgDataModel wgData) async {
    final result = await _wgDataRepository.getWgData(wgId);
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}

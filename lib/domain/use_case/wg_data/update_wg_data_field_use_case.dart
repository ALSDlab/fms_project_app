import '../../../data/core/result.dart';
import '../../repository/wg_data_repository.dart';

class UpdateWgDataFieldUseCase {
  UpdateWgDataFieldUseCase({required WgDataRepository wgDataRepository})
      : _wgDataRepository = wgDataRepository;

  final WgDataRepository _wgDataRepository;

  Future<Result<bool>> execute(String wgId, String field, dynamic value) async {
    final result = await _wgDataRepository.updateField(wgId, field, value);
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}

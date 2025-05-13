import '../../../data/core/result.dart';
import '../../repository/wg_data_repository.dart';

class DeleteWgDataUseCase {
  DeleteWgDataUseCase({required WgDataRepository wgDataRepository})
      : _wgDataRepository = wgDataRepository;

  final WgDataRepository _wgDataRepository;

  Future<Result<void>> execute(String wgId) async {
    final result = await _wgDataRepository.deleteWgData(wgId);
    return result.when(
        success: (data) => Result.success(data),
        error: (message) => Result.error(message));
  }
}

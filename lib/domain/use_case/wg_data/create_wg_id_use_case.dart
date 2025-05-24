import '../../repository/wg_data_repository.dart';

class CreateWgIdUseCase {
  CreateWgIdUseCase({required WgDataRepository wgDataRepository})
      : _wgDataRepository = wgDataRepository;

  final WgDataRepository _wgDataRepository;

  Future<int> execute() async {
    final result = await _wgDataRepository.createWgId();
    return result;
  }
}

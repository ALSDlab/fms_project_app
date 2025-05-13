import 'package:fmsproject/domain/model/wg_data_model.dart';

import '../../repository/wg_data_repository.dart';

class StreamWgDataListUseCase {
  StreamWgDataListUseCase({required WgDataRepository wgDataRepository})
      : _wgDataRepository = wgDataRepository;

  final WgDataRepository _wgDataRepository;

  Stream<List<WgDataModel>> execute(
      double longitude, double latitude, int distance) {
    final result = _wgDataRepository.getWgList(longitude, latitude, distance);
    return result;
  }
}

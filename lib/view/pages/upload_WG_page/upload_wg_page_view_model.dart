import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/view/pages/upload_WG_page/upload_wg_page_state.dart';

class UploadWGPageViewModel with ChangeNotifier {
  UploadWGPageViewModel();

  int _currentStep = 0;
  final int _totalSteps = 5;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  UploadWgPageState _state = const UploadWgPageState();

  UploadWgPageState get state => _state;

  int get currentStep => _currentStep;

  int get totalSteps => _totalSteps;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  // 스텝 1: 기간 설정
  void setPeriod(DateTime? abDem, DateTime? bis) {
    _state = state.copyWith(
        wgData: state.wgData.copyWith(abDem: abDem, bis: bis),
        isPeriodCompleted: abDem != null && bis != null);
    notifyListeners();
  }

  // 스텝 2: 위치 정보 설정
  void setLocation(String region, String ort, String kreis, String naehe,
      String address, double longitude, double latitude) {
    _state = state.copyWith(
        wgData: state.wgData.copyWith(
          region: region,
          ort: ort,
          kreis: kreis,
          naehe: naehe,
          adresse: address,
          location: GeoPoint(latitude, longitude),
        ),
        isLocationCompleted: address.isNotEmpty &&
            (region.isNotEmpty ||
                ort.isNotEmpty ||
                kreis.isNotEmpty ||
                naehe.isNotEmpty));
    notifyListeners();
  }

  // 스텝 3: 등록자 상세설정
  void setVermieter(String wirSuchen, String wirSind) {
    _state = state.copyWith(
        wgData: state.wgData.copyWith(wirSuchen: wirSuchen, wirSind: wirSind),
        isVermieterCompleted: wirSuchen.isNotEmpty || wirSind.isNotEmpty);
    notifyListeners();
  }

  // 스텝 4: 사진 추가
  void addPhoto(String photoThumbnailUrl) {
    List<String> thumbUrlList = List.from(_state.wgData.thumbnails);
    thumbUrlList.add(photoThumbnailUrl);
    _state = state.copyWith(
        wgData: state.wgData.copyWith(thumbnails: thumbUrlList),
        isPhotoCompleted: thumbUrlList.isNotEmpty);
    notifyListeners();
  }

  void removePhoto(String photoThumbnailUrl) {
    List<String> thumbUrlList = List.from(_state.wgData.thumbnails);
    thumbUrlList.remove(photoThumbnailUrl);
    _state = state.copyWith(
        wgData: state.wgData.copyWith(thumbnails: thumbUrlList),
        isPhotoCompleted: thumbUrlList.isNotEmpty);
    notifyListeners();
  }

  // 스텝 5: 가격 및 제목, 설명 설정
  void setMiete(String miete, String title, String beschreibung) {
    _state = state.copyWith(
        wgData: state.wgData
            .copyWith(miete: miete, title: title, beschreibung: beschreibung),
        isMieteCompleted:
            miete.isNotEmpty && title.isNotEmpty && beschreibung.isNotEmpty);
    notifyListeners();
  }

  // 현재 스텝이 완료되었는지 확인
  bool isCurrentStepCompleted() {
    switch (_currentStep) {
      case 0:
        return _state.isPeriodCompleted;
      case 1:
        return _state.isLocationCompleted;
      case 2:
        return _state.isVermieterCompleted;
      case 3:
        return _state.isPhotoCompleted;
      case 4:
        return _state.isMieteCompleted;
      default:
        return false;
    }
  }

  // 다음 스텝으로 이동
  bool goToNextStep() {
    if (_currentStep < _totalSteps - 1) {
      _currentStep++;
      notifyListeners();
      return true;
    }
    return false;
  }

  // 이전 스텝으로 이동
  bool goToPreviousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
      return true;
    }
    return false;
  }

  // 숙소 등록 완료
  Future<bool> submitListing() async {
    // 여기서 실제로는 API 호출을 통해 숙소 정보를 서버에 저장
    // 간단한 예제이므로 true를 반환하는 것으로 성공으로 처리
    return Future.delayed(const Duration(seconds: 1), () => true);
  }
}

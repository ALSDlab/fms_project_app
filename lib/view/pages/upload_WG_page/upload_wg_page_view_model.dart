import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/utils/simple_logger.dart';
import 'package:fmsproject/view/pages/upload_WG_page/upload_wg_page_state.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UploadWGPageViewModel with ChangeNotifier {
  UploadWGPageViewModel();

  int _currentStep = 0;
  final int _totalSteps = 5;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  GoogleMapController? controller;
  String currentAddress = "주소를 가져오는 중...";

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
    if (mapController.isCompleted) {
      mapController.future.then((controller) {
        controller.dispose();
      }).catchError((e) {
        logger.info("맵 컨트롤러 해제 중 오류: $e");
      });
    }
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
  void setLocation(String country, String states, String city, String postCode,
      String address, double latitude, double longitude) {
    _state = state.copyWith(
        wgData: state.wgData.copyWith(
          country: country,
          state: states,
          city: city,
          postCode: postCode,
          address: address,
          location: GeoPoint(latitude, longitude),
        ),
        isLocationCompleted: address.isNotEmpty &&
            (country.isNotEmpty ||
                states.isNotEmpty ||
                city.isNotEmpty ||
                postCode.isNotEmpty));
    notifyListeners();
  }

  // 2-1. 위치 권한 요청 및 현재 위치 표시 메서드
  Future<bool> requestLocationAndShowPosition() async {
    try {
      // 현재 권한 상태 확인
      LocationPermission permission = await Geolocator.checkPermission();

      // 권한이 거부된 상태라면 요청
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // 권한 거부 처리
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // 기본 위치(Palo Alto) 사용
        GeoPoint defaultLocation =
            const GeoPoint(37.42796133580664, -122.085749655962);
        await updateAddressAndMoveMap(defaultLocation);
        return false;
      }

      // 권한이 있으면 현재 위치 가져와서 바로 표시
      Position position = await Geolocator.getCurrentPosition();
      GeoPoint currentLatLng = GeoPoint(position.latitude, position.longitude);
      _state = state.copyWith(
          wgData: state.wgData.copyWith(location: currentLatLng));

      // 위치 정보로 주소 업데이트 및 지도 이동
      await updateAddressAndMoveMap(currentLatLng);
      return true;
    } catch (e) {
      logger.info("위치 권한 요청 및 표시 중 오류 발생: $e");
      return false;
    }
  }

  // 2-2. 주소 업데이트 및 지도 이동을 함께 처리하는 메서드
  Future<void> updateAddressAndMoveMap(GeoPoint latLng) async {
    try {
      // 지도 컨트롤러 가져오기
      // final GoogleMapController controller = await mapController.future;
      // 현재 줌 레벨 유지
      final currentZoom = await controller?.getZoomLevel() ?? 16.0;

      // 카메라 위치 설정
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(latLng.latitude, latLng.longitude),
        zoom: currentZoom,
      );

      // 카메라 이동
      if (controller == null) {
        return;
      }
      await controller
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      // 주소 정보 가져오기
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setLocation(
            place.country ?? '',
            place.administrativeArea ?? '',
            place.locality ?? '',
            place.postalCode ?? '',
            place.street ?? '',
            latLng.latitude,
            latLng.longitude);
        currentAddress = _formatAddress(place);
        notifyListeners();
      }
    } catch (e) {
      currentAddress = "주소를 찾을 수 없습니다";
      notifyListeners();

      logger.info("주소 업데이트 및 지도 이동 중 오류: $e");
    }
  }

  // // 2-3. 우편번호나 주소 문자열로 위치 검색 후 지도 이동 및 주소 업데이트하는 메서드
  // Future<void> searchAddressAndMoveMap(String addressOrPostal) async {
  //   try {
  //     // 주소 문자열이 비어있으면 처리하지 않음
  //     if (addressOrPostal.trim().isEmpty) {
  //       return;
  //     }
  //
  //     final placesService = GoogleMapsPlacesService(
  //       apiKey: Env.googleMapApiKey,
  //     );
  //
  //     // 주소/우편번호로 장소 검색
  //     final predictions = await placesService.findAutocompletePredictions(
  //       addressOrPostal,
  //     );
  //
  //     // 검색 결과가 있는 경우
  //     if (predictions.isNotEmpty) {
  //       // 첫 번째 예측 결과 선택
  //       final selectedPrediction = predictions.first;
  //
  //       // 장소 ID로 상세 정보 조회
  //       final placeDetails = await placesService.getPlaceDetails(
  //         selectedPrediction.placeId,
  //         fields: ['geometry', 'formatted_address'],
  //       );
  //
  //       // 위치 정보가 있으면 지도 이동
  //       if (placeDetails.geometry != null &&
  //           placeDetails.geometry!.location != null) {
  //
  //         final location = placeDetails.geometry!.location!;
  //         final searchedLocation = LatLng(location.lat, location.lng);
  //
  //         // 검색된 위치로 지도 이동 및 주소 업데이트
  //         await updateAddressAndMoveMap(searchedLocation);
  //
  //         // 검색된 주소 정보 업데이트 (필요에 따라 구현)
  //         // 예: setState(() { currentAddress = placeDetails.formattedAddress ?? ''; });
  //
  //         return; // 성공적으로 처리되면 종료
  //       }
  //     }
  //   } catch (e) {
  //     logger.info("Map Location Picker 검색 실패: $e");
  //   }
  // }

  // 2-4. 현재 위치로 이동하는 메서드
  Future<void> moveToCurrentLocation() async {
    try {
      // 위치 권한 요청 및 현재 위치 표시 메서드 호출
      await requestLocationAndShowPosition();
    } catch (e) {
      logger.info("현재 위치로 이동 중 오류 발생: $e");
    }
  }

  // 2-4. 주소 형식 지정 함수
  String _formatAddress(Placemark place) {
    String address = "";

    if (place.country != null && place.country!.isNotEmpty) {
      address += place.country!;
    }

    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      address += " ${place.administrativeArea!}";
    }

    if (place.locality != null && place.locality!.isNotEmpty) {
      address += " ${place.locality!}";
    }

    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      address += " ${place.subLocality!}";
    }

    if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
      address += " ${place.thoroughfare!}";
    }

    if (place.subThoroughfare != null && place.subThoroughfare!.isNotEmpty) {
      address += " ${place.subThoroughfare!}";
    }

    return address;
  }

  // 스텝 3: 등록자 상세설정
  void setVermieter(String wirSuchen, String wirSind) {
    _state = state.copyWith(
        wgData: state.wgData.copyWith(weFind: wirSuchen, weAre: wirSind),
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
            .copyWith(miete: miete, title: title, description: beschreibung),
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

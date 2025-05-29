import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/domain/use_case/wg_data/create_wg_id_use_case.dart';
import 'package:fmsproject/domain/use_case/wg_data/upload_wg_data_use_case.dart';
import 'package:fmsproject/domain/use_case/wg_data/upload_wg_images_use_case.dart';
import 'package:fmsproject/utils/simple_logger.dart';
import 'package:fmsproject/view/pages/upload_WG_page/upload_wg_page_state.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/core/result.dart';
import '../../../domain/use_case/user_data/get_current_user_use_case.dart';
import '../../../utils/one_answer_dialog.dart';

class UploadWGPageViewModel with ChangeNotifier {
  final CreateWgIdUseCase _createWgIdUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final UploadWgDataUseCase _uploadWgDataUseCase;
  final UploadWgImagesUseCase _uploadWgImagesUseCase;

  UploadWGPageViewModel({
    required CreateWgIdUseCase createWgIdUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required UploadWgDataUseCase uploadWgDataUseCase,
    required UploadWgImagesUseCase uploadWgImagesUseCase,
  })  : _createWgIdUseCase = createWgIdUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _uploadWgDataUseCase = uploadWgDataUseCase,
        _uploadWgImagesUseCase = uploadWgImagesUseCase;

  int _currentStep = 0;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  final TextEditingController weAreController = TextEditingController();
  final TextEditingController weFindController = TextEditingController();
  final CurrencyTextFieldController currencyController =
      CurrencyTextFieldController(initDoubleValue: 0.00);
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  GoogleMapController? controller;
  final ImagePicker _picker = ImagePicker();
  String currentAddress = "주소를 가져오는 중...";

  UploadWgPageState _state = const UploadWgPageState();

  UploadWgPageState get state => _state;

  int get currentStep => _currentStep;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    weAreController.dispose();
    weFindController.dispose();
    currencyController.dispose();
    titleController.dispose();
    descriptionController.dispose();
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
  // 2-1. 위치 권한 요청 및 현재 위치 표시 메서드
  Future<bool> requestLocationAndShowPosition() async {
    _state = state.copyWith(isMapLoading: true);
    notifyListeners();
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
      Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );
      GeoPoint currentLatLng = GeoPoint(position.latitude, position.longitude);
      _state = state.copyWith(
          wgData: state.wgData.copyWith(location: currentLatLng));
      // notifyListeners();

      // 위치 정보로 주소 업데이트 및 지도 이동
      await updateAddressAndMoveMap(currentLatLng);
      return true;
    } catch (e) {
      logger.info("위치 권한 요청 및 표시 중 오류 발생: $e");
      return false;
    } finally {
      _state = state.copyWith(isMapLoading: false);
      notifyListeners();
    }
  }

  // 2-2. 주소 업데이트 및 지도 이동을 함께 처리하는 메서드
  Future<void> updateAddressAndMoveMap(GeoPoint latLng) async {
    _state = state.copyWith(isLocationLoading: true);
    notifyListeners();
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
    } finally {
      _state = state.copyWith(isLocationLoading: false);
      notifyListeners();
    }
  }

  // 2-3. 주소 형식 지정 함수
  String _formatAddress(Placemark place) {
    String address = '';

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

  // 2-4. 위치정보 저장
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
        isLocationCompleted: address.isNotEmpty && postCode.isNotEmpty);
    notifyListeners();
  }

  // 스텝 3: 등록자상세 설정
  void fillTextVermieter(bool value) {
    _state = state.copyWith(isVermieterCompleted: value);
    notifyListeners();
  }

  void setVermieter() {
    _state = state.copyWith(
      wgData: state.wgData
          .copyWith(weAre: weAreController.text, weFind: weFindController.text),
    );
    notifyListeners();
  }

  // 스텝 4: 사진 추가
  // 4-1. 갤러리에서 이미지 선택
  Future<void> pickImagesFromGallery(BuildContext context) async {
    _state = state.copyWith(isPhotoUploading: true);
    notifyListeners();
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        final List<File> originalWgImages = List.from(state.wgImageFiles);
        for (var wgImage in pickedFiles) {
          final imageFile = File(wgImage.path);
          if (originalWgImages.contains(imageFile) && context.mounted) {
            showDialog(
              context: context,
              builder: (context) => OneAnswerDialog(
                onTap: () => context.pop(),
                title: 'already exists',
                subtitle: 'other photo',
                firstButton: 'OK',
              ),
            );
          } else {
            originalWgImages.add(File(wgImage.path));
          }
        }
        _state = state.copyWith(wgImageFiles: originalWgImages);
        addWgImagesComplete(originalWgImages);
        notifyListeners();
      }
    } catch (error) {
      logger.info('Error picking images: $error');
    } finally {
      _state = state.copyWith(isPhotoUploading: false);
      notifyListeners();
    }
  }

  // 4-2. 카메라로 사진 찍기
  Future<void> takePhoto() async {
    _state = state.copyWith(isPhotoUploading: true);
    notifyListeners();
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final List<File> originalWgImages = List.from(state.wgImageFiles);
        originalWgImages.add(File(pickedFile.path));
        _state = state.copyWith(wgImageFiles: originalWgImages);
        addWgImagesComplete(originalWgImages);
        notifyListeners();
      }
    } catch (error) {
      logger.info('Error taking photo: $error');
    } finally {
      _state = state.copyWith(isPhotoUploading: false);
      notifyListeners();
    }
  }

  // 4-3. 사진 삭제
  void removePhoto(int imageIndex) {
    if (imageIndex != -1) {
      final List<File> originalWgImages = List.from(state.wgImageFiles);
      originalWgImages.removeAt(imageIndex);
      _state = state.copyWith(wgImageFiles: originalWgImages);
      addWgImagesComplete(originalWgImages);
      notifyListeners();
    }
  }

  // 4-4. 사진 순서 변경
  void reorderPhotos(int oldIndex, int newIndex) {
    _state = state.copyWith(
        isPhotoDragging: false, draggedItemIndex: -1, currentHoverIndex: -1);
    notifyListeners();
    try {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final List<File> updatedGridPhotos = List.from(state.wgImageFiles);
      final File oldIndexItem = updatedGridPhotos.removeAt(oldIndex);
      final File newIndexItem = updatedGridPhotos.removeAt(newIndex);
      updatedGridPhotos.insert(newIndex, oldIndexItem);
      updatedGridPhotos.insert(oldIndex, newIndexItem);
      // 전체 사진 목록 업데이트
      _state = state.copyWith(wgImageFiles: updatedGridPhotos);
      notifyListeners();
    } catch (error) {
      logger.info('Error reorder photo: $error');
    }
  }

  // 4-5. 사진 이동중
  void draggingOnMove(int index) {
    _state = state.copyWith(currentHoverIndex: index);
    notifyListeners();
  }

  // 4-6. 사진 드래그여부
  void draggingOnMoveStartEnd(bool isDragging, int index) {
    _state =
        state.copyWith(isPhotoDragging: isDragging, draggedItemIndex: index);
    notifyListeners();
  }

  // 4-7. WG사진 설정
  void addWgImagesComplete(List wgImageFiles) {
    if (wgImageFiles.length > 2) {
      _state = state.copyWith(isPhotoCompleted: true);
      notifyListeners();
    } else {
      _state = state.copyWith(isPhotoCompleted: false);
    }
  }

  // 스텝 5: 가격 및 제목, 설명 설정
  void fillTextMiete(bool value) {
    _state = state.copyWith(isMieteCompleted: value);
    notifyListeners();
  }

  void setMiete() {
    _state = state.copyWith(
        wgData: state.wgData.copyWith(
            miete: currencyController.text,
            title: titleController.text,
            description: descriptionController.text));
    notifyListeners();
  }

  // 현재 스텝이 완료되었는지 확인
  int isCurrentStepCompleted() {
    switch (_currentStep) {
      case 0:
        if (_state.isPeriodCompleted) {
          return 0;
        }
      case 1:
        if (_state.isLocationCompleted) {
          return 1;
        }
      case 2:
        if (_state.isVermieterCompleted) {
          return 2;
        }
      case 3:
        if (_state.isPhotoCompleted) {
          return 3;
        }
      case 4:
        if (_state.isMieteCompleted) {
          return 4;
        }
      case 5:
        return 5;
    }
    return -1;
  }

  // 다음 스텝으로 이동
  bool goToNextStep() {
    if (_currentStep < 5) {
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
      switch (_currentStep) {
        case 0:
          _state = state.copyWith(isPeriodCompleted: false);
          break;
        case 1:
          _state = state.copyWith(isLocationCompleted: false);
          break;
        case 2:
          _state = state.copyWith(isVermieterCompleted: false);
          break;
        case 3:
          _state = state.copyWith(isPhotoCompleted: false);
          break;
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  // 숙소 등록 완료
  Future<bool> submitListing() async {
    _state = state.copyWith(isWgDataSubmitting: true);
    notifyListeners();
    try {
      final currentUserResult = _getCurrentUserUseCase.execute();
      switch (currentUserResult) {
        case Success<User>():
          // wgId 생성
          int wgId = 0;
          try {
            wgId = await _createWgIdUseCase.execute();
          } catch (e) {
            wgId = -1;
          }
          print(wgId);
          final wgIdString = '${wgId}_${currentUserResult.data.uid}';
          final createDate = DateTime.now();
          // wgData를 firebase 에 생성, 저장
          _state = state.copyWith(
              wgData: state.wgData.copyWith(
                  wgId: wgId,
                  userId: currentUserResult.data.uid,
                  createDate: createDate));
          final wgDataUploadResult =
              await _uploadWgDataUseCase.execute(wgIdString, state.wgData);
          switch (wgDataUploadResult) {
            case Success<void>():
              _state = state.copyWith(
                  isWgDataSubmitting: false, isPhotosSubmitting: true);
              notifyListeners();
              final List<File> wgImageList = List.from(state.wgImageFiles);
              final wgImageUploadResult = await _uploadWgImagesUseCase.execute(
                  wgIdString, wgImageList);
              switch (wgImageUploadResult) {
                case Success<void>():
                  return Future.delayed(
                      const Duration(milliseconds: 500), () => true);
                case Error<void>():
                  logger.info(wgImageUploadResult.message);
              }
            case Error<void>():
              logger.info(wgDataUploadResult.message);
          }
        case Error<User>():
          logger.info(currentUserResult.message);
      }
    } catch (error) {
      logger.info('Error submitting WG data: $error');
    } finally {
      _state =
          state.copyWith(isWgDataSubmitting: false, isPhotosSubmitting: false);
      notifyListeners();
    }
    return false;
  }
}

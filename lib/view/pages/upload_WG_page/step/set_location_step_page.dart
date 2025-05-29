import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/env/env.dart';
import 'package:fmsproject/utils/gif_progress_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/location_model.dart';
import '../../../../utils/upload_wg/custom_address_auto_complete.dart';
import '../upload_wg_page_view_model.dart';

class SetLocationStepPage extends StatefulWidget {
  const SetLocationStepPage({super.key});

  @override
  _SetLocationStepPageState createState() => _SetLocationStepPageState();
}

class _SetLocationStepPageState extends State<SetLocationStepPage> {
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();

  CameraPosition? _currentCameraPosition;
  Timer? _debounceTimer;
  bool _isInitialized = false;

  // 불필요한 리빌드를 방지하기 위한 캐시 데이터
  String _lastAddress = '';
  GeoPoint? _lastLocation;

  @override
  void initState() {
    super.initState();
    // 한 번만 실행되도록 플래그 추가
    if (!_isInitialized) {
      _initializeLocation();
      _isInitialized = true;
    }
  }

  Future<void> _initializeLocation() async {
    // 위젯이 마운트된 후 실행
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = context.read<UploadWGPageViewModel>();
      final state = viewModel.state;

      final result = await viewModel.requestLocationAndShowPosition();
      if (result == true && mounted) {
        _updateControllers(state);
      }
    });
  }

  void _updateControllers(state) {
    _countryController.text = state.wgData.country;
    _cityController.text = state.wgData.city;
    _stateController.text = state.wgData.state;
    _postCodeController.text = state.wgData.postCode;
    _addressController.text = state.wgData.address;
  }

  @override
  void dispose() {
    // 타이머 취소
    _debounceTimer?.cancel();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _postCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UploadWGPageViewModel>();
    final state = viewModel.state;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Where is your WG?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildAddressInputs(),
          const SizedBox(height: 16),
          _buildAutocompleteAddress(viewModel, context),
          const SizedBox(height: 24),
          _buildMap(state, viewModel),
          const SizedBox(height: 16),
          // 위치 확인 메시지
          if (state.wgData.postCode.isNotEmpty &&
              state.wgData.address.isNotEmpty)
            _buildConfirmationMessage(state),
        ],
      ),
    );
  }

  Widget _buildAddressInputs() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _countryController,
                    decoration: InputDecoration(
                      labelText: 'Country',
                      hintText: 'ex: Swiss',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      prefixIcon: const Icon(Icons.place, color: Colors.teal),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _stateController,
                    decoration: InputDecoration(
                      labelText: 'State',
                      hintText: 'state',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      prefixIcon: const Icon(Icons.home, color: Colors.teal),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'City',
                      hintText: '도시',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      prefixIcon: const Icon(Icons.place, color: Colors.teal),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _postCodeController,
                    decoration: InputDecoration(
                      labelText: 'Postcode',
                      hintText: '우편번호',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      prefixIcon: const Icon(Icons.home, color: Colors.teal),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutocompleteAddress(UploadWGPageViewModel viewModel, BuildContext context) {
    return CustomAddressAutocomplete(
      apiKey: Env.googleMapApiKey,
      controller: _addressController,
      onClearClick: () {
        _countryController.clear();
        _addressController.clear();
        _cityController.clear();
        _stateController.clear();
        _postCodeController.clear();
      },
      onSuggestionClickGetTextToUseForControl: (Place placeDetails) {
        String? forOurAddressBox = placeDetails.streetAddress;
        if (forOurAddressBox == null || forOurAddressBox.isEmpty) {
          forOurAddressBox = placeDetails.streetNumber ?? '';
          forOurAddressBox += (forOurAddressBox.isNotEmpty ? ' ' : '');
          forOurAddressBox += placeDetails.streetShort ?? '';
        }
        return forOurAddressBox;
      },
      onSuggestionClick: (Place? place) async {
        if (place != null) {
          _countryController.text = place.country!;
          _cityController.text = place.city!;
          _stateController.text = place.state!;
          _postCodeController.text = place.zipCode!;
          _addressController.text = place.streetAddress!;

          // 중복 업데이트 방지
          final latLng = GeoPoint(place.lat!, place.lng!);
          if (_shouldUpdateLocation(latLng)) {
            await viewModel.updateAddressAndMoveMap(latLng);
          }
        }
      },
      hoverColor: Colors.purple,
      selectionColor: Colors.purpleAccent,
      buildItem: (PlacePrediction prediction, int index) {
        return Container(
          margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          color: Colors.white,
          child: Text(
            prediction.description,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        );
      },
      clearButton: const Icon(Icons.close),
      autofocus: false,
      // 자동 포커스 비활성화로 불필요한 키보드 표시 방지
      scrollPadding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      autovalidateMode: AutovalidateMode.disabled,
      keyboardType: TextInputType.streetAddress,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Start typing address for Autocomplete..',
        hintStyle: const TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.purple,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.black12,
            width: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildMap(state, UploadWGPageViewModel viewModel) {
    if (state.wgData.location == null || state.isMapLoading == true) {
      return Center(child: GifProgressBar());
    }

    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 400,
          width: double.infinity,
          child: Stack(
            children: [
              _buildGoogleMap(state, viewModel),
              _buildCenterPin(),
              // _buildAddressPanel(viewModel, state),
              _buildMyLocationButton(viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleMap(state, UploadWGPageViewModel viewModel) {
    // 메모이제이션을 위한 키 생성
    final mapKey = ValueKey(
        '${state.wgData.location!.latitude}_${state.wgData.location!.longitude}');

    return RepaintBoundary(
      child: GoogleMap(
        key: mapKey,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
        },
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            state.wgData.location!.latitude,
            state.wgData.location!.longitude,
          ),
          zoom: 16.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          viewModel.controller = controller;
          viewModel.mapController.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        onCameraMove: (CameraPosition position) {
          _currentCameraPosition = position;
        },
        onCameraIdle: () {
          _handleCameraIdle(viewModel);
        },
        // 타일 캐싱 활성화로 메모리 사용량 최적화
        cameraTargetBounds: CameraTargetBounds.unbounded,
        // 불필요한 3D 빌딩 비활성화
        buildingsEnabled: false,
      ),
    );
  }

  void _handleCameraIdle(UploadWGPageViewModel viewModel) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    // 디바운스 시간 늘리기 (500ms -> 800ms)
    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      if (_currentCameraPosition != null) {
        final newLocation = GeoPoint(
          _currentCameraPosition!.target.latitude,
          _currentCameraPosition!.target.longitude,
        );

        // 중복 업데이트 방지
        if (_shouldUpdateLocation(newLocation)) {
          await viewModel.updateAddressAndMoveMap(newLocation);

          // 캐시 업데이트
          _lastLocation = newLocation;
          _lastAddress = viewModel.currentAddress;
        }
      }
    });
  }

  // 위치가 실제로 변경되었는지 확인해 불필요한 업데이트 방지
  bool _shouldUpdateLocation(GeoPoint newLocation) {
    if (_lastLocation == null) return true;

    // 위치가 일정 거리 이상 변경되었을 때만 업데이트
    const threshold = 0.0001; // 약 10m 정도의 차이
    return ((_lastLocation!.latitude - newLocation.latitude).abs() >
            threshold ||
        (_lastLocation!.longitude - newLocation.longitude).abs() > threshold);
  }

  Widget _buildCenterPin() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            child: const Icon(
              Icons.location_pin,
              size: 36,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAddressPanel(UploadWGPageViewModel viewModel, state) {
    return Positioned(
      top: 10,
      left: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (viewModel.state.isLocationLoading == true) ? Center(child: GifProgressBar(),) :
            Text(
              viewModel.currentAddress,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _confirmAddress(viewModel, state);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '이 주소로 확인',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmAddress(UploadWGPageViewModel viewModel, state) {
    _updateControllers(state);

    // 선택한 주소로 다음 단계 진행
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('선택한 주소: ${viewModel.currentAddress}')),
      );
    }
  }

  Widget _buildMyLocationButton(UploadWGPageViewModel viewModel) {
    return Positioned(
      left: 16,
      bottom: 16,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: viewModel.requestLocationAndShowPosition,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildConfirmationMessage(state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '위치 정보가 확인되었습니다: ${state.wgData.postCode}, ${state.wgData.address}',
              style: TextStyle(color: Colors.green[700]),
            ),
          ),
        ],
      ),
    );
  }
}

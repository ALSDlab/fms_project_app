import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/env/env.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_places_autocomplete_widgets/widgets/address_autocomplete_textformfield.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = context.read<UploadWGPageViewModel>();
      final state = viewModel.state;
      await viewModel.requestLocationAndShowPosition().then((value) {
        if (value == true) {
          _countryController.text = state.wgData.country;
          _cityController.text = state.wgData.city;
          _stateController.text = state.wgData.state;
          _postCodeController.text = state.wgData.postCode;
          _addressController.text = state.wgData.address;
        }
      });
    });
  }

  @override
  void dispose() {
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
          Card(
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
                              prefixIcon:
                                  const Icon(Icons.place, color: Colors.teal),
                            ),
                            onChanged: (value) async {
                              _countryController.text = value;
                            }),
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
                              prefixIcon:
                                  const Icon(Icons.home, color: Colors.teal),
                            ),
                            onChanged: (value) =>
                                _stateController.text = value),
                      ),
                    ],
                  ),
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
                              prefixIcon:
                                  const Icon(Icons.place, color: Colors.teal),
                            ),
                            onChanged: (value) => _cityController.text = value),
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
                              prefixIcon:
                                  const Icon(Icons.home, color: Colors.teal),
                            ),
                            onChanged: (value) =>
                                _postCodeController.text = value),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AddressAutocompleteTextFormField(
            mapsApiKey: Env.googleMapApiKey,
            controller: _addressController,
            debounceTime: 200,
            onClearClick: () {
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
                final latLng = GeoPoint(place.lat!, place.lng!);
                await viewModel.updateAddressAndMoveMap(latLng);
              }
            },
            // onFinishedEditingWithNoSuggestion: (text) {
            //   // you should invalidate the last entry of onSuggestionClick if you really need a valid location,
            //   // otherwise decide what to do based on what the user typed, can be an empty string
            //   debugPrint(
            //       'onFinishedEditingWithNoSuggestion()  text typed: $text');
            // },
            hoverColor: Colors.purple,
            // for desktop platforms with mouse
            selectionColor: Colors.purpleAccent,
            // for desktop platforms with mouse
            buildItem: (Suggestion suggestion, int index) {
              return Container(
                  margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                  //<<This area will get hoverColor/selectionColor on desktop
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerLeft,
                  color: Colors.white,
                  child: Text(suggestion.description,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)));
            },
            clearButton: const Icon(Icons.close),
            autofocus: true,
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            autovalidateMode: AutovalidateMode.disabled,
            keyboardType: TextInputType.streetAddress,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              debugPrint('onEditingComplete() for TextFormField');
            },
            onChanged: (newText) {
              debugPrint('onChanged() for TextFormField got "$newText"');
            },
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
          ),
          const SizedBox(height: 24),
          // 지도 표시
          Card(
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
                    GoogleMap(
                      gestureRecognizers: <Factory<
                          OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer())
                      },
                      mapType: MapType.normal,
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(37.42796133580664, -122.085749655962),
                        zoom: 14.0,
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
                      onCameraIdle: () async {
                        if (_currentCameraPosition != null) {
                          await viewModel.updateAddressAndMoveMap(
                              GeoPoint(_currentCameraPosition!.target.latitude, _currentCameraPosition!.target.longitude));
                        }
                      },
                      // markers: {
                      //   Marker(
                      //     markerId: const MarkerId('selected_location'),
                      //     draggable: true,
                      //     onDragEnd: (newPosition) {
                      //       viewModel.updateAddressAndMoveMap(GeoPoint(newPosition.latitude, newPosition.longitude));
                      //     },
                      //   ),
                      // },
                    ),
                    // 중앙 고정 핀
                    Center(
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
                          // 핀이 바닥에 닿는 곳을 정확한 위치로 표시하기 위한 간격
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    // 하단 주소 표시 패널
                    Positioned(
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
                            Text(
                              viewModel.currentAddress,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  _countryController.text = state.wgData.country;
                                  _cityController.text = state.wgData.city;
                                  _stateController.text = state.wgData.state;
                                  _postCodeController.text = state.wgData.postCode;
                                  _addressController.text = state.wgData.address;
                                  // 선택한 주소로 다음 단계 진행
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '선택한 주소: ${viewModel.currentAddress}')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
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
                    ),
                    // 내 위치로 가는 버튼
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        onPressed: viewModel.moveToCurrentLocation,
                        child: const Icon(Icons.my_location),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 위치 확인 메시지
          if (state.wgData.postCode.isNotEmpty &&
              state.wgData.address.isNotEmpty)
            Container(
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
            ),
        ],
      ),
    );
  }
}

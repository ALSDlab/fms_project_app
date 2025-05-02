import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../upload_wg_page_view_model.dart';

class SetLocationStepPage extends StatefulWidget {
  const SetLocationStepPage({super.key});

  @override
  _SetLocationStepPageState createState() => _SetLocationStepPageState();
}

class _SetLocationStepPageState extends State<SetLocationStepPage> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<UploadWGPageViewModel>();
    // _locationController.text = viewModel.listing.location;
    // _addressController.text = viewModel.listing.address;
  }

  @override
  void dispose() {
    _locationController.dispose();
    _addressController.dispose();
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
            '숙소의 위치는 어디인가요?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: '지역',
              hintText: '예: 서울, 제주, 부산 등',
              border: OutlineInputBorder(),
              filled: true,
              prefixIcon: Icon(Icons.location_on),
            ),
            onChanged: (value) {
              // 간단한 예제에서는 위치 선택 시 위도/경도 값을 임의로 설정
              // viewModel.setLocation(
              //   value,
              //   _addressController.text,
              //   37.5665, // 서울 중심 위도
              //   126.9780, // 서울 중심 경도
              // );
            },
          ),

          const SizedBox(height: 16),

          TextField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: '상세 주소',
              hintText: '예: 강남구 역삼동 123-45',
              border: OutlineInputBorder(),
              filled: true,
              prefixIcon: Icon(Icons.home),
            ),
            onChanged: (value) {
              // viewModel.setLocation(
              //   _locationController.text,
              //   value,
              //   viewModel.listing.latitude,
              //   viewModel.listing.longitude,
              // );
            },
          ),

          const SizedBox(height: 24),

          // 지도 표시 영역 (실제로는 Google 지도 또는 다른 지도 API를 통합)
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    '지도 표시 영역',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '실제 구현 시 Google Maps 또는 Naver Maps 등으로 대체',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 위치 확인 메시지
          if (state.wgData.region.isNotEmpty && state.wgData.adresse.isNotEmpty)
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
                      '위치 정보가 확인되었습니다: ${state.wgData.region}, ${state.wgData.adresse}',
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../upload_wg_page_view_model.dart';

class FinalConfirmStepPage extends StatefulWidget {
  const FinalConfirmStepPage({super.key});

  @override
  State<FinalConfirmStepPage> createState() => _FinalConfirmStepPageState();
}

class _FinalConfirmStepPageState extends State<FinalConfirmStepPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UploadWGPageViewModel>();
    final state = viewModel.state;
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300.0,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    viewModel.goToPreviousStep();
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: state.wgImageFiles.length, // 실제 이미지 개수로 변경
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          // 여기에 실제 이미지 위젯을 넣습니다.
                          // 예시로 Placeholder를 사용합니다.
                          return Image.file(
                            state.wgImageFiles[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      if (state.wgImageFiles.length > 1)
                        Container(
                          margin: const EdgeInsets.all(16.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            '${_currentPage + 1}/${state.wgImageFiles.length}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.wgData.title,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '쿠르브부아, 프랑스의 방\n싱글 침대 1개 · 공용 욕실',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 32, thickness: 1),
                          Row(
                            children: [
                              const Icon(Icons.diamond_outlined,
                                  color: Colors.deepPurple),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '흔치 않은 기회! 이 숙소는 보통 예약이 가득 차 있습니다.',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.deepPurple[700]),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 80), // 하단 고정 영역을 위한 공간
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 1.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '₩46,604 /박',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '✓ 취소 수수료 없음',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

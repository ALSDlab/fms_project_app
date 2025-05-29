import 'package:flutter/material.dart';
import 'package:fmsproject/domain/model/wg_data_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/chat_model.dart';
import 'find_wg_page_view_model.dart';
import 'full_map_screen.dart';

class SelectedWgDataPage extends StatefulWidget {
  final Function(Map<String, int>) resetNavigation;
  final Function(Map<String, int>) resetChatList;
  final WgDataModel selectedWgData;

  const SelectedWgDataPage(
      {super.key,
      required this.resetNavigation,
      required this.resetChatList,
      required this.selectedWgData});

  @override
  State<SelectedWgDataPage> createState() => _SelectedWgDataPageState();
}

class _SelectedWgDataPageState extends State<SelectedWgDataPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FindWGPageViewModel>();
    final state = viewModel.state;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      viewModel.loadCurrentUser();
      await viewModel.getHostUserData(widget.selectedWgData.userId);
    });
    return Scaffold(
      backgroundColor: const Color(0xFFEBF4F6),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300.0,
                pinned: true,
                backgroundColor: const Color(0xFFEBF4F6),
                title: const Text('Selected WG page'),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.file_upload_outlined,
                        color: Colors.black),
                    onPressed: () {
                      // 공유하기 동작
                    },
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.favorite_border, color: Colors.black),
                    onPressed: () {
                      // 좋아요 동작
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: widget.selectedWgData.thumbnails.length,
                        // 실제 이미지 개수로 변경
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final String thumbnailImageUrl =
                              widget.selectedWgData.thumbnails[index];
                          return Image.network(
                            thumbnailImageUrl,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      if (widget.selectedWgData.thumbnails.length > 1)
                        Container(
                          margin: const EdgeInsets.all(16.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            '${_currentPage + 1}/${widget.selectedWgData.thumbnails.length}',
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
                            widget.selectedWgData.title,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.selectedWgData.abDem} - ${widget.selectedWgData.bis}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 16),
                          // const Row(
                          //   children: [
                          //     Icon(Icons.star, color: Colors.pink, size: 20),
                          //     SizedBox(width: 4),
                          //     Text(
                          //       '4.85',
                          //       style: TextStyle(
                          //           fontSize: 16, fontWeight: FontWeight.bold),
                          //     ),
                          //     SizedBox(width: 16),
                          //     Row(
                          //       children: [
                          //         Icon(Icons.person_outline,
                          //             color: Colors.black, size: 20),
                          //         Icon(Icons.person_outline,
                          //             color: Colors.black, size: 20),
                          //       ],
                          //     ),
                          //     SizedBox(width: 4),
                          //     Text(
                          //       '게스트 선호',
                          //       style: TextStyle(fontSize: 16),
                          //     ),
                          //     Spacer(),
                          //     Text(
                          //       '462개 후기',
                          //       style: TextStyle(
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.bold,
                          //         decoration: TextDecoration.underline,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const Divider(height: 32, thickness: 1),
                          // _buildAmenityRow(Icons.home_outlined, '집의 방'),
                          // _buildAmenityRow(
                          //     Icons.location_on_outlined, '훌륭한 위치'),
                          // _buildAmenityRow(Icons.local_laundry_service_outlined,
                          //     '세탁기 및 건조기'),
                          // _buildAmenityRow(Icons.shield_outlined, '슈퍼호스트'),
                          // // 아이콘 변경 필요시
                          // _buildAmenityRow(
                          //     Icons.check_circle_outline, '순조로운 체크인 절차'),
                          // _buildAmenityRow(Icons.tv_outlined, 'TV'),
                          // const Divider(height: 32, thickness: 1),
                          // Row(
                          //   children: [
                          //     const Icon(Icons.diamond_outlined,
                          //         color: Colors.deepPurple),
                          //     const SizedBox(width: 8),
                          //     Expanded(
                          //       child: Text(
                          //         '흔치 않은 기회! 이 숙소는 보통 예약이 가득 차 있습니다.',
                          //         style: TextStyle(
                          //             fontSize: 14,
                          //             color: Colors.deepPurple[700]),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.selectedWgData.description,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.selectedWgData.city}, ${widget.selectedWgData.state}, ${widget.selectedWgData.country}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullMapScreen(
                                    initialPosition: LatLng(
                                        widget
                                            .selectedWgData.location!.latitude,
                                        widget.selectedWgData.location!
                                            .longitude),
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1),
                                ),
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        widget
                                            .selectedWgData.location!.latitude,
                                        widget.selectedWgData.location!
                                            .longitude),
                                    zoom: 15.0,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId:
                                          const MarkerId('initial_position'),
                                      position: LatLng(
                                          widget.selectedWgData.location!
                                              .latitude,
                                          widget.selectedWgData.location!
                                              .longitude),
                                    ),
                                  },
                                  myLocationButtonEnabled: false,
                                  zoomControlsEnabled: false,
                                  scrollGesturesEnabled: false,
                                  zoomGesturesEnabled: false,
                                  tiltGesturesEnabled: false,
                                  rotateGesturesEnabled: false,
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'We find',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.selectedWgData.weFind,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'We are',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.selectedWgData.weAre,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 80),
                          // 하단 고정 영역을 위한 공간
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
                      Text(
                        widget.selectedWgData.miete,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //TODO: 호스트, 호스트명 불러오기 기능
                      Text(
                        widget.selectedWgData.city,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      onTap: (widget.selectedWgData.userId != state.currentUser)
                          ? () async {
                              String receiverId = widget.selectedWgData.userId;
                              final chatId = await viewModel.findChatRoom(
                                  state.currentUser, receiverId);
                              ChatModel? chat =
                                  await viewModel.loadChatRoom(chatId);
                              bool isMakeRoom = false;
                              if (chat == null) {
                                isMakeRoom = true;
                                chat = ChatModel(
                                  chatId: chatId,
                                  participants: [state.currentUser, receiverId],
                                  createdAt: DateTime.now(),
                                  lastMessageId: '',
                                  lastMessage: '',
                                  lastMessageAt: null,
                                );
                              }

                              if (context.mounted) {
                                GoRouter.of(context).push('/chat_page', extra: {
                                  'isMakeRoom': isMakeRoom,
                                  'chat': chat,
                                  'resetNavigation': widget.resetNavigation,
                                  'resetChatList': widget.resetChatList
                                });
                              }
                            }
                          : null,
                      child: Ink(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: (state.tapped)
                                    ? const Color(0xff4FB0C6)
                                    : const Color(0xff54D1DB)),
                            borderRadius: BorderRadius.circular(20),
                            color: (state.tapped)
                                ? const Color(0xff4FB0C6)
                                : const Color(0xFFEBF4F6)),
                        height: 50,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Send Message',
                            style: TextStyle(
                                fontSize: 18,
                                color: (state.tapped)
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// Widget _buildAmenityRow(IconData icon, String text) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Row(
//       children: [
//         Icon(icon, size: 24, color: Colors.black87),
//         const SizedBox(width: 16),
//         Text(text,
//             style: const TextStyle(fontSize: 16, color: Colors.black87)),
//       ],
//     ),
//   );
// }
}

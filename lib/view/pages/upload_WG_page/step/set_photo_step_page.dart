import 'package:flutter/material.dart';
import 'package:fmsproject/utils/wg_photos_widget.dart';
import 'package:provider/provider.dart';

import '../upload_wg_page_view_model.dart';

class SetPhotoStepPage extends StatefulWidget {
  const SetPhotoStepPage({super.key});

  @override
  State<SetPhotoStepPage> createState() => _SetPhotoStepPageState();
}

class _SetPhotoStepPageState extends State<SetPhotoStepPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = context.read<UploadWGPageViewModel>();
      final state = viewModel.state;
      viewModel.addWgImagesComplete(state.wgImageFiles);
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UploadWGPageViewModel>();
    final state = viewModel.state;

    // 첫 번째 아이템이 첫 줄에 홀로 표시되고 나머지는 한 줄에 2개씩 표시되도록 합니다
    bool hasPrimaryItem = state.wgImageFiles.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Photos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            // 첫 번째 줄 - 한 개의 아이템 (있는 경우)
            if (hasPrimaryItem)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: _buildDraggableItem(viewModel, state, 0, true),
                ),
              ),

            // 나머지 아이템들 - 그리드 형태로 (한 줄에 2개씩)
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // 첫 번째 아이템을 제외하고 나머지 아이템들의 인덱스 조정
                  final actualIndex = hasPrimaryItem ? index + 1 : index;

                  // 아이템의 개수보다 인덱스가 크면 추가 버튼 표시
                  if (actualIndex >= state.wgImageFiles.length) {
                    return _buildAddPhotoButton(context, viewModel);
                  }

                  // 드래그 가능한 아이템 위젯
                  return _buildDraggableItem(
                      viewModel, state, actualIndex, false);
                },
                // 나머지 아이템들과 '추가' 버튼을 위한 총 개수
                childCount:
                    state.wgImageFiles.length - (hasPrimaryItem ? 1 : 0) + 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 드래그 가능한 아이템 위젯 생성
  Widget _buildDraggableItem(UploadWGPageViewModel viewModel, dynamic state,
      int index, bool isPrimary) {
    // 드래그 중인 아이템이면 투명하게 표시
    if (viewModel.state.isPhotoDragging &&
        viewModel.state.draggedItemIndex == index) {
      return Opacity(
        opacity: 0.2,
        child: WgPhotosWidget(
          key: ValueKey('photo_$index'),
          viewModel: viewModel,
          photoIndex: index,
          isPrimary: isPrimary,
        ),
      );
    }

    // DragTarget - 다른 아이템이 이 위치로 드래그될 수 있음
    return DragTarget<int>(
      onAcceptWithDetails: (DragTargetDetails draggedIndex) {
        viewModel.reorderPhotos(draggedIndex.data, index);
      },
      onWillAccept: (draggedIndex) {
        // 자신을 자신 위에 드롭하는 것은 허용하지 않음
        return draggedIndex != null && draggedIndex != index;
      },
      onMove: (details) {
        viewModel.draggingOnMove(index);
      },
      onLeave: (data) {
        viewModel.draggingOnMove(-1);
      },
      builder: (context, candidateData, rejectedData) {
        // 드래그 중에 hover된 상태를 시각적으로 표시
        final isHovering = viewModel.state.currentHoverIndex == index;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isHovering ? Colors.blue : Colors.transparent, width: 2),
          ),
          child: LongPressDraggable<int>(
            data: index,
            feedback: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: isPrimary
                    ? (MediaQuery.of(context).size.width - 16)
                    : (MediaQuery.of(context).size.width - 26) / 2,
                child: WgPhotosWidget(
                  key: ValueKey('dragging_photo_$index'),
                  viewModel: viewModel,
                  photoIndex: index,
                  isPrimary: isPrimary,
                ),
              ),
            ),
            onDragStarted: () {
              viewModel.draggingOnMoveStartEnd(true, index);
            },
            onDragCompleted: () {
              viewModel.draggingOnMoveStartEnd(false, -1);
              viewModel.draggingOnMove(-1);
            },
            onDraggableCanceled: (velocity, offset) {
              viewModel.draggingOnMoveStartEnd(false, -1);
              viewModel.draggingOnMove(-1);
            },
            child: WgPhotosWidget(
              key: ValueKey('photo_$index'),
              viewModel: viewModel,
              photoIndex: index,
              isPrimary: isPrimary,
            ),
          ),
        );
      },
    );
  }

  // 사진 추가 버튼
  Widget _buildAddPhotoButton(
      BuildContext context, UploadWGPageViewModel viewModel) {
    return Container(
      key: const ValueKey('addPhotoButton'),
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text(''),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.pink,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            _showAddPhotoBottomSheet(context, viewModel);
            viewModel.addWgImagesComplete(viewModel.state.wgImageFiles);
          },
        ),
      ),
    );
  }

  // 사진 추가 모달 바텀 시트
  void _showAddPhotoBottomSheet(
      BuildContext context, UploadWGPageViewModel viewModel) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Select from Library'),
                      onTap: () {
                        Navigator.pop(context);
                        viewModel.pickImagesFromGallery(context);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('Take a photo'),
                      onTap: () {
                        Navigator.pop(context);
                        viewModel.takePhoto();
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 취소 버튼 (별도 박스)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: ListTile(
                  leading: const Icon(Icons.close, color: Colors.red),
                  title:
                      const Text('Cancel', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context); // 모달 닫기
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

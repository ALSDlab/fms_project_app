import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/utils/gif_progress_bar.dart';
import 'package:fmsproject/view/pages/edit_profile_page/edit_profile_page_view_model.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditProfilePageViewModel>();
    final state = viewModel.state;
    return Scaffold(
      backgroundColor: const Color(0xFFEBF4F6),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFFEBF4F6),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: (state.isLoading)
                          ? Center(
                              child: GifProgressBar(),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.lightGreenAccent,
                              child: ClipOval(
                                child: (state.thumbnail == '')
                                    ? Image.asset(
                                        'assets/images/person1.png',
                                        width: 100, // 지름을 명시적으로 설정 (radius*2)
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        state.thumbnail,
                                        width: 100, // 지름을 명시적으로 설정 (radius*2)
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: -5,
                      child: GestureDetector(
                        onTap: () {
                          // 프로필 이미지 변경 로직
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading:
                                                const Icon(Icons.photo_library),
                                            title: const Text('라이브러리에서 선택'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              viewModel.pickImageFromGallery(
                                                  state.currentUser);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.camera_alt),
                                            title: const Text('사진 찍기'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              viewModel
                                                  .takePhoto(state.currentUser);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // 취소 버튼 (별도 박스)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: ListTile(
                                        leading: const Icon(Icons.close,
                                            color: Colors.red),
                                        title: const Text('취소',
                                            style:
                                                TextStyle(color: Colors.red)),
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
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            color: Colors.pink,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            BootstrapIcons.pencil,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'User Information',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildProfileItem(
                context: context,
                title: 'Name',
                content: state.name,
                onTap: () => _showEditModal(
                  context: context,
                  title: 'Name',
                  initialValue: state.name,
                  onSave: viewModel.updateName,
                ),
              ),
              _buildProfileItem(
                context: context,
                title: 'Email',
                content: state.email,
                onTap: () => _showEditModal(
                  context: context,
                  title: 'Email',
                  initialValue: state.email,
                  onSave: viewModel.updateEmail,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Comment',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildProfileItem(
                context: context,
                title: 'Comment',
                content: state.comment,
                onTap: () => _showEditModal(
                  context: context,
                  title: 'Comment',
                  initialValue: state.comment,
                  onSave: viewModel.updateComment,
                  isMultiline: true,
                ),
              ),
              // const SizedBox(height: 32),
              // const Text(
              //   '위치',
              //   style: TextStyle(
              //     fontSize: 22,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              BootstrapIcons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditModal({
    required BuildContext context,
    required String title,
    required String initialValue,
    required Function(String) onSave,
    bool isMultiline = false,
  }) {
    final textController = TextEditingController(text: initialValue);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        onSave(textController.text);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.pink,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: textController,
                  autofocus: true,
                  maxLines: isMultiline ? 5 : 1,
                  decoration: InputDecoration(
                    hintText: 'Input your $title',
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.pink,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

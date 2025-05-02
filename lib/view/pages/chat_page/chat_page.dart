import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/domain/model/chat_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/model/message_model.dart';
import '../../../utils/full_screen_image_view_widget.dart';
import '../../../utils/gif_progress_bar.dart';
import 'chat_page_view_model.dart';

class ChatPage extends StatefulWidget {
  final bool isMakeRoom;
  final ChatModel chat;
  final Function(Map<String, int>) resetNavigation;
  final Function(Map<String, int>) resetChatList;

  const ChatPage(
      {super.key,
      required this.chat,
      required this.resetNavigation,
      required this.resetChatList,
      required this.isMakeRoom});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final viewModel = context.read<ChatPageViewModel>();
        await viewModel.markMessagesAsRead(
            widget.chat.chatId, widget.resetNavigation);
        await viewModel.loadMessages(
            widget.resetNavigation, widget.resetChatList);
        viewModel.scrollControllerInit();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatPageViewModel>();
    final state = viewModel.state;

    return Scaffold(
      backgroundColor: const Color(0xFFEBF4F6),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(BootstrapIcons.arrow_left),
            onPressed: () {
              GoRouter.of(context).pop(true);
            },
          ),
          elevation: 0,
          backgroundColor: const Color(0xFFEBF4F6),
          title: Text(
            "Chat with ${widget.chat.participants.where((userId) => userId != state.currentUser).toList().join(', ')}",
            overflow: TextOverflow.ellipsis,
          )),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Builder(builder: (context){
                  final chatMessages = state.messages
                      .where((message) => message.chatId == widget.chat.chatId)
                      .toList();
                  return ListView.builder(
                    reverse: true,
                    controller: viewModel.scrollController,
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      var message = chatMessages[index];
                      bool isMe = message.senderId == state.currentUser;
                      bool isImage = message.type == 'image';

                      return Align(
                        alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: isImage
                              ? InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FullScreenImageViewWidget(
                                          imageUrl: message.text.replaceAll(
                                              'thumbnails/thumbnail_', ''),
                                          heroTag: 'heroTag',
                                        ),
                                  ),
                                );
                              },
                              child: Image.network(message.text, width: 200))
                              : Text(
                            message.text,
                            style: TextStyle(
                                color: isMe ? Colors.white : Colors.black),
                          ),
                        ),
                      );
                    },
                  );
                }),

                
                if (state.isOldMessageLoading)
                  Positioned(
                    top: 16, // 스크롤 위쪽에 표시
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GifProgressBar(),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Select from Library'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      viewModel.pickImageFromGallery(
                                          widget.chat.chatId);
                                    },
                                  ),
                                  const Divider(),
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text('Take a photo'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      viewModel.takePhoto(widget.chat.chatId);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 취소 버튼 (별도 박스)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: ListTile(
                                leading:
                                    const Icon(Icons.close, color: Colors.red),
                                title: const Text('Cancel',
                                    style: TextStyle(color: Colors.red)),
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
              ),
              Expanded(
                child: TextFormField(
                  minLines: 1,
                  maxLines: 5,
                  controller: viewModel.messageController,
                  decoration: InputDecoration(
                    hintText: 'Enter message...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 0.1,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xFF2F362F),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              (state.isLoading)
                  ? Center(
                      child: GifProgressBar(),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (viewModel.messageController.text.isNotEmpty) {
                          if (widget.isMakeRoom) {
                            viewModel.createNewChatRoom(widget.chat);
                          }
                          final DateTime now = DateTime.now();
                          final MessageModel message = MessageModel(
                              messageId: now.millisecondsSinceEpoch.toString() +
                                  const Uuid().v4().substring(0, 6),
                              chatId: widget.chat.chatId,
                              senderId: state.currentUser,
                              text: viewModel.messageController.text,
                              timestamp: now,
                              readByUsers: [],
                              type: 'text');
                          viewModel.sendMessageToUser(
                              widget.chat.chatId, message);
                        }
                      }),
            ],
          ),
        ],
      ),
    );
  }
}

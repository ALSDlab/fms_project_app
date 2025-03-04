import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/domain/model/chat_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/model/message_model.dart';
import '../../../utils/gif_progress_bar.dart';
import 'chat_page_view_model.dart';

class ChatPage extends StatefulWidget {
  final ChatModel chat;
  final Function(int) resetNavigation;
  final Function(Map<String, int>) resetChatList;

  const ChatPage(
      {super.key,
      required this.chat,
      required this.resetNavigation,
      required this.resetChatList});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    Future.microtask(() {
      if (mounted) {
        final viewModel = context.read<ChatPageViewModel>();
        viewModel.loadMessages(widget.resetNavigation, widget.resetChatList);
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
              GoRouter.of(context).go('/chat_list_page');
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
            child: ListView.builder(
              reverse: true,
              itemCount: state.messages
                  .where((message) => message.chatId == widget.chat.chatId)
                  .toList()
                  .length,
              itemBuilder: (context, index) {
                var message = state.messages
                    .where((message) => message.chatId == widget.chat.chatId)
                    .toList()[index];
                bool isMe = message.senderId == state.currentUser;
                bool isImage = message.type == 'image';

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isImage
                        ? Image.network(message.text, width: 200)
                        : Text(
                            message.text,
                            style: TextStyle(
                                color: isMe ? Colors.white : Colors.black),
                          ),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.image), onPressed: () {}),
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
                      }),
            ],
          ),
        ],
      ),
    );
  }
}

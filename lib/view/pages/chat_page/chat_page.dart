import 'package:flutter/material.dart';
import 'package:fmsproject/domain/model/chat_model.dart';
import 'package:provider/provider.dart';

import '../../navigation/navigation_bar_page_view_model.dart';
import 'chat_page_view_model.dart';

class ChatPage extends StatelessWidget {
  final ChatModel chat;

  const ChatPage({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final navigationViewModel = context.watch<NavigationBarPageViewModel>();
    final navigationState = navigationViewModel.state;
    final viewModel = context.watch<ChatPageViewModel>();
    final state = viewModel.state;

    return Scaffold(
      backgroundColor: const Color(0xFFEBF4F6),
      appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: const Color(0xFFEBF4F6),
          title: Text(
            "Chat with ${chat.participants.where((userId) => userId != navigationState.currentUser).toList().join(', ')}",
            overflow: TextOverflow.ellipsis,
          )),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: navigationState.messages
                  .where((message) => message.chatId == chat.chatId)
                  .toList()
                  .length,
              itemBuilder: (context, index) {
                var message = navigationState.messages
                    .where((message) => message.chatId == chat.chatId)
                    .toList()[index];
                bool isMe = message.senderId == navigationState.currentUser;
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
                child: TextField(
                  minLines: 1,
                  maxLines: 5,
                  controller: viewModel.messageController,
                  decoration:
                      const InputDecoration(hintText: "Enter message..."),
                ),
              ),
              IconButton(icon: const Icon(Icons.send), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

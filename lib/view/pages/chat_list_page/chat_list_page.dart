import 'package:flutter/material.dart';
import 'package:fmsproject/utils/gif_progress_bar.dart';
import 'package:fmsproject/view/pages/chat_list_page/chat_list_page_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../navigation/navigation_bar_page_view_model.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage(
      {super.key, required this.resetNavigation, required this.resetChatList});

  final Function(Map<String, int>) resetNavigation;
  final Function(Map<String, int>) resetChatList;

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final viewModel = context.read<ChatListPageViewModel>();
        await viewModel.loadChats();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatListPageViewModel>();
    final state = viewModel.state;
    final navigationBarPageViewModel =
        context.watch<NavigationBarPageViewModel>();
    final navigationBarPageState = navigationBarPageViewModel.state;

    return Scaffold(
        appBar: AppBar(title: const Text("Messages")),
        body: SafeArea(
          child: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: (state.isLoading)
                ? Center(child: GifProgressBar())
                : (state.chats.isEmpty)
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No Message'),
                          Text('New messages will appear here')
                        ],
                      )
                    : ListView.builder(
                        itemCount: state.chats.length,
                        itemBuilder: (context, index) {
                          var chat = state.chats[index];
                          return ListTile(
                            key: ValueKey(chat.chatId),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  chat.participants.join(",\n"),
                                  overflow: TextOverflow.visible,
                                ),
                                Text(viewModel
                                    .formatLastMessageTime(chat.lastMessageAt)),
                              ],
                            ),
                            subtitle: Text(chat.lastMessage ?? '', style: const TextStyle(fontSize: 18, color: Colors.grey),),
                            trailing: (navigationBarPageState
                                            .chatRoomBadge[chat.chatId] !=
                                        null &&
                                    navigationBarPageState
                                            .chatRoomBadge[chat.chatId]! >
                                        0)
                                ? Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${navigationBarPageState.chatRoomBadge[chat.chatId]}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )
                                : null,
                            onTap: () {
                              if (context.mounted) {
                                GoRouter.of(context).push('/chat_page', extra: {
                                  'isMakeRoom': false,
                                  'chat': chat,
                                  'resetNavigation': widget.resetNavigation,
                                  'resetChatList': widget.resetChatList
                                });
                              }
                            },
                          );
                        },
                      ),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:fmsproject/utils/gif_progress_bar.dart';
import 'package:fmsproject/view/pages/chat_list_page/chat_list_page_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../navigation/navigation_bar_page_view_model.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key, required this.resetNavigation});

  final Function(int) resetNavigation;

  @override
  Widget build(BuildContext context) {
    final navigationViewModel = context.watch<NavigationBarPageViewModel>();
    final navigationState = navigationViewModel.state;
    final viewModel = context.watch<ChatListPageViewModel>();
    final state = viewModel.state;
    return Scaffold(
        appBar: AppBar(title: const Text("Messages")),
        body: SafeArea(
          child: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: (state.isLoading)
                ? GifProgressBar()
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
                            title: Text(chat.participants.join(", ")),
                            subtitle: Text(chat.lastMessage ?? ''),
                            trailing: (navigationState.messages
                                    .where((e) =>
                                        e.chatId == chat.chatId &&
                                        e.senderId !=
                                            navigationState.currentUser &&
                                        !e.readByUsers.contains(
                                            navigationState.currentUser))
                                    .isNotEmpty)
                                ? Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${navigationState.messages.where((e) => e.chatId == chat.chatId && e.senderId != navigationState.currentUser && !e.readByUsers.contains(navigationState.currentUser)).length}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  )
                                : null,
                            onTap: () {
                              viewModel.markMessagesAsRead(chat.chatId, navigationState.currentUser, resetNavigation);
                              navigationViewModel.loadMessages();
                              GoRouter.of(context)
                                  .push('/chat_page', extra: {'chat': chat});
                            },
                          );
                        },
                      ),
          ),
        ));
  }
}

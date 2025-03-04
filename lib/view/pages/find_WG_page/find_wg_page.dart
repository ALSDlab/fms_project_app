import 'package:flutter/material.dart';
import 'package:fmsproject/domain/model/chat_model.dart';
import 'package:fmsproject/view/pages/find_WG_page/find_wg_page_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FindWGPage extends StatelessWidget {
  final Function(int) resetNavigation;
  final Function(Map<String, int>) resetChatList;


  const FindWGPage({super.key, required this.resetNavigation, required this.resetChatList});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FindWGPageViewModel>();
    final state = viewModel.state;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.loadCurrentUser();
    });
    return Scaffold(
        backgroundColor: const Color(0xFFEBF4F6),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFEBF4F6),
          title: const Text('Find WG page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            onTap: () async {
              const String receiverId = '2coIOGzCahfxEYOkLy33be2kEAN2';
              final chatId = await viewModel.findOrCreateChatRoom(
                  state.currentUser, receiverId);
              final ChatModel? chat = await viewModel.loadChatRoom(chatId);
              if (chat != null) {
                GoRouter.of(context)
                    .push('/chat_page', extra: {'chat': chat, 'resetNavigation': resetNavigation, 'resetChatList' : resetChatList});
              }
              // final ChatModel chat = ChatModel(
              //     chatId: chatId,
              //     participants: [state.currentUser, receiverId],
              //     createdAt: DateTime.now());
            },
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
                      color: (state.tapped) ? Colors.white : Colors.black),
                ),
              ),
            ),
          ),
        ));
  }
}

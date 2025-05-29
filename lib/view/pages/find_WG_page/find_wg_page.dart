import 'package:flutter/material.dart';
import 'package:fmsproject/domain/model/chat_model.dart';
import 'package:fmsproject/view/pages/find_WG_page/find_wg_page_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../utils/gif_progress_bar.dart';

class FindWGPage extends StatelessWidget {
  final Function(Map<String, int>) resetNavigation;
  final Function(Map<String, int>) resetChatList;

  const FindWGPage(
      {super.key, required this.resetNavigation, required this.resetChatList});

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
        body: SafeArea(
          child: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: (state.isLoading)
                ? Center(child: GifProgressBar())
                : (state.wgDataList.isEmpty)
                ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No WG Data'),
                Text('New messages will appear here')
              ],
            )
                : ListView.builder(
              itemCount: state.wgDataList.length,
              itemBuilder: (context, index) {
                var wgData = state.wgDataList[index];
                return ListTile(
                  key: ValueKey(wgData.wgId),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      wgData.thumbnails[0],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        wgData.title,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${wgData.abDem} - ${wgData.bis}',
                        style: const TextStyle(
                            fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        wgData.miete,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (context.mounted) {
                      GoRouter.of(context).push('/selected_wg_data_page', extra: {
                        'wgData': wgData,
                        'resetNavigation': resetNavigation,
                        'resetChatList': resetChatList
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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/view/pages/setting_page/setting_page_view_model.dart';
import 'package:provider/provider.dart';

import '../../../utils/gif_progress_bar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.resetNavigation});

  final Function(bool) resetNavigation;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingPageViewModel>();
    final state = viewModel.state;

    return Scaffold(
      backgroundColor: const Color(0xFFEBF4F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFEBF4F6),
        title: Text('setting'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: (state.isLoading)
            ? Center(
                child: GifProgressBar(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  const Center(
                    child: Text('setting page'),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        await viewModel.logOutUser(context);
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
                            'Log Out',
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
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        await viewModel.signOutUser(context);
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
                            'Abmelden',
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
                  const Spacer(),
                ],
              ),
      ),
    );
  }
}

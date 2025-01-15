import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/view/pages/setting_page/setting_page_view_model.dart';
import 'package:provider/provider.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Center(
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
                  //TODO: 탈퇴기능 넣기

                  // if (viewModel.languageController.value != null &&
                  //     viewModel.targetLanguageController.value != null) {
                  //   // await viewModel.applyAndSaveSettings();
                  //   if (context.mounted) {
                  //     context.go('/day_sentence_page',
                  //         extra: {'resetNavigation': widget.resetNavigation});
                  //   }
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //       content: Text('Please select a language'),
                  //       duration: Duration(seconds: 2),
                  //     ),
                  //   );
                  // }
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
                          color: (state.tapped) ? Colors.white : Colors.black),
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

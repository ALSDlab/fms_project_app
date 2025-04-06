import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/utils/full_screen_image_view_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../utils/gif_progress_bar.dart';
import '../../../utils/image_load_widget.dart';
import 'setting_page_view_model.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.resetNavigation});

  final Function resetNavigation;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  XFile? _myPickedFile;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingPageViewModel>();
    final state = viewModel.state;
    const double imageSize = 100;

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
              : ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 9),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FullScreenImageViewWidget(
                                    imageUrl: state.fullImageUrl,
                                    heroTag: 'heroTag',
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: const BoxConstraints(
                                    minHeight: imageSize,
                                    minWidth: imageSize,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  child: ClipOval(
                                      child: (_myPickedFile != null)
                                          ? Image.file(
                                              File(_myPickedFile!.path),
                                              width: imageSize,
                                              height: imageSize,
                                              fit: BoxFit.cover,
                                            )
                                          : (state.currentUser.isNotEmpty &&
                                                  state.thumbnailUrl != '')
                                              ? ImageLoadWidget(
                                                  imageUrl: state.thumbnailUrl,
                                                  width: imageSize,
                                                  height: imageSize,
                                                  fit: BoxFit.cover,
                                                  loadingBarRadius: 15,
                                                )
                                              : Image.asset(
                                                  'assets/images/person1.png',
                                                  width: imageSize,
                                                  height: imageSize,
                                                  fit: BoxFit.cover,
                                                )),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (context.mounted) {
                                  GoRouter.of(context)
                                      .push('/edit_profile_page');
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Hi,',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      (state.userName != '')
                                          ? Text(
                                              state.userName,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            )
                                          : const Text(
                                              'User',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                    ],
                                  ),
                                  const Icon(
                                    BootstrapIcons.chevron_compact_right,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
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
                    const SizedBox(
                      height: 50,
                    ),
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
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                )),
    );
  }
}

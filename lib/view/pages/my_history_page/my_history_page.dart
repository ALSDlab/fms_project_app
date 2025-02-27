import 'package:flutter/material.dart';

class MyHistoryPage extends StatefulWidget {
  const MyHistoryPage({super.key, required this.resetNavigation});

  final Function resetNavigation;

  @override
  State<MyHistoryPage> createState() => _MyHistoryPageState();
}

class _MyHistoryPageState extends State<MyHistoryPage> {
  @override
  Widget build(BuildContext context) {
    // final viewModel = context.watch<MyHistoryPageViewModel>();
    return Scaffold(
        backgroundColor: const Color(0xFFEBF4F6),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFEBF4F6),
          title: const Text('my history'),
        ),
        body: const Center(
          child: Text('my history page'),
        ));
  }
}

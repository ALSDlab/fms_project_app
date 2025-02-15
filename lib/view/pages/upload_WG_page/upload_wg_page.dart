import 'package:flutter/material.dart';

class UploadWGPage extends StatelessWidget {
  const UploadWGPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEBF4F6),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFEBF4F6),
          title: const Text('UploadWG'),
        ),
        body: const Center(
          child: Text('upload WG page'),
        )
    );
  }
}

import 'package:flutter/material.dart';

class FindWGPage extends StatelessWidget {
  const FindWGPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEBF4F6),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFEBF4F6),
          title: const Text('FindWG'),
        ),
        body: const Center(
          child: Text('find WG page'),
        ));
  }
}

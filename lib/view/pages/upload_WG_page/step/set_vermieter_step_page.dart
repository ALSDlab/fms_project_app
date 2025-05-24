import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../upload_wg_page_view_model.dart';

class SetVermieterStepPage extends StatefulWidget {
  const SetVermieterStepPage({super.key});

  @override
  State<SetVermieterStepPage> createState() => _SetVermieterStepPageState();
}

class _SetVermieterStepPageState extends State<SetVermieterStepPage> {
  final TextEditingController _weAreController = TextEditingController();
  final TextEditingController _weFindController = TextEditingController();

  @override
  void dispose() {
    _weAreController.dispose();
    _weFindController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UploadWGPageViewModel>();
    final state = viewModel.state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('About you'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('WE ARE'),
            Expanded(
              child: TextField(
                  controller: _weAreController,
                  decoration: InputDecoration(
                    hintText: 'Input text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  maxLength: 200,
                  maxLines: 5,
                  onChanged: (value) async {
                    _weAreController.text = value;
                  }),
            ),
            const SizedBox(height: 16),
            const Text('WE FIND'),
            Expanded(
              child: TextField(
                  controller: _weFindController,
                  decoration: InputDecoration(
                    hintText: 'Input text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  maxLength: 2000,
                  maxLines: null,
                  onChanged: (value) async {
                    _weFindController.text = value;
                    if (_weAreController.text.isNotEmpty &&
                        _weFindController.text.isNotEmpty) {
                      viewModel.fillTextVermieter();
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

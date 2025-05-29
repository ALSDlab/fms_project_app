import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../upload_wg_page_view_model.dart';

class SetVermieterStepPage extends StatefulWidget {
  const SetVermieterStepPage({super.key});

  @override
  State<SetVermieterStepPage> createState() => _SetVermieterStepPageState();
}

class _SetVermieterStepPageState extends State<SetVermieterStepPage> {
  @override
  void dispose() {
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
                  controller: viewModel.weAreController,
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
                    viewModel.weAreController.text = value;
                    if (viewModel.weAreController.text.isNotEmpty &&
                        viewModel.weFindController.text.isNotEmpty) {
                      viewModel.fillTextVermieter(true);
                    } else {
                      viewModel.fillTextVermieter(false);
                    }
                  }),
            ),
            const SizedBox(height: 16),
            const Text('WE FIND'),
            Expanded(
              child: TextField(
                  controller: viewModel.weFindController,
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
                    viewModel.weFindController.text = value;
                    if (viewModel.weAreController.text.isNotEmpty &&
                        viewModel.weFindController.text.isNotEmpty) {
                      viewModel.fillTextVermieter(true);
                    } else {
                      viewModel.fillTextVermieter(false);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

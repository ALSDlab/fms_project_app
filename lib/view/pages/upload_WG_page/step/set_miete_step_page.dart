import 'package:flutter/material.dart';
import 'package:fmsproject/utils/upload_wg/currency_input_field_widget.dart';
import 'package:provider/provider.dart';

import '../upload_wg_page_view_model.dart';

class SetMieteStepPage extends StatelessWidget {
  const SetMieteStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UploadWGPageViewModel>();
    final state = viewModel.state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set title'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: CurrencyInputField(
                showHint: false,
                hint: '0,00',
                controller: viewModel.currencyController,
                keyboardType: TextInputType.number,
                clearButton: true,
                style: const TextStyle(fontSize: 45),
                currencySymbol: '€',
                // 유로 통화
                locale: 'de_DE',
                // 독일 로케일
                onChanged: (value) {
                  viewModel.currencyController.text = value;
                  if (viewModel.currencyController.text.isNotEmpty &&
                      viewModel.titleController.text.isNotEmpty &&
                      viewModel.descriptionController.text.isNotEmpty) {
                    viewModel.fillTextMiete(true);
                  } else {
                    viewModel.fillTextMiete(false);
                  }
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(height: 16),
            const Text('TITLE'),
            Expanded(
              child: TextField(
                  controller: viewModel.titleController,
                  decoration: InputDecoration(
                    hintText: 'Input text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  maxLength: 100,
                  maxLines: 3,
                  onChanged: (value) async {
                    viewModel.titleController.text = value;
                    if (viewModel.currencyController.text.isNotEmpty &&
                        viewModel.titleController.text.isNotEmpty &&
                        viewModel.descriptionController.text.isNotEmpty) {
                      viewModel.fillTextMiete(true);
                    } else {
                      viewModel.fillTextMiete(false);
                    }
                  }),
            ),
            const SizedBox(height: 6),
            const Text('Description'),
            Expanded(
              child: TextField(
                  controller: viewModel.descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Input text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  maxLength: 2000,
                  maxLines: 5,
                  onChanged: (value) async {
                    viewModel.descriptionController.text = value;
                    if (viewModel.currencyController.text.isNotEmpty &&
                        viewModel.titleController.text.isNotEmpty &&
                        viewModel.descriptionController.text.isNotEmpty) {
                      viewModel.fillTextMiete(true);
                    } else {
                      viewModel.fillTextMiete(false);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

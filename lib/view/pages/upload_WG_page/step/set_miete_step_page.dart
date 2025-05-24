import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/utils/currency_input_field_widget.dart';
import 'package:provider/provider.dart';

import '../upload_wg_page_view_model.dart';

class SetMieteStepPage extends StatefulWidget {
  const SetMieteStepPage({super.key});

  @override
  State<SetMieteStepPage> createState() => _SetMieteStepPageState();
}

class _SetMieteStepPageState extends State<SetMieteStepPage> {
  final CurrencyTextFieldController _controller =
  CurrencyTextFieldController(showZeroValue: true);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
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
                controller: _controller,
                keyboardType: TextInputType.number,
                clearButton: true,
                style: const TextStyle(fontSize: 45),
                currencySymbol: '€', // 유로 통화
                locale: 'de_DE',     // 독일 로케일
                onChanged: (value) {
                  _controller.text = value;
                  debugPrint('입력된 값: $value');
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
                  controller: _titleController,
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
                    _titleController.text = value;
                  }),
            ),
            const SizedBox(height: 6),
            const Text('Description'),
            Expanded(
              child: TextField(
                  controller: _descriptionController,
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
                    _descriptionController.text = value;
                    if (_titleController.text.isNotEmpty &&
                        _descriptionController.text.isNotEmpty) {
                      viewModel.fillTextMiete();
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

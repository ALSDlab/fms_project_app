import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../upload_wg_page_view_model.dart';

class SetPeriodStepPage extends StatefulWidget {
  const SetPeriodStepPage({super.key});

  @override
  State<SetPeriodStepPage> createState() => _SetPeriodStepPageState();
}

class _SetPeriodStepPageState extends State<SetPeriodStepPage> {
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UploadWGPageViewModel>();
    final state = viewModel.state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Period'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (state.wgData.abDem.toString() == '')
                  ? '기간을 선택하세요'
                  : '${_formatDate(state.wgData.abDem)} - ${_formatDate(state.wgData.bis)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Container(
                        height: 400,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              '기간 선택',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            SfDateRangePicker(
                              view: DateRangePickerView.month,
                              selectionMode: DateRangePickerSelectionMode.range,
                              onSelectionChanged:
                                  (DateRangePickerSelectionChangedArgs args) {
                                if (args.value is PickerDateRange) {
                                  viewModel.setPeriod(
                                      args.value.startDate,
                                      args.value.endDate ??
                                          args.value.startDate);
                                }
                              },
                              showActionButtons: true,
                              onCancel: () {
                                Navigator.pop(context);
                              },
                              onSubmit: (Object? value) {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text('Select Peroid'),
            ),
          ],
        ),
      ),
    );
  }
}

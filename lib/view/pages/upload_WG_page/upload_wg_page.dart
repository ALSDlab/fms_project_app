import 'package:flutter/material.dart';
import 'package:fmsproject/utils/two_answer_dialog.dart';
import 'package:fmsproject/view/pages/upload_WG_page/step/final_confirm_step_page.dart';
import 'package:fmsproject/view/pages/upload_WG_page/step/set_location_step_page.dart';
import 'package:fmsproject/view/pages/upload_WG_page/step/set_miete_step_page.dart';
import 'package:fmsproject/view/pages/upload_WG_page/step/set_period_step_page.dart';
import 'package:fmsproject/view/pages/upload_WG_page/step/set_photo_step_page.dart';
import 'package:fmsproject/view/pages/upload_WG_page/step/set_vermieter_step_page.dart';
import 'package:fmsproject/view/pages/upload_WG_page/upload_wg_page_view_model.dart';
import 'package:provider/provider.dart';

class UploadWGPage extends StatelessWidget {
  const UploadWGPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UploadWGPageViewModel>();
    return Scaffold(
      appBar: AppBar(
          title: const Text('UPLOAD WG'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: (viewModel.currentStep > 0)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (viewModel.currentStep > 0) {
                      viewModel.goToPreviousStep();
                    }
                  },
                )
              : null),
      body: Column(
        children: [
          // 진행 상황 표시 바
          LinearProgressIndicator(
            value: (viewModel.currentStep + 1) / 5,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
          ),
          Expanded(
            child: _buildCurrentStep(context, viewModel),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(context, viewModel),
    );
  }

  Widget _buildCurrentStep(
      BuildContext context, UploadWGPageViewModel viewModel) {
    switch (viewModel.currentStep) {
      case 0:
        return const SetPeriodStepPage();
      case 1:
        return const SetLocationStepPage();
      case 2:
        return const SetVermieterStepPage();
      case 3:
        return const SetPhotoStepPage();
      case 4:
        return const SetMieteStepPage();
      case 5:
        return const FinalConfirmStepPage();
      default:
        return const Center(child: Text('알 수 없는 단계입니다.'));
    }
  }

  Widget _buildBottomNavigation(
      BuildContext context, UploadWGPageViewModel viewModel) {
    final isLastStep = viewModel.currentStep == 5;
    final buttonTitle = isLastStep ? '등록 완료하기' : '다음';
    final state = viewModel.state;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: (viewModel.isCurrentStepCompleted() != -1)
              ? () {
                  final int stepResult = viewModel.isCurrentStepCompleted();
                  if (isLastStep) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => TwoAnswerDialog(
                            onTap: () =>
                                _finishListingCreation(context, viewModel),
                            title: 'Final Confirm',
                            subtitle: 'Uploading',
                            firstButton: 'Cancel',
                            secondButton: 'OK'));
                  } else {
                    switch (stepResult) {
                      case 2:
                        viewModel.setVermieter(
                            state.wgData.weFind, state.wgData.weAre);
                        break;
                      case 4:
                        viewModel.setMiete(state.wgData.miete,
                            state.wgData.title, state.wgData.description);
                        print(state.wgData);
                        break;
                    }
                    viewModel.goToNextStep();
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(buttonTitle),
        ),
      ),
    );
  }

  void _finishListingCreation(
      BuildContext context, UploadWGPageViewModel viewModel) async {
    // 로딩 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // 등록 처리
    final success = await viewModel.submitListing();

    // 로딩 닫기
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    if (success && context.mounted) {
      // 성공 메시지 및 홈 화면으로 이동
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('숙소가 성공적으로 등록되었습니다!')),
      );

      // 모든 이전 화면 닫고 홈으로 이동
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      // 실패 메시지
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('숙소 등록에 실패했습니다. 다시 시도해주세요.')),
        );
      }
    }
  }
}

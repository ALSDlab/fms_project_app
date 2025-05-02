import 'package:fmsproject/domain/model/wg_data_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upload_wg_page_state.freezed.dart';

part 'upload_wg_page_state.g.dart';

@freezed
class UploadWgPageState with _$UploadWgPageState {
  const factory UploadWgPageState({
    @Default(false) bool isLoading,
    @Default(false) bool isPeriodCompleted,
    @Default(false) bool isLocationCompleted,
    @Default(false) bool isVermieterCompleted,
    @Default(false) bool isPhotoCompleted,
    @Default(false) bool isMieteCompleted,
    @Default(false) bool isSubmitting,
    @Default(WgDataModel()) WgDataModel wgData,
  }) = _UploadWgPageState;

  factory UploadWgPageState.fromJson(Map<String, dynamic> json) =>
      _$UploadWgPageStateFromJson(json);
}

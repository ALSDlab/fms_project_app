import 'package:fmsproject/data/repository/user_data_repository_impl.dart';
import 'package:fmsproject/domain/repository/user_data_repository.dart';
import 'package:fmsproject/domain/use_case/user_data/sign_in_with_google_use_case.dart';
import 'package:get_it/get_it.dart';

import '../view/navigation/navigation_bar_page_view_model.dart';
import '../view/pages/find_WG_page/find_WG_page_view_model.dart';
import '../view/pages/login_page/login_page_view_model.dart';
import '../view/pages/my_history_page/my_history_page_view_model.dart';
import '../view/pages/setting_page/setting_page_view_model.dart';
import '../view/pages/upload_WG_page/upload_WG_page_view_model.dart';

final getIt = GetIt.instance;

void diSetup() {
  // Repository
  getIt.registerSingleton<UserDataRepository>(UserDataRepositoryImpl());

  // use case
  getIt.registerSingleton<SignInWithGoogleUseCase>(
      SignInWithGoogleUseCase(userDataRepository: getIt<UserDataRepository>()));

  // ViewModel
  getIt
    ..registerFactory<LoginPageViewModel>(() => LoginPageViewModel(
        signInWithGoogleUseCase: getIt<SignInWithGoogleUseCase>()))
    ..registerFactory<NavigationBarPageViewModel>(
        () => NavigationBarPageViewModel())
    ..registerFactory<FindWGPageViewModel>(() => FindWGPageViewModel())
    ..registerFactory<UploadWGPageViewModel>(() => UploadWGPageViewModel())
    ..registerFactory<MyHistoryPageViewModel>(() => MyHistoryPageViewModel())
    ..registerFactory<SettingPageViewModel>(() => SettingPageViewModel());
}

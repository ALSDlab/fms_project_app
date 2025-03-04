import 'package:fmsproject/data/repository/chat_data_repository_impl.dart';
import 'package:fmsproject/data/repository/user_data_repository_impl.dart';
import 'package:fmsproject/domain/repository/chat_data_repository.dart';
import 'package:fmsproject/domain/repository/user_data_repository.dart';
import 'package:fmsproject/domain/use_case/chat_data/find_or_create_chat_room_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/get_chat_list_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/get_chat_room_data_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/mark_messages_as_read_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/send_message_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/stream_chat_list_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/stream_message_use_case.dart';
import 'package:fmsproject/domain/use_case/chat_data/upload_image_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/check_email_verified_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/get_current_user_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/log_in_by_email_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/log_out_by_email_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/sign_in_with_facebook_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/sign_in_with_google_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/sign_out_by_email_use_case.dart';
import 'package:fmsproject/domain/use_case/user_data/sign_up_by_email_use_case.dart';
import 'package:fmsproject/view/pages/chat_page/chat_page_view_model.dart';
import 'package:fmsproject/view/pages/signup_page/signup_page_view_model.dart';
import 'package:get_it/get_it.dart';

import '../domain/use_case/user_data/sign_in_with_apple_use_case.dart';
import '../view/navigation/navigation_bar_page_view_model.dart';
import '../view/pages/chat_list_page/chat_list_page_view_model.dart';
import '../view/pages/find_WG_page/find_wg_page_view_model.dart';
import '../view/pages/login_page/login_page_view_model.dart';
import '../view/pages/my_history_page/my_history_page_view_model.dart';
import '../view/pages/setting_page/setting_page_view_model.dart';
import '../view/pages/upload_WG_page/upload_wg_page_view_model.dart';

final getIt = GetIt.instance;

void diSetup() {
  // Repository
  getIt
    ..registerSingleton<UserDataRepository>(UserDataRepositoryImpl())
    ..registerSingleton<ChatDataRepository>(ChatDataRepositoryImpl());

  // use case(user data)
  getIt
    ..registerSingleton<SignUpByEmailUseCase>(
        SignUpByEmailUseCase(userDataRepository: getIt<UserDataRepository>()))
    ..registerSingleton<CheckEmailVerifiedUseCase>(CheckEmailVerifiedUseCase(
        userDataRepository: getIt<UserDataRepository>()))
    ..registerSingleton<LogInByEmailUseCase>(
        LogInByEmailUseCase(userDataRepository: getIt<UserDataRepository>()))
    ..registerSingleton<SignInWithGoogleUseCase>(SignInWithGoogleUseCase(
        userDataRepository: getIt<UserDataRepository>()))
    ..registerSingleton<SignInWithFacebookUseCase>(SignInWithFacebookUseCase(
        userDataRepository: getIt<UserDataRepository>()))
    ..registerSingleton<SignInWithAppleUseCase>(
        SignInWithAppleUseCase(userDataRepository: getIt<UserDataRepository>()))
    ..registerSingleton<GetCurrentUserUseCase>(
        GetCurrentUserUseCase(userDataRepository: getIt<UserDataRepository>()))
    ..registerSingleton<LogOutByEmailUseCase>(
        LogOutByEmailUseCase(userDataRepository: getIt<UserDataRepository>()))
    ..registerSingleton<SignOutByEmailUseCase>(
        SignOutByEmailUseCase(userDataRepository: getIt<UserDataRepository>()));

  // use case(chat data)
  getIt
    ..registerSingleton<GetChatListUseCase>(
        GetChatListUseCase(chatDataRepository: getIt<ChatDataRepository>()))
    ..registerSingleton<GetChatRoomDataUseCase>(
        GetChatRoomDataUseCase(chatDataRepository: getIt<ChatDataRepository>()))
    ..registerSingleton<StreamChatListUseCase>(
        StreamChatListUseCase(chatDataRepository: getIt<ChatDataRepository>()))
    ..registerSingleton<StreamMessageUseCase>(
        StreamMessageUseCase(chatDataRepository: getIt<ChatDataRepository>()))
    ..registerSingleton<MarkMessagesAsReadUseCase>(MarkMessagesAsReadUseCase(
        chatDataRepository: getIt<ChatDataRepository>()))
    ..registerSingleton<FindOrCreateChatRoomUseCase>(
        FindOrCreateChatRoomUseCase(
            chatDataRepository: getIt<ChatDataRepository>()))
    ..registerSingleton<SendMessageUseCase>(
        SendMessageUseCase(chatDataRepository: getIt<ChatDataRepository>()))
    ..registerSingleton<UploadImageUseCase>(
        UploadImageUseCase(chatDataRepository: getIt<ChatDataRepository>()));

  // ViewModel
  getIt
    ..registerFactory<NavigationBarPageViewModel>(
        () => NavigationBarPageViewModel())
    ..registerFactory<LoginPageViewModel>(() => LoginPageViewModel(
        logInByEmailUseCase: getIt<LogInByEmailUseCase>(),
        signInWithGoogleUseCase: getIt<SignInWithGoogleUseCase>(),
        signInWithFacebookUseCase: getIt<SignInWithFacebookUseCase>(),
        signInWithAppleUseCase: getIt<SignInWithAppleUseCase>(),
        checkEmailVerifiedUseCase: getIt<CheckEmailVerifiedUseCase>()))
    ..registerFactory<SignupPageViewModel>(() => SignupPageViewModel(
        signUpByEmailUseCase: getIt<SignUpByEmailUseCase>(),
        checkEmailVerifiedUseCase: getIt<CheckEmailVerifiedUseCase>()))
    ..registerFactory<FindWGPageViewModel>(() => FindWGPageViewModel(
        getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
        findOrCreateChatRoomUseCase: getIt<FindOrCreateChatRoomUseCase>(),
        getChatRoomDataUseCase: getIt<GetChatRoomDataUseCase>()))
    ..registerFactory<UploadWGPageViewModel>(() => UploadWGPageViewModel())
    ..registerFactory<MyHistoryPageViewModel>(() => MyHistoryPageViewModel())
    ..registerFactory<ChatListPageViewModel>(() => ChatListPageViewModel(
        getChatListUseCase: getIt<GetChatListUseCase>(),
        getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
        streamChatListUseCase: getIt<StreamChatListUseCase>(),
        markMessagesAsReadUseCase: getIt<MarkMessagesAsReadUseCase>()))
    ..registerFactory<ChatPageViewModel>(() => ChatPageViewModel(
        getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
        streamMessageUseCase: getIt<StreamMessageUseCase>(),
        sendMessageUseCase: getIt<SendMessageUseCase>(),
        uploadImageUseCase: getIt<UploadImageUseCase>()))
    ..registerFactory<SettingPageViewModel>(() => SettingPageViewModel(
        logOutByEmailUseCase: getIt<LogOutByEmailUseCase>(),
        signOutByEmailUseCase: getIt<SignOutByEmailUseCase>()));
}

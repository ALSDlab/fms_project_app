import 'package:flutter/material.dart';
import 'package:fmsproject/view/navigation/navigation_bar_page.dart';
import 'package:fmsproject/view/navigation/navigation_bar_page_view_model.dart';
import 'package:fmsproject/view/pages/find_WG_page/find_WG_page.dart';
import 'package:fmsproject/view/pages/find_WG_page/find_WG_page_view_model.dart';
import 'package:fmsproject/view/pages/login_page/login_page.dart';
import 'package:fmsproject/view/pages/login_page/login_page_view_model.dart';
import 'package:fmsproject/view/pages/my_history_page/my_history_page.dart';
import 'package:fmsproject/view/pages/my_history_page/my_history_page_view_model.dart';
import 'package:fmsproject/view/pages/setting_page/setting_page.dart';
import 'package:fmsproject/view/pages/setting_page/setting_page_view_model.dart';
import 'package:fmsproject/view/pages/splash_page/splash_page.dart';
import 'package:fmsproject/view/pages/upload_WG_page/upload_WG_page.dart';
import 'package:fmsproject/view/pages/upload_WG_page/upload_WG_page_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'di/get_it.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: '/splash_page',
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/splash_page',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
        path: '/login_page',
        builder: (context, state) {
          return ChangeNotifierProvider(
              create: (_) => getIt<LoginPageViewModel>(),
              child: const LoginPage());
        },
        routes: [
          GoRoute(
            path: 'signup_page',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: 'change_password_page',
            builder: (context, state) => const LoginPage(),
          ),
        ]),
    ShellRoute(
        navigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => getIt<NavigationBarPageViewModel>(),
                ),
                ChangeNotifierProvider(
                  create: (_) => getIt<FindWGPageViewModel>(),
                ),
                ChangeNotifierProvider(
                  create: (_) => getIt<UploadWGPageViewModel>(),
                ),
                ChangeNotifierProvider(
                  create: (_) => getIt<MyHistoryPageViewModel>(),
                ),
                ChangeNotifierProvider(
                  create: (_) => getIt<SettingPageViewModel>(),
                ),
              ],
              child: NavigationBarPage(
                location: state.matchedLocation,
                child: child,
              ),
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/find_WG_page',
            builder: (context, state) {
              final navigationViewModel =
                  Provider.of<NavigationBarPageViewModel>(context,
                      listen: false);
              return ChangeNotifierProvider(
                create: (_) => getIt<FindWGPageViewModel>(),
                child: FindWGPage(
                    // resetNavigation: navigationViewModel.resetNavigation,
                    ),
              );
            },
          ),
          GoRoute(
            path: '/upload_WG_page',
            builder: (context, state) {
              final navigationViewModel =
                  Provider.of<NavigationBarPageViewModel>(context,
                      listen: false);
              return ChangeNotifierProvider(
                create: (_) => getIt<UploadWGPageViewModel>(),
                child: UploadWGPage(
                    // resetNavigation: navigationViewModel.resetNavigation,
                    ),
              );
            },
          ),
          GoRoute(
            path: '/history_page',
            builder: (context, state) {
              final navigationViewModel =
                  Provider.of<NavigationBarPageViewModel>(context,
                      listen: false);
              return ChangeNotifierProvider(
                create: (_) => getIt<MyHistoryPageViewModel>(),
                child: MyHistoryPage(
                  resetNavigation: navigationViewModel.resetNavigation,
                ),
              );
            },
            // routes: [
            //   GoRoute(
            //     path: 'my_sentences_page',
            //     builder: (context, state) {
            //       final extra = state.extra! as Map<String, dynamic>;
            //       return ChangeNotifierProvider(
            //         create: (_) => getIt<MyFavoritePageViewModel>(),
            //         child: MySentencesPage(
            //             mySentencesItems: extra['mySentencesItems']),
            //       );
            //     },
            //   ),
            //   GoRoute(
            //     path: 'my_quiz_page',
            //     builder: (context, state) {
            //       final extra = state.extra! as Map<String, dynamic>;
            //       return ChangeNotifierProvider(
            //         create: (_) => getIt<MyFavoritePageViewModel>(),
            //         child: MyQuizPage(myQuizItems: extra['myQuizItems']),
            //       );
            //     },
            //   ),
            //   GoRoute(
            //     path: 'my_search_page',
            //     builder: (context, state) {
            //       final extra = state.extra! as Map<String, dynamic>;
            //       return ChangeNotifierProvider(
            //         create: (_) => getIt<MyFavoritePageViewModel>(),
            //         child:
            //             MySearchPage(mySearchesItems: extra['mySearchesItems']),
            //       );
            //     },
            //   ),
            // ],
          ),
          GoRoute(
            path: '/setting_page',
            builder: (context, state) {
              final navigationViewModel =
                  Provider.of<NavigationBarPageViewModel>(context,
                      listen: false);
              return ChangeNotifierProvider(
                create: (_) {
                  return getIt<SettingPageViewModel>();
                },
                child: SettingPage(
                  resetNavigation: navigationViewModel.resetNavigation,
                ),
              );
            },
          ),
        ]),
  ],
);

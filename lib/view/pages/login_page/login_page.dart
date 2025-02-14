import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fmsproject/view/pages/login_page/social_login_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../utils/custom_text_form_field.dart';
import '../../../utils/gif_progress_bar.dart';
import 'login_page_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  StreamSubscription? authStateChanges;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        final loginViewModel = context.read<LoginPageViewModel>();

        loginViewModel
            .initPreferences()
            .then((value) => loginViewModel.idController.text = value);
        authStateChanges =
            FirebaseAuth.instance.authStateChanges().listen((user) {
          if (user != null &&
              user.emailVerified &&
              !loginViewModel.state.loginCheck &&
              mounted) {
            GoRouter.of(context).go('/find_WG_page');
            return;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginPageViewModel>();
    final state = viewModel.state;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Container(
              width: 360,
              color: Colors.white,
              child: (state.isLoading)
                  ? Center(
                      child: GifProgressBar(),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 24),
                                    child: Material(
                                      color: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: Image.asset(
                                              'assets/images/myk_market_logo.png',
                                            ).image,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 8,
                                              color: Color(0x1917171C),
                                              offset: Offset(
                                                0,
                                                4,
                                              ),
                                              spreadRadius: 0,
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Log in to your account',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 30,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 12, 0, 0),
                                    child: SelectionArea(
                                        child: Text(
                                      'Welcome back! Please enter your details.',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                        height: 1.5,
                                      ),
                                    )),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 32, 0, 0),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          CustomTextFormField(
                                            controller: viewModel.idController,
                                            focusNode:
                                                viewModel.idControllerFocusNode,
                                            hintText: 'Enter your email',
                                            errorText: state.errorEmailText,
                                            onChanged: (value) {
                                              if (value.isEmpty) {
                                                viewModel.changeErrorEmailText(
                                                    '필수항목입니다.');
                                              } else {
                                                viewModel
                                                    .changeErrorEmailText('');
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          CustomTextFormField(
                                            controller:
                                                viewModel.passwordController,
                                            focusNode: viewModel
                                                .passwordControllerFocusNode,
                                            hintText: 'Password',
                                            obscureText: true,
                                            errorText: state.errorPasswordText,
                                            onChanged: (value) {
                                              if (value.isEmpty) {
                                                viewModel
                                                    .changeErrorPasswordText(
                                                        '필수항목입니다.');
                                              } else {
                                                viewModel
                                                    .changeErrorPasswordText(
                                                        '');
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 16, 0, 0),
                                    child: TextButton(
                                      style: ButtonStyle(
                                        minimumSize: MaterialStateProperty.all(
                                          Size(double.infinity, 52.h),
                                        ),
                                        shape: const MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                                Color(0xFF008080)),
                                      ),
                                      onPressed: () async {
                                        await viewModel.userLogIn(
                                            viewModel.idController.text,
                                            viewModel.passwordController.text,
                                            context);

                                        // setState(() {
                                        //   _errorIdText =
                                        //       (idController.text.isEmpty
                                        //           ? '필수항목입니다.'
                                        //           : null);
                                        //   _errorPasswordText =
                                        //       (passwordController.text.isEmpty
                                        //           ? '필수항목입니다.'
                                        //           : null);
                                        // });
                                        // if (_formKey.currentState!.validate()) {
                                        //   // await viewModel.signIn(
                                        //   //     idController.text,
                                        //   //     passwordController.text,
                                        //   //     context);
                                        // }
                                      },
                                      child: const Text(
                                        'Continue with email',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 24, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: 1,
                                        height: 1,
                                        decoration: const BoxDecoration(
                                          color: Color(0x4C696E7C),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          6, 0, 6, 0),
                                      child: SelectionArea(
                                          child: Text(
                                        'OR',
                                      )),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 1,
                                        height: 1,
                                        decoration: const BoxDecoration(
                                          color: Color(0x4D696E7C),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SocialLoginButton(
                                imagePath: 'assets/images/IOS_Google_icon.png',
                                text: 'Sign in with Google',
                                onTap: () =>
                                    viewModel.signInAndLoginWithGoogle(context),
                              ),
                              SocialLoginButton(
                                imagePath: 'assets/images/Facebook_Logo.png',
                                text: 'Sign in with Facebook',
                                onTap: () => viewModel
                                    .signInAndLoginWithFacebook(context),
                              ),
                              SocialLoginButton(
                                imagePath: 'assets/images/Apple_logo_black.png',
                                text: 'Sign in with Apple',
                                onTap: () =>
                                    viewModel.signInAndLoginWithApple(context),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SelectionArea(
                                        child: Text(
                                      'Don\'t have an account? ',
                                    )),
                                    TextButton(
                                      onPressed: () {
                                        context.push(
                                          '/login_page/signup_page',
                                          // extra: {
                                          //   'hideNavBar':
                                          //       widget.hideNavBar
                                          // }
                                        );
                                      },
                                      child: const Text(
                                        'Sign up',
                                        style: TextStyle(
                                          color: Color(0xFF8e8e93),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 5, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SelectionArea(
                                        child: Text(
                                      'Forgot your password? ',
                                    )),
                                    TextButton(
                                      onPressed: () {
                                        context.push(
                                          '/profile_page/login_page/change_password_page',
                                          // extra: {
                                          //   'hideNavBar':
                                          //       widget.hideNavBar
                                          // }
                                        );
                                      },
                                      child: const Text(
                                        'Password change',
                                        style: TextStyle(
                                          color: Color(0xFF8e8e93),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              const Column(
                                children: [
                                  // Text(
                                  //   softWrap: true, //긴 텍스트 줄 바꿈
                                  //   style: TextStyle(
                                  //       letterSpacing: 1.1,
                                  //       height: 1.4,
                                  //       fontFamily: 'Kopub',
                                  //       color: Colors.grey),
                                  //   '상호: 건강담은 민영기염소탕 흑염소진액 | 대표: 임유리 | 주소: 충남 아산시 둔포면 중앙공원로 33번길 3-11 | 사업자번호: 106-53-60883 | 통신판매업신고: 2024-충남아산-0466\n| 고객상담실: 041) 531-6023 | e-메일: envy1012@naver.com',
                                  // ),
                                  // SizedBox(
                                  //   height: 15,
                                  // ),
                                  Text(
                                      softWrap: true, //긴 텍스트 줄 바꿈
                                      style: TextStyle(
                                          fontSize: 10,
                                          letterSpacing: 1.1,
                                          height: 1.4,
                                          fontFamily: 'Kopub',
                                          color: Colors.grey),
                                      'ⓒ 2025. FMS Project Co. All rights reserved.'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/view/pages/signup_page/signup_page_view_model.dart';
import 'package:provider/provider.dart';

import '../../../utils/custom_text_form_field.dart';
import '../../../utils/gif_progress_bar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var emailControllerFocusNode = FocusNode();
  var passwordControllerFocusNode = FocusNode();
  var confirmPasswordControllerFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignupPageViewModel>();
    final state = viewModel.state;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFEBF4F6),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFEBF4F6),
          title: const Text('Sign Up'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: (state.isLoading)
              ? Center(
                  child: GifProgressBar(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('E-mail'),
                        Text('*', style: TextStyle(color: Colors.red))
                      ],
                    ),
                    CustomTextFormField(
                      controller: viewModel.emailController,
                      focusNode: emailControllerFocusNode,
                      hintText: 'email@email.com',
                      errorText: state.errorEmailText,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          viewModel.changeErrorEmailText('필수항목입니다.');
                        } else {
                          viewModel.changeErrorEmailText('');
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Text(
                          '비밀번호',
                        ),
                        Text('*', style: TextStyle(color: Colors.red))
                      ],
                    ),
                    CustomTextFormField(
                      obscureText: true,
                      controller: viewModel.passwordController,
                      focusNode: passwordControllerFocusNode,
                      hintText: '******',
                      errorText: state.errorPasswordText,
                      onChanged: (value) {
                        viewModel.validatePassword(value);
                        if (value.isEmpty) {
                          viewModel.changeErrorPasswordText('필수항목입니다.');
                        } else {
                          viewModel.changeErrorPasswordText('');
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Text(
                          '비밀번호 확인',
                        ),
                        Text('*', style: TextStyle(color: Colors.red))
                      ],
                    ),
                    CustomTextFormField(
                      obscureText: true,
                      controller: viewModel.confirmPasswordController,
                      focusNode: confirmPasswordControllerFocusNode,
                      hintText: '******',
                      errorText: state.errorConfirmPasswordText,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          viewModel.changeErrorConfirmPasswordText('필수항목입니다.');
                        } else {
                          viewModel.changeErrorConfirmPasswordText('');
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        (state.hasUpperCase)
                            ? const Icon(
                                BootstrapIcons.check,
                                color: Colors.green,
                              )
                            : const Icon(
                                BootstrapIcons.x,
                                color: Colors.red,
                              ),
                        const Text('has Upper case')
                      ],
                    ),
                    Row(
                      children: [
                        (state.hasLowerCase) && (state.hasDigit)
                            ? const Icon(
                                BootstrapIcons.check,
                                color: Colors.green,
                              )
                            : const Icon(
                                BootstrapIcons.x,
                                color: Colors.red,
                              ),
                        const Text('contains both letters and numbers')
                      ],
                    ),
                    Row(
                      children: [
                        (state.isAtLeast6Chars)
                            ? const Icon(
                                BootstrapIcons.check,
                                color: Colors.green,
                              )
                            : const Icon(
                                BootstrapIcons.x,
                                color: Colors.red,
                              ),
                        const Text('6 characters or more')
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          if (viewModel.emailController.text != '' &&
                              viewModel.passwordController.text != '' &&
                              viewModel.confirmPasswordController.text != '') {
                            await viewModel.handleSignUp(
                                email: viewModel.emailController.text,
                                password: viewModel.passwordController.text,
                                confirmPassword:
                                    viewModel.confirmPasswordController.text,
                                context: context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Check your input'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: (state.tapped)
                                      ? const Color(0xff4FB0C6)
                                      : const Color(0xff54D1DB)),
                              borderRadius: BorderRadius.circular(20),
                              color: (state.tapped)
                                  ? const Color(0xff4FB0C6)
                                  : const Color(0xFFEBF4F6)),
                          height: 50,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'APPLY',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: (state.tapped)
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

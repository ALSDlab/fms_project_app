import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  bool showText = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..forward().then((_) {
        setState(() {
          showText = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff54D1DB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _controller,
              child: Container(
                height: 260,
                width: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45), // 둥근 모서리 설정
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // 검은색 그림자
                      spreadRadius: 2, // 그림자의 확산 반경
                      blurRadius: 10, // 그림자의 블러 반경
                      offset: const Offset(0, 6), // 그림자를 아래쪽으로 약간 이동 (x, y)
                    ),
                  ],
                ),
                child: Image.asset("assets/images/fms_splash.png"),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 120,
              child: Visibility(
                visible: showText,
                child: DefaultTextStyle(
                  style: const TextStyle(
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0), // 그림자가 x, y로 2px씩 오프셋
                          blurRadius: 4.0, // 그림자의 블러 반경
                          color: Color.fromARGB(128, 0, 0, 0), // 반투명한 검은색 그림자
                        ),
                      ],
                      color: Color(0xFFEBF4F6),
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                      fontFamily: 'taeL',
                      letterSpacing: -2,
                      height: 1.4),
                  child: AnimatedTextKit(
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TyperAnimatedText('FMS Project',
                          textAlign: TextAlign.center,
                          speed: const Duration(milliseconds: 80)),
                    ],
                    onFinished: () {
                      Future.delayed(const Duration(seconds: 1), () {
                        if (context.mounted) {
                          GoRouter.of(context).go('/login_page');
                        }
                      });
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TwoAnswerDialog extends StatelessWidget {
  final Function() onTap;
  final String title;
  final String subtitle;
  final String firstButton;
  final String secondButton;

  const TwoAnswerDialog({
    super.key,
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.firstButton,
    required this.secondButton,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
        ),
        width: 270.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/dialog_cookie.gif',
              width: 70.w,
              height: 70.h,
            ),
            Text(
              title,
            ),
            SizedBox(height: 6.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 75.w,
                  height: 28.h,
                  child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8BC6CC)),
                      child: Text(
                        firstButton,
                      )),
                ),
                SizedBox(width: 14.w),
                SizedBox(
                  width: 80.w,
                  height: 28.h,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(); //창 닫기
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200),
                      child: Text(
                        secondButton,
                      )),
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

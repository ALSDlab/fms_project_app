import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OneAnswerDialog extends StatelessWidget {
  final Function() onTap;
  final String? imagePath;
  final String? result;
  final String title;
  final String? subtitle;
  final String firstButton;

  const OneAnswerDialog(
      {super.key,
      required this.onTap,
      required this.title,
      required this.firstButton,
      this.imagePath,
      this.result,
      this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
        ),
        width: 300,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontSize: 25)),
            const SizedBox(height: 10),
            (imagePath != null)
                ? Image.asset(
                    imagePath!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : (result != null)
                    ? Text(result!, style: const TextStyle(fontSize: 56))
                    : const SizedBox(),
            Visibility(
                visible: (subtitle != null), child: const SizedBox(height: 10)),
            Visibility(
              visible: (subtitle != null),
              child: Text(
                subtitle ?? '',
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 100,
              height: 32,
              child: ElevatedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                      // shape: const RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.zero),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      backgroundColor: const Color(0xFF2F362F)),
                  child: Text(firstButton,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.white))),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class CustomToast extends StatelessWidget {
  const CustomToast({super.key, required this.msg});

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(94, 97, 113, 0.96),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        msg,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          height: 0,
        ),
      ),
    );
  }
}

Future<void> showToast(
  String msg, {
  Color backgroundColor = const Color.fromRGBO(94, 97, 113, 0.96),
  Color textColor = Colors.white,
  double? fontSize,
}) async {
  return SmartDialog.showToast(
    msg,
    alignment: Alignment.center,
  );
}

import 'package:flutter/material.dart';

import '../util/spacing.dart';

class AppButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final bool isPrimary;
  final bool isDanger;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isPrimary = false,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = isDanger
        ? AppColors.error
        : isPrimary
            ? AppColors.primary
            : Colors.grey.shade300;

    Color textColor = isPrimary || isDanger ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(text, style: AppTextStyles.button.copyWith(color: textColor)),
      ),
    );
  }
}

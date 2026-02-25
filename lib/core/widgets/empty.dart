import 'package:flutter/material.dart';
import '../util/spacing.dart';


class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const EmptyState({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_services, size: 80, color: Colors.grey.shade400),
            AppSpacing.vertical16,
            Text(title, style: AppTextStyles.headingGrey),
            AppSpacing.vertical8,
            Text(subtitle, style: AppTextStyles.bodyGrey, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

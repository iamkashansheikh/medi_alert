import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/util/spacing.dart';
import '../../core/widgets/empty.dart';
import '../controller/medicine_controller.dart';

class MedicineHistoryScreen extends GetView<MedicineController> {
  const MedicineHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medicine History")),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Obx(() {
          if (controller.history.isEmpty) {
            return const EmptyState(
              title: "No History",
              subtitle: "Your taken medicines will appear here",
            );
          }

          return ListView.builder(
            itemCount: controller.history.length,
            itemBuilder: (context, index) {
              final item = controller.history[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.time),
                trailing: const Icon(Icons.check_circle_outline),
              );
            },
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/util/spacing.dart';
import '../../core/widgets/empty.dart';
import '../../core/widgets/medicine_card.dart';
import '../../routes/app_routes.dart';
import '../controller/medicine_controller.dart';

class MedicineHomeScreen extends GetView<MedicineController> {
  const MedicineHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Medicines"),
        actions: [
          // ✅ Test Notification Button in AppBar
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: controller.testNotification,
            tooltip: "Test Notification",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addMedicine),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Obx(() {
          if (controller.medicines.isEmpty) {
            return const EmptyState(
              title: "No Medicine Added",
              subtitle: "Tap + to add medicine reminder",
            );
          }

          return ListView.separated(
            itemCount: controller.medicines.length,
            separatorBuilder: (_, __) => AppSpacing.vertical16,
            itemBuilder: (context, index) {
              final med = controller.medicines[index];
              return MedicineCard(medicine: med);
            },
          );
        }),
      ),
    );
  }
}
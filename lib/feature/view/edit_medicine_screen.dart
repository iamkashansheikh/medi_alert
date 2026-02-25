import '../../core/widgets/app_button.dart';
import '../../core/widgets/text_field.dart';
import '../controller/medicine_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/util/spacing.dart';


class EditMedicineScreen extends GetView<MedicineController> {
  const EditMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Medicine")),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            AppTextField(
              controller: controller.nameController,
            ),
            AppSpacing.vertical16,

            AppButton(
              text: "Update Time",
              onTap: controller.pickTime,
            ),
            AppSpacing.vertical24,

            AppButton(
  text: "Delete Medicine",
  onTap: () {
    controller.deleteMedicine; // wrap in lambda
  },
  isDanger: true,
)

          ],
        ),
      ),
    );
  }
}

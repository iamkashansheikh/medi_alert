import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/util/spacing.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/text_field.dart';
import '../controller/medicine_controller.dart';

class AddMedicineScreen extends GetView<MedicineController> {
  const AddMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Medicine"),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_active),
            onPressed: controller.testNotification,
            tooltip: "Test Notification",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medicine Name
            AppTextField(
              controller: controller.nameController,
              hintText: "Medicine Name (e.g., Panadol)",
            ),
            SizedBox(height: 20),
            
            // Time Selection
            Obx(() => AppButton(
              text: controller.selectedTime.value == null
                  ? "Select Time"
                  : "Time: ${controller.selectedTime.value}",
              onTap: controller.pickTime,
            )),
            SizedBox(height: 20),
            
            // Repeat Type
            Text("Repeat", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedRepeatType.value,
              onChanged: (value) => controller.selectedRepeatType.value = value!,
              items: controller.repeatOptions.map<DropdownMenuItem<String>>((option) {
                return DropdownMenuItem<String>(
                  value: option['value'] as String, // ✅ Explicit type cast
                  child: Text(option['label'] as String), // ✅ Explicit type cast
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.repeat),
              ),
            )),
            SizedBox(height: 20),
            
            // Weekly Days
            Obx(() {
              if (controller.selectedRepeatType.value == 'weekly') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select Days", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.dayOptions.map<Widget>((day) {
                        final isSelected = controller.selectedDays.contains(day['value'] as int);
                        return ChoiceChip(
                          label: Text(day['label'] as String), // ✅ Type cast
                          selected: isSelected,
                          onSelected: (_) => controller.toggleDay(day['value'] as int), // ✅ Type cast
                          selectedColor: Colors.blue[200],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              }
              return SizedBox();
            }),
            
            // Snooze Options
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.snooze, color: Colors.orange),
                        SizedBox(width: 10),
                        Text("Snooze Options", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 12),
                    Obx(() => SwitchListTile(
                      title: Text("Enable Snooze"),
                      value: controller.hasSnooze.value,
                      onChanged: (value) => controller.hasSnooze.value = value,
                    )),
                    Obx(() {
                      if (controller.hasSnooze.value) {
                        return Column(
                          children: [
                            SizedBox(height: 12),
                            Text("Snooze Duration: ${controller.snoozeMinutes.value} minutes"),
                            Slider(
                              value: controller.snoozeMinutes.value.toDouble(),
                              min: 1,
                              max: 30,
                              divisions: 29,
                              onChanged: (value) => controller.snoozeMinutes.value = value.toInt(),
                            ),
                          ],
                        );
                      }
                      return SizedBox();
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            
            // Save Button
            AppButton(
              text: "Save & Set Reminder",
              onTap: controller.saveMedicine,
              isPrimary: true,
            ),
            SizedBox(height: 10),
            
            // Cancel Button
            AppButton(
              text: "Cancel",
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}
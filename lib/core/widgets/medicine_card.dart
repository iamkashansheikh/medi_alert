import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_alert/feature/controller/medicine_controller.dart';
import 'package:medi_alert/feature/model/medicine_model.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  
  const MedicineCard({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  medicine.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                Icon(Icons.medical_services, color: Colors.blue),
              ],
            ),
            SizedBox(height: 8),
            
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  medicine.displayTime,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            
            Row(
              children: [
                Icon(Icons.repeat, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  medicine.repeatText,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
            SizedBox(height: 8),
            
            if (medicine.hasSnooze)
              Row(
                children: [
                  Icon(Icons.snooze, size: 16, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    "Snooze: ${medicine.snoozeMinutes} min",
                    style: TextStyle(color: Colors.orange.shade700),
                  ),
                ],
              ),
            
            SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed('/edit-medicine', arguments: medicine);
                    },
                    icon: Icon(Icons.edit),
                    label: Text("Edit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      foregroundColor: Colors.blue.shade800,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Mark as taken
                      Get.find<MedicineController>().markTaken(medicine);
                    },
                    icon: Icon(Icons.check_circle),
                    label: Text("Taken"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade100,
                      foregroundColor: Colors.green.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
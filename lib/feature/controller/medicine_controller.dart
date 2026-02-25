import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medi_alert/feature/view/alaram_ring_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

import '../model/medicine_model.dart';

class MedicineController extends GetxController {
  // RxLists
  var medicines = <Medicine>[].obs;
  var history = <Medicine>[].obs;
  
  // Form variables
  final TextEditingController nameController = TextEditingController();
  var selectedTime = Rxn<String>();
  var selectedRepeatType = 'once'.obs;
  var selectedDays = <int>[].obs;
  var hasSnooze = true.obs;
  var snoozeMinutes = 5.obs;
  
  // UI Options
  final List<Map<String, dynamic>> repeatOptions = [
    {'value': 'once', 'label': 'Once'},
    {'value': 'daily', 'label': 'Daily'},
    {'value': 'weekly', 'label': 'Weekly'},
    {'value': 'monthly', 'label': 'Monthly'},
  ];
  
  final List<Map<String, dynamic>> dayOptions = [
    {'value': 1, 'label': 'Mon'},
    {'value': 2, 'label': 'Tue'},
    {'value': 3, 'label': 'Wed'},
    {'value': 4, 'label': 'Thu'},
    {'value': 5, 'label': 'Fri'},
    {'value': 6, 'label': 'Sat'},
    {'value': 7, 'label': 'Sun'},
  ];
  
  late Box box;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    box = Hive.box('medicinesBox');
    loadMedicines();
    _initNotification();
  }

  void _initNotification() async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Karachi'));

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
     onDidReceiveNotificationResponse: (response) {
  if (response.payload != null) {
    final data = jsonDecode(response.payload!);
    Get.to(() => AlarmRingScreen(
      medicineName: data['name'],
      time: data['time'],
      snoozeMinutes: data['snoozeMinutes'],
    ));
  }
},
    );
    
    print('✅ Notifications initialized');
  }

  void pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      selectedTime.value = '$hour:$minute';
      
      final displayHour = picked.hourOfPeriod;
      final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
      Get.snackbar('Time Selected', 
        '$displayHour:${minute.toString().padLeft(2, '0')} $period',
        duration: Duration(seconds: 2)
      );
    }
  }

  void toggleDay(int day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
    selectedDays.sort();
  }

  void clearForm() {
    nameController.clear();
    selectedTime.value = null;
    selectedRepeatType.value = 'once';
    selectedDays.clear();
    hasSnooze.value = true;
    snoozeMinutes.value = 5;
  }

  void saveMedicine() {
    if (nameController.text.isEmpty) {
      Get.snackbar("Error", "Please enter medicine name");
      return;
    }
    
    if (selectedTime.value == null) {
      Get.snackbar("Error", "Please select time");
      return;
    }

    final newMed = Medicine(
      name: nameController.text,
      time: selectedTime.value!,
      repeatType: selectedRepeatType.value,
      selectedDays: selectedDays.toList(),
      hasSnooze: hasSnooze.value,
      snoozeMinutes: snoozeMinutes.value,
    );
    
    medicines.add(newMed);
    saveToBox();
    clearForm();
    
    Get.back();
    scheduleNotification(newMed);
    
    Get.snackbar(
      'Success',
      '${newMed.name} added for ${newMed.displayTime}',
      duration: Duration(seconds: 2),
    );
  }

  void scheduleNotification(Medicine med) async {
    try {
      print('🚀 Scheduling: ${med.name} at ${med.time}');
      
      // Parse time
      final parts = med.time.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      
      // ✅ FIX: Simple notification setup
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'med_channel',
        'Medicine Reminders',
        description: 'Medicine reminder notifications',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('alaram_bell'),
        enableVibration: true,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      
      // Notification actions
      List<AndroidNotificationAction> actions = [
        AndroidNotificationAction(
          'taken',
          'Taken',
          showsUserInterface: true,
        ),
      ];
      
      if (med.hasSnooze) {
        actions.insert(0, AndroidNotificationAction(
          'snooze',
          'Snooze (${med.snoozeMinutes} min)',
          showsUserInterface: false,
        ));
      }

      final androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true, // must
  category: AndroidNotificationCategory.alarm,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('alaram_bell'),
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 500, 250, 500]),
        actions: actions,
      );

      final platformDetails = NotificationDetails(android: androidDetails);

      // Calculate scheduled time
      final scheduledTime = _calculateScheduledTime(hour, minute, med);
      
      // Create payload
      final payload = jsonEncode({
        'id': med.id,
        'name': med.name,
        'time': med.displayTime,
        'snoozeMinutes': med.snoozeMinutes,
      });
      
      // Schedule notification
      await flutterLocalNotificationsPlugin.zonedSchedule(
        int.parse(med.id) % 100000, // Unique ID
        '💊 ${med.name}',
        'Time to take your medicine',
        scheduledTime,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: 
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
        matchDateTimeComponents: _getMatchComponents(med.repeatType),
      );
      
      print('✅ Notification scheduled: ${med.name} at ${scheduledTime}');
      
    } catch (e) {
      print('💥 Error scheduling: $e');
      Get.snackbar('Warning', 'Reminder set but notification might not work');
    }
  }

tz.TZDateTime _calculateScheduledTime(int hour, int minute, Medicine med) {
  final now = tz.TZDateTime.now(tz.local);
  var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  
  // If time has passed today, move to next occurrence
  if (scheduled.isBefore(now)) {
    switch (med.repeatType) {
      case 'daily':
        scheduled = scheduled.add(Duration(days: 1));
        break;
      case 'weekly':
        // Find next selected day
        scheduled = _nextWeeklyDay(scheduled, med.selectedDays);
        break;
      case 'monthly':
        // ✅ FIX: Correct way to add month
        int newMonth = scheduled.month + 1;
        int newYear = scheduled.year;
        if (newMonth > 12) {
          newMonth = 1;
          newYear++;
        }
        scheduled = tz.TZDateTime(
          tz.local, 
          newYear, 
          newMonth, 
          scheduled.day, 
          hour, 
          minute
        );
        break;
      default: // once
        scheduled = scheduled.add(Duration(days: 1));
    }
  }
  
  return scheduled;
}

tz.TZDateTime _nextWeeklyDay(tz.TZDateTime current, List<int> selectedDays) {
  var next = current;
  
  for (int i = 1; i <= 7; i++) {
    next = next.add(Duration(days: 1));
    int weekday = next.weekday; // 1=Monday, 7=Sunday
    if (selectedDays.contains(weekday)) {
      return next;
    }
  }
  
  // Fallback: 1 week later
  return current.add(Duration(days: 7));
}

  DateTimeComponents? _getMatchComponents(String repeatType) {
    switch (repeatType) {
      case 'daily':
        return DateTimeComponents.time;
      case 'weekly':
        return DateTimeComponents.dayOfWeekAndTime;
      case 'monthly':
        return DateTimeComponents.dayOfMonthAndTime;
      default:
        return null; // once
    }
  }

  // ✅ FIXED: Test notification
  void testNotification() async {
    try {
      print('🧪 Testing notification...');
      
      // Simple notification channel for test
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'test_channel',
        'Test Notifications',
        description: 'Test notifications',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('alaram_bell'),
        enableVibration: true,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

       AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        sound: RawResourceAndroidNotificationSound('alaram_bell'),
        playSound: true,
        enableVibration: true,
      );

       NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        99999,
        '💊 Test Notification',
        'This is a test notification',
        platformDetails,
        payload: 'test',
      );
      
      print('✅ Test notification sent');
      Get.snackbar('Success', 'Test notification sent');
      
    } catch (e) {
      print('💥 Test failed: $e');
      Get.snackbar('Error', 'Test failed: $e');
    }
  }

  void deleteMedicine(Medicine med) {
    medicines.remove(med);
    saveToBox();
    Get.snackbar('Deleted', '${med.name} removed');
    if (Get.currentRoute == '/edit-medicine') {
      Get.back();
    }
  }

  void markTaken(Medicine med) {
    medicines.remove(med);
    history.add(med);
    saveToBox();
    Get.snackbar('Taken', '${med.name} marked as taken');
  }

  void saveToBox() {
    final list = medicines.map((e) => e.toMap()).toList();
    box.put('medicines', list);
  }

  void loadMedicines() {
    final saved = box.get('medicines', defaultValue: []);
    medicines.value = List<Medicine>.from(
        saved.map((e) => Medicine.fromMap(Map<String, dynamic>.from(e))));
  }
}
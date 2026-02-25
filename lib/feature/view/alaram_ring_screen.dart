import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/alarm_audio_service.dart';

class AlarmRingScreen extends StatefulWidget {
  final String medicineName;
  final String time;
  final int snoozeMinutes;

  const AlarmRingScreen({
    Key? key,
    required this.medicineName,
    this.time = '',
    this.snoozeMinutes = 5,
  }) : super(key: key);

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> {

  @override
  void initState() {
    super.initState();
    AlarmAudioService().start(); // 🔔 Start Looping Sound
  }

  @override
  void dispose() {
    AlarmAudioService().stop(); // 🛑 Stop when leaving
    super.dispose();
  }

  void stopAndClose() {
    AlarmAudioService().stop();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade900,
      body: WillPopScope(
        onWillPop: () async => false,
        child: Column(
          children: [

            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              color: Colors.black.withOpacity(0.3),
              child: const Column(
                children: [
                  Icon(Icons.alarm, size: 60, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'MEDICINE REMINDER',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Time to Take:',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        widget.medicineName,
                        style: const TextStyle(
                          fontSize: 38,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      if (widget.time.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Scheduled: ${widget.time}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                      ],

                      const SizedBox(height: 40),

                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.withOpacity(0.3),
                        ),
                        child: const Icon(
                          Icons.notifications_active,
                          size: 55,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Buttons
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.black.withOpacity(0.5),
              child: Row(
                children: [

                  // Snooze
                  Expanded(
                    child: ElevatedButton(
                      onPressed: stopAndClose,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "SNOOZE\n(${widget.snoozeMinutes} min)",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Taken
                  Expanded(
                    child: ElevatedButton(
                      onPressed: stopAndClose,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "TAKEN",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
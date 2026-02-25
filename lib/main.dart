import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Open boxes
  await Hive.openBox('medicinesBox');
  await Hive.openBox('historyBox');
  
  runApp(const App());
}
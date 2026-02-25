import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_alert/feature/controller/medicine_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediAlert',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => MedicineController());
      }),
    );
  }
}
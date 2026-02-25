import 'package:get/get.dart';
import '../feature/binding/medicine_binding.dart';
import '../feature/view/add_medicine_screen.dart';
import '../feature/view/alaram_ring_screen.dart';
import '../feature/view/edit_medicine_screen.dart';
import '../feature/view/home_screen.dart';
import '../feature/view/medicine_history_screen.dart';
import 'app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const MedicineHomeScreen(),
      binding: MedicineBinding(),
    ),
    GetPage(
      name: AppRoutes.addMedicine,
      page: () => const AddMedicineScreen(),
      binding: MedicineBinding(),
    ),
    GetPage(
      name: AppRoutes.editMedicine,
      page: () => const EditMedicineScreen(),
      binding: MedicineBinding(),
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => const MedicineHistoryScreen(),
      binding: MedicineBinding(),
    ),
    GetPage(
      name: AppRoutes.alarmRing,
      page: () => AlarmRingScreen(medicineName: Get.arguments),
    ),
  ];
}

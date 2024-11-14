import 'package:get/get.dart';

import '../PollScreen.dart';
import '../bindings/home_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const PollScreen(),
      binding: HomeBinding(),
    ),
  ];
}

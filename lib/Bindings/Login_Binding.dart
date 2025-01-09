import 'package:get/get.dart';
import 'package:mis/Controllers/login_controller.dart';


class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

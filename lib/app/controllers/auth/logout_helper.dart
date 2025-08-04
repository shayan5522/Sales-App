import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../ui/screens/auth/signup_as.dart';

Future<void> logoutUser() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  Get.offAll(() => const SignUpAsScreen());
}

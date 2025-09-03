import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_app_check/firebase_app_check.dart'; // 👈 add this
import 'app/themes/colors.dart';
import 'app/ui/screens/auth/splash.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 👇 Enable Firebase App Check
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity, // ✅ recommended
  //   // androidProvider: AndroidProvider.debug, // 👈 use this if you just want testing
  //   appleProvider: AppleProvider.appAttest, // or AppleProvider.debug for iOS testing
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'ShopOrbit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: SplashScreen(),
      initialRoute: '/',
    );
  }
}

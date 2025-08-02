import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'app/ui/screens/owner/Reports/Credit_Debit_Page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ THIS LINE IS REQUIRED

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Only enable in debug mode
      builder: (context) => const MyApp(),
    ),
  );
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
      title: 'Sales App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: CreditDebitPage(),
   //  home: SalesReportPage(),
      initialRoute: '/',
    );
  }
}

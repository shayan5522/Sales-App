import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/ui/screens/dummy.dart';
<<<<<<< HEAD
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
=======
import 'package:salesapp/app/ui/screens/labour_panel.dart';
import 'package:salesapp/app/ui/screens/owner_panel.dart';
import 'app/ui/screens/labour/labour_dashboard.dart';
import 'app/ui/screens/owner/Credit_Debit_Page.dart';
import 'app/ui/screens/owner/add_category_page.dart';
import 'app/ui/screens/owner/expense_report_page.dart';
import 'app/ui/screens/owner/intake_report.dart';
import 'app/ui/screens/owner/owner_dashboard.dart';
import 'app/ui/screens/owner/report_page.dart';
import 'app/ui/screens/owner/sales_report_page.dart';
import 'app/ui/screens/owner/stock_report.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ THIS LINE IS REQUIRED
>>>>>>> f6538ad798ae4ca3f46d190e81e2f7450dde7abe
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
      // home: SplashScreen(),

     home:AddCategoryPage(),
      initialRoute: '/',
    );
  }
}

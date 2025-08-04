import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/Admindashboard/dashboard_main-container.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/logout_dialog.dart';
class LabourDashboard extends StatelessWidget {
  const LabourDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Labour Dashboard',
        actions: [
          const Icon(Icons.person, color: Colors.white),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => LogoutDialog(
                  onCancel: () => Navigator.pop(context),
                  onConfirm: () async {
                    Navigator.pop(context);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    Get.offAllNamed('/SignUpAsScreen');
                  },

                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),

      backgroundColor: const Color(0xFFEFEFF1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome",
              style: AppTextStyles.heading.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB3B9E0), Color(0xFF5B5D97)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide ? 3 : 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1,
                children: const [
                  MainContainer(
                    imagePath: "assets/images/sales1111.png",
                    label: "Add Sale",
                  ),
                  MainContainer(
                    imagePath: "assets/images/intake.png",
                    label: "Add Intake",
                  ),
                  MainContainer(
                    imagePath: "assets/images/products.png",
                    label: "Return",
                  ),
                  MainContainer(
                    imagePath: "assets/images/Expense.png",
                    label: "Add Expense",
                  ),
                  MainContainer(
                    imagePath: "assets/images/CD_report.png",
                    label: "Credit & amount due",
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

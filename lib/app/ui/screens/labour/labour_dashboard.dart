import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../controllers/auth/logout_helper.dart';
import '../../../themes/styles.dart';
import '../../widgets/Admindashboard/dashboard_main-container.dart';
import '../../widgets/appbar.dart';
import '../../widgets/logout_dialog.dart';
import 'AddCreditDebit/labour_transaction.dart';
import 'AddExpense/labour_add_expense.dart';
import 'AddIntake/labour_add_intake.dart';
import 'AddReturn/labour_add_return.dart';
import 'AddSales/labour_add_sales.dart';
class LabourDashboard extends StatelessWidget {
  const LabourDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: CustomAppbar(
        centerTitle: false,
        showBackButton: false,
        title: 'Labour Dashboard',
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
                children: [
                  MainContainer(
                    imagePath: "assets/images/sales1111.png",
                    label: "Add Sale",
                    onTap: (){Get.to(()=>const LabourAddSales());},
                  ),
                   MainContainer(
                    imagePath: "assets/images/intake.png",
                    label: "Add Intake",
                     onTap: (){Get.to(()=>const LabourAddIntake());},
                  ),
                   MainContainer(
                    imagePath: "assets/images/products.png",
                    label: "Return",
                     onTap: (){Get.to(()=>const LabourReturnProduct());},
                  ),
                   MainContainer(
                    imagePath: "assets/images/Expense.png",
                    label: "Add Expense",
                    onTap: (){Get.to(()=>const LabourAddExpenseScreen());},
                  ),
                  MainContainer(
                    imagePath: "assets/images/CD_report.png",
                    label: "Credit & amount due",
                    onTap: (){Get.to(()=> LabourTransactionsScreen());},
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

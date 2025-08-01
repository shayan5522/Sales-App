import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';

class CustomDashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String logoPath;

  const CustomDashboardAppBar({
    super.key,
    required this.title,
    required this.logoPath,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      automaticallyImplyLeading: false,
      elevation: 2,
      titleSpacing: 16,
      title: Row(
        children: [
          Image.asset(
            logoPath,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

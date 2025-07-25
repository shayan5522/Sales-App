import 'package:flutter/material.dart';

import '../../themes/colors.dart';
import '../../themes/styles.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final Widget? leading;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color foregroundcolor;
  final TabBar? bottom;
  final bool? automaticallyImplyLeading ;

  // Define height as a class variable
  final double height;
  final double tabBarHeight;

  const CustomAppbar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.leading,
    this.actions,
    this.backgroundColor = AppColors.primary,
    this.foregroundcolor = Colors.white,
    this.bottom,
    this.automaticallyImplyLeading,

  })  : height = 56.0,
        tabBarHeight = bottom != null ? 48.0 : 0.0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.subheading.copyWith(color: Colors.white),
      ),
      centerTitle: centerTitle,
      leading: IconButton(icon: const Icon(Icons.arrow_back,color: Colors.white,),
        onPressed: (){Navigator.pop(context);},
      ),
      actions: actions,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

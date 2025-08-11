import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import '../../../controllers/auth/logout_helper.dart';
import '../../widgets/logout_dialog.dart';

class LabourSettingPage extends StatelessWidget {
  const LabourSettingPage({super.key});

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    await logoutUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Setting",showBackButton: false,),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: (){
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => LogoutDialog(
                onCancel: () => Navigator.pop(context),
                onConfirm: () async {
                  Navigator.pop(context);
                 await _logout();
                },
              ),
            );
          },
          icon: const Icon(Icons.logout),
          label: const Text("Logout"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

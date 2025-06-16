// lib/screens/shared/role_selection_screen.dart
import 'package:flutter/material.dart';
import '../mahasiswa/login_mahasiswa_screen.dart' as mahasiswa;
import '../admin/login_admin_screen.dart' as admin;

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const mahasiswa.LogoFasMail(), // pastikan widget ini tersedia
            const SizedBox(height: 40),
            const Text("Masuk Sebagai", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            buildRoleButton("Admin TU", context, const admin.LoginAdminScreen(), Colors.black),
            const SizedBox(height: 16),
            buildRoleButton("Mahasiswa", context, const mahasiswa.LoginMahasiswaScreen(), Colors.black),
          ],
        ),
      ),
    );
  }

  Widget buildRoleButton(String label, BuildContext context, Widget target, Color textColor) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => target)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF45C5C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
      ),
    );
  }
}

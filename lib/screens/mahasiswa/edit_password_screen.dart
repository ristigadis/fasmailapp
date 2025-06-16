import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  void _toggleOldPassword() {
    setState(() => _obscureOldPassword = !_obscureOldPassword);
  }

  void _toggleNewPassword() {
    setState(() => _obscureNewPassword = !_obscureNewPassword);
  }

  void _toggleConfirmPassword() {
    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
  }

  Future<void> _updatePassword() async {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi"), backgroundColor: Colors.red),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password baru minimal 6 karakter"), backgroundColor: Colors.red),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password baru dan konfirmasi tidak cocok"), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email;

      if (user != null && email != null) {
        final credential = EmailAuthProvider.credential(email: email, password: oldPassword);

        // Re-authenticate user
        await user.reauthenticateWithCredential(credential);

        // Ubah password
        await user.updatePassword(newPassword);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password berhasil diubah"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String msg = "Gagal mengubah password.";
      if (e.code == 'wrong-password') {
        msg = "Password lama salah.";
      } else if (e.code == 'weak-password') {
        msg = "Password terlalu lemah.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $msg"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ubah Password"),
        backgroundColor: const Color(0xFFF45C5C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            // Password Lama
            TextField(
              controller: _oldPasswordController,
              obscureText: _obscureOldPassword,
              decoration: InputDecoration(
                labelText: "Password Lama",
                suffixIcon: IconButton(
                  icon: Icon(_obscureOldPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: _toggleOldPassword,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFF45C5C)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFF45C5C), width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password Baru
            TextField(
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              decoration: InputDecoration(
                labelText: "Password Baru",
                suffixIcon: IconButton(
                  icon: Icon(_obscureNewPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: _toggleNewPassword,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFF45C5C)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFF45C5C), width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Konfirmasi Password Baru
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: "Konfirmasi Password Baru",
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: _toggleConfirmPassword,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFF45C5C)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFF45C5C), width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isLoading ? null : _updatePassword,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.green)
                    : const Text("Simpan Password", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

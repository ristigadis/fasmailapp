import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_admin_screen.dart';

class LogoFasMail extends StatelessWidget {
  const LogoFasMail({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: 250,
    );
  }
}

class LoginAdminScreen extends StatefulWidget {
  const LoginAdminScreen({super.key});

  @override
  State<LoginAdminScreen> createState() => _LoginAdminScreenState();
}

class _LoginAdminScreenState extends State<LoginAdminScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // Validasi format email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  Future<void> _loginAdmin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email dan password wajib diisi"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Format email tidak valid"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password minimal 6 karakter"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      setState(() => _isLoading = true);

      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists && doc.data()?['role'] == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeAdminScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Akun ini bukan admin"),
          backgroundColor: Colors.red,
        ));
        await _auth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      String msg = "Terjadi kesalahan.";
      if (e.code == 'user-not-found') {
        msg = "Akun tidak ditemukan.";
      } else if (e.code == 'wrong-password') {
        msg = "Password salah.";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $msg"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: LogoFasMail()),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                "Login Admin TU",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email Admin",
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

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
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

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isLoading ? null : _loginAdmin,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.green)
                    : const Text("Login", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

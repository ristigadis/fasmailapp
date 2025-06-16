import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_mahasiswa_screen.dart';
import 'lupa_password_screen.dart';
import 'register_screen.dart';

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

class LoginMahasiswaScreen extends StatefulWidget {
  const LoginMahasiswaScreen({super.key});

  @override
  State<LoginMahasiswaScreen> createState() => _LoginMahasiswaScreenState();
}

class _LoginMahasiswaScreenState extends State<LoginMahasiswaScreen> {
  final TextEditingController nimController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _signIn() async {
    final String nim = nimController.text.trim();
    final String password = passwordController.text.trim();

    if (nim.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("NIM dan Password tidak boleh kosong."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      // Cari email berdasarkan NIM di Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('nim', isEqualTo: nim)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("NIM tidak ditemukan");
      }

      final String email = querySnapshot.docs.first['email'];

      // Login dengan email yang ditemukan
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigasi ke HomeMahasiswaScreen setelah login berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeMahasiswaScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = "Login gagal.";

      if (e.code == 'wrong-password') {
        msg = "Password salah.";
      } else if (e.code == 'user-not-found') {
        msg = "User tidak ditemukan.";
      } else if (e.code == 'invalid-email') {
        msg = "Format email tidak valid.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $msg"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
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
            Center(child: LogoFasMail()),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                "Login Mahasiswa",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),

            // Field NIM
            TextField(
              controller: nimController,
              decoration: InputDecoration(
                labelText: "NIM",
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

            // Field Password
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
            const SizedBox(height: 8),

            // Lupa Password
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LupaPasswordScreen()),
                );
              },
              child: const Text(
                "Lupa Password?",
                style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 24),

            // Tombol Login
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isLoading ? null : _signIn,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.green)
                    : const Text(
                        "Login",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Daftar
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "Belum punya akun? Daftar",
                  style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

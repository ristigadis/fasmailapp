import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../mahasiswa/login_mahasiswa_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  String? selectedProdi;

  final List<String> prodiList = [
    'Sistem Informasi',
    'Teknologi Informasi',
    'Informatika',
  ];

  Future<void> _register() async {
    final String nama = namaController.text.trim();
    final String nim = nimController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (nama.isEmpty || nim.isEmpty || email.isEmpty || password.isEmpty || selectedProdi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua field wajib diisi!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password minimal 6 karakter."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'nama': nama,
        'nim': nim,
        'email': email,
        'prodi': selectedProdi,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registrasi berhasil!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginMahasiswaScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMsg = "Registrasi gagal.";
      if (e.code == 'email-already-in-use') {
        errorMsg = "Email sudah terdaftar.";
      } else if (e.code == 'invalid-email') {
        errorMsg = "Format email tidak valid.";
      } else if (e.code == 'weak-password') {
        errorMsg = "Password terlalu lemah.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $errorMsg"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFF45C5C)),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFF45C5C), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const Text("Register", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 24),

              // Field Nama
              TextField(
                controller: namaController,
                decoration: _inputStyle("Nama Lengkap"),
              ),
              const SizedBox(height: 16),

              // Field NIM
              TextField(
                controller: nimController,
                decoration: _inputStyle("NIM"),
              ),
              const SizedBox(height: 16),

              // Field Email
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputStyle("Email"),
              ),
              const SizedBox(height: 16),

              // Field Prodi (urutan ke-4)
              DropdownButtonFormField<String>(
                value: selectedProdi,
                items: prodiList
                    .map((prodi) => DropdownMenuItem(
                          value: prodi,
                          child: Text(prodi),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => selectedProdi = value),
                decoration: _inputStyle("Program Studi"),
              ),
              const SizedBox(height: 16),

              // Field Password
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: _inputStyle("Password"),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _register,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.green)
                      : const Text(
                          "Daftar",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_password_screen.dart';

class ProfilMahasiswaScreen extends StatefulWidget {
  const ProfilMahasiswaScreen({super.key});

  @override
  State<ProfilMahasiswaScreen> createState() => _ProfilMahasiswaScreenState();
}

class _ProfilMahasiswaScreenState extends State<ProfilMahasiswaScreen> {
  String? nama;
  String? nim;
  String? prodi;
  String? email;
  bool isLoading = true;

  Future<void> fetchProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          nama = data['nama'];
          nim = data['nim'];
          prodi = data['prodi'];
          email = data['email'];
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        backgroundColor: const Color(0xFFF45C5C),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildProfileField("Nama", nama ?? "-"),
                  const SizedBox(height: 16),

                  _buildProfileField("NIM", nim ?? "-"),
                  const SizedBox(height: 16),

                  _buildProfileField("Program Studi", prodi ?? "-"),
                  const SizedBox(height: 16),

                  _buildProfileField("Email", email ?? "-"),
                  const SizedBox(height: 32),

                  // Tombol ubah password
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EditPasswordScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Ubah Password'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tombol logout
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color.fromARGB(255, 255, 13, 13)),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

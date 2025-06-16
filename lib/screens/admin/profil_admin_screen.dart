import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilAdminScreen extends StatefulWidget {
  const ProfilAdminScreen({super.key});

  @override
  State<ProfilAdminScreen> createState() => _ProfilAdminScreenState();
}

class _ProfilAdminScreenState extends State<ProfilAdminScreen> {
  String? nama;
  String? nip;
  String? email;
  String? jabatan;
  bool isLoading = true;

  Future<void> _loadAdminData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();

      if (data != null) {
        setState(() {
          nama = data['nama'] ?? 'Admin';
          email = data['email'] ?? user.email;
          jabatan = data['jabatan'] ?? 'Tata Usaha';
          nip = data['nip'] ?? '-';
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Admin TU'),
        backgroundColor: const Color(0xFFF45C5C),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.admin_panel_settings, size: 50, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildProfileField("Nama", nama ?? "-"),
                  const SizedBox(height: 16),

                  _buildProfileField("Email", email ?? "-"),
                  const SizedBox(height: 16),

                  _buildProfileField("NIP", nip ?? "-"),
                  const SizedBox(height: 16),

                  _buildProfileField("Jabatan", jabatan ?? "-"),
                  const SizedBox(height: 32),

                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.black,
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

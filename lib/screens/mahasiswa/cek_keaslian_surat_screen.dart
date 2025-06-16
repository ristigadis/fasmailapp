// lib/screens/mahasiswa/cek_keaslian_surat_screen.dart
import 'package:flutter/material.dart';

class CekKeaslianSuratScreen extends StatelessWidget {
  const CekKeaslianSuratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nomorSuratController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Cek Keaslian Surat'), backgroundColor: const Color(0xFFFF4F4F)),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            TextField(
              controller: nomorSuratController,
              decoration: const InputDecoration(labelText: 'Nomor Surat'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Surat valid & terdaftar")));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4F4F),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Cek"),
            ),
          ],
        ),
      ),
    );
  }
}

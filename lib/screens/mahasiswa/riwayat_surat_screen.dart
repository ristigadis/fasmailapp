// lib/screens/mahasiswa/riwayat_surat_screen.dart
import 'package:flutter/material.dart';

class RiwayatSuratScreen extends StatelessWidget {
  const RiwayatSuratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> riwayat = [
      'Surat Aktif Kuliah',
      'Surat Dispensasi',
      'Surat Tugas',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Surat'),
        backgroundColor: const Color(0xFFFF4F4F),
        automaticallyImplyLeading: false, // ⬅️ ini buat hilangin tombol back
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(32),
        itemCount: riwayat.length,
        itemBuilder: (context, index) => Card(
          color: Colors.red[50],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(riwayat[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Arahkan ke halaman detail surat jika diperlukan
            },
          ),
        ),
      ),
    );
  }
}

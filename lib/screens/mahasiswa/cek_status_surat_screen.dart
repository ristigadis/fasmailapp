// lib/screens/mahasiswa/cek_status_surat_screen.dart
import 'package:flutter/material.dart';

class CekStatusSuratScreen extends StatelessWidget {
  const CekStatusSuratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final suratList = [
      {'judul': 'Surat Aktif Kuliah', 'status': 'Diproses'},
      {'judul': 'Surat Dispensasi', 'status': 'Selesai'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Status Surat'), backgroundColor: const Color(0xFFFF4F4F)),
      body: ListView.builder(
        itemCount: suratList.length,
        padding: const EdgeInsets.all(32),
        itemBuilder: (context, index) {
          final surat = suratList[index];
          final status = surat['status'];
          final statusColor = status == 'Selesai' ? Colors.green : Colors.orange;

          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(surat['judul']!),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(status!, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      ),
    );
  }
}

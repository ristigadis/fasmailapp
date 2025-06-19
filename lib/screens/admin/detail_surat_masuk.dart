import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class DetailSuratAdminScreen extends StatelessWidget {
  final String docId;

  const DetailSuratAdminScreen({super.key, required this.docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Surat Masuk'), backgroundColor: const Color(0xFFF45C5C)),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('pengajuan_surat').doc(docId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Surat tidak ditemukan."));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final nama = data['nama'] ?? '-';
          final nim = data['nim'] ?? '-';
          final kategori = data['kategori'] ?? '-';
          final tanggalLahir = data['tanggal_lahir'] ?? '-';
          final tujuan = data['tujuan'] ?? '-';
          final status = data['status'] ?? '-';
          final lokasi = data['lokasi'];
          final berkasBase64 = data['berkas_base64'];
          final fileName = data['nama_file'];

          final qrContent = "verifikasi_surat:$docId";

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nama: $nama", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("NIM: $nim", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text("Kategori: $kategori", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text("Tanggal Lahir: $tanggalLahir", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text("Tujuan: $tujuan", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text("Status: $status", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text("Preview Berkas:", style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (berkasBase64 != null && berkasBase64.isNotEmpty) 
                  Image.memory(base64Decode(berkasBase64), height: 250),
                if (berkasBase64 == null || berkasBase64.isEmpty)
                  const Text("Tidak ada berkas yang diunggah."),
                const SizedBox(height: 24),
                if (status.toLowerCase() == 'disetujui') ...[
                  const Text("QR Verifikasi:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Center(
                    child: QrImageView(
                      data: qrContent,
                      version: QrVersions.auto,
                      size: 150,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tunjukkan QR ini ke TU saat mengambil surat.",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Call API to approve
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text("Setujui"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Call API to reject
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text("Tolak"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

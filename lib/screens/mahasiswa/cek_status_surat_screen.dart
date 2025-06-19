import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CekStatusSuratScreen extends StatelessWidget {
  const CekStatusSuratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Surat'),
        backgroundColor: const Color(0xFFFF4F4F),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pengajuan_surat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada pengajuan surat."));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.all(32),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final judul = data['kategori'] ?? 'Surat';
              final rawStatus = (data['status'] ?? 'menunggu').toString().toLowerCase();

              final isSelesai = rawStatus == 'disetujui' || rawStatus == 'ditolak';
              final statusLabel = isSelesai ? 'Selesai' : 'Diproses';
              final statusColor = isSelesai ? Colors.green : Colors.orange;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(judul),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                    final tujuan = data['tujuan'] ?? '-';
                    final tglLahir = data['tanggal_lahir'] ?? '-';
                    final status = (data['status'] ?? '-').toString().toLowerCase();
                    final docId = doc.id;

                    // Konten QR bisa dimodifikasi sesuai skema verifikasi backend
                    final qrContent = "verifikasi_surat:$docId";

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Text("Detail Surat"),
                        content: SingleChildScrollView( // ✅ agar tidak overflow
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Kategori: ${data['kategori'] ?? '-'}"),
                              Text("Tujuan: $tujuan"),
                              Text("Tanggal Lahir: $tglLahir"),
                              Text("Status: ${data['status'] ?? '-'}"),
                              const SizedBox(height: 16),
                              if (status == 'disetujui') ...[
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
                              ]
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Tutup"),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
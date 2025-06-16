import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class SuratMasukDetailScreen extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> data;

  const SuratMasukDetailScreen({
    super.key,
    required this.docId,
    required this.data,
  });

  Future<void> _setujuiSurat(BuildContext context) async {
    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('pengajuan_surat').doc(docId).update({
        'status': 'disetujui',
      });

      final fileBase64 = data['berkas_base64'] ?? '';
      final fileName = data['nama_file'] ?? 'surat.jpg';

      if (fileBase64.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berkas tidak tersedia"), backgroundColor: Colors.red),
        );
        return;
      }

      await firestore.collection('surat_keluar').add({
        'nomor_surat': "SK-${DateTime.now().millisecondsSinceEpoch}",
        'tanggal': DateTime.now().toIso8601String().substring(0, 10),
        'penerima': data['tujuan'],
        'isi_ringkas': "Surat dari ${data['nama']} (${data['nim']}) untuk ${data['kategori']}",
        'file_base64': fileBase64,
        'file_name': fileName,
        'file_type': _cekTipeFile(fileName),
        'created_at': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Surat disetujui & masuk ke Surat Keluar"), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      print("ERROR saat menyetujui surat: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyetujui: $e"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _tolakSurat(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('pengajuan_surat')
        .doc(docId)
        .update({'status': 'ditolak'});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Surat telah ditolak"), backgroundColor: Colors.red),
    );
    Navigator.pop(context);
  }

  Widget _previewBerkas(BuildContext context, String base64) {
    if (_cekTipeFile(data['nama_file']) == 'pdf') {
      return ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Preview PDF belum didukung di halaman ini")));
        },
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text("Berkas PDF tersedia"),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      );
    } else {
      final bytes = base64Decode(base64);
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(bytes, height: 200, fit: BoxFit.cover),
      );
    }
  }

  String _cekTipeFile(String filename) {
    if (filename.endsWith('.pdf')) return 'pdf';
    if (filename.endsWith('.jpg') || filename.endsWith('.jpeg')) return 'jpg';
    if (filename.endsWith('.png')) return 'png';
    return 'lainnya';
  }

  void _bukaDiMaps(double lat, double lng) async {
    final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Tidak bisa membuka Maps.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = data['status'] ?? 'menunggu';
    final lokasi = data['lokasi'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Surat Masuk"),
        backgroundColor: const Color(0xFFF45C5C),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildInfoRow("Nama", data['nama']),
                _buildInfoRow("NIM", data['nim']),
                _buildInfoRow("Kategori", data['kategori']),
                _buildInfoRow("Tanggal Lahir", data['tanggal_lahir']),
                _buildInfoRow("Tujuan", data['tujuan']),
                _buildInfoRow("Status", status),
                const SizedBox(height: 16),
                const Text("Berkas Pendukung:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if ((data['berkas_base64'] ?? '').toString().isNotEmpty)
                  _previewBerkas(context, data['berkas_base64'])
                else
                  const Text("Tidak ada berkas."),
                const SizedBox(height: 20),
                if (lokasi != null && lokasi['lat'] != null && lokasi['lng'] != null) ...[
                  const Text("Lokasi Saat Pengajuan:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Latitude: ${lokasi['lat']}, Longitude: ${lokasi['lng']}"),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _bukaDiMaps(lokasi['lat'], lokasi['lng']),
                    icon: const Icon(Icons.map),
                    label: const Text("Buka di Maps"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  ),
                ]
              ],
            ),
          ),
          if (status == 'menunggu')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _setujuiSurat(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text("Setujui"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _tolakSurat(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Tolak"),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value?.toString() ?? "-")),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SuratMasukScreen extends StatelessWidget {
  const SuratMasukScreen({super.key});

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'disetujui':
        color = Colors.green;
        label = 'Disetujui';
        break;
      case 'ditolak':
        color = Colors.red;
        label = 'Ditolak';
        break;
      default:
        color = Colors.orange;
        label = 'Menunggu';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Surat Masuk"),
        backgroundColor: const Color(0xFFF45C5C),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pengajuan_surat')
            .where('status', isEqualTo: 'menunggu') // ⬅️ hanya ambil yang belum diproses
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Tidak ada surat yang menunggu persetujuan."));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final status = data['status'] ?? 'menunggu';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: ListTile(
                  title: Text(data['nama'] ?? 'Tanpa Nama'),
                  subtitle: Text("Kategori: ${data['kategori'] ?? '-'}"),
                  trailing: _buildStatusBadge(status),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SuratMasukDetailScreen(
                          docId: docs[index].id,
                          data: data,
                        ),
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

class SuratMasukDetailScreen extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> data;

  const SuratMasukDetailScreen({super.key, required this.docId, required this.data});

  Future<void> _setujuiSurat(BuildContext context) async {
    await FirebaseFirestore.instance.collection('pengajuan_surat').doc(docId).update({'status': 'disetujui'});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Surat telah disetujui"), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  Future<void> _tolakSurat(BuildContext context) async {
    await FirebaseFirestore.instance.collection('pengajuan_surat').doc(docId).update({'status': 'ditolak'});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Surat telah ditolak"), backgroundColor: Colors.red),
    );
    Navigator.pop(context);
  }

  Future<Widget> _previewFile(BuildContext context) async {
    try {
      final berkasBase64 = data['berkas'];
      final fileName = data['nama_file'] ?? 'berkas';

      if (berkasBase64 == null || berkasBase64.isEmpty) {
        return const Text("Tidak ada berkas yang diunggah.");
      }

      Uint8List bytes = base64Decode(berkasBase64);

      if (fileName.toLowerCase().endsWith('.pdf')) {
        final tempDir = await getTemporaryDirectory();
        final pdfFile = File('${tempDir.path}/$fileName');
        await pdfFile.writeAsBytes(bytes);
        return SizedBox(
          height: 400,
          child: PDFView(filePath: pdfFile.path),
        );
      } else if (fileName.toLowerCase().endsWith('.jpg') ||
          fileName.toLowerCase().endsWith('.jpeg') ||
          fileName.toLowerCase().endsWith('.png')) {
        return Image.memory(bytes, height: 300);
      } else {
        return const Text("Format berkas tidak didukung untuk preview.");
      }
    } catch (e) {
      return Text("Gagal memuat berkas: $e", style: const TextStyle(color: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = data['status'] ?? 'menunggu';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Surat Masuk"),
        backgroundColor: const Color(0xFFF45C5C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Nama: ${data['nama'] ?? '-'}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("NIM: ${data['nim'] ?? '-'}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Kategori: ${data['kategori'] ?? '-'}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Tanggal Lahir: ${data['tanggal_lahir'] ?? '-'}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Tujuan: ${data['tujuan'] ?? '-'}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text("Status: $status", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text("Preview Berkas:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            FutureBuilder(
              future: _previewFile(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red));
                } else {
                  return snapshot.data as Widget;
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _setujuiSurat(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Setujui"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _tolakSurat(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Tolak"),
            ),
          ],
        ),
      ),
    );
  }
}

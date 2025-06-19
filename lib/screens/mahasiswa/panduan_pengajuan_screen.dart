import 'package:flutter/material.dart';

class PanduanPengajuanScreen extends StatelessWidget {
  const PanduanPengajuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final panduanList = [
      {
        'judul': 'Langkah-langkah Pengajuan',
        'isi':
            '1. Pilih kategori surat\n2. Isi data lengkap\n3. Upload file pendukung (jika ada)\n4. Klik "Ajukan"\n5. Tunggu persetujuan dari admin.'
      },
      {
        'judul': 'Format Tujuan Surat',
        'isi':
            'Tuliskan dengan jelas kepada siapa surat ditujukan. Contoh:\n- "Kepala Bagian Akademik"\n- "Dekan Fakultas Ilmu Komputer"\n- "Perusahaan Mitra PT. ABC"'
      },
      {
        'judul': 'Jenis File yang Diterima',
        'isi':
            'Kamu bisa upload file dalam format:\n- .jpg / .jpeg\n- .png\n- .pdf\nUkuran file disarankan < 5MB.'
      },
      {
        'judul': 'Waktu Proses Surat',
        'isi':
            'Biasanya surat akan diproses dalam 1–3 hari kerja.\nKamu bisa cek status surat di menu "Status Surat".'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Panduan Pengajuan"),
        backgroundColor: Color(0xFFFF4F4F),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: panduanList.length,
        itemBuilder: (context, index) {
          final panduan = panduanList[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(
                  panduan['judul']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(panduan['isi']!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

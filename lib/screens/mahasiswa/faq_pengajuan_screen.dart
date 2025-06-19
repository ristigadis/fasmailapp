import 'package:flutter/material.dart';

class FaqPengajuanScreen extends StatelessWidget {
  const FaqPengajuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqList = [
      {
        'pertanyaan': 'Berapa lama proses persetujuan surat?',
        'jawaban': 'Proses persetujuan biasanya memakan waktu 1–3 hari kerja tergantung antrean.'
      },
      {
        'pertanyaan': 'Apa yang harus saya isi di kolom tujuan?',
        'jawaban': 'Isi dengan pihak atau instansi yang dituju, seperti "Kepala Departemen", "Universitas Mitra", atau nama perusahaan.'
      },
      {
        'pertanyaan': 'Apakah saya bisa mengajukan surat lewat HP?',
        'jawaban': 'Ya, aplikasi ini sudah mendukung pengajuan surat langsung dari HP.'
      },
      {
        'pertanyaan': 'Bagaimana jika saya salah upload file?',
        'jawaban': 'Ajukan ulang surat yang benar, lalu hubungi admin untuk membatalkan pengajuan sebelumnya.'
      },
      {
        'pertanyaan': 'Apakah saya bisa mengecek status surat saya?',
        'jawaban': 'Bisa, gunakan menu "Status Surat" di aplikasi untuk melihat apakah surat sudah disetujui atau belum.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQ Pengajuan Surat"),
        backgroundColor: const Color(0xFFF45C5C),
      ),
      body: ListView.builder(
        itemCount: faqList.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final faq = faqList[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              title: Text(
                faq['pertanyaan']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(faq['jawaban']!),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

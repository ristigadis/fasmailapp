import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RiwayatSuratScreen extends StatefulWidget {
  const RiwayatSuratScreen({super.key});

  @override
  State<RiwayatSuratScreen> createState() => _RiwayatSuratScreenState();
}

class _RiwayatSuratScreenState extends State<RiwayatSuratScreen> {
  String? selectedKategori;
  final List<String> kategoriList = [
    'Surat Aktif Kuliah',
    'Surat Dispensasi',
    'Surat Tugas',
  ];

  Stream<QuerySnapshot<Map<String, dynamic>>> _getSuratStream() {
    return FirebaseFirestore.instance
        .collection('pengajuan_surat')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Surat"),
        backgroundColor: const Color(0xFFF45C5C),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Filter berdasarkan kategori',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              value: selectedKategori,
              items: kategoriList
                  .map((kategori) => DropdownMenuItem(
                        value: kategori,
                        child: Text(kategori),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedKategori = value;
                });
              },
              isExpanded: true,
              icon: const Icon(Icons.filter_list),
              dropdownColor: Colors.white,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _getSuratStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Tidak ada surat dalam riwayat."));
                }

                // 🔍 Filter client-side
                final allDocs = snapshot.data!.docs;
                final filteredDocs = selectedKategori == null
                    ? allDocs
                    : allDocs.where((doc) =>
                        doc.data()['kategori'] == selectedKategori).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(child: Text("Tidak ada surat sesuai kategori."));
                }

                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final data = filteredDocs[index].data();
                    final status = data['status'] ?? '-';

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: const Color(0xFFF45C5C),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(
                          "${data['kategori'] ?? 'Kategori'}",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "NIM: ${data['nim'] ?? '-'}\nStatus: $status",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        isThreeLine: true,
                        trailing: const Icon(Icons.history, color: Colors.white),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Detail Riwayat"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Nama: ${data['nama'] ?? '-'}"),
                                  Text("NIM: ${data['nim'] ?? '-'}"),
                                  Text("Kategori: ${data['kategori'] ?? '-'}"),
                                  Text("Tujuan: ${data['tujuan'] ?? '-'}"),
                                  Text("Status: $status"),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Tutup"),
                                ),
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
          ),
        ],
      ),
    );
  }
}

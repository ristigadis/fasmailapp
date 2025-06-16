import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KelolaPengumumanScreen extends StatefulWidget {
  const KelolaPengumumanScreen({super.key});

  @override
  State<KelolaPengumumanScreen> createState() => _KelolaPengumumanScreenState();
}

class _KelolaPengumumanScreenState extends State<KelolaPengumumanScreen> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();

  Future<void> _tambahPengumuman() async {
    final String judul = _judulController.text.trim();
    final String isi = _isiController.text.trim();

    if (judul.isEmpty || isi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan isi tidak boleh kosong!'), backgroundColor: Colors.red),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('pengumuman').add({
      'judul': judul,
      'isi': isi,
    });

    _judulController.clear();
    _isiController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengumuman berhasil ditambahkan!'), backgroundColor: Colors.green),
    );
  }

  Future<void> _hapusPengumuman(String docId) async {
    await FirebaseFirestore.instance.collection('pengumuman').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Pengumuman"),
        backgroundColor: const Color(0xFFF45C5C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(labelText: 'Judul Pengumuman'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _isiController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Isi Pengumuman'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _tambahPengumuman,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Tambah Pengumuman"),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            const Text("Daftar Pengumuman", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('pengumuman')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return const Center(child: Text("Belum ada pengumuman."));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          title: Text(data['judul'] ?? ''),
                          subtitle: Text(data['isi'] ?? ''),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _hapusPengumuman(docs[index].id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

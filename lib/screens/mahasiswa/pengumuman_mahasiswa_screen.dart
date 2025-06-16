// lib/screens/mahasiswa/pengumuman_mahasiswa_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PengumumanMahasiswaScreen extends StatelessWidget {
  const PengumumanMahasiswaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengumuman Administrasi"),
        backgroundColor: const Color(0xFFF45C5C),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pengumuman')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada pengumuman."));
          }

          final pengumuman = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pengumuman.length,
            itemBuilder: (context, index) {
              final data = pengumuman[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.announcement_rounded, color: Colors.red),
                  title: Text(data['judul'] ?? ''),
                  subtitle: Text(data['isi'] ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_auth/firebase_auth.dart';

class PengajuanSuratScreen extends StatefulWidget {
  const PengajuanSuratScreen({super.key});

  @override
  State<PengajuanSuratScreen> createState() => _PengajuanSuratScreenState();
}

class _PengajuanSuratScreenState extends State<PengajuanSuratScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController tujuanController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();

  String? selectedKategori;
  String? fileName;
  String? base64File;
  bool _isLoading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        fileName = file.name;
        base64File = base64Encode(file.bytes!);
      });
    }
  }

  Future<void> _ambilFoto() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() {
        fileName = p.basename(photo.path);
        base64File = base64Encode(bytes);
      });
    }
  }

  Future<Position?> _ambilLokasi() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (!serviceEnabled || permission == LocationPermission.deniedForever) {
      return null;
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _submitForm() async {
    final nama = namaController.text.trim();
    final nim = nimController.text.trim();
    final tujuan = tujuanController.text.trim();
    final tanggal = tanggalController.text.trim();
    final kategori = selectedKategori;

    if (nama.isEmpty || nim.isEmpty || tujuan.isEmpty || tanggal.isEmpty || kategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi!"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final lokasi = await _ambilLokasi();
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Silakan login terlebih dahulu."), backgroundColor: Colors.red),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('pengajuan_surat').add({
        'nama': nama,
        'nim': nim,
        'tujuan': tujuan,
        'tanggal_lahir': tanggal,
        'kategori': kategori,
        'berkas_base64': base64File ?? '',
        'nama_file': fileName ?? '',
        'status': 'menunggu',
        'uid': currentUser.uid, // penting!
        'createdAt': FieldValue.serverTimestamp(), // penting!
        'lokasi': lokasi != null
            ? {
                'lat': lokasi.latitude,
                'lng': lokasi.longitude,
              }
            : null,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pengajuan berhasil dikirim!"), backgroundColor: Colors.green),
      );

      namaController.clear();
      nimController.clear();
      tujuanController.clear();
      tanggalController.clear();
      setState(() {
        selectedKategori = null;
        fileName = null;
        base64File = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengirim pengajuan: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        tanggalController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<Widget> _previewFile() async {
    if (base64File == null || fileName == null) return const SizedBox.shrink();
    final ext = p.extension(fileName!).toLowerCase();
    if (['.jpg', '.jpeg', '.png'].contains(ext)) {
      try {
        final bytes = base64Decode(base64File!);
        return Image.memory(bytes, width: 120, height: 120, fit: BoxFit.cover);
      } catch (_) {
        return const Text("Gagal menampilkan gambar.");
      }
    } else {
      return const Icon(Icons.insert_drive_file, size: 60, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengajuan Surat"), backgroundColor: const Color(0xFFF45C5C)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedKategori,
              items: const [
                DropdownMenuItem(value: 'Surat Aktif Kuliah', child: Text('Surat Aktif Kuliah')),
                DropdownMenuItem(value: 'Surat Dispensasi', child: Text('Surat Dispensasi')),
                DropdownMenuItem(value: 'Surat Tugas', child: Text('Surat Tugas')),
              ],
              onChanged: (value) => setState(() => selectedKategori = value),
              decoration: _inputDecoration("Kategori Surat"),
            ),
            const SizedBox(height: 16),
            TextField(controller: namaController, decoration: _inputDecoration("Nama Lengkap")),
            const SizedBox(height: 16),
            TextField(controller: nimController, decoration: _inputDecoration("NIM")),
            const SizedBox(height: 16),
            TextField(
              controller: tanggalController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: _inputDecoration("Tanggal Lahir"),
            ),
            const SizedBox(height: 16),
            TextField(controller: tujuanController, decoration: _inputDecoration("Tujuan Surat")),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Upload File"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _ambilFoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Kamera"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ),
              ],
            ),
            if (fileName != null) ...[
              const SizedBox(height: 10),
              Text(fileName!, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              FutureBuilder(
                future: _previewFile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Gagal memuat file: ${snapshot.error}");
                  } else {
                    return snapshot.data as Widget;
                  }
                },
              ),
            ],
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.green)
                    : const Text("Ajukan", style: TextStyle(color: Colors.green)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

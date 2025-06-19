import 'package:flutter/material.dart';
import 'pengajuan_surat_screen.dart';
import 'cek_status_surat_screen.dart';
import 'panduan_pengajuan_screen.dart'; // ganti dari faq_pengajuan_screen.dart
import 'profil_mahasiswa_screen.dart';
import 'pengumuman_mahasiswa_screen.dart';

class HomeMahasiswaScreen extends StatefulWidget {
  const HomeMahasiswaScreen({super.key});

  @override
  State<HomeMahasiswaScreen> createState() => _HomeMahasiswaScreenState();
}

class _HomeMahasiswaScreenState extends State<HomeMahasiswaScreen> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const PanduanPengajuanScreen(), // sudah ganti
    const HomeContent(),
    const ProfilMahasiswaScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFFF45C5C),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Panduan'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          decoration: const BoxDecoration(
            color: Color(0xFFF45C5C),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: const Text(
            "Selamat datang, Mahasiswa!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              buildHomeButton(
                context,
                label: "Pengajuan Surat",
                icon: Icons.mail_outline,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PengajuanSuratScreen())),
              ),
              const SizedBox(height: 12),
              buildHomeButton(
                context,
                label: "Cek Status Surat",
                icon: Icons.access_time,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CekStatusSuratScreen())),
              ),
              const SizedBox(height: 12),
              buildHomeButton(
                context,
                label: "Panduan Pengajuan",
                icon: Icons.menu_book,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PanduanPengajuanScreen())),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PengumumanMahasiswaScreen())),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Pengumuman Administrasi"),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildHomeButton(BuildContext context, {required String label, required IconData icon, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF45C5C),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
            Icon(icon, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

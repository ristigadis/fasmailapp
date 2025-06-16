import 'package:flutter/material.dart';
import 'surat_masuk_screen.dart';
import 'riwayat_surat_screen.dart'; // Pastikan file ini ada
import 'kelola_pengumuman_screen.dart';
import 'profil_admin_screen.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({super.key});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const KelolaPengumumanScreen(),
    const HomeContentAdmin(),
    const ProfilAdminScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF45C5C),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.announcement), label: 'Pengumuman'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

class HomeContentAdmin extends StatelessWidget {
  const HomeContentAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
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
              "Selamat datang, Admin!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),

          // Tombol Menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _buildMenuTile(
                  context,
                  title: "Surat Masuk",
                  icon: Icons.inbox,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SuratMasukScreen()),
                  ),
                ),
                _buildMenuTile(
                  context,
                  title: "Riwayat Surat",
                  icon: Icons.history,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RiwayatSuratScreen()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context,
      {required String title, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF45C5C),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Icon(icon, size: 28, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

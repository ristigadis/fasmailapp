// lib/routes/app_routes.dart
import 'package:flutter/material.dart';

// shared
import '../screens/shared/splash_screen.dart';
import '../screens/shared/role_selection_screen.dart';

// mahasiswa
import '../screens/mahasiswa/login_mahasiswa_screen.dart';
import '../screens/mahasiswa/register_screen.dart';
import '../screens/mahasiswa/home_mahasiswa_screen.dart';
import '../screens/mahasiswa/pengajuan_surat_screen.dart';
import '../screens/mahasiswa/cek_status_surat_screen.dart';
import '../screens/mahasiswa/cek_keaslian_surat_screen.dart';
import '../screens/mahasiswa/riwayat_surat_screen.dart';
import '../screens/mahasiswa/profil_mahasiswa_screen.dart';

// admin
import '../screens/admin/login_admin_screen.dart';
import '../screens/admin/home_admin_screen.dart';
// tambah admin route lain di sini

class AppRoutes {
  static const String splash = '/';
  static const String roleSelection = '/role';

  static const String loginMahasiswa = '/mahasiswa/login';
  static const String registerMahasiswa = '/mahasiswa/register';
  static const String homeMahasiswa = '/mahasiswa/home';
  static const String pengajuanSurat = '/mahasiswa/pengajuan';
  static const String cekStatusSurat = '/mahasiswa/cek-status';
  static const String cekKeaslianSurat = '/mahasiswa/cek-keaslian';
  static const String riwayatSurat = '/mahasiswa/riwayat';
  static const String profilMahasiswa = '/mahasiswa/profil';

  static const String loginAdmin = '/admin/login';
  static const String homeAdmin = '/admin/home';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    roleSelection: (context) => const RoleSelectionScreen(),

    loginMahasiswa: (context) => const LoginMahasiswaScreen(),
    registerMahasiswa: (context) => const RegisterScreen(),
    homeMahasiswa: (context) => const HomeMahasiswaScreen(),
    pengajuanSurat: (context) => const PengajuanSuratScreen(),
    cekStatusSurat: (context) => const CekStatusSuratScreen(),
    cekKeaslianSurat: (context) => const CekKeaslianSuratScreen(),
    riwayatSurat: (context) => const RiwayatSuratScreen(),
    profilMahasiswa: (context) => const ProfilMahasiswaScreen(),

    loginAdmin: (context) => const LoginAdminScreen(),
    homeAdmin: (context) => const HomeAdminScreen(),
    // tambahin route admin lainnya di sini
  };
}
  
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:laporkades_app/pages/login.dart'; // Sesuaikan path ke halaman login
import 'package:laporkades_app/pages/kebijakan_privasi.dart';
import 'package:laporkades_app/pages/syarat_dan_ketentuan.dart';
import 'package:laporkades_app/pages/tentang.dart';

class HalamanProfil extends StatelessWidget {
  const HalamanProfil({super.key});

  // Fungsi untuk melakukan log out
  Future<void> _signOut(BuildContext context) async {
  try {
    // Proses sign out
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    
    // Navigasi jika berhasil
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  } catch (e) {
    // Jika terjadi error, tampilkan SnackBar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal untuk keluar: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Di dalam HalamanProfil
          // Di dalam HalamanProfil
          _buildOptionListTile(
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi LaporKades',
            onTap: () {
              // Navigasi ke halaman Tentang Aplikasi
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TentangScreen()),
              );
            },
          ),
          // Di dalam HalamanProfil
          _buildOptionListTile(
            icon: Icons.description_outlined,
            title: 'Syarat dan Ketentuan',
            onTap: () {
              // Navigasi ke halaman Syarat & Ketentuan
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsAndConditionsScreen()),
              );
            },
          ),
          _buildOptionListTile(
            icon: Icons.shield_outlined,
            title: 'Kebijakan Privasi',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
              );
            },
          ),
          
          const Divider(height: 32),
          
          // --- Tombol Keluar ---
          _buildOptionListTile(
            icon: Icons.logout,
            title: 'Keluar',
            color: Colors.red,
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk membuat setiap baris opsi
  Widget _buildOptionListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}